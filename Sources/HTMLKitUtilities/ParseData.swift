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
    // MARK: Parse Arguments
    static func parse_arguments(
        context: some MacroExpansionContext,
        children: SyntaxChildren
    ) -> ElementData {
        var encoding:HTMLEncoding = HTMLEncoding.string
        var global_attributes:[HTMLElementAttribute] = []
        var attributes:[String:Any] = [:]
        var innerHTML:[CustomStringConvertible] = []
        var trailingSlash:Bool = false
        var lookupFiles:Set<String> = []
        for element in children {
            if let child:LabeledExprSyntax = element.labeled {
                if var key:String = child.label?.text {
                    if key == "encoding" {
                        if let key:String = child.expression.memberAccess?.declName.baseName.text {
                            switch key {
                                case "string": encoding = .string
                                case "utf8Bytes": encoding = .utf8Bytes
                                case "utf16Bytes": encoding = .utf16Bytes
                                case "foundationData": encoding = .foundationData
                                case "byteBuffer": encoding = .byteBuffer
                                default: break
                            }
                        } else if let custom:FunctionCallExprSyntax = child.expression.functionCall {
                            encoding = .custom(custom.arguments.first!.expression.stringLiteral!.string)
                        }
                    } else if key == "lookupFiles" {
                        lookupFiles = Set(child.expression.array!.elements.compactMap({ $0.expression.stringLiteral?.string }))
                    } else if key == "attributes" {
                        (global_attributes, trailingSlash) = parse_global_attributes(context: context, array: child.expression.array!.elements, lookupFiles: lookupFiles)
                    } else {
                        if key == "acceptCharset" {
                            key = "accept-charset"
                        } else if key == "httpEquiv" {
                            key = "http-equiv"
                        }
                        if let string:String = parse_literal_value(context: context, key: key, expression: child.expression, lookupFiles: lookupFiles)?.value(key: key) {
                            attributes[key] = string
                        }
                    }
                // inner html
                } else if let inner_html:CustomStringConvertible = parse_inner_html(context: context, child: child, lookupFiles: lookupFiles) {
                    innerHTML.append(inner_html)
                }
            }
        }
        return ElementData(encoding, global_attributes, attributes, innerHTML, trailingSlash)
    }
    // MARK: Parse Global Attributes
    static func parse_global_attributes(
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
                let key:String = function.calledExpression.memberAccess!.declName.baseName.text
                if key.contains(" ") {
                    context.diagnose(Diagnostic(node: first_expression, message: DiagnosticMsg(id: "spacesNotAllowedInAttributeDeclaration", message: "Spaces are not allowed in attribute declaration.")))
                } else if keys.contains(key) {
                    global_attribute_already_defined(context: context, attribute: key, node: first_expression)
                } else if let attr:HTMLElementAttribute = HTMLElementAttribute.init(key: key, function) {
                    attributes.append(attr)
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
    static func global_attribute_already_defined(context: some MacroExpansionContext, attribute: String, node: some SyntaxProtocol) {
        // TODO: reenable
        //context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "globalAttributeAlreadyDefined", message: "Global attribute \"" + attribute + "\" is already defined.")))
    }
    // MARK: Parse innerHTML
    static func parse_inner_html(
        context: some MacroExpansionContext,
        child: LabeledExprSyntax,
        lookupFiles: Set<String>
    ) -> CustomStringConvertible? {
        if let expansion:MacroExpansionExprSyntax = child.expression.macroExpansion {
            return "" // TODO: fix?
        } else if let string:HTMLElement = parse_element(context: context, expr: child.expression) {
            return string
        } else if var string:String = parse_literal_value(context: context, key: "", expression: child.expression, lookupFiles: lookupFiles)?.value(key: "") {
            string.escapeHTML(escapeAttributes: false)
            return string
        } else {
            unallowed_expression(context: context, node: child)
            return nil
        }
    }
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

    // MARK: Parse element
    static func parse_element(context: some MacroExpansionContext, expr: ExprSyntax) -> HTMLElement? {
        guard let function:FunctionCallExprSyntax = expr.functionCall else { return nil }
        return HTMLElementValueType.parse_element(context: context, function)
    }

    // MARK: Parse Literal Value
    static func parse_literal_value(
        context: some MacroExpansionContext,
        key: String,
        expression: ExprSyntax,
        lookupFiles: Set<String>
    ) -> LiteralReturnType? {
        if let boolean:String = expression.booleanLiteral?.literal.text {
            return .boolean(boolean == "true")
        }
        if let string:String = expression.integerLiteral?.literal.text ?? expression.floatLiteral?.literal.text {
            return .string(string)
        }
        guard var returnType:LiteralReturnType = extract_literal(context: context, key: key, expression: expression, lookupFiles: lookupFiles) else {
            //context.diagnose(Diagnostic(node: expression, message: DiagnosticMsg(id: "somethingWentWrong", message: "Something went wrong. (" + expression.debugDescription + ")", severity: .warning)))
            return nil
        }
        var remaining_interpolation:Int = returnType.isInterpolation ? 1 : 0, interpolation:[ExpressionSegmentSyntax] = []
        if let stringLiteral:StringLiteralExprSyntax = expression.stringLiteral {
            remaining_interpolation = stringLiteral.segments.count(where: { $0.is(ExpressionSegmentSyntax.self) })
            interpolation = stringLiteral.segments.compactMap({ $0.as(ExpressionSegmentSyntax.self) })
        }
        var string:String = ""
        switch returnType {
            case .interpolation(let i): string = i
            default: break
        }
        for expr in interpolation {
            string.replace("\(expr)", with: promote_interpolation(context: context, remaining_interpolation: &remaining_interpolation, expr: expr, lookupFiles: lookupFiles))
        }
        if remaining_interpolation > 0 {
            warn_interpolation(context: context, node: expression, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
            if remaining_interpolation > 0 && !string.contains("\\(") {
                string = "\\(" + string + ")"
            }
        }
        if remaining_interpolation > 0 {
            returnType = .interpolation(string)
        }
        return returnType
    }
    // MARK: Extract literal
    static func extract_literal(
        context: some MacroExpansionContext,
        key: String,
        expression: ExprSyntax,
        lookupFiles: Set<String>
    ) -> LiteralReturnType? {
        if let stringLiteral:StringLiteralExprSyntax = expression.stringLiteral {
            let string:String = stringLiteral.string
            return stringLiteral.segments.count(where: { $0.is(ExpressionSegmentSyntax.self) }) == 0 ? .string(string) : .interpolation(string)
        }
        if let function:FunctionCallExprSyntax = expression.functionCall {
            let enums:Set<String> = ["command", "download", "height", "width"]
            if enums.contains(key) || key.hasPrefix("aria-") {
                return .enumCase("")
            } else {
                if let decl:String = function.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                    switch decl {
                        case "StaticString":
                            var string:String = function.arguments.first!.expression.stringLiteral!.string
                            return .string(string)
                        default:
                            if let element:HTMLElement = HTMLElementValueType.parse_element(context: context, function) {
                                let string:String = element.description
                                return string.contains("\\(") ? .interpolation(string) : .string(string)
                            }
                            break
                    }
                }
                return .interpolation("\(function)")
            }
        }
        if let member:MemberAccessExprSyntax = expression.memberAccess {
            return .interpolation("\(member)")
        }
        if let array:ArrayExprSyntax = expression.array {
            let separator:String
            switch key {
                case "accept", "coords", "exportparts", "imagesizes", "imagesrcset", "sizes", "srcset":
                    separator = ","
                    break
                case "allow":
                    separator = ";"
                    break
                default:
                    separator = " "
                    break
            }
            var results:[String] = []
            for element in array.elements {
                if let string:String = element.expression.stringLiteral?.string {
                    if string.contains(separator) {
                        context.diagnose(Diagnostic(node: element.expression, message: DiagnosticMsg(id: "characterNotAllowedInDeclaration", message: "Character \"\(separator)\" is not allowed when declaring values for \"" + key + "\".")))
                        return nil
                    }
                    results.append(string)
                }
                if let string:String = element.expression.integerLiteral?.literal.text ?? element.expression.floatLiteral?.literal.text {
                    results.append(string)
                }
            }
            let result:String = results.joined(separator: separator)
            return .array(of: .string(result))
        }
        if let _:DeclReferenceExprSyntax = expression.as(DeclReferenceExprSyntax.self) {
            var string:String = "\(expression)", remaining_interpolation:Int = 1
            warn_interpolation(context: context, node: expression, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
            if remaining_interpolation > 0 {
                return .interpolation("\\(" + string + ")")
            } else {
                return .string(string)
            }
        }
        return nil
    }
    // MARK: Promote Interpolation
    static func promote_interpolation(
        context: some MacroExpansionContext,
        remaining_interpolation: inout Int,
        expr: ExpressionSegmentSyntax,
        lookupFiles: Set<String>
    ) -> String {
        var string:String = "\(expr)"
        guard let expression:ExprSyntax = expr.expressions.first?.expression else { return string }
        if let stringLiteral:StringLiteralExprSyntax = expression.stringLiteral {
            let segments:StringLiteralSegmentListSyntax = stringLiteral.segments
            if segments.count(where: { $0.is(StringSegmentSyntax.self) }) == segments.count {
                remaining_interpolation = 0
                string = segments.map({ $0.as(StringSegmentSyntax.self)!.content.text }).joined()
            } else {
                string = ""
                for segment in segments {
                    if let literal:String = segment.as(StringSegmentSyntax.self)?.content.text {
                        string += literal
                    } else if let interpolation:ExpressionSegmentSyntax = segment.as(ExpressionSegmentSyntax.self) {
                        let promoted:String = promote_interpolation(context: context, remaining_interpolation: &remaining_interpolation, expr: interpolation, lookupFiles: lookupFiles)
                        if "\(interpolation)" == promoted {
                            //string += "\\(\"\(promoted)\".escapingHTML(escapeAttributes: true))"
                            string += "\(promoted)"
                            warn_interpolation(context: context, node: interpolation, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
                        } else {
                            string += promoted
                        }
                    } else {
                        //string += "\\(\"\(segment)\".escapingHTML(escapeAttributes: true))"
                        warn_interpolation(context: context, node: segment, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
                        string += "\(segment)"
                    }
                }
            }
        } else if let fix:String = expression.integerLiteral?.literal.text ?? expression.floatLiteral?.literal.text {
            let target:String = "\(expr)"
            remaining_interpolation -= string.ranges(of: target).count
            string.replace(target, with: fix)
        } else {
            //string = "\\(\"\(string)\".escapingHTML(escapeAttributes: true))"
            warn_interpolation(context: context, node: expr, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
        }
        return string
    }
    // MARK: warn interpolation
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
}

// MARK: Misc
package extension SyntaxProtocol {
    var booleanLiteral : BooleanLiteralExprSyntax? { self.as(BooleanLiteralExprSyntax.self) }
    var stringLiteral : StringLiteralExprSyntax? { self.as(StringLiteralExprSyntax.self) }
    var integerLiteral : IntegerLiteralExprSyntax? { self.as(IntegerLiteralExprSyntax.self) }
    var floatLiteral : FloatLiteralExprSyntax? { self.as(FloatLiteralExprSyntax.self) }
    var array : ArrayExprSyntax? { self.as(ArrayExprSyntax.self) }
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