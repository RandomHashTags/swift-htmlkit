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
            let element = item.key.as(MemberAccessExprSyntax.self)!.declName.baseName.text
            let isVoid = void_elements.contains(element)
            var tag = element
            if element == "variable" {
                tag = "var"
            }
            var string:String = "// MARK: \(tag)\n/// The `\(tag)` HTML element.\npublic struct \(element) : HTMLElement {\n"
            string += """
            public let tag:String = "\(tag)"
            public var attributes:[HTMLAttribute]
            public var innerHTML:[CustomStringConvertible & Sendable]
            private var encoding:HTMLEncoding = .string
            private var fromMacro:Bool = false
            public let isVoid:Bool = \(isVoid)
            public var trailingSlash:Bool = false
            public var escaped:Bool = false
            """

            var initializers = ""
            var attribute_declarations = ""
            var attributes:[(String, String, String)] = []
            var other_attributes:[(String, String)] = []
            if let test = item.value.as(ArrayExprSyntax.self)?.elements {
                attributes.reserveCapacity(test.count)
                for element in test {
                    var key = ""
                    let tuple = element.expression.as(TupleExprSyntax.self)!
                    for attribute_element in tuple.elements {
                        let label = attribute_element
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
                            var isArray = false
                            let (value_type, default_value, value_type_literal):(String, String, HTMLElementValueType) = parse_value_type(isArray: &isArray, key: key, label.expression)
                            switch value_type_literal {
                            case .otherAttribute(let other):
                                other_attributes.append((key, other))
                            default:
                                break
                            }
                            attribute_declarations += "\npublic var \(key):\(value_type)\(default_value.split(separator: "=", omittingEmptySubsequences: false)[0])"
                            attributes.append((key, value_type, default_value))
                        }
                    }
                }
            }
            if !other_attributes.isEmpty {
                let oa = other_attributes.map({ "\"" + $0.0 + "\":\"" + $0.1 + "\"" }).joined(separator: ",")
                string += "\npublic static let otherAttributes:[String:String] = [" + oa + "]\n"
            }
            string += attribute_declarations

            initializers += "\npublic init(\n"
            initializers += "attributes: [HTMLAttribute] = [],\n"
            for (key, value_type, default_value) in attributes {
                initializers += key + ": " + value_type + default_value + ",\n"
            }
            initializers += "_ innerHTML: CustomStringConvertible & Sendable...\n) {\n"
            initializers += "self.attributes = attributes\n"
            for (key, _, _) in attributes {
                var key_literal = key
                if key_literal.first == "`" {
                    key_literal.removeFirst()
                    key_literal.removeLast()
                }
                initializers += "self.\(key_literal) = \(key)\n"
            }
            initializers += "self.innerHTML = innerHTML\n}\n"

            initializers += "public init(_ encoding: HTMLEncoding, _ data: HTMLKitUtilities.ElementData) {\n"
            initializers += "self.encoding = encoding\n"
            initializers += "self.fromMacro = true\n"
            if isVoid {
                initializers += "self.trailingSlash = data.trailingSlash\n"
            }
            initializers += "self.attributes = data.globalAttributes\n"
            for (key, value_type, _) in attributes {
                var key_literal = key
                if key_literal.first == "`" {
                    key_literal.removeFirst()
                    key_literal.removeLast()
                }
                var value = "as? \(value_type)"
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

            var render = "\npublic var description : String {\n"
            var attributes_func = "func attributes() -> String {\n"
            if !attributes.isEmpty {
                attributes_func += "let sd = encoding.stringDelimiter(forMacro: fromMacro)\n"
                attributes_func += "var"
            } else {
                attributes_func += "let"
            }
            attributes_func += " items:[String] = self.attributes.compactMap({\n"
            attributes_func += "guard let v = $0.htmlValue(encoding: encoding, forMacro: fromMacro) else { return nil }\n"
            attributes_func += "let d = $0.htmlValueDelimiter(encoding: encoding, forMacro: fromMacro)\n"
            attributes_func += #"return $0.key + ($0.htmlValueIsVoidable && v.isEmpty ? "" : "=" + d + v + d)"#
            attributes_func += "\n})\n"
            for (key, value_type, _) in attributes {
                var key_literal = key
                if key_literal.first == "`" {
                    key_literal.removeFirst()
                    key_literal.removeLast()
                }
                let variable_name = key_literal
                if key_literal == "httpEquiv" {
                    key_literal = "http-equiv"
                } else if key_literal == "acceptCharset" {
                    key_literal = "accept-charset"
                }
                if value_type == "Bool" {
                    attributes_func += "if \(key) { items.append(\"\(key_literal)\") }\n"
                } else if value_type.first == "[" {
                    attributes_func += "if let _\(variable_name):String = "
                    let separator = separator(key: key)
                    switch value_type {
                    case "[String]":
                        attributes_func += "\(key)?"
                    case "[Int]", "[Float]":
                        attributes_func += "\(key)?.map({ \"\\($0)\" })"
                    default:
                        attributes_func += "\(key)?.compactMap({ return $0.htmlValue(encoding: encoding, forMacro: fromMacro) })"
                    }
                    attributes_func += ".joined(separator: \"\(separator)\") {\n"
                    attributes_func += #"let k:String = _\#(variable_name).isEmpty ? "" : "=" + sd + _\#(variable_name) + sd"#
                    attributes_func += "\nitems.append(\"\(key_literal)\" + k)"
                    attributes_func += "\n}\n"
                } else if value_type == "String" || value_type == "Int" || value_type == "Float" || value_type == "Double" {
                    let value = value_type == "String" ? key : "String(describing: \(key))"
                    attributes_func += #"if let \#(key) { items.append("\#(key_literal)=" + sd + \#(value) + sd) }"#
                    attributes_func += "\n"
                } else {
                    attributes_func += "if let \(key), let v = \(key).htmlValue(encoding: encoding, forMacro: fromMacro) {\n"
                    attributes_func += #"let s = \#(key).htmlValueIsVoidable && v.isEmpty ? "" : "=" + sd + v + sd"#
                    attributes_func += "\nitems.append(\"\(key_literal)\" + s)"
                    attributes_func += "\n}\n"
                }
            }
            attributes_func += "return (items.isEmpty ? \"\" : \" \") + items.joined(separator: \" \")\n}\n"
            render += attributes_func
            render += "let string:String = innerHTML.map({ String(describing: $0) }).joined()\n"
            let trailing_slash = isVoid ? " + (trailingSlash ? \" /\" : \"\")" : ""
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
            render += "return \(tag == "html" ? "l + \"!DOCTYPE html\" + g + " : "")l + tag + attributes()\(trailing_slash) + g + string" + (isVoid ? "" : " + l + \"/\" + tag + g")
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
            return ("HTMLAttribute.Extra.\(key)", isArray ? "" : "? = nil", .attribute)
        case "otherAttribute":
            var string = "\(expr.as(FunctionCallExprSyntax.self)!.arguments.first!.expression.as(StringLiteralExprSyntax.self)!)"
            string.removeFirst()
            string.removeLast()
            return ("HTMLAttribute.Extra." + string, isArray ? "" : "? = nil", .otherAttribute(string))
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
            return ("CSSUnit", isArray ? "" : "? = nil", .cssUnit)
        default:
            return ("Float", "? = nil", .float)
        }
    }
}

// MARK: HTMLElementVariable
struct HTMLElementVariable {
    let name:String
    let defaultValue:String?
    let `public`:Bool
    let mutable:Bool
}

// MARK: HTMLElementValueType
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
