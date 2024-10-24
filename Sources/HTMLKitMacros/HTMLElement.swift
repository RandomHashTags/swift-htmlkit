//
//  HTMLElement.swift
//
//
//  Created by Evan Anderson on 9/14/24.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics
import HTMLKitUtilities

#if canImport(Foundation)
import struct Foundation.Data
#endif

import struct NIOCore.ByteBuffer

enum HTMLElement : ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let string:String = expand_macro(context: context, macro: node.macroExpansion!)
        var set:Set<HTMLElementType?> = [.htmlUTF8Bytes, .htmlUTF16Bytes, .htmlUTF8CString, .htmlByteBuffer]

        #if canImport(Foundation)
        set.insert(.htmlData)
        #endif

        if set.contains(HTMLElementType(rawValue: node.macroName.text)) {
            let has_interpolation:Bool = !string.ranges(of: try! Regex("\\((.*)\\)")).isEmpty
            guard !has_interpolation else {
                context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "interpolationNotAllowedForDataType", message: "String Interpolation is not allowed for this data type. Runtime values get converted to raw text, which is not the expected result.")))
                return ""
            }
            func bytes<T: FixedWidthInteger>(_ bytes: [T]) -> String {
                return "[" + bytes.map({ "\($0)" }).joined(separator: ",") + "]"
            }
            switch HTMLElementType(rawValue: node.macroName.text) {
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

private extension HTMLElement {
    // MARK: Expand Macro
    static func expand_macro(context: some MacroExpansionContext, macro: MacroExpansionExprSyntax) -> String {
        guard let elementType:HTMLElementType = HTMLElementType(rawValue: macro.macroName.text) else {
            return "\(macro)"
        }
        let childs:SyntaxChildren = macro.arguments.children(viewMode: .all)
        if elementType == .escapeHTML {
            return childs.compactMap({
                guard let child:LabeledExprSyntax = $0.labeled else { return nil }
                return parse_inner_html(context: context, elementType: elementType, child: child)
            }).joined()
        }
        let tag:String, isVoid:Bool
        var children:Slice<SyntaxChildren>
        if elementType == .custom {
            tag = childs.first(where: { $0.labeled?.label?.text == "tag" })!.labeled!.expression.stringLiteral!.string
            isVoid = childs.first(where: { $0.labeled?.label?.text == "isVoid" })!.labeled!.expression.booleanLiteral!.literal.text == "true"
            children = childs.dropFirst() // tag
            children.removeFirst() // isVoid
        } else {
            tag = elementType.rawValue.starts(with: "html") ? "html" : elementType.rawValue
            isVoid = elementType.isVoid
            children = childs.prefix(childs.count)
        }
        let (attributes, innerHTML):(String, String) = parse_arguments(context: context, elementType: elementType, children: children)
        var string:String = (tag == "html" ? "<!DOCTYPE html>" : "") + "<" + tag + attributes + ">" + innerHTML
        if !isVoid {
            string += "</" + tag + ">"
        }
        return string
    }
    // MARK: Parse Arguments
    static func parse_arguments(context: some MacroExpansionContext, elementType: HTMLElementType, children: Slice<SyntaxChildren>) -> (attributes: String, innerHTML: String) {
        var attributes:String = " ", innerHTML:String = ""
        for element in children {
            if let child:LabeledExprSyntax = element.labeled {
                if var key:String = child.label?.text {
                    if key == "attributes" {
                        for attribute in parse_global_attributes(context: context, elementType: elementType, array: child.expression.array!.elements) {
                            attributes += attribute + " "
                        }
                    } else {
                        if key == "acceptCharset" {
                            key = "accept-charset"
                        }
                        if let string:String = parse_attribute(context: context, elementType: elementType, key: key, expression: child.expression) {
                            attributes += key + (string.isEmpty ? "" : "=\\\"" + string + "\\\"") + " "
                        }
                    }
                // inner html
                } else if let inner_html:String = parse_inner_html(context: context, elementType: elementType, child: child) {
                    innerHTML += inner_html
                }
            }
        }
        attributes.removeLast()
        return (attributes, innerHTML)
    }
    // MARK: Parse Global Attributes
    static func parse_global_attributes(context: some MacroExpansionContext, elementType: HTMLElementType, array: ArrayElementListSyntax) -> [String] {
        var keys:Set<String> = [], attributes:[String] = []
        for element in array {
            let function:FunctionCallExprSyntax = element.expression.functionCall!, first_expression:ExprSyntax = function.arguments.first!.expression
            var key:String = function.calledExpression.memberAccess!.declName.baseName.text, value:String! = nil
            switch key {
                case "custom", "data":
                    var returnType:LiteralReturnType = .string
                    (value, returnType) = parse_literal_value(context: context, elementType: elementType, key: key, expression: function.arguments.last!.expression)!
                    if returnType == .string {
                        value.escapeHTML(escapeAttributes: true)
                    }
                    if key == "custom" {
                        key = first_expression.stringLiteral!.string
                    } else {
                        key += "-\(first_expression.stringLiteral!.string)"
                    }
                    break
                case "event":
                    key = "on" + first_expression.memberAccess!.declName.baseName.text
                    if var (string, returnType):(String, LiteralReturnType) = parse_literal_value(context: context, elementType: elementType, key: key, expression: function.arguments.last!.expression) {
                        if returnType == .string {
                            string.escapeHTML(escapeAttributes: true)
                        }
                        value = string
                    } else {
                        unallowed_expression(context: context, node: function.arguments.last!)
                        return []
                    }
                    break
                default:
                    if let string:String = parse_attribute(context: context, elementType: elementType, key: key, expression: first_expression) {
                        value = string
                    }
                    break
            }
            if key.contains(" ") {
                context.diagnose(Diagnostic(node: first_expression, message: DiagnosticMsg(id: "spacesNotAllowedInAttributeDeclaration", message: "Spaces are not allowed in attribute declaration.")))
            } else if let value:String = value {
                if keys.contains(key) {
                    context.diagnose(Diagnostic(node: first_expression, message: DiagnosticMsg(id: "globalAttributeAlreadyDefined", message: "Global attribute \"" + key + "\" is already defined.")))
                } else {
                    attributes.append(key + (value.isEmpty ? "" : "=\\\"" + value + "\\\""))
                    keys.insert(key)
                }
            }
        }
        return attributes
    }
    // MARK: Parse innerHTML
    static func parse_inner_html(context: some MacroExpansionContext, elementType: HTMLElementType, child: LabeledExprSyntax) -> String? {
        if let macro:MacroExpansionExprSyntax = child.expression.macroExpansion {
            var string:String = expand_macro(context: context, macro: macro)
            if elementType == .escapeHTML {
                string.escapeHTML(escapeAttributes: false)
            }
            return string
        } else if var string:String = parse_literal_value(context: context, elementType: elementType, key: "", expression: child.expression)?.value {
            string.escapeHTML(escapeAttributes: false)
            return string
        } else {
            unallowed_expression(context: context, node: child)
            return nil
        }
    }
    static func unallowed_expression(context: some MacroExpansionContext, node: LabeledExprSyntax) {
        context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unallowedExpression", message: "String Interpolation is required when encoding runtime values."), fixIts: [
            FixIt(message: DiagnosticMsg(id: "useStringInterpolation", message: "Use String Interpolation."), changes: [
                FixIt.Change.replace(
                    oldNode: Syntax(node),
                    newNode: Syntax(StringLiteralExprSyntax(content: "\\(\(node))"))
                )
            ])
        ]))
    }
    
    static func enumName(elementType: HTMLElementType, key: String) -> String {
        switch elementType.rawValue + key {
        case "buttontype": return "buttontype"
        case "inputtype":  return "inputtype"
        case "oltype":     return "numberingtype"
        case "scripttype": return "scripttype"
        default:           return key
        }
    }
    
    // MARK: Parse Attribute
    static func parse_attribute(context: some MacroExpansionContext, elementType: HTMLElementType, key: String, expression: ExprSyntax) -> String? {
        if var (string, returnType):(String, LiteralReturnType) = parse_literal_value(context: context, elementType: elementType, key: key, expression: expression) {
            switch returnType {
            case .boolean: return string.elementsEqual("true") ? "" : nil
            case .string, .enumCase:
                if returnType == .string && string.isEmpty && key != "href" {
                    return nil
                }
                string.escapeHTML(escapeAttributes: true)
                return string
            case .interpolation: return string
            }
        }
        if let function:FunctionCallExprSyntax = expression.functionCall {
            let string:String = "\(function)"
            return HTMLElementAttribute.Extra.htmlValue(enumName: enumName(elementType: elementType, key: key), for: String(string[string.index(after: string.startIndex)...]))
        }
        return nil
    }
    // MARK: Parse Literal Value
    static func parse_literal_value(context: some MacroExpansionContext, elementType: HTMLElementType, key: String, expression: ExprSyntax) -> (value: String, returnType: LiteralReturnType)? {
        if let boolean:String = expression.booleanLiteral?.literal.text {
            return (boolean, .boolean)
        }
        func return_string_or_interpolation() -> (String, LiteralReturnType)? {
            if let string:String = expression.stringLiteral?.string ?? expression.integerLiteral?.literal.text ?? expression.floatLiteral?.literal.text {
                return (string, .string)
            }
            if let function:FunctionCallExprSyntax = expression.functionCall {
                switch key {
                case "height", "width":
                    var value:String = "\(function)"
                    value = String(value[value.index(after: value.startIndex)...])
                    value = HTMLElementAttribute.Extra.htmlValue(enumName: enumName(elementType: elementType, key: key), for: value)
                    return (value, .enumCase)
                default:
                    if function.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text == "StaticString" {
                        return (function.arguments.first!.expression.stringLiteral!.string, .string)
                    }
                    return ("\(function)", .interpolation)
                }
            }
            if let member:MemberAccessExprSyntax = expression.memberAccess {
                if let _:ExprSyntax = member.base {
                    return ("\(member)", .interpolation)
                }
                return (HTMLElementAttribute.Extra.htmlValue(enumName: enumName(elementType: elementType, key: key), for: member.declName.baseName.text), .enumCase)
            }
            if let array:ArrayExprSyntax = expression.array {
                let separator:Character, separator_string:String
                switch key {
                    case "accept", "coords", "exportparts", "imagesizes", "imagesrcset", "sizes", "srcset":
                        separator = ","
                        break
                    default:
                        separator = " "
                        break
                }
                separator_string = String(separator)
                var result:String = ""
                for element in array.elements {
                    if let string:String = element.expression.stringLiteral?.string {
                        if string.contains(separator) {
                            context.diagnose(Diagnostic(node: element.expression, message: DiagnosticMsg(id: "characterNotAllowedInDeclaration", message: "Character \"\(separator)\" is not allowed when declaring values for \"" + key + "\".")))
                            return nil
                        }
                        result += string + separator_string
                    }
                    if let string:String = element.expression.integerLiteral?.literal.text ?? element.expression.floatLiteral?.literal.text {
                        result += string + separator_string
                    }
                    if let string:String = element.expression.memberAccess?.declName.baseName.text {
                        result += HTMLElementAttribute.Extra.htmlValue(enumName: enumName(elementType: elementType, key: key), for: string) + separator_string
                    }
                }
                if !result.isEmpty {
                    result.removeLast()
                }
                return (result, .string)
            }
            if let _:DeclReferenceExprSyntax = expression.as(DeclReferenceExprSyntax.self) {
                context.diagnose(Diagnostic(node: expression, message: DiagnosticMsg(id: "runtimeValueNotAllowed", message: "Runtime value not allowed here.")))
            }
            return nil
        }
        guard var (string, returnType):(String, LiteralReturnType) = return_string_or_interpolation() else {
            //context.diagnose(Diagnostic(node: expression, message: DiagnosticMsg(id: "somethingWentWrong", message: "Something went wrong. (" + expression.debugDescription + ")", severity: .warning)))
            return nil
        }
        let interpolation:[ExpressionSegmentSyntax] = expression.stringLiteral?.segments.compactMap({ $0.as(ExpressionSegmentSyntax.self) }) ?? []
        var remaining_interpolation:Int = interpolation.count
        for expr in interpolation {
            string.replace("\(expr)", with: flatten_interpolation(context: context, remaining_interpolation: &remaining_interpolation, expr: expr))
        }
        if returnType == .interpolation || remaining_interpolation > 0 {
            if !string.contains("\\(") {
                string = "\\(" + string + ")"
                warn_interpolation(context: context, node: expression)
            }
            returnType = .interpolation
        }
        return (string, returnType)
    }
    // MARK: Flatten Interpolation
    static func flatten_interpolation(context: some MacroExpansionContext, remaining_interpolation: inout Int, expr: ExpressionSegmentSyntax) -> String {
        let expression:ExprSyntax = expr.expressions.first!.expression
        var string:String = "\(expr)"
        if let stringLiteral:StringLiteralExprSyntax = expression.stringLiteral {
            let segments:StringLiteralSegmentListSyntax = stringLiteral.segments
            if segments.count(where: { $0.is(StringSegmentSyntax.self) }) == segments.count {
                remaining_interpolation = 0
                string = segments.map({ $0.as(StringSegmentSyntax.self)!.content.text }).joined()
            } else {
                string = ""
                for segment in segments {
                    if let literal:String = segment.as(StringSegmentSyntax.self)?.content.text {
                        string += literal
                    } else if let interpolation:ExpressionSegmentSyntax = segment.as(ExpressionSegmentSyntax.self) {
                        let flattened:String = flatten_interpolation(context: context, remaining_interpolation: &remaining_interpolation, expr: interpolation)
                        if "\(interpolation)" == flattened {
                            //string += "\\(\"\(flattened)\".escapingHTML(escapeAttributes: true))"
                            string += "\(flattened)"
                            warn_interpolation(context: context, node: interpolation)
                        } else {
                            string += flattened
                        }
                    } else {
                        //string += "\\(\"\(segment)\".escapingHTML(escapeAttributes: true))"
                        warn_interpolation(context: context, node: segment)
                        string += "\(segment)"
                    }
                }
            }
        } else if let fix:String = expression.integerLiteral?.literal.text ?? expression.floatLiteral?.literal.text {
            let target:String = "\(expr)"
            remaining_interpolation -= string.ranges(of: target).count
            string.replace(target, with: fix)
        } else {
            //string = "\\(\"\(string)\".escapingHTML(escapeAttributes: true))"
            warn_interpolation(context: context, node: expr)
        }
        return string
    }
    static func warn_interpolation(context: some MacroExpansionContext, node: some SyntaxProtocol) {
        context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unsafeInterpolation", message: "Interpolation may introduce raw HTML.", severity: .warning)))
    }
}

