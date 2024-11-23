//
//  HTMLElement.swift
//
//
//  Created by Evan Anderson on 9/14/24.
//

import HTMLKitUtilities
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

#if canImport(Foundation)
import struct Foundation.Data
#endif

enum HTMLElementMacro : ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let (string, encoding):(String, HTMLEncoding) = expand_macro(context: context, macro: node.macroExpansion!)
        func has_no_interpolation() -> Bool {
            let has_interpolation:Bool = !string.ranges(of: try! Regex("\\((.*)\\)")).isEmpty
            guard !has_interpolation else {
                context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "interpolationNotAllowedForDataType", message: "String Interpolation is not allowed for this data type. Runtime values get converted to raw text, which is not the expected result.")))
                return false
            }
            return true
        }
        func bytes<T: FixedWidthInteger>(_ bytes: [T]) -> String {
            return "[" + bytes.map({ "\($0)" }).joined(separator: ",") + "]"
        }
        switch encoding {
            case .utf8Bytes:
                guard has_no_interpolation() else { return "" }
                return "\(raw: bytes([UInt8](string.utf8)))"
            case .utf16Bytes:
                guard has_no_interpolation() else { return "" }
                return "\(raw: bytes([UInt16](string.utf16)))"
            case .utf8CString:
                return "\(raw: string.utf8CString)"

            case .foundationData:
                guard has_no_interpolation() else { return "" }
                return "Data(\(raw: bytes([UInt8](string.utf8))))"

            case .byteBuffer:
                guard has_no_interpolation() else { return "" }
                return "ByteBuffer(bytes: \(raw: bytes([UInt8](string.utf8))))"

            case .string:
                return "\"\(raw: string)\""
            case .custom(let encoded):
                return "\(raw: encoded.replacingOccurrences(of: "$0", with: string))"
        }
    }
}

private extension HTMLElementMacro {
    // MARK: Expand Macro
    static func expand_macro(context: some MacroExpansionContext, macro: MacroExpansionExprSyntax) -> (String, HTMLEncoding) {
        guard let elementType:HTMLElementType = HTMLElementType(rawValue: macro.macroName.text) else {
            return ("\(macro)", .string)
        }
        let children:SyntaxChildren = macro.arguments.children(viewMode: .all)
        /*if elementType == .escapeHTML {
            let array:[CustomStringConvertible] = children.compactMap({
                guard let child:LabeledExprSyntax = $0.labeled else { return nil }
                return HTMLKitUtilities.parseInnerHTML(context: context, child: child, lookupFiles: [])
            })
            return array.map({ String(describing: $0) }).joined()
        }*/
        let data:HTMLKitUtilities.ElementData = HTMLKitUtilities.parseArguments(context: context, children: children)
        return (data.innerHTML.map({ String(describing: $0) }).joined(), data.encoding)
    }
}