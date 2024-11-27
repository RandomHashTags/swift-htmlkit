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

        let void_elements:Set<String> = [
            "area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "source", "track", "wbr"
        ]

        for item in dictionary {
            let element:String = item.key.as(MemberAccessExprSyntax.self)!.declName.baseName.text
            let is_void:Bool = void_elements.contains(element)
            var tag:String = element
            if element == "variable" {
                tag = "var"
            }
            var string:String = "/// MARK: \(tag)\n/// The `\(tag)` HTML element.\npublic struct \(element) : HTMLElement {\n"
            string += "public private(set) var isVoid:Bool = \(is_void)\n"
            string += "public var trailingSlash:Bool = false\n"
            string += "public var escaped:Bool = false\n"
            string += "public let tag:String = \"\(tag)\"\n"
            string += "private var encoding:HTMLEncoding = .string\n"
            string += "public var attributes:[HTMLElementAttribute]\n"

            var initializers:String = ""
            var attribute_declarations:String = ""
            var attributes:[(String, String, String)] = []
            var other_attributes:[(String, String)] = []
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
                            switch value_type_literal {
                                case .otherAttribute(let other):
                                    other_attributes.append((key, other))
                                    break
                                default:
                                    break
                            }
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

            initializers += "public init?(_ context: some MacroExpansionContext, _ encoding: HTMLEncoding, _ children: SyntaxChildren) {\n"
            let other_attributes_string:String = other_attributes.isEmpty ? "" : ", otherAttributes: [" + other_attributes.map({ "\"" + $0.0 + "\":\"" + $0.1 + "\"" }).joined(separator: ",") + "]"
            initializers += "self.encoding = encoding\n"
            initializers += "let data:HTMLKitUtilities.ElementData = HTMLKitUtilities.parseArguments(context: context, encoding: encoding, children: children\(other_attributes_string))\n"
            if is_void {
                initializers += "self.trailingSlash = data.trailingSlash\n"
            }
            initializers += "self.attributes = data.globalAttributes\n"
            for (key, value_type, _) in attributes {
                var key_literal:String = key
                if key_literal.first == "`" {
                    key_literal.removeFirst()
                    key_literal.removeLast()
                }
                var value:String = "as? \(value_type)"
                switch value_type {
                    case "Bool":
                        value += " ?? false"
                    default:
                        break
                }
                initializers += "self.\(key) = data.attributes[\"\(key_literal)\"] " + value + "\n"
            }
            initializers += "self.innerHTML = data.innerHTML\n"
            initializers += "}"
            string += initializers

            var render:String = "\npublic var description : String {\n"
            var attributes_func:String = "func attributes() -> String {\n"
            if !attributes.isEmpty {
                attributes_func += "let sd:String = encoding.stringDelimiter\n"
                attributes_func += "var"
            } else {
                attributes_func += "let"
            }
            attributes_func += " items:[String] = self.attributes.compactMap({\n"
            attributes_func += "guard let v:String = $0.htmlValue(encoding) else { return nil }\n"
            attributes_func += "let d:String = $0.htmlValueDelimiter(encoding)\n"
            attributes_func += #"return $0.key + ($0.htmlValueIsVoidable && v.isEmpty ? "" : "=" + d + v + d)"#
            attributes_func += "\n})\n"
            for (key, value_type, _) in attributes {
                var key_literal:String = key
                if key_literal.first == "`" {
                    key_literal.removeFirst()
                    key_literal.removeLast()
                }
                let variable_name:String = key_literal
                if key_literal == "httpEquiv" {
                    key_literal = "http-equiv"
                } else if key_literal == "acceptCharset" {
                    key_literal = "accept-charset"
                }
                if value_type == "Bool" {
                    attributes_func += "if \(key) { items.append(\"\(key_literal)\") }\n"
                } else if value_type.first == "[" {
                    attributes_func += "if let _\(variable_name):String = "
                    let separator:String = separator(key: key)
                    switch value_type {
                        case "[String]":
                            attributes_func += "\(key)?"
                            break
                        case "[Int]", "[Float]":
                            attributes_func += "\(key)?.map({ \"\\($0)\" })"
                            break
                        default:
                            attributes_func += "\(key)?.compactMap({ return $0.htmlValue(encoding) })"
                            break
                    }
                    attributes_func += ".joined(separator: \"\(separator)\") {\n"
                    attributes_func += #"let k:String = _\#(variable_name).isEmpty ? "" : "=" + sd + _\#(variable_name) + sd"#
                    attributes_func += "\nitems.append(\"\(key_literal)\" + k)"
                    attributes_func += "\n}\n"
                } else if value_type == "String" || value_type == "Int" || value_type == "Float" || value_type == "Double" {
                    let value:String = value_type == "String" ? key : "String(describing: \(key))"
                    attributes_func += #"if let \#(key) { items.append("\#(key_literal)=" + sd + \#(value) + sd) }"#
                    attributes_func += "\n"
                } else {
                    attributes_func += "if let \(key), let v:String = \(key).htmlValue(encoding) {\n"
                    attributes_func += #"let s:String = \#(key).htmlValueIsVoidable && v.isEmpty ? "" : "=" + sd + v + sd"#
                    attributes_func += "\nitems.append(\"\(key_literal)\" + s)"
                    attributes_func += "\n}\n"
                }
            }
            attributes_func += "return (items.isEmpty ? \"\" : \" \") + items.joined(separator: \" \")\n}\n"
            render += attributes_func
            render += "let string:String = innerHTML.map({ String(describing: $0) }).joined()\n"
            let trailing_slash:String = is_void ? " + (trailingSlash ? \" /\" : \"\")" : ""
            render += """
            let l:String, g:String
            if escaped {
                l = "&lt;"
                g = "&gt;"
            } else {
                l = "<"
                g = ">"
            }
            """
            render += "return \(tag == "html" ? "l + \"!DOCTYPE html\" + g + " : "")l + tag + attributes()\(trailing_slash) + g + string" + (is_void ? "" : " + l + \"/\" + tag + g")
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
                return ("[" + of_type + "]", "? = nil", .array(of: of_type_literal))
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
                return ("HTMLElementAttribute.CSSUnit", isArray ? "" : "? = nil", .cssUnit)
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