enum LiteralReturnType {
    case boolean, string, enumCase, interpolation
}

// MARK: HTMLElementType
enum HTMLElementType : String, CaseIterable {
    case escapeHTML
    case custom

    case html, htmlUTF8Bytes, htmlUTF16Bytes, htmlUTF8CString
    
    #if canImport(Foundation)
    case htmlData
    #endif

    case htmlByteBuffer
    
    case a
    case abbr
    case address
    case area
    case article
    case aside
    case audio

    case b
    case base
    case bdi
    case bdo
    case blockquote
    case body
    case br
    case button

    case canvas
    case caption
    case cite
    case code
    case col
    case colgroup

    case data
    case datalist
    case dd
    case del
    case details
    case dfn
    case dialog
    case div
    case dl
    case dt

    case em
    case embed

    case fencedframe
    case fieldset
    case figcaption
    case figure
    case footer
    case form
    case frame
    case frameset

    case h1, h2, h3, h4, h5, h6
    case head
    case header
    case hgroup
    case hr
    
    case i
    case iframe
    case img
    case input
    case ins

    case kbd

    case label
    case legend
    case li
    case link

    case main
    case map
    case mark
    case menu
    case meta
    case meter

    case nav
    case noscript

    case object
    case ol
    case optgroup
    case option
    case output

