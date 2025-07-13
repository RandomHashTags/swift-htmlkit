
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
            representation: .literal,
            key: "",
            arguments: node.arguments
        )
        return "\"\(raw: HTMLKitUtilities.rawHTML(context: &c))\""
    }
}