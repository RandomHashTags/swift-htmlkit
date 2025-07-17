
import HTMLAttributes
import HTMLKitUtilities
import SwiftSyntax

// MARK: Parse Literal Value
extension HTMLKitUtilities {
    static func parseLiteral(
        context: HTMLExpansionContext,
        expr: ExprSyntax
    ) -> LiteralReturnType? {
        guard let returnType = extractLiteral(context: context, expression: expr) else { return nil }
        guard returnType.isInterpolation else { return returnType }
        var remainingInterpolation = 1
        if let stringLiteral = expr.stringLiteral {
            remainingInterpolation = 0
            var interpolation = [ExpressionSegmentSyntax]()
            var segments:[any (SyntaxProtocol & SyntaxHashable)] = []
            for segment in stringLiteral.segments {
                segments.append(segment)
                if let expression = segment.as(ExpressionSegmentSyntax.self) {
                    interpolation.append(expression)
                    remainingInterpolation += 1
                }
            }
            var minimum = 0
            for expr in interpolation {
                let promotions = promoteInterpolation(context: context, remainingInterpolation: &remainingInterpolation, expr: expr)
                for (i, segment) in segments.enumerated() {
                    if i >= minimum && segment.as(ExpressionSegmentSyntax.self) == expr {
                        segments.remove(at: i)
                        segments.insert(contentsOf: promotions, at: i)
                        minimum += promotions.count
                        break
                    }
                }
            }
            let literals:[LiteralReturnType] = segments.compactMap({
                let string = "\($0)"
                guard !string.isEmpty else { return nil }
                if $0.is(ExpressionSegmentSyntax.self) {
                    return .interpolation(string)
                } else {
                    return .string(string)
                }
            })
            return .arrayOfLiterals(literals)
        } else {
            if let function = expr.functionCall {
                DiagnosticMsg.warnInterpolation(context: context, node: function.calledExpression)
            } else {
                DiagnosticMsg.warnInterpolation(context: context, node: expr)
            }
            if let member = expr.memberAccess {
                return .interpolation(member.singleLineDescription)
            } else {
                var expressionString = "\(expr)"
                var removed = 0
                var index = expressionString.startIndex
                while index < expressionString.endIndex, expressionString[index].isWhitespace {
                    removed += 1
                    expressionString.formIndex(after: &index)
                }
                expressionString.removeFirst(removed)
                while expressionString.last?.isWhitespace ?? false {
                    expressionString.removeLast()
                }
                return .interpolation(expressionString)
            }
        }
    }
}

// MARK: Promote Interpolation
extension HTMLKitUtilities {
    static func promoteInterpolation(
        context: HTMLExpansionContext,
        remainingInterpolation: inout Int,
        expr: ExpressionSegmentSyntax
    ) -> [any (SyntaxProtocol & SyntaxHashable)] {
        var values:[any (SyntaxProtocol & SyntaxHashable)] = []
        for element in expr.expressions {
            let expression = element.expression
            if let stringLiteral = expression.stringLiteral {
                let segments = stringLiteral.segments
                if segments.count(where: { $0.is(StringSegmentSyntax.self) }) == segments.count {
                    remainingInterpolation -= 1
                    values.append(create(stringLiteral.string(encoding: context.encoding)))
                } else {
                    for segment in segments {
                        if let literal = segment.as(StringSegmentSyntax.self)?.content.text {
                            values.append(create(literal))
                        } else if let interpolation = segment.as(ExpressionSegmentSyntax.self) {
                            let promotions = promoteInterpolation(context: context, remainingInterpolation: &remainingInterpolation, expr: interpolation)
                            values.append(contentsOf: promotions)
                        } else {
                            DiagnosticMsg.somethingWentWrong(context: context, node: segment, expr: expression)
                            return values
                        }
                    }
                }
            } else if let fix = expression.integerLiteral?.literal.text ?? expression.floatLiteral?.literal.text {
                remainingInterpolation -= 1
                values.append(create(fix))
            } else {
                values.append(interpolate(expression))
                DiagnosticMsg.warnInterpolation(context: context, node: expression)
            }
        }
        return values
    }
    static func create(_ string: String) -> StringLiteralExprSyntax {
        var s = StringLiteralExprSyntax(content: string)
        s.openingQuote = TokenSyntax(stringLiteral: "")
        s.closingQuote = TokenSyntax(stringLiteral: "")
        return s
    }
    static func interpolate(_ syntax: some ExprSyntaxProtocol) -> ExpressionSegmentSyntax {
        var list = LabeledExprListSyntax()
        list.append(LabeledExprSyntax(expression: syntax))
        return ExpressionSegmentSyntax(expressions: list)
    }
}

