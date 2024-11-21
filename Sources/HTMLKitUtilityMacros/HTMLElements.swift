//
//  HTMLElements.swift
//
//
//  Created by Evan Anderson on 11/16/24.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum HTMLElements : DeclarationMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        let dictionary:DictionaryElementListSyntax = node.arguments.children(viewMode: .all).first!.as(LabeledExprSyntax.self)!.expression.as(DictionaryExprSyntax.self)!.content.as(DictionaryElementListSyntax.self)!
        
        var items:[DeclSyntax] = []
        items.reserveCapacity(dictionary.count)

        func separator(key: String) -> String {
            switch key {
                case "accept", "coords", "exportparts", "imagesizes", "imagesrcset", "sizes", "srcset":
                    return ","
                case "allow":
                    return ";"
                default:
                    return " "
            }
        }

        for item in dictionary {
            var element:String = item.key.as(MemberAccessExprSyntax.self)!.declName.baseName.text
            let is_void:Bool = HTMLElementType(rawValue: element)!.isVoid
            if element == "var" {
                element = "`var`"
            }
            var string:String = "/// MARK: \(element)\n/// The `\(element)` HTML element.\npublic struct \(element) : HTMLElement {\n"
            string += "public private(set) var tag:String = \"\(element)\"\n"
            string += "public private(set) var isVoid:Bool = \(is_void)\n"
            string += "public var attributes:[HTMLElementAttribute]\n"

            var initializers:String = ""
            //string += "public let isVoid:Bool = false\npublic var attributes:[HTMLElementAttribute] = []"
            var attribute_declarations:String = ""
            var attributes:[(String, String, String)] = []
            if let test = item.value.as(ArrayExprSyntax.self)?.elements {
                attributes.reserveCapacity(test.count)
                for element in test {
                    var key:String = ""
                    let tuple = element.expression.as(TupleExprSyntax.self)!
                    for attribute_element in tuple.elements {
                        let label:LabeledExprSyntax = attribute_element
                        if let key_element = label.expression.as(StringLiteralExprSyntax.self) {
                            key = "\(key_element)"
                            key.removeFirst()
                            key.removeLast()
                            switch key {
                                case "for", "default", "defer", "as":
                                    key = "`\(key)`"
                                default:
                                    break
                            }
                        } else {
                            var isArray:Bool = false
                            let (value_type, default_value, value_type_literal):(String, String, HTMLElementValueType) = parse_value_type(isArray: &isArray, key: key, label.expression)
                            attribute_declarations += "\npublic var \(key):\(value_type)\(default_value.split(separator: "=", omittingEmptySubsequences: false)[0])"
                            attributes.append((key, value_type, default_value))
                        }
                    }
                }
            }

            string += attribute_declarations
            string += "\npublic var innerHTML:[CustomStringConvertible]\n"

            initializers += "\npublic init(\n"
            initializers += "attributes: [HTMLElementAttribute] = [],\n"
            for (key, value_type, default_value) in attributes {
                initializers += key + ": " + value_type + default_value + ",\n"
            }
            initializers += "_ innerHTML: CustomStringConvertible...\n) {\n"
            initializers += "self.attributes = attributes\n"
            for (key, _, _) in attributes {
                var key_literal:String = key
                if key_literal.first == "`" {
                    key_literal.removeFirst()
                    key_literal.removeLast()
                }
                initializers += "self.\(key_literal) = \(key)\n"
            }
            initializers += "self.innerHTML = innerHTML\n}\n"

            initializers += "public init?(context: some MacroExpansionContext, _ children: SyntaxChildren) {\n"
            initializers += "let data:HTMLKitUtilities.ElementData = HTMLKitUtilities.parse_arguments(context: context, children: children)\n"
            initializers += "self.attributes = data.globalAttributes\n"
            for (key, value_type, _) in attributes {
                var value:String = "as? \(value_type)"
                switch value_type {
                    case "Bool":
                        value += " ?? false"
                    default:
                        if value_type.first == "[" {
                            value += " ?? []"
                        }
                        break
                }
                initializers += "self.\(key) = data.attributes[\"\(key)\"] " + value + "\n"
            }
            initializers += "self.innerHTML = data.innerHTML\n"
            initializers += "\n}"
            string += initializers

            var render:String = "\npublic var description : String {\n"
            var attributes_func:String = "func attributes() -> String {\n"
            attributes_func += (attributes.isEmpty ? "let" : "var") + " items:[String] = self.attributes.compactMap({\n"
            attributes_func += "guard let v:String = $0.htmlValue else { return nil }\n"
            attributes_func += #"return "\($0.key)" + (v.isEmpty ? "" : "=\\\"\(v)\\\"")"#
            attributes_func += "\n})"
            for (key, value_type, _) in attributes {
                var key_literal:String = key
                if key_literal.first == "`" {
                    key_literal.removeFirst()
                    key_literal.removeLast()
                }
                if key_literal == "httpEquiv" {
                    key_literal = "http-equiv"
                } else if key_literal == "acceptCharset" {
                    key_literal = "accept-charset"
                }
                if value_type == "Bool" {
                    attributes_func += "\nif \(key) { items.append(\"\(key_literal)\") }"
                } else if value_type.first == "[" {
                    attributes_func += "\nif !\(key).isEmpty {\nlet string:String = "
                    let separator:String = separator(key: key)
                    switch value_type {
                        case "[String]":
                            attributes_func += "\(key)"
                            break
                        case "[Int]", "[Float]":
                            attributes_func += "\(key).map({ \"\\($0)\" })"
                            break
                        default:
                            attributes_func += "\(key).compactMap({ return $0.htmlValue })"
                            break
                    }
                    attributes_func += ".joined(separator: \"\(separator)\")\n"
                    attributes_func += #"items.append("\#(key_literal)=\\\"" + string + "\\\"")}"#
                    attributes_func += "\n"
                } else if value_type == "String" || value_type == "Int" || value_type == "Float" || value_type == "Double" {
                    attributes_func += "\n"
                    let value:String = value_type == "String" ? key : "String(describing: \(key))"
                    attributes_func += #"if let \#(key) { items.append("\#(key)=\\\"" + \#(value) + "\\\"") }"#
                    attributes_func += "\n"
                } else {
                    attributes_func += "\n"
                    attributes_func += #"if let v:String = \#(key)?.htmlValue { items.append("\#(key_literal)=\\\"\(v)\\\"") }"#
                }
            }
            attributes_func += "\nreturn (items.isEmpty ? \"\" : \" \") + items.joined(separator: \" \")\n}\n"
            render += attributes_func
            render += "let string:String = innerHTML.map({ String(describing: $0) }).joined()\n"
            render += "return \"\(element == "html" ? "<!DOCTYPE html>" : "")<\(element)\" + attributes() + \">\" + string" + (is_void ? "" : " + \"</\(element)>\"")
            render += "}"

            string += render
            string += "\n}"
            items.append("\(raw: string)")
        }
        return items
    }
    // MARK: parse value type
    static func parse_value_type(isArray: inout Bool, key: String, _ expr: ExprSyntax) -> (value_type: String, default_value: String, value_type_literal: HTMLElementValueType) {
        let value_type_key:String
        if let member:MemberAccessExprSyntax = expr.as(MemberAccessExprSyntax.self) {
            value_type_key = member.declName.baseName.text
        } else {
            value_type_key = expr.as(FunctionCallExprSyntax.self)!.calledExpression.as(MemberAccessExprSyntax.self)!.declName.baseName.text
        }
        switch value_type_key {
            case "array":
                isArray = true
                let (of_type, _, of_type_literal):(String, String, HTMLElementValueType) = parse_value_type(isArray: &isArray, key: key, expr.as(FunctionCallExprSyntax.self)!.arguments.first!.expression)
                return ("[" + of_type + "]", "= []", .array(of: of_type_literal))
            case "attribute":
                return ("HTMLElementAttribute.Extra.\(key)", isArray ? "" : "? = nil", .attribute)
            case "otherAttribute":
                var string:String = "\(expr.as(FunctionCallExprSyntax.self)!.arguments.first!.expression.as(StringLiteralExprSyntax.self)!)"
                string.removeFirst()
                string.removeLast()
                return ("HTMLElementAttribute.Extra." + string, isArray ? "" : "? = nil", .otherAttribute(string))
            case "string":
                return ("String", isArray ? "" : "? = nil", .string)
            case "int":
                return ("Int", isArray ? "" : "? = nil", .int)
            case "float":
                return ("Float", isArray ? "" : "? = nil", .float)
            case "bool":
                return ("Bool", isArray ? "" : " = false", .bool)
            case "booleanDefaultValue":
                let value:Bool = expr.as(FunctionCallExprSyntax.self)!.arguments.first!.expression.as(BooleanLiteralExprSyntax.self)!.literal.text == "true"
                return ("Bool", "= \(value)", .booleanDefaultValue(value))
            case "cssUnit":
                return ("HTMLElementAttribute.CSSUnit", isArray ? "" : "? = nil", .string)
            default:
                return ("Float", "? = nil", .float)
        }
    }
}

indirect enum HTMLElementValueType {
    case string
    case int
    case float
    case bool
    case booleanDefaultValue(Bool)
    case attribute
    case otherAttribute(String)
    case cssUnit
    case array(of: HTMLElementValueType)
}


// MARK: HTMLElementType
package enum HTMLElementType : String, CaseIterable {
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

    package var isVoid : Bool {
        switch self {
        case .area, .base, .br, .col, .embed, .hr, .img, .input, .link, .meta, .source, .track, .wbr:
            return true
        default:
            return false
        }
    }
}