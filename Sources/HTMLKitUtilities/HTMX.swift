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
        case onevent(HTMLElementAttribute.Extra.event, String)
        case pushURL(URL)
        case select(String)
        case selectOOB(String)
        case swap(Swap)
        case swapOOB(String)
        case target(String)
        case trigger(String)
        case vals(String)

        case ws(WebSocket)

        public init?(rawValue: String) {
            guard rawValue.last == ")" else { return nil }
            let start:String.Index = rawValue.startIndex, end:String.Index = rawValue.index(before: rawValue.endIndex), end_minus_one:String.Index = rawValue.index(before: end)
            let key:Substring = rawValue.split(separator: "(")[0]
            func literal() -> String {
                return String(rawValue[rawValue.index(start, offsetBy: key.count + 2)..<end])
            }
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
                //case "headers": self = .headers(js: Bool, [String : String]) // TODO: fix
                case "history": self = .history(enumeration())
                case "historyElt": self = .historyElt(boolean())
                case "include": self = .include(string())
                case "indicator": self = .indicator(string())
                case "inherit": self = .inherit(string())
                case "params": self = .params(Params(rawValue: literal())!)
                case "patch": self = .patch(string())
                case "preserve": self = .preserve(boolean())
                case "prompt": self = .prompt(string())
                case "put": self = .put(string())
                case "replaceURL": self = .replaceURL(URL(rawValue: literal())!)
                //case "request": self = .request(js: Bool, timeout: Int, credentials: Bool, noHeaders: Bool) // TODO: fix
                //case "sync": self = .sync(String, strategy: SyncStrategy?) // TODO: fix
                case "validate": self = .validate(enumeration())

                case "get": self = .get(string())
                case "post": self = .post(string())
                case "on", "onevent":
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
                    break
                case "pushURL": self = .pushURL(URL(rawValue: string())!)
                case "select": self = .select(string())
                case "selectOOB": self = .selectOOB(string())
                case "swap": self = .swap(enumeration())
                case "swapOOB": self = .swapOOB(string())
                case "target": self = .target(string())
                case "trigger": self = .trigger(string())
                case "vals": self = .vals(string())

                case "ws": self = .ws(WebSocket(rawValue: literal())!)
                default: return nil
            }
        }

        public var key : String {
            switch self {
                case .boost(_): return "boost"
                case .confirm(_): return "confirm"
                case .delete(_): return "delete"
                case .disable(_): return "disable"
                case .disabledElt(_): return "disable-elt"
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
                case .on(let event, _): return "on:" + event.key
                case .onevent(let event, _): return "on:" + event.rawValue
                case .pushURL(_): return "push-url"
                case .select(_): return "select"
                case .selectOOB(_): return "select-oob"
                case .swap(_): return "swap"
                case .swapOOB(_): return "swap-oob"
                case .target(_): return "target"
                case .trigger(_): return "trigger"
                case .vals(_): return "vals"

                case .ws(let value): return "ws-" + value.key
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
                case .headers(let js, let headers): // TODO: fix
                    return js ? "" : "{" + headers.map({ "\\\"" + $0.key + "\\\":\\\"" + $0.value + "\\\"" }).joined(separator: ",") + "}"
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
                    return "" // TODO: fix
                case .sync(let selector, let strategy):
                    return selector + (strategy == nil ? "" : ":" + strategy!.htmlValue)
                case .validate(let value): return value.rawValue
                
                case .get(let value):  return value
                case .post(let value): return value
                case .on(_, let value): return value
                case .onevent(_, let value): return value
                case .pushURL(let url): return url.htmlValue
                case .select(let value): return value
                case .selectOOB(let value): return value
                case .swap(let swap): return swap.rawValue
                case .swapOOB(let value): return value
                case .target(let value): return value
                case .trigger(let value): return value
                case .vals(let value): return value

                case .ws(let value): return value.htmlValue
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
        case beforeSend
        case beforeSwap
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
        case beforeHistoryUpdate
        case pushedIntoHistory
        case replacedInHistory
        case responseError
        case sendError
        case sseError
        case sseOpen
        case swapError
        case targetError
        case timeout
        case trigger
        case validateURL
        case validationValidate
        case validationFailed
        case validationHalted
        case xhrAbort
        case xhrLoadEnd
        case xhrLoadStart
        case xhrProgress

        public var key : String {
            func slug() -> String {
                switch self {
                    case .afterOnLoad:           return "after-on-load"
                    case .afterProcessNode:      return "after-process-node"
                    case .afterRequest:          return "after-request"
                    case .afterSettle:           return "after-settle"
                    case .afterSwap:             return "after-swap"
                    case .beforeCleanupElement:  return "before-cleanup-element"
                    case .beforeOnLoad:          return "before-on-load"
                    case .beforeProcessNode:     return "before-process-node"
                    case .beforeRequest:         return "before-request"
                    case .beforeSend:            return "before-send"
                    case .beforeSwap:            return "before-swap"
                    case .beforeTransition:      return "before-transition"
                    case .configRequest:         return "config-request"
                    case .historyCacheError:     return "history-cache-error"
                    case .historyCacheMiss:      return "history-cache-miss"
                    case .historyCacheMissError: return "history-cache-miss-error"
                    case .historyCacheMissLoad:  return "history-cache-miss-load"
                    case .historyRestore:        return "history-restore"
                    case .beforeHistorySave:     return "before-history-save"
                    case .noSSESourceError:      return "no-sse-source-error"
                    case .onLoadError:           return "on-load-error"
                    case .oobAfterSwap:          return "oob-after-swap"
                    case .oobBeforeSwap:         return "oob-before-swap"
                    case .oobErrorNoTarget:      return "oob-error-no-target"
                    case .beforeHistoryUpdate:   return "before-history-update"
                    case .pushedIntoHistory:     return "pushed-into-history"
                    case .replacedInHistory:     return "replaced-in-history"
                    case .responseError:         return "response-error"
                    case .sendError:             return "send-error"
                    case .sseError:              return "sse-error"
                    case .sseOpen:               return "sse-open"
                    case .swapError:             return "swap-error"
                    case .targetError:           return "target-error"
                    case .validateURL:           return "validate-url"
                    case .validationValidate:    return "validation:validate"
                    case .validationFailed:      return "validation:failed"
                    case .validationHalted:      return "validation:halted"
                    case .xhrAbort:              return "xhr:abort"
                    case .xhrLoadEnd:            return "xhr:loadend"
                    case .xhrLoadStart:          return "xhr:loadstart"
                    case .xhrProgress:           return "xhr:progress"
                    default:                     return rawValue
                }
            }
            return ":" + slug()
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

        public init?(rawValue: String) {
            let key:Substring = rawValue.split(separator: "(")[0]
            func array_string() -> [String] {
                let string:String = String(rawValue[rawValue.index(rawValue.startIndex, offsetBy: key.count + 2)..<rawValue.index(before: rawValue.endIndex)])
                let ranges:[Range<String.Index>] = try! string.ranges(of: Regex("\"([^\"]+)\"")) // TODO: fix? (doesn't parse correctly if the string contains escaped quotation marks)
                return ranges.map({
                    let item:String = String(string[$0])
                    return String(item[item.index(after: item.startIndex)..<item.index(before: item.endIndex)])
                })
            }
            switch key {
                case "all":  self = .all
                case "none": self = .none
                case "not":  self = .not(array_string())
                case "list": self = .list(array_string())
                default: return nil
            }
        }

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

        public init?(rawValue: String) {
            let key:Substring = rawValue.split(separator: "(")[0]
            let end:String.Index = rawValue.index(before: rawValue.endIndex), end_minus_one:String.Index = rawValue.index(before: end)
            func string() -> String {
                return String(rawValue[rawValue.index(rawValue.startIndex, offsetBy: key.count + 2)..<end_minus_one])
            }
            switch key {
                case "true": self = .true
                case "false": self = .false
                case "url": self = .url(string())
                default: return nil
            }
        }

        public var htmlValue : String {
            switch self {
                case .true: return "true"
                case .false: return "false"
                case .url(let url): return url.hasPrefix("http://") || url.hasPrefix("https://") ? url : (url.first == "/" ? "" : "/") + url
            }
        }
    }
}

// MARK: WebSocket
public extension HTMLElementAttribute.HTMX {
    enum WebSocket {
        case connect(String)
        case send(String)

        public init?(rawValue: String) {
            guard rawValue.last == ")" else { return nil }
            let start:String.Index = rawValue.startIndex, end:String.Index = rawValue.index(before: rawValue.endIndex), end_minus_one:String.Index = rawValue.index(before: end)
            let key:Substring = rawValue.split(separator: "(")[0]
            func string() -> String {
                return String(rawValue[rawValue.index(start, offsetBy: key.count + 2)..<end_minus_one])
            }
            switch key {
                case "connect": self = .connect(string())
                case "send": self = .send(string())
                default: return nil
            }
        }

        public var key : String {
            switch self {
                case .connect(_): return "connect"
                case .send(_): return "send"
            }
        }

        public var htmlValue : String {
            switch self {
                case .connect(let value): return value
                case .send(let value): return value
            }
        }

        public enum Event : String {
            case wsConnecting
            case wsOpen
            case wsClose
            case wsError
            case wsBeforeMessage
            case wsAfterMessage
            case wsConfigSend
            case wsBeforeSend
            case wsAfterSend
        }
    }
}