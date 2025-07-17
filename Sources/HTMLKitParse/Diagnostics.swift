
import HTMLKitUtilities
import SwiftDiagnostics
import SwiftSyntax

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

extension DiagnosticMsg {
    // MARK: GA Already Defined
    static func globalAttributeAlreadyDefined(context: HTMLExpansionContext, attribute: String, node: some SyntaxProtocol) -> Diagnostic {
        Diagnostic(node: node, message: DiagnosticMsg(id: "globalAttributeAlreadyDefined", message: "Global attribute \"" + attribute + "\" is already defined."))
    }

    // MARK: Unallowed Expression
    static func unallowedExpression(context: HTMLExpansionContext, node: some ExprSyntaxProtocol) {
        context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unallowedExpression", message: "String Interpolation is required when encoding runtime values."), fixIts: [
            FixIt(message: DiagnosticMsg(id: "useStringInterpolation", message: "Use String Interpolation."), changes: [
                FixIt.Change.replace(
                    oldNode: Syntax(node),
                    newNode: Syntax(StringLiteralExprSyntax(content: "\\(\(node))"))
                )
            ])
        ]))
    }

    // MARK: Something went wrong
    static func somethingWentWrong(context: HTMLExpansionContext, node: some SyntaxProtocol, expr: some ExprSyntaxProtocol) {
        context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "somethingWentWrong", message: "Something went wrong. (" + expr.debugDescription + ")")))
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
            context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unsafeInterpolation", message: "Interpolation may introduce raw HTML.", severity: .warning)))
        //}
    }
}

// MARK: Expectations
extension DiagnosticMsg {
    static func expectedArrayExpr(expr: some ExprSyntaxProtocol) -> Diagnostic {
        Diagnostic(node: expr, message: DiagnosticMsg(id: "expectedArrayExpr", message: "Expected array expression; got \(expr.kind)"))
    }
    static func expectedFunctionCallExpr(expr: some ExprSyntaxProtocol) -> Diagnostic {
        Diagnostic(node: expr, message: DiagnosticMsg(id: "expectedFunctionCallExpr", message: "Expected function call expression; got \(expr.kind)"))
    }
    static func expectedMemberAccessExpr(expr: some ExprSyntaxProtocol) -> Diagnostic {
        Diagnostic(node: expr, message: DiagnosticMsg(id: "expectedMemberAccessExpr", message: "Expected member access expression; got \(expr.kind)"))
    }
    static func expectedFunctionCallOrMemberAccessExpr(expr: some ExprSyntaxProtocol) -> Diagnostic {
        Diagnostic(node: expr, message: DiagnosticMsg(id: "expectedFunctionCallOrMemberAccessExpr", message: "Expected function call or member access expression; got \(expr.kind)"))
    }
    static func expectedStringLiteral(expr: some ExprSyntaxProtocol) -> Diagnostic {
        Diagnostic(node: expr, message: DiagnosticMsg(id: "expectedStringLiteral", message: "Expected string literal; got \(expr.kind)"))
    }
    static func expectedStringLiteralOrMemberAccess(expr: some ExprSyntaxProtocol) -> Diagnostic {
        Diagnostic(node: expr, message: DiagnosticMsg(id: "expectedStringLiteralOrMemberAccess", message: "Expected string literal or member access; got \(expr.kind)"))
    }
    static func stringLiteralContainsIllegalCharacter(expr: some ExprSyntaxProtocol, char: String) -> Diagnostic {
        Diagnostic(node: expr, message: DiagnosticMsg(id: "stringLiteralContainsIllegalCharacter", message: "String literal contains illegal character: \"\(char)\""))
    }
}