    case p
    case picture
    case portal
    case pre
    case progress

    case q

    case rp
    case rt
    case ruby
    
    case s
    case samp
    case script
    case search
    case section
    case select
    case slot
    case small
    case source
    case span
    case strong
    case style
    case sub
    case summary
    case sup

    case table
    case tbody
    case td
    case template
    case textarea
    case tfoot
    case th
    case thead
    case time
    case title
    case tr
    case track

    case u
    case ul

    case `var`
    case video

    case wbr

    var isVoid : Bool {
        switch self {
        case .area, .base, .br, .col, .embed, .hr, .img, .input, .link, .meta, .source, .track, .wbr:
            return true
        default:
            return false
        }
    }
}

// MARK: Misc
extension SyntaxProtocol {
    var booleanLiteral : BooleanLiteralExprSyntax? { self.as(BooleanLiteralExprSyntax.self) }
    var stringLiteral : StringLiteralExprSyntax? { self.as(StringLiteralExprSyntax.self) }
    var integerLiteral : IntegerLiteralExprSyntax? { self.as(IntegerLiteralExprSyntax.self) }
    var floatLiteral : FloatLiteralExprSyntax? { self.as(FloatLiteralExprSyntax.self) }
    var array : ArrayExprSyntax? { self.as(ArrayExprSyntax.self) }
    var memberAccess : MemberAccessExprSyntax? { self.as(MemberAccessExprSyntax.self) }
    var macroExpansion : MacroExpansionExprSyntax? { self.as(MacroExpansionExprSyntax.self) }
    var functionCall : FunctionCallExprSyntax? { self.as(FunctionCallExprSyntax.self) }
}
extension SyntaxChildren.Element {
    var labeled : LabeledExprSyntax? { self.as(LabeledExprSyntax.self) }
}
extension StringLiteralExprSyntax {
    var string : String { "\(segments)" }
}

extension HTMLElementAttribute.Extra {
    static func htmlValue(enumName: String, for enumCase: String) -> String { // only need to check the ones where the htmlValue is different from the rawValue
        switch enumName {
        case "contenteditable": return contenteditable(rawValue: enumCase)!.htmlValue
        case "crossorigin":     return crossorigin(rawValue: enumCase)!.htmlValue
        case "formenctype":     return formenctype(rawValue: enumCase)!.htmlValue
        case "hidden":          return hidden(rawValue: enumCase)!.htmlValue
        case "httpequiv":       return httpequiv(rawValue: enumCase)!.htmlValue
        case "inputtype":       return inputtype(rawValue: enumCase)!.htmlValue
        case "numberingtype":   return numberingtype(rawValue: enumCase)!.htmlValue
        case "referrerpolicy":  return referrerpolicy(rawValue: enumCase)!.htmlValue
        case "sandbox":         return sandbox(rawValue: enumCase)!.htmlValue
        case "height", "width":
            let values:[Substring] = enumCase.split(separator: "("), key:String = String(values[0]), value:String = String(values[1])
            return value[value.startIndex..<value.index(before: value.endIndex)] + CSSUnitType(rawValue: key)!.suffix
        default:                return enumCase
        }
    }
    
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
