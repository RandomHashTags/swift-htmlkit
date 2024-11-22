//
//  HTMX.swift
//
//
//  Created by Evan Anderson on 11/12/24.
//

import SwiftSyntax
import SwiftSyntaxMacros

public extension HTMLElementAttribute {
    enum HTMX : HTMLInitializable {
        case boost(TrueOrFalse?)
        case confirm(String?)
        case delete(String?)
        case disable(Bool?)
        case disabledElt(String?)
        case disinherit(String?)
        case encoding(String?)
        case ext(String?)
        case headers(js: Bool, [String:String])
        case history(TrueOrFalse?)
        case historyElt(Bool?)
        case include(String?)
        case indicator(String?)
        case inherit(String?)
        case params(Params?)
        case patch(String?)
        case preserve(Bool?)
        case prompt(String?)
        case put(String?)
        case replaceURL(URL?)
        case request(js: Bool, timeout: String?, credentials: String?, noHeaders: String?)
        case sync(String, strategy: SyncStrategy?)
        case validate(TrueOrFalse?)

        case get(String?)
        case post(String?)
        case on(Event?, String)
        case onevent(HTMLElementAttribute.Extra.event?, String)
        case pushURL(URL?)
        case select(String?)
        case selectOOB(String?)
        case swap(Swap?)
        case swapOOB(String?)
        case target(String?)
        case trigger(String?)
        case vals(String?)

        case sse(ServerSentEvents?)
        case ws(WebSocket?)

