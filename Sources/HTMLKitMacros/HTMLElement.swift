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
        let arguments:LabeledExprListSyntax = node.arguments
        let macroName:String = node.macroName.text
        var type:HTMLElementType = HTMLElementType(rawValue: macroName) ?? HTMLElementType.a
        var attributes:[String] = [], extra_attributes:[String] = []
        var items:[Item] = []
        for element in arguments.children(viewMode: .all) {
            if let child:LabeledExprSyntax = element.as(LabeledExprSyntax.self) {
                if let key:String = child.label?.text {
                    switch key {
                        case "elementType":
                            type = HTMLElementType(rawValue: child.expression.as(MemberAccessExprSyntax.self)!.declName.baseName.text) ?? HTMLElementType.div
                            break
                        case "attributes":
                            attributes = parse_attributes(child: child)
                            break
                        case "accept",
                                "alt",
                                "as",
                                "attributionsrc",
                                "autocomplete",
                                "autoplay",
                                "blocking",
                                "browsingtopics",
                                "capture",
                                "charset",
                                "checked",
                                "cite",
                                "cols",
                                "coords",
                                "content",
                                "controls",
                                "controlslist",
                                "credentialless",
                                "crossorigin",
                                "csp",
                                "datetime",
                                "decoding",
                                "default",
                                "defer",
                                "dirname",
                                "disabled",
                                "disablepictureinpicture",
                                "disableremoteplayback",
                                "download",
                                "elementtiming",
                                "fetchpriority",
                                "for",
                                "form",
                                "formaction",
                                "formenctype",
                                "formmethod",
                                "formnovalidate",
                                "formtarget",
                                "height",
                                "high",
                                "href",
                                "hreflang",
                                "httpEquiv",
                                "imagesizes",
                                "integrity",
                                "ismap",
                                "kind",
                                "label",
                                "list",
                                "loading",
                                "loop",
                                "low",
                                "max",
                                "maxlength",
                                "media",
                                "min",
                                "minlength",
                                "multiple",
                                "muted",
                                "name",
                                "nomodule",
                                "onafterprint",
                                "onbeforeprint",
                                "onbeforeunload",
                                "onblur",
                                "onerror",
                                "onfocus",
                                "onhashchange",
                                "onlanguagechange",
                                "onload",
                                "onmessage",
                                "onoffline",
                                "ononline",
                                "onpopstate",
                                "onresize",
                                "onstorange",
                                "onunload",
                                "open",
                                "optimum",
                                "pattern",
                                "ping",
                                "placeholder",
                                "playsinline",
                                "popovertarget",
                                "popovertargetaction",
                                "poster",
                                "preload",
                                "readonly",
                                "referrerpolicy",
                                "rel",
                                "reversed",
                                "required",
                                "rows",
                                "sandbox",
                                "scope",
                                "selected",
                                "shadowrootclonable",
                                "shadowrootdelegatesfocus",
                                "shadowrootmode",
                                "shadowrootserializable",
                                "shape",
                                "size",
                                "sizes",
                                "src",
                                "srcdoc",
                                "srclang",
                                "srcset",
                                "start",
                                "step",
                                "target",
                                "template",
                                "type",
                                "usemap",
                                "value",
                                "width",
                                "wrap",
                                "xmlns":
                            let string:String = parse_extra_attribute(child: child)
                            if !string.isEmpty {
                                extra_attributes.append(string)
                            }
                            break
                        case "innerHTML":
                            let array:ArrayElementListSyntax = child.expression.as(ArrayExprSyntax.self)!.elements
                            parse_body(node: node, context: context, macroName: macroName, array: array, items: &items)
                            break
                        default:
                            break
                    }
                } else if let array:ArrayElementListSyntax = child.expression.as(ArrayExprSyntax.self)?.elements {
                    parse_body(node: node, context: context, macroName: macroName, array: array, items: &items)
                }
            }
        }
        let attributes_string:String = attributes.isEmpty ? "" : " " + attributes.joined(separator: " ")
        let extra_attributes_string:String = extra_attributes.isEmpty ? "" : " " + extra_attributes.joined(separator: " ")
        var string:String = "\"<" + type.rawValue + attributes_string + extra_attributes_string + ">"
        if !items.isEmpty {
            string += "\""
        }
        for item in items {
            string += "+" + item.string
        }
        if !type.isVoid {
            string += (items.isEmpty ? "" : " + \"") + "</" + type.rawValue + ">\""
        }
        return "\(raw: string)"
    }
    private static func parse_body(node: some FreestandingMacroExpansionSyntax, context: some MacroExpansionContext, macroName: String, array: ArrayElementListSyntax, items: inout [Item]) {
        for element in array {
            if let test:MacroExpansionExprSyntax = element.expression.as(MacroExpansionExprSyntax.self) {
                let key:String
                let recursive:Bool = macroName == test.macroName.text
                if recursive { // swift macro limitation
                    key = "#HTMLElement(elementType: ." + test.macroName.text + ","
                } else {
                    if test.macroName.text == "HTMLElement" {
                        items.append(Item(isMacro: true, value: "\(test)"))
                        break
                    } else {
                        key = "#" + test.macroName.text + "("
                    }
                }
                var values:[String] = []
                for child in test.arguments.children(viewMode: .all) {
                    let label:LabeledExprSyntax = child.as(LabeledExprSyntax.self)!, key:String = label.label!.text + ": ", expression:ExprSyntax = label.expression
                    var string:String = ""
                    if let array:ArrayElementListSyntax = expression.as(ArrayExprSyntax.self)?.elements {
                        var body_items:[Item] = []
                        parse_body(node: node, context: context, macroName: macroName, array: array, items: &body_items)
                        string = key + "[" + body_items.map({ $0.string }).joined(separator: ", ") + "]"
                    } else {
                        string = key + "\(expression)"
                    }
                    if !string.isEmpty {
                        values.append(string)
                    }
                }
                if recursive && values.isEmpty {
                    values.append("innerHTML: []")
                }
                items.append(Item(isMacro: true, value: key + values.joined(separator: ",") + ")"))
            } else if let text:String = element.expression.as(StringLiteralExprSyntax.self)?.string {
                items.append(Item(isMacro: false, value: text))
            } else {
                var string:String = "\(element)"
                while string[string.startIndex].isWhitespace {
                    string.removeFirst()
                }
                while string[string.index(before: string.endIndex)].isWhitespace || string[string.index(before: string.endIndex)] == "," {
                    string.removeLast()
                }
                var jugs:[Character] = [], offset:Int = 1
                while string[string.index(string.startIndex, offsetBy: offset)] != "(" {
                    jugs.append(string[string.index(string.startIndex, offsetBy: offset)])
                    offset += 1
                }
                if string[string.index(string.startIndex, offsetBy: offset + 1)] == "." {
                    let ez:String = String(jugs)
                    string.insert(contentsOf: "HTMLElementAttribute." + ez[ez.startIndex].uppercased() + ez[ez.index(after: ez.startIndex)...], at: string.index(string.startIndex, offsetBy: offset+1)) 
                }
                if !string.starts(with: "HTMLElementAttribute") {
                    string.insert(contentsOf: "HTMLElementAttribute", at: string.startIndex)
                }
                items.append(Item(isMacro: true, value: string))
            }
        }
    }
}

