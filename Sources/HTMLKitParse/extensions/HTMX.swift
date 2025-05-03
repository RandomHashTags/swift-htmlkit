//
//  HTMX.swift
//
//
//  Created by Evan Anderson on 11/12/24.
//

import HTMLKitUtilities
import HTMX

// MARK: init
extension HTMXAttribute: HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        func boolean() -> Bool? { context.boolean() }
        func enumeration<T: HTMLParsable>() -> T? { context.enumeration() }
        func string() -> String? { context.string() }
        switch context.key {
        case "boost": self = .boost(enumeration())
        case "confirm": self = .confirm(string())
        case "delete": self = .delete(string())
        case "disable": self = .disable(boolean())
        case "disabledElt": self = .disabledElt(string())
        case "disinherit": self = .disinherit(string())
        case "encoding": self = .encoding(string())
        case "ext": self = .ext(string())
        case "headers": self = .headers(js: boolean() ?? false, context.arguments.last!.expression.dictionaryStringString(context))
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
            guard let js = boolean() else { return nil }
            let timeout = context.arguments.getPositive(1)?.expression.string(context)
            let credentials = context.arguments.getPositive(2)?.expression.string(context)
            let noHeaders = context.arguments.getPositive(3)?.expression.string(context)
            self = .request(js: js, timeout: timeout, credentials: credentials, noHeaders: noHeaders)
        case "sync":
            guard let s = string() else { return nil }
            self = .sync(s, strategy: context.arguments.last!.expression.enumeration(context))
        case "validate": self = .validate(enumeration())

        case "get": self = .get(string())
        case "post": self = .post(string())
        case "on", "onevent":
            guard let s = context.arguments.last?.expression.string(context) else { return nil }
            if context.key == "on" {
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
extension HTMXAttribute.Params: HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        switch context.key {
        case "all":  self = .all
        case "none": self = .none
        case "not":  self = .not(context.arrayString())
        case "list": self = .list(context.arrayString())
        default: return nil
        }
    }
}

// MARK: SyncStrategy
extension HTMXAttribute.SyncStrategy: HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        switch context.key {
        case "drop":    self = .drop
        case "abort":   self = .abort
        case "replace": self = .replace
        case "queue":
            self = .queue(context.enumeration())
        default:        return nil
        }
    }
}

// MARK: Server Sent Events
extension HTMXAttribute.ServerSentEvents: HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        switch context.key {
        case "connect": self = .connect(context.string())
        case "swap": self = .swap(context.string())
        case "close": self = .close(context.string())
        default: return nil
        }
    }
}

// MARK: WebSocket
extension HTMXAttribute.WebSocket: HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        switch context.key {
        case "connect": self = .connect(context.string())
        case "send": self = .send(context.boolean())
        default: return nil
        }
    }
}