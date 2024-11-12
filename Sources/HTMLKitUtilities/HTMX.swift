//
//  HTMX.swift
//
//
//  Created by Evan Anderson on 11/12/24.
//

public extension HTMLElementAttribute {
    enum HTMX {
        case boost(TrueOrFalse)
        case confirm(String)
        case delete(String)
        case disable(Bool)
        case disabledElt(String)
        case disinherit(String)
        case encoding(String)
        case ext(String)
        case headers(js: Bool, [String:String])
        case history(TrueOrFalse)
        case historyElt(Bool)
        case include(String)
        case indicator(String)
        case inherit(String)
        case params(Params)
        case patch(String)
        case preserve(Bool)
        case prompt(String)
        case put(String)
        case replaceURL(URL)
        case request(js: Bool, timeout: Int = 0, credentials: Bool = false, noHeaders: Bool = false)
        case sync(String, strategy: SyncStrategy?)
        case validate(TrueOrFalse)

        case get(String)
        case post(String)
        case on(Event, String)
        case pushURL(URL)
        case select(String)
        case selectOOB(String)
        case swap(Swap)
        case swapOOB(String)
        case target(String)
        case trigger(String)
        case vals(String)

        public init?(rawValue: String) {
            guard rawValue.last == ")" else { return nil }
            let start:String.Index = rawValue.startIndex, end:String.Index = rawValue.index(before: rawValue.endIndex), end_minus_one:String.Index = rawValue.index(before: end)
            let key:Substring = rawValue.split(separator: "(")[0]
            func string() -> String {
                return String(rawValue[rawValue.index(start, offsetBy: key.count + 2)..<end_minus_one])
            }
            func boolean() -> Bool {
                return rawValue[rawValue.index(start, offsetBy: key.count + 1)..<end] == "true"
            }
            func enumeration<T : RawRepresentable>() -> T where T.RawValue == String {
                return T(rawValue: String(rawValue[rawValue.index(start, offsetBy: key.count + 2)..<end]))!
            }
            switch key {
                case "boost": self = .boost(enumeration())
                case "confirm": self = .confirm(string())
                case "delete": self = .delete(string())
                case "disable": self = .disable(boolean())
                case "disabledElt": self = .disabledElt(string())
                case "disinherit": self = .disinherit(string())
                case "encoding": self = .encoding(string())
                case "ext": self = .ext(string())
                //case "headers": self = .headers(js: Bool, [String : String])
                case "history": self = .history(enumeration())
                case "historyElt": self = .historyElt(boolean())
                case "include": self = .include(string())
                case "indicator": self = .indicator(string())
                case "inherit": self = .inherit(string())
                //case "params": self = .params(enumeration())
                case "patch": self = .patch(string())
                case "preserve": self = .preserve(boolean())
                case "prompt": self = .prompt(string())
                case "put": self = .put(string())
                //case "replaceURL": self = .replaceURL(enumeration())
                //case "request": self = .request(js: Bool, timeout: Int, credentials: Bool, noHeaders: Bool)
                //case "sync": self = .sync(String, strategy: SyncStrategy?)
                case "validate": self = .validate(enumeration())

                case "get": self = .get(string())
                case "post": self = .post(string())
                //case "on": self = .on(Event, String)
                //case "pushURL": self = .pushURL(enumeration())
                case "select": self = .select(string())
                case "selectOOB": self = .selectOOB(string())
                case "swap": self = .swap(enumeration())
                case "swapOOB": self = .swapOOB(string())
                case "target": self = .target(string())
                case "trigger": self = .trigger(string())
                case "vals": self = .vals(string())
                default: return nil
            }
        }

