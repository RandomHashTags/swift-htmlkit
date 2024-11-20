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

import struct NIOCore.ByteBuffer

enum HTMLElementMacro : ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let string:String = expand_macro(context: context, macro: node.macroExpansion!)
        var set:Set<HTMLElementType?> = [.htmlUTF8Bytes, .htmlUTF16Bytes, .htmlUTF8CString, .htmlByteBuffer]

        #if canImport(Foundation)
        set.insert(.htmlData)
        #endif

        let elementType:HTMLElementType? = HTMLElementType(rawValue: node.macroName.text)
        if set.contains(elementType) {
            let has_interpolation:Bool = !string.ranges(of: try! Regex("\\((.*)\\)")).isEmpty
            guard !has_interpolation else {
                context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "interpolationNotAllowedForDataType", message: "String Interpolation is not allowed for this data type. Runtime values get converted to raw text, which is not the expected result.")))
                return ""
            }
            func bytes<T: FixedWidthInteger>(_ bytes: [T]) -> String {
                return "[" + bytes.map({ "\($0)" }).joined(separator: ",") + "]"
            }
            switch elementType {
                case .htmlUTF8Bytes:
                    return "\(raw: bytes([UInt8](string.utf8)))"
                case .htmlUTF16Bytes:
                    return "\(raw: bytes([UInt16](string.utf16)))"
                case .htmlUTF8CString:
                    return "\(raw: string.utf8CString)"

                #if canImport(Foundation)
                case .htmlData:
                    return "Data(\(raw: bytes([UInt8](string.utf8))))"
                #endif

                case .htmlByteBuffer:
                    return "ByteBuffer(bytes: \(raw: bytes([UInt8](string.utf8))))"

                default: break
            }
        }
        return "\"\(raw: string)\""
    }
}

private extension HTMLElementMacro {
    // MARK: Expand Macro
    static func expand_macro(context: some MacroExpansionContext, macro: MacroExpansionExprSyntax) -> String {
        guard let elementType:HTMLElementType = HTMLElementType(rawValue: macro.macroName.text) else {
            return "\(macro)"
        }
        let children:SyntaxChildren = macro.arguments.children(viewMode: .all)
        if elementType == .escapeHTML {
            let array:[CustomStringConvertible] = children.compactMap({
                guard let child:LabeledExprSyntax = $0.labeled else { return nil }
                return HTMLKitUtilities.parse_inner_html(context: context, child: child, lookupFiles: [])
            })
            return array.map({ String(describing: $0) }).joined()
        }
        let data:HTMLKitUtilities.ElementData = HTMLKitUtilities.parse_arguments(context: context, children: children)
        return data.innerHTML.map({ String(describing: $0) }).joined()
    }
}

extension HTMLElementAttribute.Extra {
    enum CSSUnitType : String {
        case centimeters
        case millimeters
        case inches
        case pixels
        case points
        case picas
        
        case em
        case ex
        case ch
        case rem
        case viewportWidth
        case viewportHeight
        case viewportMin
        case viewportMax
        case percent
        
        var suffix : String {
            switch self {
            case .centimeters:    return "cm"
            case .millimeters:    return "mm"
            case .inches:         return "in"
            case .pixels:         return "px"
            case .points:         return "pt"
            case .picas:          return "pc"
                
            case .em:             return "em"
            case .ex:             return "ex"
            case .ch:             return "ch"
            case .rem:            return "rem"
            case .viewportWidth:  return "vw"
            case .viewportHeight: return "vh"
            case .viewportMin:    return "vmin"
            case .viewportMax:    return "vmax"
            case .percent:        return "%"
            }
        }
    }
}