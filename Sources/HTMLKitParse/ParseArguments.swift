
import HTMLAttributes
import HTMLKitUtilities

extension HTMLKitUtilities {
    public static func parseArguments(
        context: HTMLExpansionContext,
        otherAttributes: [String:String] = [:]
    ) -> ElementData {
        var context = context
        return parseArguments(context: &context, otherAttributes: otherAttributes)
    }

    public static func parseArguments(
        context: inout HTMLExpansionContext,
        otherAttributes: [String:String] = [:]
    ) -> ElementData {
        var globalAttributes = [HTMLAttribute]()
        var attributes = [String:Sendable]()
        var innerHTML = [Sendable]()
        var trailingSlash = false
        for element in context.arguments.children(viewMode: .all) {
            guard let child = element.labeled else { continue }
            context.key = ""
            if let key = child.label?.text {
                context.key = key
                switch key {
                case "encoding":
                    context.encoding = .parse(expr: child.expression) ?? .string
                case "resultType":
                    context.resultType = .parse(expr: child.expression) ?? .literal
                case "lookupFiles":
                    guard let array = child.expression.array?.elements else {
                        context.diagnose(DiagnosticMsg.expectedArrayExpr(expr: child.expression))
                        break
                    }
                    context.lookupFiles = Set(array.compactMap({
                        guard let string = $0.expression.stringLiteral?.string(encoding: context.encoding) else {
                            context.diagnose(DiagnosticMsg.expectedStringLiteral(expr: $0.expression))
                            return nil
                        }
                        return string
                    }))
                case "attributes":
                    guard let array = child.expression.array?.elements else {
                        context.diagnose(DiagnosticMsg.expectedArrayExpr(expr: child.expression))
                        break
                    }
                    (globalAttributes, trailingSlash) = parseGlobalAttributes(context: context, array: array)
                default:
                    context.key = otherAttributes[key] ?? key
                    if let test = HTMLAttribute.Extra.parse(context: context, expr: child.expression) {
                        attributes[key] = test
                    } else if let literal = parseLiteral(context: context, expr: child.expression) {
                        switch literal {
                        case .boolean(let b):
                            attributes[key] = b
                        case .string, .interpolation:
                            attributes[key] = literal.value(key: key, escape: context.escape, escapeAttributes: context.escapeAttributes)
                        case .int(let i):
                            attributes[key] = i
                        case .float(let f):
                            attributes[key] = f
                        case .arrayOfLiterals(let literals):
                            attributes[key] = literals.compactMap({ $0.value(key: key, escape: context.escape, escapeAttributes: context.escapeAttributes) }).joined()
                        case .array:
                            switch literal.escapeArray() {
                            case .array(let a):
                                attributes[key] = a
                            default:
                                break
                            }
                        }
                    }
                }
            // inner html
            } else if let inner_html = parseInnerHTML(context: context, expr: child.expression) {
                innerHTML.append(inner_html)
            }
        }
        if let statements = context.trailingClosure?.statements {
            var c = context
            c.trailingClosure = nil
            for statement in statements {
                switch statement.item {
                case .expr(let expr):
                    if let inner_html = parseInnerHTML(context: c, expr: expr) {
                        innerHTML.append(inner_html)
                    }
                default:
                    break
                }
            }
        }
        return ElementData(context.encoding, globalAttributes, attributes, innerHTML, trailingSlash)
    }
}