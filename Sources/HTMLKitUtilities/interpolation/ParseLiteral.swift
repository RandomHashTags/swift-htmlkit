//
//  ParseLiteral.swift
//
//
//  Created by Evan Anderson on 11/27/24.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

extension HTMLKitUtilities {
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
        if let string:String = expression.integerLiteral?.literal.text {
            return .int(Int(string)!)
        }
        if let string:String = expression.floatLiteral?.literal.text {
            return .float(Float(string)!)
        }
        guard var returnType:LiteralReturnType = extract_literal(context: context, key: key, expression: expression, lookupFiles: lookupFiles) else {
            //context.diagnose(Diagnostic(node: expression, message: DiagnosticMsg(id: "somethingWentWrong", message: "Something went wrong. (" + expression.debugDescription + ")", severity: .warning)))
            return nil
        }
        var string:String = ""
        switch returnType {
            case .interpolation(let s): string = s
            default: return returnType
        }
        var remaining_interpolation:Int = returnType.isInterpolation ? 1 : 0, interpolation:[ExpressionSegmentSyntax] = []
        if let stringLiteral:StringLiteralExprSyntax = expression.stringLiteral {
            remaining_interpolation = stringLiteral.segments.count(where: { $0.is(ExpressionSegmentSyntax.self) })
            interpolation = stringLiteral.segments.compactMap({ $0.as(ExpressionSegmentSyntax.self) })
        }
        for expr in interpolation {
            string.replace("\(expr)", with: promoteInterpolation(context: context, remaining_interpolation: &remaining_interpolation, expr: expr, lookupFiles: lookupFiles))
        }
        if remaining_interpolation > 0 {
            warn_interpolation(context: context, node: expression, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
            if remaining_interpolation > 0 && !string.contains("\\(") {
                string = "\\(" + string + ")"
            }
        }
        if remaining_interpolation > 0 {
            returnType = .interpolation(string)
        } else {
            returnType = .string(string)
        }
        return returnType
    }
    // MARK: Promote Interpolation
    static func promoteInterpolation(
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
                        let promoted:String = promoteInterpolation(context: context, remaining_interpolation: &remaining_interpolation, expr: interpolation, lookupFiles: lookupFiles)
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
            //if let decl:DeclReferenceExprSyntax = expression.declRef {
                // TODO: lookup and try to promote | need to wait for swift-syntax to update to access SwiftLexicalLookup
            //}
            //string = "\\(\"\(string)\".escapingHTML(escapeAttributes: true))"
            warn_interpolation(context: context, node: expr, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
        }
        return string
    }
    // MARK: Extract Literal
    static func extract_literal(
        context: some MacroExpansionContext,
        key: String,
        expression: ExprSyntax,
        lookupFiles: Set<String>
    ) -> LiteralReturnType? {
        if let _:NilLiteralExprSyntax = expression.as(NilLiteralExprSyntax.self) {
            return nil
        }
        if let stringLiteral:StringLiteralExprSyntax = expression.stringLiteral {
            let string:String = stringLiteral.string
            if stringLiteral.segments.count(where: { $0.is(ExpressionSegmentSyntax.self) }) == 0 {
                return .string(string)
            } else {
                return .interpolation(string)
            }
        }
        if let function:FunctionCallExprSyntax = expression.functionCall {
            if let decl:String = function.calledExpression.declRef?.baseName.text {
                switch decl {
                    case "StaticString":
                        let string:String = function.arguments.first!.expression.stringLiteral!.string
                        return .string(string)
                    default:
                        break
                }
            }
            return .interpolation(expr_to_single_line(function))
        }
        if let member:MemberAccessExprSyntax = expression.memberAccess {
            return .interpolation(expr_to_single_line(member))
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
            var results:[Any] = []
            for element in array.elements {
                if let attribute:any HTMLInitializable = HTMLElementAttribute.Extra.parse(context: context, key: key, expr: element.expression) {
                    results.append(attribute)
                } else if let literal:LiteralReturnType = parse_literal_value(context: context, key: key, expression: element.expression, lookupFiles: lookupFiles) {
                    switch literal {
                        case .string(let string), .interpolation(let string):
                            if string.contains(separator) {
                                context.diagnose(Diagnostic(node: element.expression, message: DiagnosticMsg(id: "characterNotAllowedInDeclaration", message: "Character \"\(separator)\" is not allowed when declaring values for \"" + key + "\".")))
                                return nil
                            }
                            results.append(string)
                        case .int(let i): results.append(i)
                        case .float(let f): results.append(f)
                        case .array(let a): results.append(a)
                        case .boolean(let b): results.append(b)
                    }
                }
            }
            return .array(results)
        }
        if let decl:DeclReferenceExprSyntax = expression.as(DeclReferenceExprSyntax.self) {
            var string:String = decl.baseName.text, remaining_interpolation:Int = 1
            warn_interpolation(context: context, node: expression, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
            if remaining_interpolation > 0 {
                return .interpolation("\\(" + string + ")")
            } else {
                return .string(string)
            }
        }
        if let unwrap:ForceUnwrapExprSyntax = expression.as(ForceUnwrapExprSyntax.self) {
            let merged:String = expr_to_single_line(unwrap)
            return .interpolation("\\(" + merged + ")")
        }
        return nil
    }

    // MARK: Expr to Single Line
    static func expr_to_single_line(_ expression: ExprSyntax) -> String {
        if let function:FunctionCallExprSyntax = expression.functionCall {
            return expr_to_single_line(function)
        } else if let member:MemberAccessExprSyntax = expression.memberAccess {
            return expr_to_single_line(member)
        } else if let force_unwrap:ForceUnwrapExprSyntax = expression.as(ForceUnwrapExprSyntax.self) {
            return expr_to_single_line(force_unwrap) + "!"
        } else {
            return "\(expression)"
        }
    }
    static func expr_to_single_line(_ force_unwrap: ForceUnwrapExprSyntax) -> String {
        return expr_to_single_line(force_unwrap.expression) + "!"
    }
    static func expr_to_single_line(_ member: MemberAccessExprSyntax) -> String {
        var string:String = "\(member)"
        string.removeAll { $0.isWhitespace }
        return string
    }
    static func expr_to_single_line(_ function: FunctionCallExprSyntax) -> String {
        var string:String = "\(function.calledExpression)"
        string.removeAll { $0.isWhitespace }
        var args:String = ""
        var is_first:Bool = true
        for argument in function.arguments {
            var arg:String
            if let label = argument.label {
                arg = "\(label)"
                while arg.first?.isWhitespace ?? false {
                    arg.removeFirst()
                }
                if !is_first {
                    arg.insert(",", at: arg.startIndex)
                }
                arg += ": "
                var expr:String = expr_to_single_line(argument.expression)
                while expr.first?.isWhitespace ?? false {
                    expr.removeFirst()
                }
                arg += expr
            } else {
                arg = "\(argument)"
                while arg.first?.isWhitespace ?? false {
                    arg.removeFirst()
                }
            }
            args += arg
            is_first = false
        }
        args = "(" + args + ")"
        return string + args
    }
}

// MARK: LiteralReturnType
public enum LiteralReturnType {
    case boolean(Bool)
    case string(String)
    case int(Int)
    case float(Float)
    case interpolation(String)
    case array([Any])

    public var isInterpolation : Bool {
        switch self {
            case .interpolation(_): return true
            default: return false
        }
    }

    public func value(key: String) -> String? {
        switch self {
            case .boolean(let b): return b ? key : nil
            case .string(var string):
                if string.isEmpty && key == "attributionsrc" {
                    return ""
                }
                string.escapeHTML(escapeAttributes: true)
                return string
            case .int(let int):
                return String(describing: int)
            case .float(let float):
                return String(describing: float)
            case .interpolation(let string):
                return string
            case .array(_):
                return nil
        }
    }

    public func escapeArray() -> LiteralReturnType {
        switch self {
            case .array(let a):
                if let array_string:[String] = a as? [String] {
                    return .array(array_string.map({ $0.escapingHTML(escapeAttributes: true) }))
                }
                return .array(a)
            default:
                return self
        }
    }
}