        public var htmlValue : String {
            switch self {
                case .boost(let value): return value.rawValue
                case .confirm(let value): return value
                case .delete(let value): return value
                case .disable(_): return ""
                case .disabledElt(let value): return value
                case .disinherit(let value): return value
                case .encoding(let value): return value
                case .ext(let value): return value
                case .headers(let js, let headers):
                    return js ? "" : headers.map({ "\"" + $0.key + "\":\"" + $0.value + "\"" }).joined(separator: ",")
                case .history(let value): return value.rawValue
                case .historyElt(_): return ""
                case .include(let value): return value
                case .indicator(let value): return value
                case .inherit(let value): return value
                case .params(let params): return params.htmlValue
                case .patch(let value): return value
                case .preserve(_): return ""
                case .prompt(let value): return value
                case .put(let value): return value
                case .replaceURL(let url): return url.htmlValue
                case .request(let js, let timeout, let credentials, let noHeaders):
                    return ""
                case .sync(let selector, let strategy):
                    return selector + (strategy == nil ? "" : ":" + strategy!.htmlValue)
                case .validate(let value): return value.rawValue
                
                case .get(let value):  return value
                case .post(let value): return value
                case .on(_, let value): return value
                case .pushURL(let url): return url.htmlValue
                case .select(let value): return value
                case .selectOOB(let value): return value
                case .swap(let swap): return swap.rawValue
                case .swapOOB(let value): return value
                case .target(let value): return value
                case .trigger(let value): return value
                case .vals(let value): return value
            }
        }
    }
}

// MARK: Attributes




public extension HTMLElementAttribute.HTMX {
    // MARK: Boost
    enum TrueOrFalse : String {
        case `true`, `false`
    }

    // MARK: Event
    enum Event : String {
        case abort
        case afterOnLoad
        case afterProcessNode
        case afterRequest
        case afterSettle
        case afterSwap
        case beforeCleanupElement
        case beforeOnLoad
        case beforeProcessNode
        case beforeRequest
        case beforeSwap
        case beforeSend
        case beforeTransition
        case configRequest
        case confirm
        case historyCacheError
        case historyCacheMiss
        case historyCacheMissError
        case historyCacheMissLoad
        case historyRestore
        case beforeHistorySave
        case load
        case noSSESourceError
        case onLoadError
        case oobAfterSwap
        case oobBeforeSwap
        case oobErrorNoTarget
        case prompt
        case pushedIntoHistory
        case responseError
        case sendError
        case sseError
        case sseOpen
        case swapError
        case targetError
        case timeout
        case validationValidate
        case validationFailed
        case validationHalted
        case xhrAbort
        case xhrLoadEnd
        case xhrLoadStart
        case xhrProgress

        public var htmlValue : String {
            switch self {
                case .validationValidate: return "validation:validate"
                case .validationFailed:   return "validation:failed"
                case .validationHalted:   return "validation:halted"
                case .xhrAbort:           return "xhr:abort"
                case .xhrLoadEnd:         return "xhr:loadend"
                case .xhrLoadStart:       return "xhr:loadstart"
                case .xhrProgress:        return "xhr:progress"
                default:                  return rawValue
            }
        }
    }

    // MARK: Modifiers
    enum Modifier {
    }

    // MARK: Params
    enum Params {
        case all
        case none
        case not([String])
        case list([String])

        public var htmlValue : String {
            switch self {
                case .all:             return "*"
                case .none:            return "none"
                case .not(let list):  return "not " + list.joined(separator: ",")
                case .list(let list): return list.joined(separator: ",")
            }
        }
    }

    // MARK: Swap
    enum Swap : String {
        case innerHTML, outerHTML
        case textContent
        case beforebegin, afterbegin
        case beforeend, afterend
        case delete, none
    }

    // MARK: Sync
    enum SyncStrategy {
        case drop, abort, replace
        case queue(Queue)

        public enum Queue : String {
            case first, last, all
        }

        public var htmlValue : String {
            switch self {
                case .drop:             return "drop"
                case .abort:            return "abort"
                case .replace:          return "replace"
                case .queue(let queue): return queue.rawValue
            }
        }
    }

    // MARK: URL
    enum URL {
        case `true`, `false`
        case url(String)

        public var htmlValue : String {
            switch self {
                case .true: return "true"
                case .false: return "false"
                case .url(let url): return url.hasPrefix("http://") || url.hasPrefix("https://") ? url : (url.first == "/" ? "" : "/") + url
            }
        }
    }
}