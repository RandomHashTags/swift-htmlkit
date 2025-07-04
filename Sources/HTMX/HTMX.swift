
#if canImport(HTMLKitUtilities)
import HTMLKitUtilities
#endif

public enum HTMXAttribute: HTMLInitializable {
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
    case onevent(HTMLEvent?, String)
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

    // MARK: key
    @inlinable
    public var key: String {
        switch self {
        case .boost: "boost"
        case .confirm: "confirm"
        case .delete: "delete"
        case .disable: "disable"
        case .disabledElt: "disabled-elt"
        case .disinherit: "disinherit"
        case .encoding: "encoding"
        case .ext: "ext"
        case .headers: "headers"
        case .history: "history"
        case .historyElt: "history-elt"
        case .include: "include"
        case .indicator: "indicator"
        case .inherit: "inherit"
        case .params: "params"
        case .patch: "patch"
        case .preserve: "preserve"
        case .prompt: "prompt"
        case .put: "put"
        case .replaceURL: "replace-url"
        case .request: "request"
        case .sync: "sync"
        case .validate: "validate"

        case .get: "get"
        case .post: "post"
        case .on(let event, _): (event != nil ? "on:" + event!.key : "")
        case .onevent(let event, _): (event != nil ? "on:" + event!.rawValue : "")
        case .pushURL: "push-url"
        case .select: "select"
        case .selectOOB: "select-oob"
        case .swap: "swap"
        case .swapOOB: "swap-oob"
        case .target: "target"
        case .trigger: "trigger"
        case .vals: "vals"

        case .sse(let event): (event != nil ? "sse-" + event!.key : "")
        case .ws(let value): (value != nil ? "ws-" + value!.key : "")
        }
    }

    //  MARK: htmlValue
    @inlinable
    public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
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
            let delimiter = encoding.stringDelimiter(forMacro: forMacro)
            let value = headers.map({ item in
                delimiter + item.key + delimiter + ":" + delimiter + item.value + delimiter
            }).joined(separator: ",")
            return (js ? "js:" : "") + "{" + value + "}"
        case .history(let value): return value?.rawValue
        case .historyElt(let value): return value ?? false ? "" : nil
        case .include(let value): return value
        case .indicator(let value): return value
        case .inherit(let value): return value
        case .params(let params): return params?.htmlValue(encoding: encoding, forMacro: forMacro)
        case .patch(let value): return value
        case .preserve(let value): return value ?? false ? "" : nil
        case .prompt(let value): return value
        case .put(let value): return value
        case .replaceURL(let url): return url?.htmlValue(encoding: encoding, forMacro: forMacro)
        case .request(let js, let timeout, let credentials, let noHeaders):
            let delimiter = encoding.stringDelimiter(forMacro: forMacro)
            if let timeout = timeout {
                return js ? "js: timeout:\(timeout)" : "{" + delimiter + "timeout" + delimiter + ":\(timeout)}"
            } else if let credentials = credentials {
                return js ? "js: credentials:\(credentials)" : "{" + delimiter + "credentials" + delimiter + ":\(credentials)}"
            } else if let noHeaders = noHeaders {
                return js ? "js: noHeaders:\(noHeaders)" : "{" + delimiter + "noHeaders" + delimiter + ":\(noHeaders)}"
            } else {
                return ""
            }
        case .sync(let selector, let strategy):
            return selector + (strategy == nil ? "" : ":" + strategy!.htmlValue(encoding: encoding, forMacro: forMacro)!)
        case .validate(let value): return value?.rawValue
        
        case .get(let value):  return value
        case .post(let value): return value
        case .on(_, let value): return value
        case .onevent(_, let value): return value
        case .pushURL(let url): return url?.htmlValue(encoding: encoding, forMacro: forMacro)
        case .select(let value): return value
        case .selectOOB(let value): return value
        case .swap(let swap): return swap?.rawValue
        case .swapOOB(let value): return value
        case .target(let value): return value
        case .trigger(let value): return value
        case .vals(let value): return value

        case .sse(let value): return value?.htmlValue(encoding: encoding, forMacro: forMacro)
        case .ws(let value): return value?.htmlValue(encoding: encoding, forMacro: forMacro)
        }
    }

    @inlinable
    public var htmlValueIsVoidable: Bool {
        switch self {
        case .disable, .historyElt, .preserve:
            return true
        case .ws(let value):
            switch value {
            case .send: return true
            default: return false
            }
        default:
            return false
        }
    }
}