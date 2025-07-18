
import HTMLKitParse
import HTMLKitUtilities
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum HTMLElementMacro: ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let c = HTMLExpansionContext(
            context: context,
            expansion: node,
            ignoresCompilerWarnings: node.macroName.text == "uncheckedHTML",
            encoding: .string,
            resultType: .literal,
            key: "",
            arguments: node.arguments,
            escape: true,
            escapeAttributes: true
        )
        return try HTMLKitUtilities.expandHTMLMacro(context: c)
    }
}