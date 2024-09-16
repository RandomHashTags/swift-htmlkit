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

    static let notAStruct:ErrorDiagnostic = ErrorDiagnostic(id: "notAStruct", message: "Can only be applied to a 'struct'")
    static let notAnEnum:ErrorDiagnostic = ErrorDiagnostic(id: "notAnEnum", message: "Can only be aplpied to an 'enum")
    static let notAnExtension:ErrorDiagnostic = ErrorDiagnostic(id: "notAnExtension", message: "Can only be applied to an 'extension'")

    static let noArguments:ErrorDiagnostic = ErrorDiagnostic(id: "noArguments", message: "No arguments")

    static func missingParameter(_ key: String) -> ErrorDiagnostic {
        return ErrorDiagnostic(id: "missingParameter", message: "Missing \"" + key + "\" parameter")
    }
}

@main
struct HTMLKitMacros : CompilerPlugin {
    let providingMacros:[any Macro.Type] = [
        HTMLElement.self
    ]
}