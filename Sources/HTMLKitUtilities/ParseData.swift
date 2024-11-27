//
//  ParseData.swift
//
//
//  Created by Evan Anderson on 11/21/24.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public extension HTMLKitUtilities {
    // MARK: Escape HTML
    static func escapeHTML(expansion: MacroExpansionExprSyntax, context: some MacroExpansionContext) -> String {
        return expansion.arguments.children(viewMode: .all).compactMap({
            guard let child:LabeledExprSyntax = $0.labeled,
                    var c:CustomStringConvertible = HTMLKitUtilities.parseInnerHTML(context: context, child: child, lookupFiles: []) else {
                return nil
            }
            if var element:HTMLElement = c as? HTMLElement {
                element.escaped = true
                c = element
            }
            return String(describing: c)
        }).joined()
    }
    
    // MARK: Expand #html
    static func expandHTMLMacro(context: some MacroExpansionContext, macroNode: MacroExpansionExprSyntax) throws -> ExprSyntax {
        let (string, encoding):(String, HTMLEncoding) = expand_macro(context: context, macro: macroNode)
        func has_no_interpolation() -> Bool {
            let has_interpolation:Bool = !string.ranges(of: try! Regex("\\((.*)\\)")).isEmpty
            guard !has_interpolation else {
                context.diagnose(Diagnostic(node: macroNode, message: DiagnosticMsg(id: "interpolationNotAllowedForDataType", message: "String Interpolation is not allowed for this data type. Runtime values get converted to raw text, which is not the expected result.")))
                return false
            }
            return true
        }
        func bytes<T: FixedWidthInteger>(_ bytes: [T]) -> String {
            return "[" + bytes.map({ "\($0)" }).joined(separator: ",") + "]"
        }
        switch encoding {
            case .utf8Bytes:
                guard has_no_interpolation() else { return "" }
                return "\(raw: bytes([UInt8](string.utf8)))"
            case .utf16Bytes:
                guard has_no_interpolation() else { return "" }
                return "\(raw: bytes([UInt16](string.utf16)))"
            case .utf8CString:
                return "\(raw: string.utf8CString)"

            case .foundationData:
                guard has_no_interpolation() else { return "" }
                return "Data(\(raw: bytes([UInt8](string.utf8))))"

            case .byteBuffer:
                guard has_no_interpolation() else { return "" }
                return "ByteBuffer(bytes: \(raw: bytes([UInt8](string.utf8))))"

            case .string:
                return "\"\(raw: string)\""
            case .custom(let encoded):
                return "\(raw: encoded.replacingOccurrences(of: "$0", with: string))"
        }
    }

    // MARK: Parse Arguments
    static func parseArguments(
        context: some MacroExpansionContext,
        children: SyntaxChildren,
        otherAttributes: [String:String] = [:]
    ) -> ElementData {
        var encoding:HTMLEncoding = HTMLEncoding.string
        var global_attributes:[HTMLElementAttribute] = []
        var attributes:[String:Any] = [:]
        var innerHTML:[CustomStringConvertible] = []
        var trailingSlash:Bool = false
        var lookupFiles:Set<String> = []
        for element in children {
            if let child:LabeledExprSyntax = element.labeled {
                if let key:String = child.label?.text {
                    if key == "encoding" {
                        if let key:String = child.expression.memberAccess?.declName.baseName.text {
                            encoding = HTMLEncoding(rawValue: key) ?? .string
                        } else if let custom:FunctionCallExprSyntax = child.expression.functionCall {
                            encoding = .custom(custom.arguments.first!.expression.stringLiteral!.string)
                        }
                    } else if key == "lookupFiles" {
                        lookupFiles = Set(child.expression.array!.elements.compactMap({ $0.expression.stringLiteral?.string }))
                    } else if key == "attributes" {
                        (global_attributes, trailingSlash) = parseGlobalAttributes(context: context, array: child.expression.array!.elements, lookupFiles: lookupFiles)
                    } else {
                        var target_key:String = key
                        if let target:String = otherAttributes[key] {
                            target_key = target
                        }
                        if let test:any HTMLInitializable = HTMLElementAttribute.Extra.parse(context: context, key: target_key, expr: child.expression) {
                            attributes[key] = test
                        } else if let string:LiteralReturnType = parse_literal_value(context: context, key: key, expression: child.expression, lookupFiles: lookupFiles) {
                            switch string {
                                case .boolean(let b): attributes[key] = b
                                case .string(let s), .interpolation(let s): attributes[key] = s
                                case .int(let i): attributes[key] = i
                                case .float(let f): attributes[key] = f
                                case .array(let a): attributes[key] = a
                            }
                        }
                    }
                // inner html
                } else if let inner_html:CustomStringConvertible = parseInnerHTML(context: context, child: child, lookupFiles: lookupFiles) {
                    innerHTML.append(inner_html)
                }
            }
        }
        return ElementData(encoding, global_attributes, attributes, innerHTML, trailingSlash)
    }

    // MARK: Parse Global Attributes
    static func parseGlobalAttributes(
        context: some MacroExpansionContext,
        array: ArrayElementListSyntax,
        lookupFiles: Set<String>
    ) -> (attributes: [HTMLElementAttribute], trailingSlash: Bool) {
        var keys:Set<String> = []
        var attributes:[HTMLElementAttribute] = []
        var trailingSlash:Bool = false
        for element in array {
            if let function:FunctionCallExprSyntax = element.expression.functionCall {
                let first_expression:ExprSyntax = function.arguments.first!.expression
                var key:String = function.calledExpression.memberAccess!.declName.baseName.text
                if key.contains(" ") {
                    context.diagnose(Diagnostic(node: first_expression, message: DiagnosticMsg(id: "spacesNotAllowedInAttributeDeclaration", message: "Spaces are not allowed in attribute declaration.")))
                } else if keys.contains(key) {
                    global_attribute_already_defined(context: context, attribute: key, node: first_expression)
                } else if let attr:HTMLElementAttribute = HTMLElementAttribute.init(context: context, key: key, function) {
                    attributes.append(attr)
                    key = attr.key
                    keys.insert(key)
                }
            } else if let member:String = element.expression.memberAccess?.declName.baseName.text, member == "trailingSlash" {
                if keys.contains(member) {
                    global_attribute_already_defined(context: context, attribute: member, node: element.expression)
                } else {
                    trailingSlash = true
                    keys.insert(member)
                }
            }
        }
        return (attributes, trailingSlash)
    }

    // MARK: Parse Inner HTML
    static func parseInnerHTML(
        context: some MacroExpansionContext,
        child: LabeledExprSyntax,
        lookupFiles: Set<String>
    ) -> CustomStringConvertible? {
        if let expansion:MacroExpansionExprSyntax = child.expression.macroExpansion {
            if expansion.macroName.text == "escapeHTML" {
                return escapeHTML(expansion: expansion, context: context)
            }
            return "" // TODO: fix?
        } else if let element:HTMLElement = parse_element(context: context, expr: child.expression) {
            return element
        } else if let string:String = parse_literal_value(context: context, key: "", expression: child.expression, lookupFiles: lookupFiles)?.value(key: "") {
            return string
        } else {
            unallowed_expression(context: context, node: child)
            return nil
        }
    }

    // MARK: Parse element
    static func parse_element(context: some MacroExpansionContext, expr: ExprSyntax) -> HTMLElement? {
        guard let function:FunctionCallExprSyntax = expr.functionCall else { return nil }
        return HTMLElementValueType.parse_element(context: context, function)
    }
}
extension HTMLKitUtilities {
    // MARK: GA Already Defined
    static func global_attribute_already_defined(context: some MacroExpansionContext, attribute: String, node: some SyntaxProtocol) {
        context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "globalAttributeAlreadyDefined", message: "Global attribute \"" + attribute + "\" is already defined.")))
    }

    // MARK: Unallowed Expression
    static func unallowed_expression(context: some MacroExpansionContext, node: LabeledExprSyntax) {
        context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unallowedExpression", message: "String Interpolation is required when encoding runtime values."), fixIts: [
            FixIt(message: DiagnosticMsg(id: "useStringInterpolation", message: "Use String Interpolation."), changes: [
                FixIt.Change.replace(
                    oldNode: Syntax(node),
                    newNode: Syntax(StringLiteralExprSyntax(content: "\\(\(node))"))
                )
            ])
        ]))
    }

    // MARK: Warn Interpolation
    static func warn_interpolation(
        context: some MacroExpansionContext,
        node: some SyntaxProtocol,
        string: inout String,
        remaining_interpolation: inout Int,
        lookupFiles: Set<String>
    ) {
        if let fix:String = InterpolationLookup.find(context: context, node, files: lookupFiles) {
            let expression:String = "\(node)"
            let ranges:[Range<String.Index>] = string.ranges(of: expression)
            string.replace(expression, with: fix)
            remaining_interpolation -= ranges.count
        } else {
            context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unsafeInterpolation", message: "Interpolation may introduce raw HTML.", severity: .warning)))
        }
    }

    // MARK: Expand Macro
    static func expand_macro(context: some MacroExpansionContext, macro: MacroExpansionExprSyntax) -> (String, HTMLEncoding) {
        guard macro.macroName.text == "html" else {
            return ("\(macro)", .string)
        }
        let data:HTMLKitUtilities.ElementData = HTMLKitUtilities.parseArguments(context: context, children: macro.arguments.children(viewMode: .all))
        return (data.innerHTML.map({ String(describing: $0) }).joined(), data.encoding)
    }
}

