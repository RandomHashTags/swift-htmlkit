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
        let type:HTMLElementType = HTMLElementType(rawValue: node.macroName.text)!
        let data:ElementData = parse_arguments(elementType: type, arguments: node.arguments)
        var string:String = (type == .html ? "<!DOCTYPE html>" : "") + "<" + type.rawValue + data.attributes + ">" + data.innerHTML
        if !type.isVoid {
            string += "</" + type.rawValue + ">"
        }
        return "\"\(raw: string)\""
    }
}

private extension HTMLElement {
    static func parse_arguments(elementType: HTMLElementType, arguments: LabeledExprListSyntax) -> ElementData {
        var attributes:[String] = [], innerHTML:[String] = []
        for element in arguments.children(viewMode: .all) {
            if let child:LabeledExprSyntax = element.as(LabeledExprSyntax.self) {
                if var key:String = child.label?.text { // attributes
                    if key == "data" {
                        //context.diagnose(Diagnostic(node: node, message: ErrorDiagnostic(id: "bro", message: child.expression.debugDescription)))
                        let tuple:TupleExprSyntax = child.expression.as(TupleExprSyntax.self)!, valueExpression:ExprSyntax = tuple.elements.last!.expression
                        var (value, returnType):(String, LiteralReturnType) = parse_literal_value(elementType: elementType, key: "data", expression: valueExpression)!
                        if returnType == .interpolation {
                            value = "\\(" + value + ")"
                        }
                        key += "-\(tuple.elements.first!.expression.as(StringLiteralExprSyntax.self)!.string)"
                        attributes.append(key + "=\\\"" + value + "\\\"")
                    } else {
                        if key == "acceptCharset" {
                            key = "accept-charset"
                        }
                        if let string:String = parse_attribute(elementType: elementType, key: key, expression: child.expression) {
                            attributes.append(string)
                        }
                    }
                } else if let array:ArrayElementListSyntax = child.expression.as(ArrayExprSyntax.self)?.elements { // inner html
                    for yoink in array {
                        if let macro:MacroExpansionExprSyntax = yoink.expression.as(MacroExpansionExprSyntax.self) {
                            innerHTML.append(parse_element_macro(expression: macro))
                        } else if let string:String = yoink.expression.as(StringLiteralExprSyntax.self)?.string {
                            innerHTML.append(string)
                        }
                    }
                }
            }
        }
        return ElementData(attributes: attributes, innerHTML: innerHTML)
    }
    static func parse_element_macro(expression: MacroExpansionExprSyntax) -> String {
        guard let elementType:HTMLElementType = HTMLElementType(rawValue: expression.macroName.text) else { return "\(expression)" }
        let data:ElementData = parse_arguments(elementType: elementType, arguments: expression.arguments)
        return "<" + elementType.rawValue + data.attributes + ">" + data.innerHTML + (elementType.isVoid ? "" : "</" + elementType.rawValue + ">")
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
        case "inputtype":  return "inputmode"
        case "oltype":     return "numberingtype"
        case "scripttype": return "scripttype"
        default:           return key
        }
    }
    
    static func parse_attribute(elementType: HTMLElementType, key: String, expression: ExprSyntax) -> String? {
        func yup(_ value: String) -> String { key + "=\\\"" + value + "\\\"" }
        if let (string, returnType):(String, LiteralReturnType) = parse_literal_value(elementType: elementType, key: key, expression: expression) {
            switch returnType {
            case .boolean: return string.elementsEqual("true") ? key : nil
            case .string: return yup(string)
            case .interpolation: return yup("\\(" + string + ")")
            }
        }
        if let value:String = expression.as(ArrayExprSyntax.self)?.elements.compactMap({
            if let string:String = $0.expression.stringLiteral?.string {
                return string
            }
            if let string:String = $0.expression.integerLiteral?.literal.text {
                return string
            }
            if let string:String = $0.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
                return HTMLElementAttribute.htmlValue(enumName: enumName(elementType: elementType, key: key), for: string)
            }
            return nil
        }).joined(separator: get_separator(key: key)) {
            return yup(value)
        }
        func member(_ value: String) -> String {
            var string:String = String(value[value.index(after: value.startIndex)...])
            string = HTMLElementAttribute.htmlValue(enumName: enumName(elementType: elementType, key: key), for: string)
            return yup(string)
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
    static func parse_literal_value(elementType: HTMLElementType, key: String, expression: ExprSyntax) -> (value: String, returnType: LiteralReturnType)? {
        if let boolean:String = expression.booleanLiteral?.literal.text {
            return (boolean, .boolean)
        }
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
                value = HTMLElementAttribute.htmlValue(enumName: enumName(elementType: elementType, key: key), for: value)
                return (value, .string)
            default:
                return ("\(function)", .interpolation)
            }
        }
        if let member:MemberAccessExprSyntax = expression.as(MemberAccessExprSyntax.self) {
            let decl:String = member.declName.baseName.text
            if let base:ExprSyntax = member.base {
                if let integer:String = base.integerLiteral?.literal.text {
                    switch decl {
                    case "description":
                        return (integer, .string)
                    default:
                        return (integer, .interpolation)
                    }
                } else {
                    return ("\(member)", .interpolation)
                }
            } else {
                return (HTMLElementAttribute.htmlValue(enumName: enumName(elementType: elementType, key: key), for: decl), .string)
            }
        }
        return nil
    }
}

enum LiteralReturnType {
    case boolean, string, interpolation
}

// MARK: HTMLElementType
enum HTMLElementType : String {
    case html
    
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

extension ExprSyntax {
    var booleanLiteral : BooleanLiteralExprSyntax? { self.as(BooleanLiteralExprSyntax.self) }
    var stringLiteral : StringLiteralExprSyntax? { self.as(StringLiteralExprSyntax.self) }
    var integerLiteral : IntegerLiteralExprSyntax? { self.as(IntegerLiteralExprSyntax.self) }
    var floatLiteral : FloatLiteralExprSyntax? { self.as(FloatLiteralExprSyntax.self) }
}
extension StringLiteralExprSyntax {
    var string : String { "\(segments)" }
}

extension HTMLElementAttribute {
    static func htmlValue(enumName: String, for enumCase: String) -> String { // only need to check the ones where the htmlValue is different from the rawValue
        switch enumName {
        case "contenteditable": return contenteditable(rawValue: enumCase)!.htmlValue
        case "crossorigin":     return crossorigin(rawValue: enumCase)!.htmlValue
        case "formenctype":     return formenctype(rawValue: enumCase)!.htmlValue
        case "hidden":          return hidden(rawValue: enumCase)!.htmlValue
        case "httpequiv":       return httpequiv(rawValue: enumCase)!.htmlValue
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
