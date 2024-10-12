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

struct HTMLElement : ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        var dynamicVariables:[String] = []
        let (string, isDynamic):(String, Bool) = parse_macro(context: context, expression: node.as(MacroExpansionExprSyntax.self)!, isRoot: true, dynamicVariables: &dynamicVariables)
        return isDynamic ? "\(raw: string)" : "\"\(raw: string)\""
    }
}

private extension HTMLElement {
    static func parse_macro(context: some MacroExpansionContext, expression: MacroExpansionExprSyntax, isRoot: Bool, dynamicVariables: inout [String]) -> (String, Bool) {
        guard let elementType:HTMLElementType = HTMLElementType(rawValue: expression.macroName.text) else { return ("\(expression)", true) }
        let childs:SyntaxChildren = expression.arguments.children(viewMode: .all)
        if elementType == .escapeHTML {
            return (childs.compactMap({
                guard let child:LabeledExprSyntax = $0.labeled else { return nil }
                return parse_inner_html(context: context, elementType: elementType, child: child, dynamicVariables: &dynamicVariables)
            }).joined(), false)
        }
        let tag:String, isVoid:Bool
        var children:Slice<SyntaxChildren>
        if elementType == .custom {
            tag = childs.first(where: { $0.labeled?.label?.text == "tag" })!.labeled!.expression.stringLiteral!.string
            isVoid = childs.first(where: { $0.labeled?.label?.text == "isVoid" })!.labeled!.expression.booleanLiteral!.literal.text == "true"
            children = childs.dropFirst() // tag
            children.removeFirst() // isVoid
        } else {
            tag = elementType.rawValue
            isVoid = elementType.isVoid
            children = childs.prefix(childs.count)
        }
        let data:ElementData = parse_arguments(context: context, elementType: elementType, children: children, dynamicVariables: &dynamicVariables)
        var string:String = (elementType == .html ? "<!DOCTYPE html>" : "") + "<" + tag + data.attributes + ">" + data.innerHTML
        if !isVoid {
            string += "</" + tag + ">"
        }
        return (string, false)

        /*if isRoot {
            return dynamicVariables.isEmpty ? (string, false) : ("DynamicString(string: \"" + string + "\").test", true)
            //return dynamicVariables.isEmpty ? (string, false) : ("DynamicString(string: \"" + string + "\", values: [" + dynamicVariables.map({ $0.contains("\\(") ? "\"\($0)\"" : $0 }).joined(separator: ",") + "]).test", true)
        } else {
            return (string, false)
        }*/
    }
    static func parse_arguments(context: some MacroExpansionContext, elementType: HTMLElementType, children: Slice<SyntaxChildren>, dynamicVariables: inout [String]) -> ElementData {
        var attributes:[String] = [], innerHTML:[String] = []
        for element in children {
            if let child:LabeledExprSyntax = element.labeled {
                if var key:String = child.label?.text {
                    if key == "attributes" {
                        attributes.append(contentsOf: parse_global_attributes(context: context, elementType: elementType, array: child.expression.array!, dynamicVariables: &dynamicVariables))
                    } else {
                        if key == "acceptCharset" {
                            key = "accept-charset"
                        }
                        if let string:String = parse_attribute(context: context, elementType: elementType, key: key, argument: child, dynamicVariables: &dynamicVariables) {
                            attributes.append(key + (string.isEmpty ? "" : "=\\\"" + string + "\\\""))
                        }
                    }
                // inner html
                } else if let inner_html:String = parse_inner_html(context: context, elementType: elementType, child: child, dynamicVariables: &dynamicVariables) {
                    innerHTML.append(inner_html)
                }
            }
        }
        return ElementData(attributes: attributes, innerHTML: innerHTML)
    }
    static func parse_global_attributes(context: some MacroExpansionContext, elementType: HTMLElementType, array: ArrayExprSyntax, dynamicVariables: inout [String]) -> [String] {
        var keys:Set<String> = [], attributes:[String] = []
        for element in array.elements {
            let function:FunctionCallExprSyntax = element.expression.as(FunctionCallExprSyntax.self)!, key_argument:LabeledExprSyntax = function.arguments.first!, key_element:ExprSyntax = key_argument.expression
            var key:String = function.calledExpression.memberAccess!.declName.baseName.text, value:String? = nil
            switch key {
                case "custom", "data":
                    var (literalValue, returnType):(String, LiteralReturnType) = parse_literal_value(context: context, elementType: elementType, key: key, argument: function.arguments.last!, dynamicVariables: &dynamicVariables)!
                    if returnType == .string {
                        literalValue.escapeHTML(escapeAttributes: true)
                    }
                    value = literalValue
                    if key == "custom" {
                        key = key_element.stringLiteral!.string
                    } else {
                        key += "-\(key_element.stringLiteral!.string)"
                    }
                    break
                case "event":
                    key = "on" + key_element.memberAccess!.declName.baseName.text
                    if var (literalValue, returnType):(String, LiteralReturnType) = parse_literal_value(context: context, elementType: elementType, key: key, argument: function.arguments.last!, dynamicVariables: &dynamicVariables) {
                        if returnType == .string {
                            literalValue.escapeHTML(escapeAttributes: true)
                        }
                        value = literalValue
                    } else {
                        unallowed_expression(context: context, node: function.arguments.last!)
                        return []
                    }
                    break
                default:
                    if let string:String = parse_attribute(context: context, elementType: elementType, key: key, argument: key_argument, dynamicVariables: &dynamicVariables) {
                        value = string
                    }
                    break
            }
            if key.contains(" ") {
                context.diagnose(Diagnostic(node: key_element, message: DiagnosticMsg(id: "spacesNotAllowedInAttributeDeclaration", message: "Spaces are not allowed in attribute declaration.")))
            } else if let value:String = value {
                if keys.contains(key) {
                    context.diagnose(Diagnostic(node: key_element, message: DiagnosticMsg(id: "globalAttributeAlreadyDefined", message: "Global attribute is already defined.")))
                } else {
                    attributes.append(key + (value.isEmpty ? "" : "=\\\"" + value + "\\\""))
                    keys.insert(key)
                }
            }
        }
        return attributes
    }
    static func parse_inner_html(context: some MacroExpansionContext, elementType: HTMLElementType, child: LabeledExprSyntax, dynamicVariables: inout [String]) -> String? {
        if let macro:MacroExpansionExprSyntax = child.expression.macroExpansion {
            var string:String = parse_macro(context: context, expression: macro, isRoot: false, dynamicVariables: &dynamicVariables).0
            if elementType == .escapeHTML {
                string.escapeHTML(escapeAttributes: false)
            }
            return string
        } else if var string:String = parse_literal_value(context: context, elementType: elementType, key: "", argument: child, dynamicVariables: &dynamicVariables)?.value {
            string.escapeHTML(escapeAttributes: false)
            return string
        } else {
            unallowed_expression(context: context, node: child)
            return nil
        }
    }
    static func unallowed_expression(context: some MacroExpansionContext, node: LabeledExprSyntax) {
        context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unallowedExpression", message: "String Interpolation is required when encoding runtime values."), fixIts: [
            FixIt(message: DiagnosticMsg(id: "useStringInterpolation", message: "Use String Interpolation.", severity: .error), changes: [
                FixIt.Change.replace(
                    oldNode: Syntax(node),
                    newNode: Syntax(StringLiteralExprSyntax(content: "\\(\(node))"))
                )
            ])
        ]))
    }

    struct ElementData {
        let attributes:String, innerHTML:String

        init(attributes: [String], innerHTML: [String]) {
            self.attributes = attributes.isEmpty ? "" : " " + attributes.joined(separator: " ")
            self.innerHTML = innerHTML.joined()
        }
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
    
    static func parse_attribute(context: some MacroExpansionContext, elementType: HTMLElementType, key: String, argument: LabeledExprSyntax, dynamicVariables: inout [String]) -> String? {
        let expression:ExprSyntax = argument.expression
        if var (string, returnType):(String, LiteralReturnType) = parse_literal_value(context: context, elementType: elementType, key: key, argument: argument, dynamicVariables: &dynamicVariables) {
            switch returnType {
            case .boolean: return string.elementsEqual("true") ? "" : nil
            case .string:
                string.escapeHTML(escapeAttributes: true)
                return string
            case .interpolation: return string
            }
        }
        func member(_ value: String) -> String {
            var string:String = String(value[value.index(after: value.startIndex)...])
            string = HTMLElementAttribute.Extra.htmlValue(enumName: enumName(elementType: elementType, key: key), for: string)
            return string
        }
        if let function:FunctionCallExprSyntax = expression.as(FunctionCallExprSyntax.self) {
            return member("\(function)")
        }
        return nil
    }
    static func get_separator(key: String) -> String {
        switch key {
            case "accept", "coords", "exportparts", "imagesizes", "imagesrcset", "sizes", "srcset": return ","
            default: return " "
        }
    }
    static func parse_literal_value(context: some MacroExpansionContext, elementType: HTMLElementType, key: String, argument: LabeledExprSyntax, dynamicVariables: inout [String]) -> (value: String, returnType: LiteralReturnType)? {
        let expression:ExprSyntax = argument.expression
        if let boolean:String = expression.booleanLiteral?.literal.text {
            return (boolean, .boolean)
        }
        func return_string_or_interpolation() -> (String, LiteralReturnType)? {
            if let string:String = expression.stringLiteral?.string {
                return (string, .string)
            }
            if let integer:String = expression.integerLiteral?.literal.text {
                return (integer, .string)
            }
            if let float:String = expression.floatLiteral?.literal.text {
                return (float, .string)
            }
            if let function:FunctionCallExprSyntax = expression.as(FunctionCallExprSyntax.self) {
                switch key {
                case "height", "width":
                    var value:String = "\(function)"
                    value = String(value[value.index(after: value.startIndex)...])
                    value = HTMLElementAttribute.Extra.htmlValue(enumName: enumName(elementType: elementType, key: key), for: value)
                    return (value, .string)
                default:
                    if function.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text == "StaticString" {
                        return (function.arguments.first!.expression.stringLiteral!.string, .string)
                    }
                    return ("\\(\(function))", .interpolation)
                }
            }
            if let member:MemberAccessExprSyntax = expression.memberAccess {
                let decl:String = member.declName.baseName.text
                if let _:ExprSyntax = member.base {
                    /*if let integer:String = base.integerLiteral?.literal.text {
                        switch decl {
                        case "description":
                            return (integer, .integer)
                        default:
                            return (integer, .interpolation)
                        }
                    } else {*/
                        return ("\\(\(member))", .interpolation)
                    //}
                } else {
                    return (HTMLElementAttribute.Extra.htmlValue(enumName: enumName(elementType: elementType, key: key), for: decl), .string)
                }
            }
            let separator:String = get_separator(key: key)
            let string_return_logic:(ExprSyntax, String) -> String = {
                if $1.contains(separator) {
                    context.diagnose(Diagnostic(node: $0, message: DiagnosticMsg(id: "characterNotAllowedInDeclaration", message: "Character \"" + separator + "\" is not allowed when declaring values for \"" + key + "\".")))
                }
                return $1
            }
            if let value:String = expression.array?.elements.compactMap({
                if let string:String = $0.expression.stringLiteral?.string {
                    return string_return_logic($0.expression, string)
                }
                if let string:String = $0.expression.integerLiteral?.literal.text {
                    return string
                }
                if let string:String = $0.expression.floatLiteral?.literal.text {
                    return string
                }
                if let string:String = $0.expression.memberAccess?.declName.baseName.text {
                    return HTMLElementAttribute.Extra.htmlValue(enumName: enumName(elementType: elementType, key: key), for: string)
                }
                return nil
            }).joined(separator: separator) {
                return (value, .string)
            }
            return nil
        }
        guard var (string, returnType):(String, LiteralReturnType) = return_string_or_interpolation() else {
            //context.diagnose(Diagnostic(node: expression, message: DiagnosticMsg(id: "somethingWentWrong", message: "Something went wrong. (" + expression.debugDescription + ")", severity: .warning)))
            return nil
        }
        var remaining_interpolation:Int = 0
        if let list:StringLiteralSegmentListSyntax = expression.stringLiteral?.segments {
            for segment in list {
                if let expr:ExpressionSegmentSyntax = segment.as(ExpressionSegmentSyntax.self) {
                    remaining_interpolation += 1
                    if flatten_interpolation(string: &string, remaining_interpolation: &remaining_interpolation, expr: expr) {
                        remaining_interpolation -= 1
                    }
                }
            }
        }
        if returnType == .interpolation || remaining_interpolation > 0 {
            //dynamicVariables.append(string)
            if !string.contains("\\(") {
                string = "\\(" + string + ")"
            }
            returnType = .interpolation
            context.diagnose(Diagnostic(node: expression, message: DiagnosticMsg(id: "unsafeInterpolation", message: "Interpolation may introduce raw HTML.", severity: .warning)))
        }
        return (string, returnType)
    }
    static func flatten_interpolation(string: inout String, remaining_interpolation: inout Int, expr: ExpressionSegmentSyntax) -> Bool { // TODO: can still be improved ("\(description \(title))" doesn't get flattened)
        let expression:ExprSyntax = expr.expressions.first!.expression
        if let list:StringLiteralSegmentListSyntax = expression.stringLiteral?.segments {
            for segment in list {
                if let expr:ExpressionSegmentSyntax = segment.as(ExpressionSegmentSyntax.self) {
                    remaining_interpolation += 1
                    if flatten_interpolation(string: &string, remaining_interpolation: &remaining_interpolation, expr: expr) {
                        remaining_interpolation -= 1
                    }
                } else if let fix:String = segment.as(StringSegmentSyntax.self)?.content.text {
                    string.replace("\(expr)", with: fix)
                    remaining_interpolation -= 1
                }
            }
        }
        if let fix:String = expression.integerLiteral?.literal.text ?? expression.floatLiteral?.literal.text {
            string.replace("\(expr)", with: fix)
            return true
        }
        return false
    }
}

enum LiteralReturnType {
    case boolean, string, interpolation
}

// MARK: HTMLElementType
enum HTMLElementType : String, CaseIterable {
    case escapeHTML
    case html
    case custom
    
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
extension ExprSyntax {
    var booleanLiteral : BooleanLiteralExprSyntax? { self.as(BooleanLiteralExprSyntax.self) }
    var stringLiteral : StringLiteralExprSyntax? { self.as(StringLiteralExprSyntax.self) }
    var integerLiteral : IntegerLiteralExprSyntax? { self.as(IntegerLiteralExprSyntax.self) }
    var floatLiteral : FloatLiteralExprSyntax? { self.as(FloatLiteralExprSyntax.self) }
    var array : ArrayExprSyntax? { self.as(ArrayExprSyntax.self) }
    var memberAccess : MemberAccessExprSyntax? { self.as(MemberAccessExprSyntax.self) }
    var macroExpansion : MacroExpansionExprSyntax? { self.as(MacroExpansionExprSyntax.self) }
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