extension HTMLElement {
    struct Item {
        let string:String

        init(isMacro: Bool, value: String) {
            string = isMacro ? value : "\"" + value + "\""
        }
    }
}

// MARK: Parse Attribute
private extension HTMLElement {
    static func parse_attributes(child: LabeledExprSyntax) -> [String] {
        let elements:ArrayElementListSyntax = child.expression.as(ArrayExprSyntax.self)!.elements
        var attributes:[String] = []
        for attribute in elements {
            let function:FunctionCallExprSyntax = attribute.expression.as(FunctionCallExprSyntax.self)!
            let functionName:String = function.calledExpression.as(MemberAccessExprSyntax.self)!.declName.baseName.text
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

    static func parse_extra_attribute(child: LabeledExprSyntax) -> String {
        let key:String = child.label!.text
        func yup(_ value: String) -> String {
            return key + "=\\\"" + value + "\\\""
        }
        let expression:ExprSyntax = child.expression
        if let boolean:String = expression.as(BooleanLiteralExprSyntax.self)?.literal.text {
            return boolean.elementsEqual("true") ? key : ""
        }
        if let string:String = expression.as(StringLiteralExprSyntax.self)?.string {
            return yup(string)
        }
        if let member:String = expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
            return yup("\\(HTMLElementAttribute." + key[key.startIndex].uppercased() + key[key.index(after: key.startIndex)...] + "." + member + ")")
        }
        if let _:NilLiteralExprSyntax = expression.as(NilLiteralExprSyntax.self) {
            return ""
        }
        if let integer:String = expression.as(IntegerLiteralExprSyntax.self)?.literal.text {
            return yup(integer)
        }
        if let float:String = expression.as(FloatLiteralExprSyntax.self)?.literal.text {
            return yup(float)
        }
        return ""
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
    var string : String {
        segments.children(viewMode: .sourceAccurate).first!.as(StringSegmentSyntax.self)!.content.text
    }
}