
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum HTMLElements: DeclarationMacro {
    // MARK: expansion
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        let dictionary:DictionaryElementListSyntax = node.arguments.children(viewMode: .all).first!.as(LabeledExprSyntax.self)!.expression.as(DictionaryExprSyntax.self)!.content.as(DictionaryElementListSyntax.self)!
        
        var items = [DeclSyntax]()
        items.reserveCapacity(dictionary.count)

        let voidElementTags:Set<String> = [
            "area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "source", "track", "wbr"
        ]

        for item in dictionary {
            let element = item.key.as(MemberAccessExprSyntax.self)!.declName.baseName.text
            let isVoid = voidElementTags.contains(element)
            var tag = element
            if element == "variable" {
                tag = "var"
            }
            var string = "// MARK: \(tag)\n/// The `\(tag)` HTML element.\npublic struct \(element): HTMLElement {\n"
            string += """
            public let tag = "\(tag)"
            public var attributes:[HTMLAttribute]
            public var innerHTML:[Sendable]
            public private(set) var encoding = HTMLEncoding.string
            public private(set) var fromMacro = false
            public let isVoid = \(isVoid)
            public var trailingSlash = false
            public var escaped = false
            """

            var initializers = ""
            var attribute_declarations = ""
            var attributes = [(String, String, String)]()
            var other_attributes = [(String, String)]()
            if let test = item.value.as(ArrayExprSyntax.self)?.elements {
                attributes.reserveCapacity(test.count)
                for element in test {
                    guard let tuple = element.expression.as(TupleExprSyntax.self) else { continue }
                    var key = ""
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
                            let (value_type, default_value, valueTypeLiteral) = parseValueType(isArray: &isArray, key: key, label.expression)
                            switch valueTypeLiteral {
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

            initializers += "\n" + defaultInitializer(
                attributes: attributes,
                innerHTMLValueType: "[Sendable] = []",
                assignInnerHTML: "innerHTML"
            )
            initializers += "\n" + defaultInitializer(
                attributes: attributes,
                innerHTMLValueType: "Sendable...",
                assignInnerHTML: "innerHTML"
            )
            initializers += "\n" + defaultInitializer(
                attributes: attributes,
                innerHTMLValueType: "() -> Sendable...",
                assignInnerHTML: "innerHTML.map { $0() }"
            )

            initializers += "public init(_ encoding: HTMLEncoding, _ data: HTMLKitUtilities.ElementData) {\n"
            initializers += "self.encoding = encoding\n"
            initializers += "self.fromMacro = true\n"
            if isVoid {
                initializers += "self.trailingSlash = data.trailingSlash\n"
            }
            initializers += "self.attributes = data.globalAttributes\n"
            var builders = ""
            for (key, valueType, _) in attributes {
                var keyLiteral = key
                if keyLiteral.first == "`" {
                    keyLiteral.removeFirst()
                    keyLiteral.removeLast()
                }
                var value = "as? \(valueType)"
                switch valueType {
                case "Bool":
                    value += " ?? false"
                default:
                    break
                }
                initializers += "self.\(key) = data.attributes[\"\(keyLiteral)\"] " + value + "\n"
                builders += """
                @inlinable
                public mutating func \(key)(_ value: \(valueType)\(valueType == "Bool" ? "" : "?")) -> Self {
                    self.\(key) = value
                    return self
                }
                """
            }
            initializers += "self.innerHTML = data.innerHTML\n"
            initializers += "}"
            string += initializers

            var referencedStringDelimiter = false
            var render = "\n@inlinable public var description: String {\n"
            var attributes_func = ""
            var itemsArray = ""
            if !attributes.isEmpty {
                attributes_func += "let sd = encoding.stringDelimiter(forMacro: fromMacro)\n"
                itemsArray += "var items = [String]()\n"
            }
            for (key, valueType, _) in attributes {
                var keyLiteral = key
                if keyLiteral.first == "`" {
                    keyLiteral.removeFirst()
                    keyLiteral.removeLast()
                }
                let variableName = keyLiteral
                switch keyLiteral {
                case "httpEquiv":     keyLiteral = "http-equiv"
                case "acceptCharset": keyLiteral = "accept-charset"
                default: break
                }
                if valueType.first == "[" {
                    referencedStringDelimiter = true
                    itemsArray += "if let _\(variableName):String = "
                    let separator = separator(key: key)
                    switch valueType {
                    case "[String]":
                        itemsArray += "\(key)?"
                    case "[Int]", "[Float]":
                        itemsArray += "\(key)?.map({ \"\\($0)\" })"
                    default:
                        itemsArray += "\(key)?.compactMap({ $0.htmlValue(encoding: encoding, forMacro: fromMacro) })"
                    }
                    itemsArray += ".joined(separator: \"\(separator)\") {\n"
                    itemsArray += #"let k:String = _\#(variableName).isEmpty ? "" : "=" + sd + _\#(variableName) + sd"#
                    itemsArray += "\nitems.append(\"\(keyLiteral)\" + k)"
                    itemsArray += "\n}\n"
                } else {
                    switch valueType {
                    case "Bool":
                        itemsArray += "if \(key) { items.append(\"\(keyLiteral)\") }\n"
                    case "String", "Int", "Float", "Double":
                        referencedStringDelimiter = true
                        let value = valueType == "String" ? key : "String(describing: \(key))"
                        itemsArray += #"if let \#(key) { items.append("\#(keyLiteral)=" + sd + \#(value) + sd) }"#
                        itemsArray += "\n"
                    default:
                        referencedStringDelimiter = true
                        itemsArray += "if let \(key), let v = \(key).htmlValue(encoding: encoding, forMacro: fromMacro) {\n"
                        itemsArray += #"let s = \#(key).htmlValueIsVoidable && v.isEmpty ? "": "=" + sd + v + sd"#
                        itemsArray += "\nitems.append(\"\(keyLiteral)\" + s)"
                        itemsArray += "\n}\n"
                    }
                }
            }
            render += (!referencedStringDelimiter ? "" : attributes_func) + itemsArray
            render += "return render("
            if tag == "html" {
                render += "prefix: \"!DOCTYPE html\", "
            }
            if !isVoid {
                render += "suffix: \"/\" + tag, "
            }
            render += "items: \(itemsArray.isEmpty ? "[]" : "items"))"
            render += "}"

            string += render
            //string += "\n" + builders
            string += "\n}"
            items.append("\(raw: string)")
        }
        return items
    }

    // MARK: separator
    static func separator(key: String) -> String {
        switch key {
        case "accept", "coords", "exportparts", "imagesizes", "imagesrcset", "sizes", "srcset":
            ","
        case "allow":
            ";"
        default:
            " "
        }
    }

    // MARK: default initializer
    static func defaultInitializer(
        attributes: [(String, String, String)],
        innerHTMLValueType: String,
        assignInnerHTML: String
    ) -> String {
        var initializers = "@discardableResult public init(\n"
        initializers += "attributes: [HTMLAttribute] = [],\n"
        for (key, valueType, defaultValue) in attributes {
            initializers += key + ": " + valueType + defaultValue + ",\n"
        }
        initializers += "_ innerHTML: \(innerHTMLValueType)\n) {\n"
        initializers += "self.attributes = attributes\n"
        for (key, _, _) in attributes {
            var keyLiteral = key
            if keyLiteral.first == "`" {
                keyLiteral.removeFirst()
                keyLiteral.removeLast()
            }
            initializers += "self.\(keyLiteral) = \(key)\n"
        }
        initializers += "self.innerHTML = \(assignInnerHTML)\n}\n"
        return initializers
    }

    // MARK: parse value type
    static func parseValueType(
        isArray: inout Bool,
        key: String,
        _ expr: ExprSyntax
    ) -> (value_type: String, default_value: String, valueTypeLiteral: HTMLElementValueType) {
        let valueTypeKey:String
        if let member = expr.as(MemberAccessExprSyntax.self) {
            valueTypeKey = member.declName.baseName.text
        } else {
            valueTypeKey = expr.as(FunctionCallExprSyntax.self)!.calledExpression.as(MemberAccessExprSyntax.self)!.declName.baseName.text
        }
        switch valueTypeKey {
        case "array":
            isArray = true
            let (of_type, _, of_type_literal) = parseValueType(isArray: &isArray, key: key, expr.as(FunctionCallExprSyntax.self)!.arguments.first!.expression)
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
