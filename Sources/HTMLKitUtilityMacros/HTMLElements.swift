//
//  HTMLElements.swift
//
//
//  Created by Evan Anderson on 11/16/24.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum HTMLElements : MemberMacro {
    static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        let dictionary:DictionaryElementListSyntax = node.arguments!.children(viewMode: .all).first!.as(LabeledExprSyntax.self)!.expression.as(DictionaryExprSyntax.self)!.content.as(DictionaryElementListSyntax.self)!
        
        var items:[DeclSyntax] = []
        items.reserveCapacity(dictionary.count)

        var tags:[String] = []
        tags.reserveCapacity(dictionary.count)

        var initializer:String = "public init?(rawValue: String) {\n"
        initializer += "let key:Substring = rawValue.split(separator: \"(\")[0]\n"
        initializer += "var range:Substring = rawValue[rawValue.index(rawValue.startIndex, offsetBy: key.count+1)..<rawValue.index(rawValue.endIndex, offsetBy: -1)]\n"
        initializer += consume()
        initializer += cString()
        initializer += cBool()
        initializer += cFloat()
        initializer += cAttribute()
        initializer += "switch key {\n"

        for item in dictionary {
            var element:String = item.key.as(MemberAccessExprSyntax.self)!.declName.baseName.text
            element = element == "var" ? "`var`" : element
            var string:String = "case \(element)(\n"
            string += "attributes: [HTMLElementAttribute] = []"

            initializer += "case \"\(element)\": self = .\(element)("

            tags.append(element)
            //string += "public let isVoid:Bool = false\npublic var attributes:[HTMLElementAttribute] = []"
            var attributes:String = ""
            if let test = item.value.as(FunctionCallExprSyntax.self)?.arguments.first?.expression.as(ArrayExprSyntax.self)?.elements {
                for element in test {
                    var key:String = ""
                    for attribute_element in element.expression.as(FunctionCallExprSyntax.self)!.arguments.children(viewMode: .all) {
                        let label:LabeledExprSyntax = attribute_element.as(LabeledExprSyntax.self)!
                        if let key_element = label.expression.as(StringLiteralExprSyntax.self) {
                            key = "\(key_element)"
                            key.removeFirst()
                            key.removeLast()
                        } else {
                            var isArray:Bool = false
                            let value_type:String = parse_value_type(isArray: &isArray, key: key, label.expression)
                            let init_type:String
                            if value_type.hasPrefix("String") {
                                init_type = "cString()"
                            } else if value_type.hasPrefix("Bool") {
                                init_type = "cBool()"
                            } else if value_type.hasPrefix("Float") {
                                init_type = "cFloat()"
                            } else if value_type.hasPrefix("HTMLElementAttribute.Extra.") {
                                init_type = "cAttribute()"
                            } else if value_type.first == "[" {
                                init_type = "[]"
                            } else {
                                init_type = "nil"
                            }
                            attributes += ",\n\(key): \(value_type)"
                            initializer += "\n" + key + ": " + init_type + ","
                        }
                    }
                }
            }
            if initializer.last == "," {
                initializer.removeLast()
            }
            initializer += ")\n"
            //print("test=" + test.debugDescription)
            string += attributes
            //string += "\npublic var innerHTML:[HTML] = []\n}"
            string += ",\n_ innerHTML: [HTML] = []\n)"
            items.append("\(raw: string)")
        }
        initializer += "\ndefault: return nil\n}\n}"
        items.append("\(raw: initializer)")
        return items
    }
    // MARK: consume
    static func consume() -> String {
        return """
            func consume(_ length: Int) -> String {
                let slice:Substring = range[range.startIndex..<range.index(range.endIndex, offsetBy: length)]
                range = range[range.index(range.startIndex, offsetBy: length)...]
                while (range.first?.isWhitespace ?? false) || range.first == "," {
                    range.removeFirst()
                }
                return String(slice)
            }\n
        """
    }
    // MARK: cString
    static func cString() -> String {
        return """
            func cString() -> String? {
                guard range.first == "\\\"" else { return nil }
                range.removeFirst()
                let index:Substring.Index = range.firstIndex(of: "\\\"")!
                return consume(range.distance(from: range.startIndex, to: index))
            }\n
        """
    }
    // MARK: cBool
    static func cBool() -> String {
        return """
            func cBool() -> Bool {
                if range.hasPrefix("true") {
                    _ = consume(4)
                    return true
                }
                if range.hasPrefix("false") {
                    _ = consume(5)
                    return false
                }
                return false
            }\n
        """
    }
    // MARK: cFloat
    static func cFloat() -> String {
        return """
            func cFloat() -> Float? {
                guard range.first?.isNumber ?? false else { return nil }
                var string:String = ""
                while (range.first?.isNumber ?? false) || range.first == "." || range.first == "_" {
                    string.append(range.removeFirst())
                }
                return Float(string)!
            }\n
        """
    }
    // MARK: cAttribute
    static func cAttribute() -> String {
        return """
            func cAttribute<T: HTMLInitializable>() -> T? {
                guard range.first == "." else { return nil }
                range.removeFirst()
                var string:String = "", depth:Int = 1
                while let char:Character = range.first {
                    if char == "(" {
                        depth += 1
                    } else if char == ")" {
                        depth -= 1
                    }
                    if depth == 0 {
                        break
                    }
                    string.append(range.removeFirst())
                }
                string += ")"
                return T(rawValue: string)
            }\n
        """
    }
    // MARK: parse value type
    static func parse_value_type(isArray: inout Bool, key: String, _ expr: ExprSyntax) -> String {
        let value_type_key:String
        if let member:MemberAccessExprSyntax = expr.as(MemberAccessExprSyntax.self) {
            value_type_key = member.declName.baseName.text
        } else {
            value_type_key = expr.as(FunctionCallExprSyntax.self)!.calledExpression.as(MemberAccessExprSyntax.self)!.declName.baseName.text
        }
        switch value_type_key {
            case "array":
                isArray = true
                let of_type:String = parse_value_type(isArray: &isArray, key: key, expr.as(FunctionCallExprSyntax.self)!.arguments.first!.expression)
                return "[" + of_type + "] = []"
            case "attribute":
                return "HTMLElementAttribute.Extra.\(key)" + (isArray ? "" : "? = nil")
            case "otherAttribute":
                var string:String = "\(expr.as(FunctionCallExprSyntax.self)!.arguments.first!.expression.as(StringLiteralExprSyntax.self)!)"
                string.removeFirst()
                string.removeLast()
                return "HTMLElementAttribute.Extra." + string + (isArray ? "" : "? = nil")
            case "string":
                return "String" + (isArray ? "" : "? = nil")
            case "int":
                return "Int" + (isArray ? "" : "? = nil")
            case "float":
                return "Float" + (isArray ? "" : "? = nil")
            case "bool":
                return "Bool" + (isArray ? "" : " = false")
            case "booleanDefaultValue":
                let value:Bool = expr.as(FunctionCallExprSyntax.self)!.arguments.first!.expression.as(BooleanLiteralExprSyntax.self)!.literal.text == "true"
                return "Bool = \(value)"
            case "cssUnit":
                return "HTMLElementAttribute.CSSUnit" + (isArray ? "" : "? = nil")
            default:
                return "Float"
        }
    }
}