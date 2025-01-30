//
//  HTMLAttributes.swift
//
//
//  Created by Evan Anderson on 11/12/24.
//

import HTMLAttributes
import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

extension HTMLAttribute {
    public init?(
        context: some MacroExpansionContext,
        isUnchecked: Bool,
        key: String,
        arguments: LabeledExprListSyntax
    ) {
        guard let expression:ExprSyntax = arguments.first?.expression else { return nil }
        func string() -> String?        { expression.string(context: context, isUnchecked: isUnchecked, key: key) }
        func boolean() -> Bool?         { expression.boolean(context: context, key: key) }
        func enumeration<T : HTMLParsable>() -> T? { expression.enumeration(context: context, isUnchecked: isUnchecked, key: key, arguments: arguments) }
        func int() -> Int? { expression.int(context: context, key: key) }
        func array_string() -> [String]? { expression.array_string(context: context, isUnchecked: isUnchecked, key: key) }
        func array_enumeration<T: HTMLParsable>() -> [T]? { expression.array_enumeration(context: context, isUnchecked: isUnchecked, key: key, arguments: arguments) }
        switch key {
        case "accesskey":             self = .accesskey(string())
        case "ariaattribute":         self = .ariaattribute(enumeration())
        case "role":                  self = .role(enumeration())
        case "autocapitalize":        self = .autocapitalize(enumeration())
        case "autofocus":             self = .autofocus(boolean())
        case "class":                 self = .class(array_string())
        case "contenteditable":       self = .contenteditable(enumeration())
        case "data", "custom":
            guard let id:String = string(), let value:String = arguments.last?.expression.string(context: context, isUnchecked: isUnchecked, key: key) else {
                return nil
            }
            if key == "data" {
                self = .data(id, value)
            } else {
                self = .custom(id, value)
            }
        case "dir":                   self = .dir(enumeration())
        case "draggable":             self = .draggable(enumeration())
        case "enterkeyhint":          self = .enterkeyhint(enumeration())
        case "exportparts":           self = .exportparts(array_string())
        case "hidden":                self = .hidden(enumeration())
        case "id":                    self = .id(string())
        case "inert":                 self = .inert(boolean())
        case "inputmode":             self = .inputmode(enumeration())
        case "is":                    self = .is(string())
        case "itemid":                self = .itemid(string())
        case "itemprop":              self = .itemprop(string())
        case "itemref":               self = .itemref(string())
        case "itemscope":             self = .itemscope(boolean())
        case "itemtype":              self = .itemtype(string())
        case "lang":                  self = .lang(string())
        case "nonce":                 self = .nonce(string())
        case "part":                  self = .part(array_string())
        case "popover":               self = .popover(enumeration())
        case "slot":                  self = .slot(string())
        case "spellcheck":            self = .spellcheck(enumeration())

        #if canImport(CSS)
        case "style":                 self = .style(array_enumeration())
        #endif

        case "tabindex":              self = .tabindex(int())
        case "title":                 self = .title(string())
        case "translate":             self = .translate(enumeration())
        case "virtualkeyboardpolicy": self = .virtualkeyboardpolicy(enumeration())
        case "writingsuggestions":    self = .writingsuggestions(enumeration())
        case "trailingSlash":         self = .trailingSlash
        case "htmx":                  self = .htmx(enumeration())
        case "event":
            guard let event:HTMLEvent = enumeration(), let value:String = arguments.last?.expression.string(context: context, isUnchecked: isUnchecked, key: key) else {
                return nil
            }
            self = .event(event, value)
        default: return nil
        }
    }
}
