//
//  ParseData.swift
//
//
//  Created by Evan Anderson on 11/21/24.
//

/*
import HTMLKitUtilities
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

extension HTMLKitUtilities {
    // MARK: Escape HTML
    public static func escapeHTML(expansion: MacroExpansionExprSyntax, encoding: HTMLEncoding = .string, context: some MacroExpansionContext) -> String {
        var encoding:HTMLEncoding = encoding
        let children:SyntaxChildren = expansion.arguments.children(viewMode: .all)
        var inner_html:String = ""
        inner_html.reserveCapacity(children.count)
        for e in children {
            if let child:LabeledExprSyntax = e.labeled {
                if let key:String = child.label?.text {
                    if key == "encoding" {
                        encoding = parseEncoding(expression: child.expression) ?? .string
                    }
                } else if var c:CustomStringConvertible = HTMLKitUtilities.parseInnerHTML(context: context, encoding: encoding, child: child, lookupFiles: []) {
                    if var element:HTMLElement = c as? HTMLElement {
                        element.escaped = true
                        c = element
                    }
                    inner_html += String(describing: c)
                }
            }
        }
        return inner_html
    }
    
    // MARK: Expand #html
    public static func expandHTMLMacro(context: some MacroExpansionContext, macroNode: MacroExpansionExprSyntax) throws -> ExprSyntax {
        let (string, encoding):(String, HTMLEncoding) = expand_macro(context: context, macro: macroNode)
        return "\(raw: encodingResult(context: context, node: macroNode, string: string, for: encoding))"
    }
    private static func encodingResult(context: some MacroExpansionContext, node: MacroExpansionExprSyntax, string: String, for encoding: HTMLEncoding) -> String {
        func hasNoInterpolation() -> Bool {
            let has_interpolation:Bool = !string.ranges(of: try! Regex("\\((.*)\\)")).isEmpty
            guard !has_interpolation else {
                if !encoding.isUnchecked {
                    context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "interpolationNotAllowedForDataType", message: "String Interpolation is not allowed for this data type. Runtime values get converted to raw text, which is not the expected result.")))
                }
                return false
            }
            return true
        }
        func bytes<T: FixedWidthInteger>(_ bytes: [T]) -> String {
            return "[" + bytes.map({ "\($0)" }).joined(separator: ",") + "]"
        }
        switch encoding {
        case .unchecked(let e):
            return encodingResult(context: context, node: node, string: string, for: e)

        case .utf8Bytes:
            guard hasNoInterpolation() else { return "" }
            return bytes([UInt8](string.utf8))
        case .utf16Bytes:
            guard hasNoInterpolation() else { return "" }
            return bytes([UInt16](string.utf16))
        case .utf8CString:
            guard hasNoInterpolation() else { return "" }
            return "\(string.utf8CString)"

        case .foundationData:
            guard hasNoInterpolation() else { return "" }
            return "Data(\(bytes([UInt8](string.utf8))))"

        case .byteBuffer:
            guard hasNoInterpolation() else { return "" }
            return "ByteBuffer(bytes: \(bytes([UInt8](string.utf8))))"

        case .string:
            return "\"\(string)\""
        case .custom(let encoded, _):
            return encoded.replacingOccurrences(of: "$0", with: string)
        }
    }

    // MARK: Parse Arguments
    public static func parseArguments(
        context: some MacroExpansionContext,
        encoding: HTMLEncoding,
        children: SyntaxChildren,
        otherAttributes: [String:String] = [:]
    ) -> ElementData {
        var encoding:HTMLEncoding = encoding
        var global_attributes:[HTMLElementAttribute] = []
        var attributes:[String:Any] = [:]
        var innerHTML:[CustomStringConvertible] = []
        var trailingSlash:Bool = false
        var lookupFiles:Set<String> = []
        for element in children {
            if let child:LabeledExprSyntax = element.labeled {
                if let key:String = child.label?.text {
                    if key == "encoding" {
                        encoding = parseEncoding(expression: child.expression) ?? .string
                    } else if key == "lookupFiles" {
                        lookupFiles = Set(child.expression.array!.elements.compactMap({ $0.expression.stringLiteral?.string }))
                    } else if key == "attributes" {
                        (global_attributes, trailingSlash) = parseGlobalAttributes(context: context, isUnchecked: encoding.isUnchecked, array: child.expression.array!.elements, lookupFiles: lookupFiles)
                    } else {
                        var target_key:String = key
                        if let target:String = otherAttributes[key] {
                            target_key = target
                        }
                        if let test:any HTMLInitializable = HTMLElementAttribute.Extra.parse(context: context, isUnchecked: encoding.isUnchecked, key: target_key, expr: child.expression) {
                            attributes[key] = test
                        } else if let literal:LiteralReturnType = parse_literal_value(context: context, isUnchecked: encoding.isUnchecked, key: key, expression: child.expression, lookupFiles: lookupFiles) {
                            switch literal {
                            case .boolean(let b): attributes[key] = b
                            case .string, .interpolation: attributes[key] = literal.value(key: key)
                            case .int(let i): attributes[key] = i
                            case .float(let f): attributes[key] = f
                            case .array:
                                let escaped:LiteralReturnType = literal.escapeArray()
                                switch escaped {
                                case .array(let a): attributes[key] = a
                                default: break
                                }
                            }
                        }
                    }
                // inner html
                } else if let inner_html:CustomStringConvertible = parseInnerHTML(context: context, encoding: encoding, child: child, lookupFiles: lookupFiles) {
                    innerHTML.append(inner_html)
                }
            }
        }
        return ElementData(encoding, global_attributes, attributes, innerHTML, trailingSlash)
    }

    // MARK: Parse Encoding
    public static func parseEncoding(expression: ExprSyntax) -> HTMLEncoding? {
        if let key:String = expression.memberAccess?.declName.baseName.text {
            return HTMLEncoding(rawValue: key)
        } else if let function:FunctionCallExprSyntax = expression.functionCall {
            switch function.calledExpression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
            case "unchecked":
                guard let encoding:HTMLEncoding = parseEncoding(expression: function.arguments.first!.expression) else { break }
                return .unchecked(encoding)
            case "custom":
                guard let logic:String = function.arguments.first?.expression.stringLiteral?.string else { break }
                if function.arguments.count == 1 {
                    return .custom(logic)
                } else {
                    return .custom(logic, stringDelimiter: function.arguments.last!.expression.stringLiteral!.string)
                }
            default:
                break
            }
        }
        return nil
    }

    // MARK: Parse Global Attributes
    public static func parseGlobalAttributes(
        context: some MacroExpansionContext,
        isUnchecked: Bool,
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
                } else if let attr:HTMLElementAttribute = HTMLElementAttribute(context: context, isUnchecked: isUnchecked, key: key, arguments: function.arguments) {
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
    public static func parseInnerHTML(
        context: some MacroExpansionContext,
        encoding: HTMLEncoding,
        child: LabeledExprSyntax,
        lookupFiles: Set<String>
    ) -> CustomStringConvertible? {
        if let expansion:MacroExpansionExprSyntax = child.expression.macroExpansion {
            if expansion.macroName.text == "escapeHTML" {
                return escapeHTML(expansion: expansion, encoding: encoding, context: context)
            }
            return "" // TODO: fix?
        } else if let element:HTMLElement = parse_element(context: context, encoding: encoding, expr: child.expression) {
            return element
        } else if let string:String = parse_literal_value(context: context, isUnchecked: encoding.isUnchecked, key: "", expression: child.expression, lookupFiles: lookupFiles)?.value(key: "") {
            return string
        } else {
            unallowed_expression(context: context, node: child)
            return nil
        }
    }

    // MARK: Parse element
    public static func parse_element(context: some MacroExpansionContext, encoding: HTMLEncoding, expr: ExprSyntax) -> HTMLElement? {
        guard let function:FunctionCallExprSyntax = expr.functionCall else { return nil }
        return HTMLElementValueType.parse_element(context: context, encoding: encoding, function)
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
        node: some SyntaxProtocol
    ) {
        /*if let fix:String = InterpolationLookup.find(context: context, node, files: lookupFiles) {
            let expression:String = "\(node)"
            let ranges:[Range<String.Index>] = string.ranges(of: expression)
            string.replace(expression, with: fix)
            remaining_interpolation -= ranges.count
        } else {*/
            context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unsafeInterpolation", message: "Interpolation may introduce raw HTML.", severity: .warning)))
        //}
    }

    // MARK: Expand Macro
    static func expand_macro(context: some MacroExpansionContext, macro: MacroExpansionExprSyntax) -> (String, HTMLEncoding) {
        guard macro.macroName.text == "html" else {
            return ("\(macro)", .string)
        }
        let data:HTMLKitUtilities.ElementData = HTMLKitUtilities.parseArguments(context: context, encoding: .string, children: macro.arguments.children(viewMode: .all))
        return (data.innerHTML.map({ String(describing: $0) }).joined(), data.encoding)
    }
}

