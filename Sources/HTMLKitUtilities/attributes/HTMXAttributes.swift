//
//  HTMXAttributes.swift
//
//
//  Created by Evan Anderson on 11/19/24.
//

import SwiftSyntax
import SwiftSyntaxMacros

public extension HTMLElementAttribute.HTMX {
    // MARK: TrueOrFalse
    enum TrueOrFalse : String, HTMLInitializable {
        case `true`, `false`
    }

    // MARK: Event
    enum Event : String, HTMLInitializable {
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

    // MARK: Params
    enum Params : HTMLInitializable {
        case all
        case none
        case not([String]?)
        case list([String]?)

        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            let expression:ExprSyntax = arguments.first!.expression
            func array_string() -> [String]? { expression.array_string(context: context, key: key) }
            switch key {
                case "all":  self = .all
                case "none": self = .none
                case "not":  self = .not(array_string())
                case "list": self = .list(array_string())
                default: return nil
            }
        }

        public var key : String {
            switch self {
                case .all:     return "all"
                case .none:    return "none"
                case .not(_):  return "not"
                case .list(_): return "list"
            }
        }

        public func htmlValue(_ encoding: HTMLEncoding) -> String? {
            switch self {
                case .all:             return "*"
                case .none:            return "none"
                case .not(let list):  return "not " + (list?.joined(separator: ",") ?? "")
                case .list(let list): return list?.joined(separator: ",")
            }
        }

        public var htmlValueIsVoidable : Bool { false }
    }

    // MARK: Swap
    enum Swap : String, HTMLInitializable {
        case innerHTML, outerHTML
        case textContent
        case beforebegin, afterbegin
        case beforeend, afterend
        case delete, none
    }

    // MARK: Sync
    enum SyncStrategy : HTMLInitializable {
        case drop, abort, replace
        case queue(Queue?)

        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            switch key {
                case "drop":    self = .drop
                case "abort":   self = .abort
                case "replace": self = .replace
                case "queue":
                    let expression:ExprSyntax = arguments.first!.expression
                    func enumeration<T : HTMLInitializable>() -> T? { expression.enumeration(context: context, key: key, arguments: arguments) }
                    self = .queue(enumeration())
                default:        return nil
            }
        }

        public enum Queue : String, HTMLInitializable {
            case first, last, all
        }

        public var key : String {
            switch self {
                case .drop:     return "drop"
                case .abort:    return "abort"
                case .replace:  return "replace"
                case .queue(_): return "queue"
            }
        }

        public func htmlValue(_ encoding: HTMLEncoding) -> String? {
            switch self {
                case .drop:             return "drop"
                case .abort:            return "abort"
                case .replace:          return "replace"
                case .queue(let queue): return (queue != nil ? "queue " + queue!.rawValue : nil)
            }
        }

        public var htmlValueIsVoidable : Bool { false }
    }

    // MARK: URL
    enum URL : HTMLInitializable {
        case `true`, `false`
        case url(String)

        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            switch key {
                case "true": self = .true
                case "false": self = .false
                case "url": self = .url(arguments.first!.expression.stringLiteral!.string)
                default: return nil
            }
        }

        public var key : String {
            switch self {
                case .true:   return "true"
                case .false:  return "false"
                case .url(_): return "url"
            }
        }

        public func htmlValue(_ encoding: HTMLEncoding) -> String? {
            switch self {
                case .true: return "true"
                case .false: return "false"
                case .url(let url): return url.hasPrefix("http://") || url.hasPrefix("https://") ? url : (url.first == "/" ? "" : "/") + url
            }
        }

        public var htmlValueIsVoidable : Bool { false }
    }
}

// MARK: Server Sent Events
public extension HTMLElementAttribute.HTMX {
    enum ServerSentEvents : HTMLInitializable {
        case connect(String?)
        case swap(String?)
        case close(String?)

        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            func string() -> String?        { arguments.first!.expression.string(context: context, key: key) }
            switch key {
                case "connect": self = .connect(string())
                case "swap": self = .swap(string())
                case "close": self = .close(string())
                default: return nil
            }
        }

        public var key : String {
            switch self {
                case .connect(_): return "connect"
                case .swap(_): return "swap"
                case .close(_): return "close"
            }
        }

        public func htmlValue(_ encoding: HTMLEncoding) -> String? {
            switch self {
                case .connect(let value),
                        .swap(let value),
                        .close(let value):
                    return value
            }
        }

        public var htmlValueIsVoidable : Bool { false }
    }
}

// MARK: WebSocket
public extension HTMLElementAttribute.HTMX {
    enum WebSocket : HTMLInitializable {
        case connect(String?)
        case send(Bool?)

        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            let expression:ExprSyntax = arguments.first!.expression
            func string() -> String?        { expression.string(context: context, key: key) }
            func boolean() -> Bool?         { expression.boolean(context: context, key: key) }
            switch key {
                case "connect": self = .connect(string())
                case "send": self = .send(boolean())
                default: return nil
            }
        }

        public var key : String {
            switch self {
                case .connect(_): return "connect"
                case .send(_): return "send"
            }
        }

        public func htmlValue(_ encoding: HTMLEncoding) -> String? {
            switch self {
                case .connect(let value): return value
                case .send(let value): return value ?? false ? "" : nil
            }
        }

        public var htmlValueIsVoidable : Bool {
            switch self {
                case .send(_): return true
                default: return false
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