// MARK: Misc
package extension SyntaxProtocol {
    var booleanLiteral : BooleanLiteralExprSyntax? { self.as(BooleanLiteralExprSyntax.self) }
    var stringLiteral : StringLiteralExprSyntax? { self.as(StringLiteralExprSyntax.self) }
    var integerLiteral : IntegerLiteralExprSyntax? { self.as(IntegerLiteralExprSyntax.self) }
    var floatLiteral : FloatLiteralExprSyntax? { self.as(FloatLiteralExprSyntax.self) }
    var array : ArrayExprSyntax? { self.as(ArrayExprSyntax.self) }
    var dictionary : DictionaryExprSyntax? { self.as(DictionaryExprSyntax.self) }
    var memberAccess : MemberAccessExprSyntax? { self.as(MemberAccessExprSyntax.self) }
    var macroExpansion : MacroExpansionExprSyntax? { self.as(MacroExpansionExprSyntax.self) }
    var functionCall : FunctionCallExprSyntax? { self.as(FunctionCallExprSyntax.self) }
    var declRef : DeclReferenceExprSyntax? { self.as(DeclReferenceExprSyntax.self) }
}
package extension SyntaxChildren.Element {
    var labeled : LabeledExprSyntax? { self.as(LabeledExprSyntax.self) }
}
package extension StringLiteralExprSyntax {
    var string : String { "\(segments)" }
}
package extension LabeledExprListSyntax {
    func get(_ index: Int) -> Element? {
        return index < count ? self[self.index(at: index)] : nil
    }
}
package extension ExprSyntax {
    func string(context: some MacroExpansionContext, key: String) -> String? {
        return HTMLKitUtilities.parse_literal_value(context: context, key: key, expression: self, lookupFiles: [])?.value(key: key)
    }
    func boolean(context: some MacroExpansionContext, key: String) -> Bool? {
        booleanLiteral?.literal.text == "true"
    }
    func enumeration<T : HTMLInitializable>(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) -> T? {
        if let function:FunctionCallExprSyntax = functionCall, let member:MemberAccessExprSyntax = function.calledExpression.memberAccess {
            return T(context: context, key: member.declName.baseName.text, arguments: function.arguments)
        }
        if let member:MemberAccessExprSyntax = memberAccess {
            return T(context: context, key: member.declName.baseName.text, arguments: arguments)
        }
        return nil
    }
    func int(context: some MacroExpansionContext, key: String) -> Int? {
        guard let s:String = HTMLKitUtilities.parse_literal_value(context: context, key: key, expression: self, lookupFiles: [])?.value(key: key) else { return nil }
        return Int(s)
    }
    func array_string(context: some MacroExpansionContext, key: String) -> [String]? {
        array?.elements.compactMap({ $0.expression.string(context: context, key: key) })
    }
    func dictionary_string_string(context: some MacroExpansionContext, key: String) -> [String:String] {
        var d:[String:String] = [:]
        if let elements:DictionaryElementListSyntax = dictionary?.content.as(DictionaryElementListSyntax.self) {
            for element in elements {
                if let key:String = element.key.string(context: context, key: key), let value:String = element.value.string(context: context, key: key) {
                    d[key] = value
                }
            }
        }
        return d
    }
    func float(context: some MacroExpansionContext, key: String) -> Float? {
        guard let s:String = HTMLKitUtilities.parse_literal_value(context: context, key: key, expression: self, lookupFiles: [])?.value(key: key) else { return nil }
        return Float(s)
    }
}

// MARK: DiagnosticMsg
package struct DiagnosticMsg : DiagnosticMessage, FixItMessage {
    package let message:String
    package let diagnosticID:MessageID
    package let severity:DiagnosticSeverity
    package var fixItID : MessageID { diagnosticID }

    package init(id: String, message: String, severity: DiagnosticSeverity = .error) {
        self.message = message
        self.diagnosticID = MessageID(domain: "HTMLKitMacros", id: id)
        self.severity = severity
    }
}