//
//  HTMLKitMacros.swift
//
//
//  Created by Evan Anderson on 9/14/24.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros
import SwiftDiagnostics

// MARK: ErrorDiagnostic
struct ErrorDiagnostic : DiagnosticMessage {
    let message:String
    let diagnosticID:MessageID
    let severity:DiagnosticSeverity = DiagnosticSeverity.error

    init(id: String, message: String) {
        self.message = message
        self.diagnosticID = MessageID(domain: "HTMLKitMacros", id: id)
    }
}

@main
struct HTMLKitMacros : CompilerPlugin {
    let providingMacros:[any Macro.Type] = [
        HTMLElement.self
    ]
}