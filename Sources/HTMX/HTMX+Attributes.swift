
#if canImport(HTMLKitUtilities)
import HTMLKitUtilities
#endif

extension HTMXAttribute {
    // MARK: TrueOrFalse
    public enum TrueOrFalse: String, HTMLParsable {
        case `true`, `false`
    }

    // MARK: Event
    public enum Event: String, HTMLParsable {
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

        @inlinable
        var slug: String {
            switch self {
            case .afterOnLoad:           "after-on-load"
            case .afterProcessNode:      "after-process-node"
            case .afterRequest:          "after-request"
            case .afterSettle:           "after-settle"
            case .afterSwap:             "after-swap"
            case .beforeCleanupElement:  "before-cleanup-element"
            case .beforeOnLoad:          "before-on-load"
            case .beforeProcessNode:     "before-process-node"
            case .beforeRequest:         "before-request"
            case .beforeSend:            "before-send"
            case .beforeSwap:            "before-swap"
            case .beforeTransition:      "before-transition"
            case .configRequest:         "config-request"
            case .historyCacheError:     "history-cache-error"
            case .historyCacheMiss:      "history-cache-miss"
            case .historyCacheMissError: "history-cache-miss-error"
            case .historyCacheMissLoad:  "history-cache-miss-load"
            case .historyRestore:        "history-restore"
            case .beforeHistorySave:     "before-history-save"
            case .noSSESourceError:      "no-sse-source-error"
            case .onLoadError:           "on-load-error"
            case .oobAfterSwap:          "oob-after-swap"
            case .oobBeforeSwap:         "oob-before-swap"
            case .oobErrorNoTarget:      "oob-error-no-target"
            case .beforeHistoryUpdate:   "before-history-update"
            case .pushedIntoHistory:     "pushed-into-history"
            case .replacedInHistory:     "replaced-in-history"
            case .responseError:         "response-error"
            case .sendError:             "send-error"
            case .sseError:              "sse-error"
            case .sseOpen:               "sse-open"
            case .swapError:             "swap-error"
            case .targetError:           "target-error"
            case .validateURL:           "validate-url"
            case .validationValidate:    "validation:validate"
            case .validationFailed:      "validation:failed"
            case .validationHalted:      "validation:halted"
            case .xhrAbort:              "xhr:abort"
            case .xhrLoadEnd:            "xhr:loadend"
            case .xhrLoadStart:          "xhr:loadstart"
            case .xhrProgress:           "xhr:progress"
            default:                     rawValue
            }
        }

        @inlinable
        public var key: String {
            ":" + slug
        }
    }

    // MARK: Params
    public enum Params: HTMLInitializable {
        case all
        case none
        case not([String]?)
        case list([String]?)

        @inlinable
        public var key: String {
            switch self {
            case .all:  "all"
            case .none: "none"
            case .not:  "not"
            case .list: "list"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .all:             "*"
            case .none:            "none"
            case .not(let list):  "not " + (list?.joined(separator: ",") ?? "")
            case .list(let list): list?.joined(separator: ",")
            }
        }
    }

    // MARK: Swap
    public enum Swap: String, HTMLParsable {
        case innerHTML, outerHTML
        case textContent
        case beforebegin, afterbegin
        case beforeend, afterend
        case delete, none
    }

    // MARK: SyncStrategy
    public enum SyncStrategy: HTMLInitializable {
        case drop, abort, replace
        case queue(Queue?)

        public enum Queue: String, HTMLParsable {
            case first, last, all
        }

        @inlinable
        public var key: String {
            switch self {
            case .drop:    "drop"
            case .abort:   "abort"
            case .replace: "replace"
            case .queue:   "queue"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .drop:             "drop"
            case .abort:            "abort"
            case .replace:          "replace"
            case .queue(let queue): (queue != nil ? "queue " + queue!.rawValue : nil)
            }
        }
    }

    // MARK: URL
    public enum URL: HTMLParsable {
        case `true`, `false`
        case url(String)
        
        #if canImport(SwiftSyntax)
        public init?(context: HTMLExpansionContext) {
            switch context.key {
            case "true": self = .true
            case "false": self = .false
            case "url": self = .url(context.expression!.stringLiteral!.string(encoding: context.encoding))
            default: return nil
            }
        }
        #endif

        @inlinable
        public var key: String {
            switch self {
            case .true:  "true"
            case .false: "false"
            case .url:   "url"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .true: "true"
            case .false: "false"
            case .url(let url): url.hasPrefix("http://") || url.hasPrefix("https://") ? url : (url.first == "/" ? "" : "/") + url
            }
        }
    }
}

// MARK: Server Sent Events
extension HTMXAttribute {
    public enum ServerSentEvents: HTMLInitializable {
        case connect(String?)
        case swap(String?)
        case close(String?)

        @inlinable
        public var key: String {
            switch self {
            case .connect: "connect"
            case .swap:    "swap"
            case .close:   "close"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .connect(let value),
                .swap(let value),
                .close(let value):
                return value
            }
        }
    }
}

// MARK: WebSocket
extension HTMXAttribute {
    public enum WebSocket: HTMLInitializable {
        case connect(String?)
        case send(Bool?)

        @inlinable
        public var key: String {
            switch self {
            case .connect: "connect"
            case .send:    "send"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .connect(let value): value
            case .send(let value):      value ?? false ? "" : nil
            }
        }

        @inlinable
        public var htmlValueIsVoidable: Bool {
            switch self {
            case .send: true
            default:    false
            }
        }

        public enum Event: String {
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