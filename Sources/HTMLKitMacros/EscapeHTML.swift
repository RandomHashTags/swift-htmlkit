
import HTMLKitParse
import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

enum EscapeHTML: ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        var c = HTMLExpansionContext(
            context: context,
            expansion: node,
            ignoresCompilerWarnings: false,
            encoding: .string,
            representation: .literalOptimized,
            key: "",
            arguments: node.arguments,
            escape: true,
            escapeAttributes: true
        )
        return "\"\(raw: HTMLKitUtilities.escapeHTML(context: &c))\""
    }
}