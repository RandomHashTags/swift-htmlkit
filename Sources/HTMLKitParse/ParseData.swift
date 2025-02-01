//
//  ParseData.swift
//
//
//  Created by Evan Anderson on 11/21/24.
//

import HTMLAttributes
import HTMLElements
import HTMLKitUtilities
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

extension HTMLKitUtilities {
    // MARK: Escape HTML
    public static func escapeHTML(context: HTMLExpansionContext) -> String {
        var context:HTMLExpansionContext = context
        let children:SyntaxChildren = context.arguments.children(viewMode: .all)
        var inner_html:String = ""
        inner_html.reserveCapacity(children.count)
        for e in children {
            if let child:LabeledExprSyntax = e.labeled {
                if let key:String = child.label?.text {
                    if key == "encoding" {
                        context.encoding = parseEncoding(expression: child.expression) ?? .string
                    }
                } else if var c:CustomStringConvertible = HTMLKitUtilities.parseInnerHTML(context: context, child: child) {
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
    public static func expandHTMLMacro(context: HTMLExpansionContext) throws -> ExprSyntax {
        let (string, encoding):(String, HTMLEncoding) = expand_macro(context: context)
        return "\(raw: encodingResult(context: context, node: context.expansion, string: string, for: encoding))"
    }
    private static func encodingResult(context: HTMLExpansionContext, node: MacroExpansionExprSyntax, string: String, for encoding: HTMLEncoding) -> String {
        func hasNoInterpolation() -> Bool {
            let has_interpolation:Bool = !string.ranges(of: try! Regex("\\((.*)\\)")).isEmpty
            guard !has_interpolation else {
                if !context.ignoresCompilerWarnings {
                    context.context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "interpolationNotAllowedForDataType", message: "String Interpolation is not allowed for this data type. Runtime values get converted to raw text, which is not the expected result.")))
                }
                return false
            }
            return true
        }
        func bytes<T: FixedWidthInteger>(_ bytes: [T]) -> String {
            return "[" + bytes.map({ "\($0)" }).joined(separator: ",") + "]"
        }
        switch encoding {
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
        context: HTMLExpansionContext,
        otherAttributes: [String:String] = [:]
    ) -> ElementData {
        var context:HTMLExpansionContext = context
        var global_attributes:[HTMLAttribute] = []
        var attributes:[String:Any] = [:]
        var innerHTML:[CustomStringConvertible] = []
        var trailingSlash:Bool = false
        for element in context.arguments.children(viewMode: .all) {
            if let child:LabeledExprSyntax = element.labeled {
                context.key = ""
                if let key:String = child.label?.text {
                    context.key = key
                    if key == "encoding" {
                        context.encoding = parseEncoding(expression: child.expression) ?? .string
                    } else if key == "lookupFiles" {
                        context.lookupFiles = Set(child.expression.array!.elements.compactMap({ $0.expression.stringLiteral?.string(encoding: context.encoding) }))
                    } else if key == "attributes" {
                        (global_attributes, trailingSlash) = parseGlobalAttributes(context: context, array: child.expression.array!.elements)
                    } else {
                        var target_key:String = key
                        if let target:String = otherAttributes[key] {
                            target_key = target
                        }
                        context.key = target_key
                        if let test:any HTMLInitializable = HTMLAttribute.Extra.parse(context: context, expr: child.expression) {
                            attributes[key] = test
                        } else if let literal:LiteralReturnType = parse_literal_value(context: context, expression: child.expression) {
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
                } else if let inner_html:CustomStringConvertible = parseInnerHTML(context: context, child: child) {
                    innerHTML.append(inner_html)
                }
            }
        }
        return ElementData(context.encoding, global_attributes, attributes, innerHTML, trailingSlash)
    }

    // MARK: Parse Encoding
    public static func parseEncoding(expression: ExprSyntax) -> HTMLEncoding? {
        if let key:String = expression.memberAccess?.declName.baseName.text {
            return HTMLEncoding(rawValue: key)
        } else if let function:FunctionCallExprSyntax = expression.functionCall {
            switch function.calledExpression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
            case "custom":
                guard let logic:String = function.arguments.first?.expression.stringLiteral?.string(encoding: .string) else { break }
                if function.arguments.count == 1 {
                    return .custom(logic)
                } else {
                    return .custom(logic, stringDelimiter: function.arguments.last!.expression.stringLiteral!.string(encoding: .string))
                }
            default:
                break
            }
        }
        return nil
    }

    // MARK: Parse Global Attributes
    public static func parseGlobalAttributes(
        context: HTMLExpansionContext,
        array: ArrayElementListSyntax
    ) -> (attributes: [HTMLAttribute], trailingSlash: Bool) {
        var keys:Set<String> = []
        var attributes:[HTMLAttribute] = []
        var trailingSlash:Bool = false
        for element in array {
            if let function:FunctionCallExprSyntax = element.expression.functionCall {
                let first_expression:ExprSyntax = function.arguments.first!.expression
                var key:String = function.calledExpression.memberAccess!.declName.baseName.text
                var c:HTMLExpansionContext = context
                c.key = key
                c.arguments = function.arguments
                if key.contains(" ") {
                    context.context.diagnose(Diagnostic(node: first_expression, message: DiagnosticMsg(id: "spacesNotAllowedInAttributeDeclaration", message: "Spaces are not allowed in attribute declaration.")))
                } else if keys.contains(key) {
                    global_attribute_already_defined(context: context, attribute: key, node: first_expression)
                } else if let attr:HTMLAttribute = HTMLAttribute(context: c) {
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
        context: HTMLExpansionContext,
        child: LabeledExprSyntax
    ) -> CustomStringConvertible? {
        if let expansion:MacroExpansionExprSyntax = child.expression.macroExpansion {
            if expansion.macroName.text == "escapeHTML" {
                var c:HTMLExpansionContext = context
                c.arguments = expansion.arguments
                return escapeHTML(context: c)
            }
            return "" // TODO: fix?
        } else if let element:HTMLElement = parse_element(context: context, expr: child.expression) {
            return element
        } else if let string:String = parse_literal_value(context: context, expression: child.expression)?.value(key: "") {
            return string
        } else {
            unallowed_expression(context: context, node: child)
            return nil
        }
    }

    // MARK: Parse element
    public static func parse_element(context: HTMLExpansionContext, expr: ExprSyntax) -> HTMLElement? {
        guard let function:FunctionCallExprSyntax = expr.functionCall else { return nil }
        return HTMLElementValueType.parse_element(context: context, function)
    }
}
extension HTMLKitUtilities {
    // MARK: GA Already Defined
    static func global_attribute_already_defined(context: HTMLExpansionContext, attribute: String, node: some SyntaxProtocol) {
        context.context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "globalAttributeAlreadyDefined", message: "Global attribute \"" + attribute + "\" is already defined.")))
    }

    // MARK: Unallowed Expression
    static func unallowed_expression(context: HTMLExpansionContext, node: LabeledExprSyntax) {
        context.context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unallowedExpression", message: "String Interpolation is required when encoding runtime values."), fixIts: [
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
        context: HTMLExpansionContext,
        node: some SyntaxProtocol
    ) {
        /*if let fix:String = InterpolationLookup.find(context: context, node) {
            let expression:String = "\(node)"
            let ranges:[Range<String.Index>] = string.ranges(of: expression)
            string.replace(expression, with: fix)
            remaining_interpolation -= ranges.count
        } else {*/
            guard !context.ignoresCompilerWarnings else { return }
            context.context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unsafeInterpolation", message: "Interpolation may introduce raw HTML.", severity: .warning)))
        //}
    }

    // MARK: Expand Macro
    static func expand_macro(context: HTMLExpansionContext) -> (String, HTMLEncoding) {
        let data:HTMLKitUtilities.ElementData = HTMLKitUtilities.parseArguments(context: context)
        return (data.innerHTML.map({ String(describing: $0) }).joined(), data.encoding)
    }
}

// MARK: Misc
extension ExprSyntax {
    package func string(context: HTMLExpansionContext) -> String? {
        return HTMLKitUtilities.parse_literal_value(context: context, expression: self)?.value(key: context.key)
    }
    package func boolean(context: HTMLExpansionContext) -> Bool? {
        booleanLiteral?.literal.text == "true"
    }
    package func enumeration<T : HTMLParsable>(context: HTMLExpansionContext) -> T? {
        if let function:FunctionCallExprSyntax = functionCall, let member:MemberAccessExprSyntax = function.calledExpression.memberAccess {
            var c:HTMLExpansionContext = context
            c.key = member.declName.baseName.text
            c.arguments = function.arguments
            return T(context: c)
        }
        if let member:MemberAccessExprSyntax = memberAccess {
            var c:HTMLExpansionContext = context
            c.key = member.declName.baseName.text
            return T(context: c)
        }
        return nil
    }
    package func int(context: HTMLExpansionContext) -> Int? {
        guard let s:String = HTMLKitUtilities.parse_literal_value(context: context, expression: self)?.value(key: context.key) else { return nil }
        return Int(s)
    }
    package func array_string(context: HTMLExpansionContext) -> [String]? {
        array?.elements.compactMap({ $0.expression.string(context: context) })
    }
    package func array_enumeration<T: HTMLParsable>(context: HTMLExpansionContext) -> [T]? {
        array?.elements.compactMap({ $0.expression.enumeration(context: context) })
    }
    package func dictionary_string_string(context: HTMLExpansionContext) -> [String:String] {
        var d:[String:String] = [:]
        if let elements:DictionaryElementListSyntax = dictionary?.content.as(DictionaryElementListSyntax.self) {
            for element in elements {
                if let key:String = element.key.string(context: context), let value:String = element.value.string(context: context) {
                    d[key] = value
                }
            }
        }
        return d
    }
    package func float(context: HTMLExpansionContext) -> Float? {
        guard let s:String = HTMLKitUtilities.parse_literal_value(context: context, expression: self)?.value(key: context.key) else { return nil }
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

// MARK: HTMLExpansionContext
extension HTMLExpansionContext {
    func string() -> String? { expression?.string(context: self) }
    func boolean() -> Bool?  { expression?.boolean(context: self) }
    func enumeration<T : HTMLParsable>() -> T? { expression?.enumeration(context: self) }
    func int() -> Int? { expression?.int(context: self) }
    func float() -> Float? { expression?.float(context: self) }
    func array_string() -> [String]? { expression?.array_string(context: self) }
    func array_enumeration<T: HTMLParsable>() -> [T]? { expression?.array_enumeration(context: self) }
}