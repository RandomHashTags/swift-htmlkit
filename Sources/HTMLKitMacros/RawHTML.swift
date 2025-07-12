
import HTMLKitParse
import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

enum RawHTML: ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        var c = HTMLExpansionContext(
            context: context,
            expansion: node,
            ignoresCompilerWarnings: false,
            encoding: .string,
            representation: .literalOptimized,
            key: "",
            arguments: node.arguments,
            escape: false,
            escapeAttributes: false
        )
        return "\"\(raw: HTMLKitUtilities.rawHTML(context: &c))\""
    }
}