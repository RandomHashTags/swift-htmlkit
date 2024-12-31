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
            return nil
        }
        guard returnType.isInterpolation else { return returnType }
        var remaining_interpolation:Int = 1
        var string:String
        if let stringLiteral:StringLiteralExprSyntax = expression.stringLiteral {
            remaining_interpolation = 0
            var interpolation:[ExpressionSegmentSyntax] = []
            var segments:[any (SyntaxProtocol & SyntaxHashable)] = []
            for segment in stringLiteral.segments {
                segments.append(segment)
                if let expression:ExpressionSegmentSyntax = segment.as(ExpressionSegmentSyntax.self) {
                    interpolation.append(expression)
                }
                remaining_interpolation += segment.is(StringSegmentSyntax.self) ? 0 : 1
            }
            var minimum:Int = 0
            for expr in interpolation {
                let promotions:[any (SyntaxProtocol & SyntaxHashable)] = promoteInterpolation(context: context, remaining_interpolation: &remaining_interpolation, expr: expr, lookupFiles: lookupFiles)
                for (i, segment) in segments.enumerated() {
                    if i >= minimum && segment.as(ExpressionSegmentSyntax.self) == expr {
                        segments.remove(at: i)
                        segments.insert(contentsOf: promotions, at: i)
                        minimum += promotions.count
                        break
                    }
                }
            }
            string = segments.map({ "\($0)" }).joined()
        } else {
            if let function:FunctionCallExprSyntax = expression.functionCall {
                warn_interpolation(context: context, node: function.calledExpression)
            } else {
                warn_interpolation(context: context, node: expression)
            }
            if let member:MemberAccessExprSyntax = expression.memberAccess {
                string = "\\(" + member.singleLineDescription + ")"
            } else {
                var expression_string:String = "\(expression)"
                while expression_string.first?.isWhitespace ?? false {
                    expression_string.removeFirst()
                }
                while expression_string.last?.isWhitespace ?? false {
                    expression_string.removeLast()
                }
                string = "\" + String(describing: " + expression_string + ") + \""
            }
        }
        // TODO: promote interpolation via lookupFiles here (remove `warn_interpolation` above and from `promoteInterpolation`)
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
    ) -> [any (SyntaxProtocol & SyntaxHashable)] {
        func create(_ string: String) -> StringLiteralExprSyntax {
            var s:StringLiteralExprSyntax = StringLiteralExprSyntax(content: string)
            s.openingQuote = TokenSyntax(stringLiteral: "")
            s.closingQuote = TokenSyntax(stringLiteral: "")
            return s
        }
        func interpolate(_ syntax: ExprSyntaxProtocol) -> ExpressionSegmentSyntax {
            var list:LabeledExprListSyntax = LabeledExprListSyntax()
            list.append(LabeledExprSyntax(expression: syntax))
            return ExpressionSegmentSyntax(expressions: list)
        }
        var values:[any (SyntaxProtocol & SyntaxHashable)] = []
        for element in expr.expressions {
            let expression:ExprSyntax = element.expression
            if let stringLiteral:StringLiteralExprSyntax = expression.stringLiteral {
                let segments:StringLiteralSegmentListSyntax = stringLiteral.segments
                if segments.count(where: { $0.is(StringSegmentSyntax.self) }) == segments.count {
                    remaining_interpolation -= 1
                    values.append(create(stringLiteral.string))
                } else {
                    for segment in segments {
                        if let literal:String = segment.as(StringSegmentSyntax.self)?.content.text {
                            values.append(create(literal))
                        } else if let interpolation:ExpressionSegmentSyntax = segment.as(ExpressionSegmentSyntax.self) {
                            let promotions:[any (SyntaxProtocol & SyntaxHashable)] = promoteInterpolation(context: context, remaining_interpolation: &remaining_interpolation, expr: interpolation, lookupFiles: lookupFiles)
                            values.append(contentsOf: promotions)
                        } else {
                            context.diagnose(Diagnostic(node: segment, message: DiagnosticMsg(id: "somethingWentWrong", message: "Something went wrong. (" + expression.debugDescription + ")")))
                            return values
                        }
                    }
                }
            } else if let fix:String = expression.integerLiteral?.literal.text ?? expression.floatLiteral?.literal.text {
                remaining_interpolation -= 1
                values.append(create(fix))
            } else {
                //if let decl:DeclReferenceExprSyntax = expression.declRef {
                    // TODO: lookup and try to promote | need to wait for swift-syntax to update to access SwiftLexicalLookup
                //}
                values.append(interpolate(expression))
                warn_interpolation(context: context, node: expression)
            }
        }
        return values
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
            return .interpolation("\(function)")
        }
        if expression.memberAccess != nil || expression.is(ForceUnwrapExprSyntax.self) {
            return .interpolation("\(expression)")
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
        if let decl:DeclReferenceExprSyntax = expression.declRef {
            warn_interpolation(context: context, node: expression)
            return .interpolation(decl.baseName.text)
        }
        return nil
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

// MARK: Misc
extension MemberAccessExprSyntax {
    var singleLineDescription : String {
        var string:String = "\(self)"
        string.removeAll { $0.isWhitespace }
        return string
    }
}