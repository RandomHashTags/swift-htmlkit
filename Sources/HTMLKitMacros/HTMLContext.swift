
import HTMLKitParse
import HTMLKitUtilities
//import SwiftLexicalLookup
import SwiftSyntax
import SwiftSyntaxMacros

enum HTMLContext: ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        return "\"\""
    }
}