//
//  HTMLKitMacros.swift
//
//
//  Created by Evan Anderson on 9/14/24.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct HTMLKitMacros : CompilerPlugin {
    let providingMacros:[any Macro.Type] = [
        HTMLElementMacro.self,
        EscapeHTML.self,
        RawHTML.self,
        HTMLContext.self
    ]
}