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
        let childs:SyntaxChildren = macro.arguments.children(viewMode: .all)
        if elementType == .escapeHTML {
            return childs.compactMap({
                guard let child:LabeledExprSyntax = $0.labeled else { return nil }
                return parse_inner_html(context: context, elementType: elementType, child: child, lookupFiles: [])
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
        let (attributes, innerHTML, trailingSlash):(String, String, Bool) = parse_arguments(context: context, elementType: elementType, children: children)
        return innerHTML

        var string:String = (tag == "html" ? "<!DOCTYPE html>" : "") + "<" + tag + attributes
        if trailingSlash {
            if isVoid {
                string += " /"
            } else {
                context.diagnose(Diagnostic(node: macro, message: DiagnosticMsg(id: "trailingSlashGlobalAttributeMisused", message: "Trailing Slash global attribute can only be applied to void elements.")))
                return ""
            }
        }
        string += ">" + innerHTML
        if !isVoid {
            string += "</" + tag + ">"
        }
        return string
    }
    // MARK: Parse Arguments
    static func parse_arguments(
        context: some MacroExpansionContext,
        elementType: HTMLElementType,
        children: Slice<SyntaxChildren>
    ) -> (attributes: String, innerHTML: String, trailingSlash: Bool) {
        var attributes:String = " ", innerHTML:String = "", trailingSlash:Bool = false
        var lookupFiles:Set<String> = []
        for element in children {
            if let child:LabeledExprSyntax = element.labeled {
                if var key:String = child.label?.text {
                    if key == "lookupFiles" {
                        lookupFiles = Set(child.expression.array!.elements.compactMap({ $0.expression.stringLiteral?.string }))
                    } else if key == "attributes" {
                        let (attributes_array, ts):([String], Bool) = parse_global_attributes(context: context, elementType: elementType, array: child.expression.array!.elements, lookupFiles: lookupFiles)
                        trailingSlash = ts
                        for attribute in attributes_array {
                            attributes += attribute + " "
                        }
                    } else {
                        if key == "acceptCharset" {
                            key = "accept-charset"
                        } else if key == "httpEquiv" {
                            key = "http-equiv"
                        }
                        if let string:String = parse_attribute(context: context, elementType: elementType, key: key, expression: child.expression, lookupFiles: lookupFiles) {
                            attributes += string + " "
                        }
                    }
                // inner html
                } else if let inner_html:String = parse_inner_html(context: context, elementType: elementType, child: child, lookupFiles: lookupFiles) {
                    innerHTML += inner_html
                }
            }
        }
        attributes.removeLast()
        return (attributes, innerHTML, trailingSlash)
    }
    // MARK: Parse Global Attributes
    static func parse_global_attributes(
        context: some MacroExpansionContext,
        elementType: HTMLElementType,
        array: ArrayElementListSyntax,
        lookupFiles: Set<String>
    ) -> (attributes: [String], trailingSlash: Bool) {
        var keys:Set<String> = [], attributes:[String] = [], trailingSlash:Bool = false
        for element in array {
            if let function:FunctionCallExprSyntax = element.expression.functionCall {
                let first_expression:ExprSyntax = function.arguments.first!.expression
                var key:String = function.calledExpression.memberAccess!.declName.baseName.text, value:String! = nil
                switch key {
                    case "custom", "data":
                        var returnType:LiteralReturnType = .string
                        (value, returnType) = parse_literal_value(context: context, elementType: elementType, key: key, expression: function.arguments.last!.expression, lookupFiles: lookupFiles)!
                        if returnType == .string {
                            value.escapeHTML(escapeAttributes: true)
                        }
                        if key == "custom" {
                            key = first_expression.stringLiteral!.string
                        } else {
                            key += "-\(first_expression.stringLiteral!.string)"
                        }
                        value = key + "=\\\"" + value + "\\\""
                        break
                    case "event":
                        key = "on" + first_expression.memberAccess!.declName.baseName.text
                        if var (string, returnType):(String, LiteralReturnType) = parse_literal_value(context: context, elementType: elementType, key: key, expression: function.arguments.last!.expression, lookupFiles: lookupFiles) {
                            if returnType == .string {
                                string.escapeHTML(escapeAttributes: true)
                            }
                            value = key + "=\\\"" + string + "\\\""
                        } else {
                            unallowed_expression(context: context, node: function.arguments.last!)
                            return ([], false)
                        }
                        break
                    default:
                        if key == "ariaattribute" {
                            key = "aria-" + first_expression.functionCall!.calledExpression.memberAccess!.declName.baseName.text
                        }
                        if key == "htmx" {
                            var string:String = "\(first_expression)"
                            string = String(string[string.index(after: string.startIndex)...])
                            if let htmx:HTMLElementAttribute.HTMX = HTMLElementAttribute.HTMX(rawValue: string) {
                                key = "hx-" + htmx.key
                                let htmlValue:String = htmx.htmlValue
                                var delimiter:String = "\\\"", isBoolean:Bool = false
                                func check_boolean(_ boolean: Bool) {
                                    isBoolean = true
                                    if !boolean {
                                        value = ""
                                    }
                                }
                                switch htmx {
                                    case .disable(let boolean),
                                            .historyElt(let boolean),
                                            .preserve(let boolean):
                                        check_boolean(boolean)
                                        break
                                    case .request(_, _, _, _), .headers(_, _):
                                        delimiter = "'"
                                        break
                                    case .sse(let sse_value):
                                        key = "sse-" + sse_value.key
                                        break
                                    case .ws(let ws_value):
                                        key = "ws-" + ws_value.key
                                        switch ws_value {
                                            case .send(let boolean):
                                                check_boolean(boolean)
                                                break
                                            default:
                                                break
                                        }
                                        break
                                    default:
                                        break
                                }
                                if isBoolean {
                                    value = value == nil || !value.isEmpty ? key : nil // only allow the value to be added if the boolean value is true
                                } else {
                                    value = key + "=" + delimiter + htmlValue + delimiter
                                }
                            }
                        } else if let string:String = parse_attribute(context: context, elementType: elementType, key: key, expression: first_expression, lookupFiles: lookupFiles) {
                            value = string
                        }
                        break
                }
                if key.contains(" ") {
                    context.diagnose(Diagnostic(node: first_expression, message: DiagnosticMsg(id: "spacesNotAllowedInAttributeDeclaration", message: "Spaces are not allowed in attribute declaration.")))
                } else if let value:String = value {
                    if keys.contains(key) {
                        global_attribute_already_defined(context: context, attribute: key, node: first_expression)
                    } else {
                        attributes.append(value)
                        keys.insert(key)
                    }
                }
            } else if let member:String = element.expression.memberAccess?.declName.baseName.text, member == "trailingSlash" {
                if keys.contains(member) {
                    global_attribute_already_defined(context: context, attribute: member, node: element.expression)
                } else {
                    trailingSlash = true
                    keys.insert(member)
                }
            }
        }
        return (attributes, trailingSlash)
    }
    static func global_attribute_already_defined(context: some MacroExpansionContext, attribute: String, node: some SyntaxProtocol) {
        context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "globalAttributeAlreadyDefined", message: "Global attribute \"" + attribute + "\" is already defined.")))
    }
    // MARK: Parse innerHTML
    static func parse_inner_html(
        context: some MacroExpansionContext,
        elementType: HTMLElementType,
        child: LabeledExprSyntax,
        lookupFiles: Set<String>
    ) -> String? {
        if let macro:MacroExpansionExprSyntax = child.expression.macroExpansion {
            var string:String = expand_macro(context: context, macro: macro)
            if elementType == .escapeHTML {
                string.escapeHTML(escapeAttributes: false)
            }
            return string
        } else if let string:String = parse_element(expr: child.expression) {
            return string
        } else if var string:String = parse_literal_value(context: context, elementType: elementType, key: "", expression: child.expression, lookupFiles: lookupFiles)?.value {
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
        case "buttontype":     return "buttontype"
        case "formenctype":    return "formenctype"
        case "inputtype":      return "inputtype"
        case "metahttp-equiv": return "httpequiv"
        case "oltype":         return "numberingtype"
        case "scripttype":     return "scripttype"
        default:
            if key.hasPrefix("aria-") {
                return "ariaattribute"
            }
            return key
        }
    }
    
    // MARK: Parse Attribute
    static func parse_attribute(
        context: some MacroExpansionContext,
        elementType: HTMLElementType,
        key: String,
        expression: ExprSyntax,
        lookupFiles: Set<String>
    ) -> String? {
        if var (string, returnType):(String, LiteralReturnType) = parse_literal_value(context: context, elementType: elementType, key: key, expression: expression, lookupFiles: lookupFiles) {
            switch returnType {
            case .boolean: return string.elementsEqual("true") ? key : nil
            case .string, .enumCase:
                if returnType == .enumCase && string.isEmpty
                    || returnType == .string && key == "attributionsrc" && string.isEmpty {
                    return key
                }
                string.escapeHTML(escapeAttributes: true)
                return key + "=\\\"" + string + "\\\""
            case .interpolation:
                return key + "=\\\"" + string + "\\\""
            }
        }
        if let function:FunctionCallExprSyntax = expression.functionCall {
            let string:String = "\(function)"
            return HTMLElementAttribute.Extra.htmlValue(enumName: enumName(elementType: elementType, key: key), for: String(string[string.index(after: string.startIndex)...]))
        }
        return nil
    }
    // MARK: Parse element
    static func parse_element(expr: ExprSyntax) -> String? {
        guard expr.is(FunctionCallExprSyntax.self) else { return nil }
        var string:String = "\(expr)"
        while string.first?.isWhitespace ?? false {
            string.removeFirst()
        }
        guard let element:HTMLElement = HTMLElementValueType.parse_element(rawValue: string) else { return nil }
        return element.description
    }
    // MARK: Parse Literal Value
    static func parse_literal_value(
        context: some MacroExpansionContext,
        elementType: HTMLElementType,
        key: String,
        expression: ExprSyntax,
        lookupFiles: Set<String>
    ) -> (value: String, returnType: LiteralReturnType)? {
        if let boolean:String = expression.booleanLiteral?.literal.text {
            return (boolean, .boolean)
        }
        if let string:String = expression.integerLiteral?.literal.text ?? expression.floatLiteral?.literal.text {
            return (string, .string)
        }
        guard var (string, returnType):(String, LiteralReturnType) = extract_string_or_interpolation(context: context, elementType: elementType, key: key, expression: expression, lookupFiles: lookupFiles) else {
            //context.diagnose(Diagnostic(node: expression, message: DiagnosticMsg(id: "somethingWentWrong", message: "Something went wrong. (" + expression.debugDescription + ")", severity: .warning)))
            return nil
        }
        var remaining_interpolation:Int = returnType == .interpolation ? 1 : 0, interpolation:[ExpressionSegmentSyntax] = []
        if let stringLiteral:StringLiteralExprSyntax = expression.stringLiteral {
            remaining_interpolation = stringLiteral.segments.count(where: { $0.is(ExpressionSegmentSyntax.self) })
            interpolation = stringLiteral.segments.compactMap({ $0.as(ExpressionSegmentSyntax.self) })
        }
        for expr in interpolation {
            string.replace("\(expr)", with: flatten_interpolation(context: context, remaining_interpolation: &remaining_interpolation, expr: expr, lookupFiles: lookupFiles))
        }
        if remaining_interpolation > 0 {
            warn_interpolation(context: context, node: expression, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
            if remaining_interpolation > 0 && !string.contains("\\(") {
                string = "\\(" + string + ")"
            }
        }
        if remaining_interpolation > 0 {
            returnType = .interpolation
        }
        return (string, returnType)
    }
    // MARK: Extract string/interpolation
    static func extract_string_or_interpolation(
        context: some MacroExpansionContext,
        elementType: HTMLElementType,
        key: String,
        expression: ExprSyntax,
        lookupFiles: Set<String>
    ) -> (String, LiteralReturnType)? {
        if let stringLiteral:StringLiteralExprSyntax = expression.stringLiteral {
            let return_type:LiteralReturnType = stringLiteral.segments.count(where: { $0.is(ExpressionSegmentSyntax.self) }) == 0 ? .string : .interpolation
            return (stringLiteral.string, return_type)
        }
        if let function:FunctionCallExprSyntax = expression.functionCall {
            let enums:Set<String> = ["command", "download", "height", "width"]
            if enums.contains(key) || key.hasPrefix("aria-") {
                var value:String = "\(function)"
                value = String(value[value.index(after: value.startIndex)...])
                value = HTMLElementAttribute.Extra.htmlValue(enumName: enumName(elementType: elementType, key: key), for: value)
                return (value, .enumCase)
            } else {
                if let decl:String = function.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                    switch decl {
                        case "StaticString":
                            var string:String = function.arguments.first!.expression.stringLiteral!.string
                            return (string, .string)
                        default:
                            var string:String = "\(function)"
                            while string.first?.isWhitespace ?? false {
                                string.removeFirst()
                            }
                            if let element:HTMLElement = HTMLElementValueType.parse_element(rawValue: string) {
                                let string:String = element.description
                                return (string, string.contains("\\(") ? .interpolation : .string)
                            }
                            break
                    }
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
                case "allow":
                    separator = ";"
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
            var string:String = "\(expression)", remaining_interpolation:Int = 1
            warn_interpolation(context: context, node: expression, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
            if remaining_interpolation > 0 {
                return ("\\(" + string + ")", .interpolation)
            } else {
                return (string, .string)
            }
        }
        return nil
    }
    // MARK: Flatten Interpolation
    static func flatten_interpolation(
        context: some MacroExpansionContext,
        remaining_interpolation: inout Int,
        expr: ExpressionSegmentSyntax,
        lookupFiles: Set<String>
    ) -> String {
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
                        let flattened:String = flatten_interpolation(context: context, remaining_interpolation: &remaining_interpolation, expr: interpolation, lookupFiles: lookupFiles)
                        if "\(interpolation)" == flattened {
                            //string += "\\(\"\(flattened)\".escapingHTML(escapeAttributes: true))"
                            string += "\(flattened)"
                            warn_interpolation(context: context, node: interpolation, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
                        } else {
                            string += flattened
                        }
                    } else {
                        //string += "\\(\"\(segment)\".escapingHTML(escapeAttributes: true))"
                        warn_interpolation(context: context, node: segment, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
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
            warn_interpolation(context: context, node: expr, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
        }
        return string
    }
    static func warn_interpolation(
        context: some MacroExpansionContext,
        node: some SyntaxProtocol,
        string: inout String,
        remaining_interpolation: inout Int,
        lookupFiles: Set<String>
    ) {
        if let fix:String = InterpolationLookup.find(context: context, node, files: lookupFiles) {
            let expression:String = "\(node)"
            let ranges:[Range<String.Index>] = string.ranges(of: expression)
            string.replace(expression, with: fix)
            remaining_interpolation -= ranges.count
        } else {
            context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unsafeInterpolation", message: "Interpolation may introduce raw HTML.", severity: .warning)))
        }
    }
}

enum LiteralReturnType {
    case boolean, string, enumCase, interpolation
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
    var declRef : DeclReferenceExprSyntax? { self.as(DeclReferenceExprSyntax.self) }
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
        case "ariaattribute":   return ariaattribute(rawValue: enumCase)?.htmlValue ?? "???"
        case "command":         return command(rawValue: enumCase)!.htmlValue!
        case "contenteditable": return contenteditable(rawValue: enumCase)!.htmlValue!
        case "crossorigin":     return crossorigin(rawValue: enumCase)!.htmlValue!
        case "download":        return download(rawValue: enumCase)!.htmlValue!
        case "formenctype":     return formenctype(rawValue: enumCase)!.htmlValue!
        case "hidden":          return hidden(rawValue: enumCase)!.htmlValue!
        case "httpequiv":       return httpequiv(rawValue: enumCase)!.htmlValue!
        case "inputtype":       return inputtype(rawValue: enumCase)!.htmlValue!
        case "numberingtype":   return numberingtype(rawValue: enumCase)!.htmlValue!
        case "referrerpolicy":  return referrerpolicy(rawValue: enumCase)!.htmlValue!
        case "rel":             return rel(rawValue: enumCase)!.htmlValue!
        case "sandbox":         return sandbox(rawValue: enumCase)!.htmlValue!
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