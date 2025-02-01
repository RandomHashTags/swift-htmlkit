//
//  HTMLElement.swift
//
//
//  Created by Evan Anderson on 9/14/24.
//

import HTMLKitParse
import HTMLKitUtilities
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum HTMLElementMacro : ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let ignoresCompilerWarnings:Bool = node.macroName.text == "uncheckedHTML"
        return try HTMLKitUtilities.expandHTMLMacro(context: HTMLExpansionContext(context: context, expansion: node.as(ExprSyntax.self)!.macroExpansion!, ignoresCompilerWarnings: ignoresCompilerWarnings, encoding: .string, key: "", arguments: node.arguments))
    }
}