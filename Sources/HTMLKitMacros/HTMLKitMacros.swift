
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct HTMLKitMacros: CompilerPlugin {
    let providingMacros:[any Macro.Type] = [
        HTMLElementMacro.self,
        EscapeHTML.self,
        RawHTML.self
    ]
}