// MARK: Misc
extension SyntaxProtocol {
    package var booleanLiteral : BooleanLiteralExprSyntax? { self.as(BooleanLiteralExprSyntax.self) }
    package var stringLiteral : StringLiteralExprSyntax? { self.as(StringLiteralExprSyntax.self) }
    package var integerLiteral : IntegerLiteralExprSyntax? { self.as(IntegerLiteralExprSyntax.self) }
    package var floatLiteral : FloatLiteralExprSyntax? { self.as(FloatLiteralExprSyntax.self) }
    package var array : ArrayExprSyntax? { self.as(ArrayExprSyntax.self) }
    package var dictionary : DictionaryExprSyntax? { self.as(DictionaryExprSyntax.self) }
    package var memberAccess : MemberAccessExprSyntax? { self.as(MemberAccessExprSyntax.self) }
    package var macroExpansion : MacroExpansionExprSyntax? { self.as(MacroExpansionExprSyntax.self) }
    package var functionCall : FunctionCallExprSyntax? { self.as(FunctionCallExprSyntax.self) }
    package var declRef : DeclReferenceExprSyntax? { self.as(DeclReferenceExprSyntax.self) }
}
extension SyntaxChildren.Element {
    package var labeled : LabeledExprSyntax? { self.as(LabeledExprSyntax.self) }
}
extension StringLiteralExprSyntax {
    package var string : String { "\(segments)" }
}
extension LabeledExprListSyntax {
    package func get(_ index: Int) -> Element? {
        return index < count ? self[self.index(at: index)] : nil
    }
}

