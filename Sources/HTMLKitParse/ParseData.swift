
import HTMLElements
import HTMLKitUtilities
import SwiftDiagnostics
import SwiftSyntax

extension HTMLKitUtilities {
    // MARK: Escape HTML
    public static func escapeHTML(
        context: HTMLExpansionContext
    ) -> String {
        var context = context
        return escapeHTML(context: &context)
    }
    public static func escapeHTML(
        context: inout HTMLExpansionContext
    ) -> String {
        context.escape = true
        context.escapeAttributes = true
        context.elementsRequireEscaping = true
        return html(
            context: context
        )
    }

    // MARK: Raw HTML
    public static func rawHTML(
        context: HTMLExpansionContext
    ) -> String {
        var context = context
        return rawHTML(context: &context)
    }
    public static func rawHTML(
        context: inout HTMLExpansionContext
    ) -> String {
        context.escape = false
        context.escapeAttributes = false
        context.elementsRequireEscaping = false
        return html(
            context: context
        )
    }

    // MARK: HTML
    public static func html(
        context: HTMLExpansionContext
    ) -> String {
        var context = context
        let children = context.arguments.children(viewMode: .all)
        var innerHTML = ""
        innerHTML.reserveCapacity(children.count)
        for e in children {
            guard let child = e.labeled else { continue }
            if let key = child.label?.text {
                switch key {
                case "encoding": context.encoding = parseEncoding(expression: child.expression) ?? .string
                case "representation": context.representation = parseRepresentation(expr: child.expression) ?? .literal
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

    // MARK: Parse Encoding
    public static func parseEncoding(expression: ExprSyntax) -> HTMLEncoding? {
        switch expression.kind {
        case .memberAccessExpr:
            return HTMLEncoding(rawValue: expression.memberAccess!.declName.baseName.text)
        case .functionCallExpr:
            let function = expression.functionCall!
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

    // MARK: Parse Representation
    public static func parseRepresentation(expr: ExprSyntax) -> HTMLResultRepresentation? {
        switch expr.kind {
        case .memberAccessExpr:
            switch expr.memberAccess!.declName.baseName.text {
            case "literal": return .literal
            //case "literalOptimized": return .literalOptimized
            case "chunked": return .chunked()
            #if compiler(>=6.2)
            case "chunkedInline": return .chunkedInline()
            #endif
            case "streamed": return .streamed()
            case "streamedAsync": return .streamedAsync()
            default: return nil
            }
        case .functionCallExpr:
            let function = expr.functionCall!
            var optimized = true
            var chunkSize = 1024
            var suspendDuration:Duration? = nil
            for arg in function.arguments {
                switch arg.label?.text {
                case "optimized":
                    optimized = arg.expression.booleanIsTrue
                case "chunkSize":
                    if let s = arg.expression.integerLiteral?.literal.text, let size = Int(s) {
                        chunkSize = size
                    }
                case "suspendDuration":
                    guard let function = arg.expression.functionCall else { break }
                    var intValue:UInt64? = nil
                    var doubleValue:Double? = nil
                    if let v = function.arguments.first?.expression.integerLiteral?.literal.text, let i = UInt64(v) {
                        intValue = i
                    } else if let v = function.arguments.first?.expression.as(FloatLiteralExprSyntax.self)?.literal.text, let d = Double(v) {
                        doubleValue = d
                    } else {
                        break
                    }
                    switch function.calledExpression.memberAccess?.declName.baseName.text {
                    case "milliseconds":
                        if let intValue {
                            suspendDuration = .milliseconds(intValue)
                        } else if let doubleValue {
                            suspendDuration = .milliseconds(doubleValue)
                        }
                    case "microseconds":
                        if let intValue {
                            suspendDuration = .microseconds(intValue)
                        } else if let doubleValue {
                            suspendDuration = .microseconds(doubleValue)
                        }
                    case "nanoseconds":
                        if let intValue {
                            suspendDuration = .nanoseconds(intValue)
                        }
                    case "seconds":
                        if let intValue {
                            suspendDuration = .seconds(intValue)
                        } else if let doubleValue {
                            suspendDuration = .seconds(doubleValue)
                        }
                    default:
                        break
                    }
                default:
                    break
                }
            }
            switch function.calledExpression.memberAccess?.declName.baseName.text {
            case "chunked":
                return .chunked(optimized: optimized, chunkSize: chunkSize)
            #if compiler(>=6.2)
            case "chunkedInline":
                return .chunkedInline(optimized: optimized, chunkSize: chunkSize)
            #endif
            case "streamed":
                return .streamed(optimized: optimized, chunkSize: chunkSize)
            case "streamedAsync":
                return .streamedAsync(optimized: optimized, chunkSize: chunkSize, suspendDuration: suspendDuration)
            default:
                return nil
            }
        default:
            return nil
        }
    }
}

extension HTMLKitUtilities {
    // MARK: GA Already Defined
    static func globalAttributeAlreadyDefined(context: HTMLExpansionContext, attribute: String, node: some SyntaxProtocol) {
        context.context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "globalAttributeAlreadyDefined", message: "Global attribute \"" + attribute + "\" is already defined.")))
    }

    // MARK: Unallowed Expression
    static func unallowedExpression(context: HTMLExpansionContext, node: ExprSyntax) {
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
    static func warnInterpolation(
        context: HTMLExpansionContext,
        node: some SyntaxProtocol
    ) {
        /*#if canImport(SwiftLexicalLookup)
        for t in node.tokens(viewMode: .fixedUp) {
            let results = node.lookup(t.identifier)
            for result in results {
                switch result {
                case .lookForMembers(let test):
                    print("lookForMembers=" + test.debugDescription)
                case .lookForImplicitClosureParameters(let test):
                    print("lookForImplicitClosureParameters=" + test.debugDescription)
                default:
                    print(result.debugDescription)
                }
            }
        }
        #endif*/
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
}

// MARK: DiagnosticMsg
package struct DiagnosticMsg: DiagnosticMessage, FixItMessage {
    package let message:String
    package let diagnosticID:MessageID
    package let severity:DiagnosticSeverity
    package var fixItID: MessageID { diagnosticID }

    package init(id: String, message: String, severity: DiagnosticSeverity = .error) {
        self.message = message
        self.diagnosticID = MessageID(domain: "HTMLKitMacros", id: id)
        self.severity = severity
    }
}