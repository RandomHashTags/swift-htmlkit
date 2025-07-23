
import HTMLElements
import HTMLKitUtilities
import SwiftSyntax

extension HTMLKitUtilities {
    // MARK: Escape HTML
    public static func escapeHTML(context: HTMLExpansionContext) -> String {
        var context = context
        return escapeHTML(context: &context)
    }
    public static func escapeHTML(context: inout HTMLExpansionContext) -> String {
        context.escape = true
        context.escapeAttributes = true
        context.elementsRequireEscaping = true
        return html(context: context)
    }

    // MARK: Raw HTML
    public static func rawHTML(context: HTMLExpansionContext) -> String {
        var context = context
        return rawHTML(context: &context)
    }
    public static func rawHTML(context: inout HTMLExpansionContext) -> String {
        context.escape = false
        context.escapeAttributes = false
        context.elementsRequireEscaping = false
        return html(context: context)
    }

    // MARK: HTML
    public static func html(context: HTMLExpansionContext) -> String {
        var context = context
        let children = context.arguments.children(viewMode: .all)
        var innerHTML = ""
        innerHTML.reserveCapacity(children.count)
        for e in children {
            guard let child = e.labeled else { continue }
            if let key = child.label?.text {
                switch key {
                case "encoding": context.encoding = .parse(expr: child.expression) ?? .string
                case "resultType": context.resultType = .parse(expr: child.expression) ?? .literal
                case "minify": context.minify = child.expression.boolean(context) ?? false
                default: break
                }
            } else if var c = HTMLKitUtilities.parseInnerHTML(context: context, expr: child.expression) {
                if var element = c as? HTMLElement {
                    element.escaped = context.elementsRequireEscaping
                    c = element
                }
                innerHTML += String(describing: c)
            }
        }
        if context.minify {
            innerHTML = minify(html: innerHTML)
        }
        innerHTML.replace(HTMLKitUtilities.lineFeedPlaceholder, with: "\\n")
        return innerHTML
    }
}

// MARK: Parse encoding
extension HTMLEncoding {
    public static func parse(expr: some ExprSyntaxProtocol) -> HTMLEncoding? {
        switch expr.kind {
        case .memberAccessExpr:
            return HTMLEncoding(rawValue: expr.memberAccess!.declName.baseName.text)
        case .functionCallExpr:
            let function = expr.functionCall!
            switch function.calledExpression.memberAccess?.declName.baseName.text {
            case "custom":
                guard let logic = function.arguments.first?.expression.stringLiteral?.string(encoding: .string) else { return nil }
                if function.arguments.count == 1 {
                    return .custom(logic)
                } else if let delimiter = function.arguments.last!.expression.stringLiteral?.string(encoding: .string) {
                    return .custom(logic, stringDelimiter: delimiter)
                } else {
                    return nil
                }
            default:
                return nil
            }
        default:
            return nil
        }
    }
}

// MARK: Parse result type
extension HTMLExpansionResultTypeAST {
    public static func parse(expr: some ExprSyntaxProtocol) -> Self? {
        switch expr.kind {
        case .memberAccessExpr:
            switch expr.memberAccess!.declName.baseName.text {
            case "literal": return .literal
            //case "literalOptimized": return .literalOptimized
            case "chunks": return .chunks()
            case "chunksInline":
                #if compiler(>=6.2)
                return .chunksInline()
                #else
                return nil // TODO: show compiler diagnostic
                #endif
            
            case "stream": return .stream()
            case "streamAsync": return .streamAsync()
            default: return nil
            }
        case .functionCallExpr:
            let function = expr.functionCall!
            var optimized = true
            var chunkSize = 1024
            var yieldVariableName:String? = nil
            var afterYield:String? = nil
            for arg in function.arguments {
                switch arg.label?.text {
                case "optimized":
                    optimized = arg.expression.booleanIsTrue
                case "chunkSize":
                    if let s = arg.expression.integerLiteral?.literal.text, let size = Int(s) {
                        chunkSize = size
                    }
                default: // afterYield
                    guard let closure = arg.expression.as(ClosureExprSyntax.self) else { break }
                    if let parameters = closure.signature?.parameterClause {
                        switch parameters {
                        case .simpleInput(let shorthand):
                            yieldVariableName = shorthand.first?.name.text
                        case .parameterClause(let parameterSyntax):
                            if let parameter = parameterSyntax.parameters.first {
                                yieldVariableName = (parameter.secondName ?? parameter.firstName).text
                            }
                        }
                    }
                    afterYield = closure.statements.description
                }
            }
            switch function.calledExpression.memberAccess?.declName.baseName.text {
            case "chunks":
                return .chunks(optimized: optimized, chunkSize: chunkSize)
            case "chunksInline":
                #if compiler(>=6.2)
                return .chunksInline(optimized: optimized, chunkSize: chunkSize)
                #else
                return nil // TODO: show compiler diagnostic
                #endif
            case "stream":
                return .stream(optimized: optimized, chunkSize: chunkSize)
            case "streamAsync":
                return .streamAsync(optimized: optimized, chunkSize: chunkSize, yieldVariableName: yieldVariableName, afterYield: afterYield)
            default:
                // TODO: show compiler diagnostic
                return nil
            }
        default:
            return nil
        }
    }
}