        // MARK: init
        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            let expression:ExprSyntax = arguments.first!.expression
            func string() -> String?        { expression.string(context: context, key: key) }
            func boolean() -> Bool?         { expression.boolean(context: context, key: key) }
            func enumeration<T : HTMLInitializable>() -> T? { expression.enumeration(context: context, key: key, arguments: arguments) }
            switch key {
                case "boost": self = .boost(enumeration())
                case "confirm": self = .confirm(string())
                case "delete": self = .delete(string())
                case "disable": self = .disable(boolean())
                case "disabledElt": self = .disabledElt(string())
                case "disinherit": self = .disinherit(string())
                case "encoding": self = .encoding(string())
                case "ext": self = .ext(string())
                case "headers": // TODO: fix
                    //let dictionary = expression.dictionary!
                    var js:Bool = false
                    var headers:[String:String] = [:]
                    self = .headers(js: js, headers)
                    break
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
                case "request": // TODO: fix
                    return nil
                    /*
                    let string:String = literal(), values:[Substring] = string.split(separator: ",")
                    var timeout_string:Substring = values[1][values[1].index(after: values[1].firstIndex(of: ":")!)...]
                    while timeout_string.first?.isWhitespace ?? false {
                        timeout_string.removeFirst()
                    }
                    let javascript:Bool = values[0].split(separator: ":")[1].hasSuffix("true")
                    let timeout:String?
                    if timeout_string.first == "\"" {
                        timeout_string.removeFirst()
                        timeout = String(timeout_string[timeout_string.startIndex..<timeout_string.index(before: timeout_string.endIndex)])
                    } else {
                        timeout = nil
                    }
                    var credentials:String? = nil
                    var credentials_string:Substring = values[2][values[2].index(after: values[2].firstIndex(of: ":")!)...]
                    if !credentials_string.hasSuffix("nil") {
                        while (credentials_string.first?.isWhitespace ?? false) || credentials_string.first == "\"" {
                            credentials_string.removeFirst()
                        }
                        credentials_string.removeLast()
                        credentials = String(credentials_string)
                    }
                    var noHeaders:String? = nil
                    if !string.hasSuffix("nil") {
                        var value:Substring = values[3][values[3].index(after: values[3].firstIndex(of: ":")!)...]
                        while (value.first?.isWhitespace ?? false) || value.first == "\"" {
                            value.removeFirst()
                        }
                        value.removeLast()
                        noHeaders = (javascript ? "js:" : "") + value
                    }
                    self = .request(js: javascript, timeout: timeout, credentials: credentials, noHeaders: noHeaders)
                    break*/
                case "sync": // TODO: fix
                    return nil
                    /*
                    let string:String = literal()
                    let values:[Substring] = string.split(separator: ",")
                    var key:Substring = values[0]
                    key.removeLast() // "
                    var strategy:SyncStrategy? = nil
                    var strategy_string:Substring = values[1].split(separator: ":")[1]
                    if !strategy_string.hasSuffix("nil") {
                        while (strategy_string.first?.isWhitespace ?? false) || strategy_string.first == "." {
                            strategy_string.removeFirst()
                        }
                        strategy = SyncStrategy(rawValue: String(strategy_string))
                    }
                    self = .sync(String(key), strategy: strategy)
                    break*/
                case "validate": self = .validate(enumeration())

                case "get": self = .get(string())
                case "post": self = .post(string())
                case "on", "onevent": // TODO: fix
                    return nil
                    /*
                    let string:String = literal()
                    let values:[Substring] = string.split(separator: ",")
                    let event_string:String = String(values[0])
                    var value:String = String(string[values[1].startIndex...])
                    while (value.first?.isWhitespace ?? false) || value.first == "\"" {
                        value.removeFirst()
                    }
                    value.removeLast()
                    if key == "on" {
                        let event:Event = Event(rawValue: event_string)!
                        self = .on(event, value)
                    } else {
                        let event:HTMLElementAttribute.Extra.event = .init(rawValue: event_string)!
                        self = .onevent(event, value)
                    }
                    break*/
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

        // MARK: key
        public var key : String {
            switch self {
                case .boost(_): return "boost"
                case .confirm(_): return "confirm"
                case .delete(_): return "delete"
                case .disable(_): return "disable"
                case .disabledElt(_): return "disabled-elt"
                case .disinherit(_): return "disinherit"
                case .encoding(_): return "encoding"
                case .ext(_): return "ext"
                case .headers(_, _): return "headers"
                case .history(_): return "history"
                case .historyElt(_): return "history-elt"
                case .include(_): return "include"
                case .indicator(_): return "indicator"
                case .inherit(_): return "inherit"
                case .params(_): return "params"
                case .patch(_): return "patch"
                case .preserve(_): return "preserve"
                case .prompt(_): return "prompt"
                case .put(_): return "put"
                case .replaceURL(_): return "replace-url"
                case .request(_, _, _, _): return "request"
                case .sync(_, _): return "sync"
                case .validate(_): return "validate"

                case .get(_): return "get"
                case .post(_): return "post"
                case .on(let event, _): return (event != nil ? "on:" + event!.key : "")
                case .onevent(let event, _): return (event != nil ? "on:" + event!.rawValue : "")
                case .pushURL(_): return "push-url"
                case .select(_): return "select"
                case .selectOOB(_): return "select-oob"
                case .swap(_): return "swap"
                case .swapOOB(_): return "swap-oob"
                case .target(_): return "target"
                case .trigger(_): return "trigger"
                case .vals(_): return "vals"

                case .sse(let event): return (event != nil ? "sse-" + event!.key : "")
                case .ws(let value): return (value != nil ? "ws-" + value!.key : "")
            }
        }

        //  MARK: htmlValue
        public var htmlValue : String? {
            switch self {
                case .boost(let value): return value?.rawValue
                case .confirm(let value): return value
                case .delete(let value): return value
                case .disable(let value): return value ?? false ? "" : nil
                case .disabledElt(let value): return value
                case .disinherit(let value): return value
                case .encoding(let value): return value
                case .ext(let value): return value
                case .headers(let js, let headers):
                    return (js ? "js:" : "") + "{" + headers.map({ "\\\"" + $0.key + "\\\":\\\"" + $0.value + "\\\"" }).joined(separator: ",") + "}"
                case .history(let value): return value?.rawValue
                case .historyElt(let value): return value ?? false ? "" : nil
                case .include(let value): return value
                case .indicator(let value): return value
                case .inherit(let value): return value
                case .params(let params): return params?.htmlValue
                case .patch(let value): return value
                case .preserve(let value): return value ?? false ? "" : nil
                case .prompt(let value): return value
                case .put(let value): return value
                case .replaceURL(let url): return url?.htmlValue
                case .request(let js, let timeout, let credentials, let noHeaders):
                    if let timeout:String = timeout {
                        return js ? "js: timeout:\(timeout)" : "{\\\"timeout\\\":\(timeout)}"
                    } else if let credentials:String = credentials {
                        return js ? "js: credentials:\(credentials)" : "{\\\"credentials\\\":\(credentials)}"
                    } else if let noHeaders:String = noHeaders {
                        return js ? "js: noHeaders:\(noHeaders)" : "{\\\"noHeaders\\\":\(noHeaders)}"
                    } else {
                        return ""
                    }
                case .sync(let selector, let strategy):
                    return selector + (strategy == nil ? "" : ":" + strategy!.htmlValue!)
                case .validate(let value): return value?.rawValue
                
                case .get(let value):  return value
                case .post(let value): return value
                case .on(_, let value): return value
                case .onevent(_, let value): return value
                case .pushURL(let url): return url?.htmlValue
                case .select(let value): return value
                case .selectOOB(let value): return value
                case .swap(let swap): return swap?.rawValue
                case .swapOOB(let value): return value
                case .target(let value): return value
                case .trigger(let value): return value
                case .vals(let value): return value

                case .sse(let value): return value?.htmlValue
                case .ws(let value): return value?.htmlValue
            }
        }
    }
}