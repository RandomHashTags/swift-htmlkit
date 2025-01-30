//
//  HTMX.swift
//
//
//  Created by Evan Anderson on 11/12/24.
//

import HTMLKitUtilities
import HTMX
import SwiftSyntax
import SwiftSyntaxMacros

// MARK: init
extension HTMXAttribute : HTMLParsable {
    public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
        let expression:ExprSyntax = arguments.first!.expression
        func string() -> String?        { expression.string(context: context, isUnchecked: isUnchecked, key: key) }
        func boolean() -> Bool?         { expression.boolean(context: context, key: key) }
        func enumeration<T : HTMLParsable>() -> T? { expression.enumeration(context: context, isUnchecked: isUnchecked, key: key, arguments: arguments) }
        switch key {
        case "boost": self = .boost(enumeration())
        case "confirm": self = .confirm(string())
        case "delete": self = .delete(string())
        case "disable": self = .disable(boolean())
        case "disabledElt": self = .disabledElt(string())
        case "disinherit": self = .disinherit(string())
        case "encoding": self = .encoding(string())
        case "ext": self = .ext(string())
        case "headers": self = .headers(js: boolean() ?? false, arguments.last!.expression.dictionary_string_string(context: context, isUnchecked: isUnchecked, key: key))
        case "history": self = .history(enumeration())
        case "historyElt": self = .historyElt(boolean())
        case "include": self = .include(string())
        case "indicator": self = .indicator(string())
        case "inherit": self = .inherit(string())
        case "params": self = .params(enumeration())
        case "patch": self = .patch(string())
        case "preserve": self = .preserve(boolean())
        case "prompt": self = .prompt(string())
        case "put": self = .put(string())
        case "replaceURL": self = .replaceURL(enumeration())
        case "request":
            guard let js:Bool = boolean() else { return nil }
            let timeout:String? = arguments.get(1)?.expression.string(context: context, isUnchecked: isUnchecked, key: key)
            let credentials:String? = arguments.get(2)?.expression.string(context: context, isUnchecked: isUnchecked, key: key)
            let noHeaders:String? = arguments.get(3)?.expression.string(context: context, isUnchecked: isUnchecked, key: key)
            self = .request(js: js, timeout: timeout, credentials: credentials, noHeaders: noHeaders)
        case "sync":
            guard let s:String = string() else { return nil }
            self = .sync(s, strategy: arguments.last!.expression.enumeration(context: context, isUnchecked: isUnchecked, key: key, arguments: arguments))
        case "validate": self = .validate(enumeration())

        case "get": self = .get(string())
        case "post": self = .post(string())
        case "on", "onevent":
            guard let s:String = arguments.last!.expression.string(context: context, isUnchecked: isUnchecked, key: key) else { return nil }
            if key == "on" {
                self = .on(enumeration(), s)
            } else {
                self = .onevent(enumeration(), s)
            }
        case "pushURL": self = .pushURL(enumeration())
        case "select": self = .select(string())
        case "selectOOB": self = .selectOOB(string())
        case "swap": self = .swap(enumeration())
        case "swapOOB": self = .swapOOB(string())
        case "target": self = .target(string())
        case "trigger": self = .trigger(string())
        case "vals": self = .vals(string())

        case "sse": self = .sse(enumeration())
        case "ws": self = .ws(enumeration())
        default: return nil
        }
    }
}

// MARK: Params
extension HTMXAttribute.Params : HTMLParsable {
    public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
        let expression:ExprSyntax = arguments.first!.expression
        func array_string() -> [String]? { expression.array_string(context: context, isUnchecked: isUnchecked, key: key) }
        switch key {
        case "all":  self = .all
        case "none": self = .none
        case "not":  self = .not(array_string())
        case "list": self = .list(array_string())
        default: return nil
        }
    }
}

// MARK: SyncStrategy
extension HTMXAttribute.SyncStrategy : HTMLParsable {
    public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
        switch key {
        case "drop":    self = .drop
        case "abort":   self = .abort
        case "replace": self = .replace
        case "queue":
            let expression:ExprSyntax = arguments.first!.expression
            func enumeration<T : HTMLParsable>() -> T? { expression.enumeration(context: context, isUnchecked: isUnchecked, key: key, arguments: arguments) }
            self = .queue(enumeration())
        default:        return nil
        }
    }
}

// MARK: URL
extension HTMXAttribute.URL : HTMLParsable {
    public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
        switch key {
        case "true": self = .true
        case "false": self = .false
        case "url": self = .url(arguments.first!.expression.stringLiteral!.string)
        default: return nil
        }
    }
}

// MARK: Server Sent Events
extension HTMXAttribute.ServerSentEvents : HTMLParsable {
    public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
        func string() -> String?        { arguments.first!.expression.string(context: context, isUnchecked: isUnchecked, key: key) }
        switch key {
        case "connect": self = .connect(string())
        case "swap": self = .swap(string())
        case "close": self = .close(string())
        default: return nil
        }
    }
}

// MARK: WebSocket
extension HTMXAttribute.WebSocket : HTMLParsable {
    public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
        let expression:ExprSyntax = arguments.first!.expression
        func string() -> String?        { expression.string(context: context, isUnchecked: isUnchecked, key: key) }
        func boolean() -> Bool?         { expression.boolean(context: context, key: key) }
        switch key {
        case "connect": self = .connect(string())
        case "send": self = .send(boolean())
        default: return nil
        }
    }
}