extension ExprSyntax {
    package func string(context: some MacroExpansionContext, isUnchecked: Bool, key: String) -> String? {
        return HTMLKitUtilities.parse_literal_value(context: context, isUnchecked: isUnchecked, key: key, expression: self, lookupFiles: [])?.value(key: key)
    }
    package func boolean(context: some MacroExpansionContext, key: String) -> Bool? {
        booleanLiteral?.literal.text == "true"
    }
    package func enumeration<T : HTMLInitializable>(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) -> T? {
        if let function:FunctionCallExprSyntax = functionCall, let member:MemberAccessExprSyntax = function.calledExpression.memberAccess {
            return T(context: context, isUnchecked: isUnchecked, key: member.declName.baseName.text, arguments: function.arguments)
        }
        if let member:MemberAccessExprSyntax = memberAccess {
            return T(context: context, isUnchecked: isUnchecked, key: member.declName.baseName.text, arguments: arguments)
        }
        return nil
    }
    package func int(context: some MacroExpansionContext, key: String) -> Int? {
        guard let s:String = HTMLKitUtilities.parse_literal_value(context: context, isUnchecked: false, key: key, expression: self, lookupFiles: [])?.value(key: key) else { return nil }
        return Int(s)
    }
    package func array_string(context: some MacroExpansionContext, isUnchecked: Bool, key: String) -> [String]? {
        array?.elements.compactMap({ $0.expression.string(context: context, isUnchecked: isUnchecked, key: key) })
    }
    package func array_enumeration<T: HTMLInitializable>(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) -> [T]? {
        array?.elements.compactMap({ $0.expression.enumeration(context: context, isUnchecked: isUnchecked, key: key, arguments: arguments) })
    }
    package func dictionary_string_string(context: some MacroExpansionContext, isUnchecked: Bool, key: String) -> [String:String] {
        var d:[String:String] = [:]
        if let elements:DictionaryElementListSyntax = dictionary?.content.as(DictionaryElementListSyntax.self) {
            for element in elements {
                if let key:String = element.key.string(context: context, isUnchecked: isUnchecked, key: key), let value:String = element.value.string(context: context, isUnchecked: isUnchecked, key: key) {
                    d[key] = value
                }
            }
        }
        return d
    }
    package func float(context: some MacroExpansionContext, key: String) -> Float? {
        guard let s:String = HTMLKitUtilities.parse_literal_value(context: context, isUnchecked: false, key: key, expression: self, lookupFiles: [])?.value(key: key) else { return nil }
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
*/