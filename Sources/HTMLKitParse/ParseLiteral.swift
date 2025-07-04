
import HTMLAttributes
import HTMLKitUtilities
import SwiftDiagnostics
import SwiftSyntax

extension HTMLKitUtilities {
    // MARK: Parse Literal Value
    static func parseLiteralValue(
        context: HTMLExpansionContext,
        expression: ExprSyntax
    ) -> LiteralReturnType? {
        guard let returnType = extractLiteral(context: context, expression: expression) else { return nil }
        guard returnType.isInterpolation else { return returnType }
        var remainingInterpolation:Int = 1
        var string:String
        if let stringLiteral = expression.stringLiteral {
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
            string = segments.map({ "\($0)" }).joined()
        } else {
            if let function = expression.functionCall {
                warnInterpolation(context: context, node: function.calledExpression)
            } else {
                warnInterpolation(context: context, node: expression)
            }
            if let member = expression.memberAccess {
                string = "\\(" + member.singleLineDescription + ")"
            } else {
                var expressionString = "\(expression)"
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
                string = "\" + String(describing: " + expressionString + ") + \""
            }
        }
        // TODO: promote interpolation via lookupFiles here (remove `warnInterpolation` above and from `promoteInterpolation`)
        if remainingInterpolation > 0 {
            return .interpolation(string)
        } else {
            return .string(string)
        }
    }
    // MARK: Promote Interpolation
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
                            context.context.diagnose(Diagnostic(node: segment, message: DiagnosticMsg(id: "somethingWentWrong", message: "Something went wrong. (" + expression.debugDescription + ")")))
                            return values
                        }
                    }
                }
            } else if let fix = expression.integerLiteral?.literal.text ?? expression.floatLiteral?.literal.text {
                remainingInterpolation -= 1
                values.append(create(fix))
            } else {
                values.append(interpolate(expression))
                warnInterpolation(context: context, node: expression)
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
    static func interpolate(_ syntax: ExprSyntaxProtocol) -> ExpressionSegmentSyntax {
        var list = LabeledExprListSyntax()
        list.append(LabeledExprSyntax(expression: syntax))
        return ExpressionSegmentSyntax(expressions: list)
    }

    // MARK: Extract Literal
    static func extractLiteral(
        context: HTMLExpansionContext,
        expression: ExprSyntax
    ) -> LiteralReturnType? {
        switch expression.kind {
        case .nilLiteralExpr:
            return nil
        case .booleanLiteralExpr:
            return .boolean(expression.booleanLiteral!.literal.text == "true")
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
                    let string = function.arguments.first!.expression.stringLiteral!.string(encoding: context.encoding)
                    return .string(string)
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
            var results:[Sendable] = []
            for element in expression.array!.elements {
                if let attribute = HTMLAttribute.Extra.parse(context: context, expr: element.expression) {
                    results.append(attribute)
                } else if let literal = parseLiteralValue(context: context, expression: element.expression) {
                    switch literal {
                    case .string(let string), .interpolation(let string):
                        if string.contains(separator) {
                            context.context.diagnose(Diagnostic(node: element.expression, message: DiagnosticMsg(id: "characterNotAllowedInDeclaration", message: "Character \"\(separator)\" is not allowed when declaring values for \"" + context.key + "\".")))
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
        case .declReferenceExpr:
            warnInterpolation(context: context, node: expression)
            return .interpolation(expression.declRef!.baseName.text)
        default:
            return nil
        }
    }
}

// MARK: LiteralReturnType
public enum LiteralReturnType {
    case boolean(Bool)
    case string(String)
    case int(Int)
    case float(Float)
    case interpolation(String)
    case array([Sendable])

    public var isInterpolation: Bool {
        switch self {
        case .interpolation: true
        default: false
        }
    }

    /// - Parameters:
    ///   - key: Attribute key associated with the value.
    ///   - escape: Whether or not to escape source-breaking HTML characters.
    ///   - escapeAttributes: Whether or not to escape source-breaking HTML attribute characters.
    public func value(
        key: String,
        escape: Bool = true,
        escapeAttributes: Bool = true
    ) -> String? {
        switch self {
        case .boolean(let b):
            return b ? key : nil
        case .string(var string):
            if string.isEmpty && key == "attributionsrc" {
                return ""
            }
            if escape {
                string.escapeHTML(escapeAttributes: escapeAttributes)
            }
            return string
        case .int(let int):
            return String(describing: int)
        case .float(let float):
            return String(describing: float)
        case .interpolation(let string):
            return string
        case .array:
            return nil
        }
    }

    public func escapeArray() -> LiteralReturnType {
        switch self {
        case .array(let a):
            if let arrayString = a as? [String] {
                return .array(arrayString.map({ $0.escapingHTML(escapeAttributes: true) }))
            }
            return .array(a)
        default:
            return self
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