//
//  HTMLElement.swift
//
//
//  Created by Evan Anderson on 9/14/24.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

struct HTMLElement : ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        return "\(raw: parse_element(node: node, context: context))"
    }
}

extension HTMLElement {
    static func parse_element(node: some FreestandingMacroExpansionSyntax, context: some MacroExpansionContext) -> String {
        let macroName:String = node.macroName.text
        let type:HTMLElementType = HTMLElementType(rawValue: macroName) ?? HTMLElementType.a
        let data:ElementData = parse_arguments(arguments: node.arguments)
        var string:String = (type == .html ? "<!DOCTYPE html>" : "") + "<" + type.rawValue + data.attributes + ">" + data.innerHTML
        if !type.isVoid {
            string += "</" + type.rawValue + ">"
        }
        return "\"" + string + "\""
    }
    static func parse_arguments(arguments: LabeledExprListSyntax) -> ElementData {
        var attributes:[String] = []
        var innerHTML:[String] = []
        for element in arguments.children(viewMode: .all) {
            if let child:LabeledExprSyntax = element.as(LabeledExprSyntax.self) {
                if let key:String = child.label?.text {
                    switch key {
                        case "attributes":
                            attributes = parse_attributes(child: child)
                            break
                        case "innerHTML":
                            innerHTML = parse_inner_html(child: child)
                            break
                        default: // extra attribute
                            if let string:String = parse_extra_attribute(child: child) {
                                attributes.append(string)
                            }
                            break
                    }
                }
            }
        }
        return ElementData(attributes: attributes, innerHTML: innerHTML)
    }
    static func parse_element_macro(expression: MacroExpansionExprSyntax) -> String {
        guard let elementType:HTMLElementType = HTMLElementType(rawValue: expression.macroName.text) else { return "\(expression)" }
        let data:ElementData = parse_arguments(arguments: expression.arguments)
        return "<" + elementType.rawValue + data.attributes + ">" + data.innerHTML + (elementType.isVoid ? "" : "</" + elementType.rawValue + ">")
    }
    static func parse_inner_html(child: LabeledExprSyntax) -> [String] {
        var innerHTML:[String] = []
        if let array:ArrayElementListSyntax = child.expression.as(ArrayExprSyntax.self)?.elements {
            for yoink in array {
                if let macro:MacroExpansionExprSyntax = yoink.expression.as(MacroExpansionExprSyntax.self) {
                    innerHTML.append(parse_element_macro(expression: macro))
                } else if let string:String = yoink.expression.as(StringLiteralExprSyntax.self)?.string {
                    innerHTML.append(string)
                }
            }
        }
        return innerHTML
    }
}

struct ElementData {
    let attributes:String
    let innerHTML:String

    init(attributes: [String], innerHTML: [String]) {
        self.attributes = attributes.isEmpty ? "" : " " + attributes.joined(separator: " ")
        self.innerHTML = innerHTML.joined()
    }
}

// MARK: Parse Attribute
private extension HTMLElement {
    static func parse_attributes(child: LabeledExprSyntax) -> [String] {
        let elements:ArrayElementListSyntax = child.expression.as(ArrayExprSyntax.self)!.elements
        var attributes:[String] = []
        for attribute in elements {
            let function:FunctionCallExprSyntax = attribute.expression.as(FunctionCallExprSyntax.self)!
            var functionName:String = function.calledExpression.as(MemberAccessExprSyntax.self)!.declName.baseName.text
            var string:String = ""
            switch functionName {
                case "accesskey",
                        "contentEditable",
                        "dir",
                        "draggable",
                        "enterKeyHint",
                        "hidden",
                        "id",
                        "inputMode",
                        "is",
                        "itemId",
                        "itemProp",
                        "itemRef",
                        //"itemScope",
                        "itemType",
                        "lang",
                        "nonce",
                        "popover",
                        "role",
                        "slot",
                        "spellcheck",
                        "style",
                        "title",
                        "translate",
                        "virtualKeyboardPolicy",
                        "writingSuggestions":
                    string = parse_attribute_string(functionName, function)
                    break
                case "class",
                        "exportParts",
                        "part":
                    string = parse_attribute_array(function).joined(separator: " ")
                    break
                case "tabIndex": // TODO: fix
                    break
                case "data":
                    functionName = "data-" + function.arguments.first!.expression.as(StringLiteralExprSyntax.self)!.string
                    string = function.arguments.last!.expression.as(StringLiteralExprSyntax.self)!.string
                    break
                default:
                    break
            }
            if !string.isEmpty {
                attributes.append(functionName.lowercased() + "=\\\"" + string + "\\\"")
            }
        }
        return attributes
    }
    static func parse_attribute_string(_ key : String, _ function: FunctionCallExprSyntax) -> String {
        let argument = function.arguments.first!
        let expression:ExprSyntax = argument.expression
        if let string:String = expression.as(StringLiteralExprSyntax.self)?.string {
            return string
        }
        if let member = expression.as(MemberAccessExprSyntax.self) {
            var token:[String] = []
            var base:ExprSyntax? = member.base
            while base != nil {
                if let member:MemberAccessExprSyntax = base!.as(MemberAccessExprSyntax.self) {
                    token.append(member.declName.baseName.text)
                    base = member.base
                } else if let decl:String = base!.as(DeclReferenceExprSyntax.self)?.baseName.text {
                    token.append(decl)
                    base = nil
                } else {
                    base = nil
                }
            }
            if token.isEmpty {
                token.append("HTMLElementAttribute." + key[key.startIndex].uppercased() + key[key.index(after: key.startIndex)...])
            }
            return "\\(" + token.reversed().joined(separator: ".") + "." + member.declName.baseName.text + ")"
        }
        return "?"
    }
    static func parse_attribute_array(_ function: FunctionCallExprSyntax) -> [String] {
        return function.arguments.first!.expression.as(ArrayExprSyntax.self)!.elements.map({ $0.expression.as(StringLiteralExprSyntax.self)!.string })
    }

    static func parse_extra_attribute(child: LabeledExprSyntax) -> String? {
        let key:String = child.label!.text
        func yup(_ value: String) -> String {
            return key + "=\\\"" + value + "\\\""
        }
        let expression:ExprSyntax = child.expression
        if let boolean:String = expression.as(BooleanLiteralExprSyntax.self)?.literal.text {
            return boolean.elementsEqual("true") ? key : nil
        }
        if let string:String = expression.as(StringLiteralExprSyntax.self)?.string {
            return yup(string)
        }
        if let member:String = expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
            return yup("\\(HTMLElementAttribute." + key[key.startIndex].uppercased() + key[key.index(after: key.startIndex)...] + "." + member + ")")
        }
        if let _:NilLiteralExprSyntax = expression.as(NilLiteralExprSyntax.self) {
            return nil
        }
        if let integer:String = expression.as(IntegerLiteralExprSyntax.self)?.literal.text {
            return yup(integer)
        }
        if let float:String = expression.as(FloatLiteralExprSyntax.self)?.literal.text {
            return yup(float)
        }
        return nil
    }
}

// MARK: HTMLElementType
public enum HTMLElementType : String, CaseIterable {
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

    public var isVoid : Bool {
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