// MARK: Extract Literal
extension HTMLKitUtilities {
    static func extractLiteral(
        context: HTMLExpansionContext,
        expression: ExprSyntax
    ) -> LiteralReturnType? {
        switch expression.kind {
        case .nilLiteralExpr:
            return nil
        case .booleanLiteralExpr:
            return .boolean(expression.booleanIsTrue)
        case .integerLiteralExpr:
            return .int(Int(expression.integerLiteral!.literal.text)!)
        case .floatLiteralExpr:
            return .float(Float(expression.floatLiteral!.literal.text)!)
        case .memberAccessExpr, .forceUnwrapExpr:
            return .interpolation("\(expression)")
        case .stringLiteralExpr:
            let stringLiteral = expression.stringLiteral!
            let string = stringLiteral.string(encoding: context.encoding)
            if stringLiteral.segments.count(where: { $0.is(ExpressionSegmentSyntax.self) }) == 0 {
                return .string(string)
            } else {
                return .interpolation(string)
            }
        case .functionCallExpr:
            let function = expression.functionCall!
            if let decl = function.calledExpression.declRef?.baseName.text {
                switch decl {
                case "StaticString":
                    if let string = function.arguments.first?.expression.stringLiteral?.string(encoding: context.encoding) {
                        return .string(string)
                    }
                default:
                    break
                }
            }
            return .interpolation("\(function)")
        case .arrayExpr:
            let separator:String
            switch context.key {
            case "accept", "coords", "exportparts", "imagesizes", "imagesrcset", "sizes", "srcset":
                separator = ","
            case "allow":
                separator = ";"
            default:
                separator = " "
            }
            var results = [Sendable]()
            for e in expression.array!.elements {
                if let attribute = HTMLAttribute.Extra.parse(context: context, expr: e.expression) {
                    results.append(attribute)
                } else if let literal = parseLiteral(context: context, expr: e.expression) {
                    if let sendable = literalToSendable(context: context, expr: e.expression, separator: separator, literal: literal) {
                        results.append(sendable)
                    }
                }
            }
            return .array(results)
        case .declReferenceExpr:
            DiagnosticMsg.warnInterpolation(context: context, node: expression)
            return .interpolation(expression.declRef!.baseName.text)
        default:
            return nil
        }
    }
    static func literalToSendable(
        context: HTMLExpansionContext,
        expr: ExprSyntax,
        separator: String,
        literal: LiteralReturnType
    ) -> (any Sendable)? {
        switch literal {
        case .string(let string), .interpolation(let string):
            if string.contains(separator) {
                context.diagnose(DiagnosticMsg.stringLiteralContainsIllegalCharacter(expr: expr, char: separator))
                return nil
            }
            return string
        case .arrayOfLiterals(let literals):
            return literals.compactMap({ literalToSendable(context: context, expr: expr, separator: separator, literal: $0) })
        case .int(let i):
            return i
        case .float(let f):
            return f
        case .array(let a):
            return a
        case .boolean(let b):
            return b
        }
    }
}

// MARK: Misc
extension MemberAccessExprSyntax {
    @inlinable
    var singleLineDescription: String {
        var string = "\(self)"
        string.removeAll { $0.isWhitespace }
        return string
    }
}