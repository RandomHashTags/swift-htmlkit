//
//  HTMLElement.swift
//
//
//  Created by Evan Anderson on 9/14/24.
//

import SwiftSyntax
import SwiftSyntaxMacros

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

/*extension HTMLElement : BodyMacro {
    static func expansion(of node: AttributeSyntax, providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax, in context: some MacroExpansionContext) throws -> [CodeBlockItemSyntax] {
        return ["test: String? = nil,"]
    }
}*/

private extension HTMLElement {
    static func parse_arguments(elementType: HTMLElementType, arguments: LabeledExprListSyntax) -> ElementData {
        var attributes:[String] = [], innerHTML:[String] = []
        for element in arguments.children(viewMode: .all) {
            if let child:LabeledExprSyntax = element.as(LabeledExprSyntax.self) {
                if var key:String = child.label?.text { // attributes
                    if key == "data" {
                        let tuple:TupleExprSyntax = child.expression.as(TupleExprSyntax.self)!
                        key += "-\(tuple.elements.first!.expression.as(StringLiteralExprSyntax.self)!.string)"
                        attributes.append(key + "=\\\"\(tuple.elements.last!.expression.as(StringLiteralExprSyntax.self)!.string)\\\"")
                    } else if let string:String = parse_attribute(elementType: elementType, key: key, expression: child.expression) {
                        attributes.append(string)
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
    
    static func parse_attribute(elementType: HTMLElementType, key: String, expression: ExprSyntax) -> String? {
        if let boolean:String = expression.as(BooleanLiteralExprSyntax.self)?.literal.text {
            return boolean.elementsEqual("true") ? key : nil
        }
        func yup(_ value: String) -> String { key + "=\\\"" + value + "\\\"" }
        if let string:String = expression.as(StringLiteralExprSyntax.self)?.string {
            return yup(string)
        }
        if let integer:String = expression.as(IntegerLiteralExprSyntax.self)?.literal.text {
            return yup(integer)
        }
        if let float:String = expression.as(FloatLiteralExprSyntax.self)?.literal.text {
            return yup(float)
        }
        if let value:String = expression.as(ArrayExprSyntax.self)?.elements.map({ $0.expression.as(StringLiteralExprSyntax.self)!.string }).joined(separator: " ") { // TODO: fix: [Int], [HTMLElementAttribute.controlslist], [HTMLElementAttribute.sandbox]
            return yup(value)
        }
        func member(_ value: String) -> String {
            var enumName:String = key
            switch elementType.rawValue + key { // better performance than switching key, than switching elementType
                case "buttontype":
                    enumName = "buttontype"
                    break
                case "inputtype":
                    enumName = "inputmode"
                    break
                case "oltype":
                    enumName = "numberingtype"
                    break
                case "scripttype":
                    enumName = "scripttype"
                    break
                default:
                    break
            }
            return yup("\\(HTMLElementAttribute." + enumName + value + ")")
        }
        if let function:FunctionCallExprSyntax = expression.as(FunctionCallExprSyntax.self) {
            return member("\(function)")
        }
        if let value:String = expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
            return member("." + value)
        }
        return nil
    }
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

extension StringLiteralExprSyntax {
    var string : String { "\(segments)" }
}
