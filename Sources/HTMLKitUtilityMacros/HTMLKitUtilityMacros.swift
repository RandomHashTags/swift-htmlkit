
import SwiftCompilerPlugin
import SwiftSyntaxMacros
import SwiftDiagnostics

// MARK: DiagnosticMsg
struct DiagnosticMsg: DiagnosticMessage {
    let message:String
    let diagnosticID:MessageID
    let severity:DiagnosticSeverity

    init(id: String, message: String, severity: DiagnosticSeverity = .error) {
        self.message = message
        self.diagnosticID = MessageID(domain: "HTMLKitUtilityMacros", id: id)
        self.severity = severity
    }
}
extension DiagnosticMsg: FixItMessage {
    var fixItID: MessageID { diagnosticID }
}


@main
struct HTMLKitUtilityMacros: CompilerPlugin {
    let providingMacros:[any Macro.Type] = [
        HTMLElements.self
    ]
}