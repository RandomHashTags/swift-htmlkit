//
//  EscapeHTML.swift
//
//
//  Created by Evan Anderson on 11/23/24.
//

import HTMLKitParse
import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

enum EscapeHTML : ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let c:HTMLExpansionContext = HTMLExpansionContext(context: context, encoding: .string, key: "", arguments: node.arguments)
        return "\"\(raw: HTMLKitUtilities.escapeHTML(context: c))\""
    }
}