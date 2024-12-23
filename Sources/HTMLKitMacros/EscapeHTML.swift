//
//  EscapeHTML.swift
//
//
//  Created by Evan Anderson on 11/23/24.
//

import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

enum EscapeHTML : ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        return "\"\(raw: HTMLKitUtilities.escapeHTML(expansion: node.macroExpansion!, context: context))\""
    }
}