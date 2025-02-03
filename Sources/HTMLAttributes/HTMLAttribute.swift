//
//  HTMLAttribute.swift
//
//
//  Created by Evan Anderson on 11/19/24.
//

#if canImport(CSS)
import CSS
#endif

#if canImport(HTMLKitUtilities)
import HTMLKitUtilities
#endif

#if canImport(HTMX)
import HTMX
#endif

#if canImport(SwiftSyntax)
import SwiftSyntax
import SwiftSyntaxMacros
#endif

// MARK: HTMLAttribute
public enum HTMLAttribute : HTMLInitializable {
    case accesskey(String? = nil)

    case ariaattribute(Extra.ariaattribute? = nil)
    case role(Extra.ariarole? = nil)

    case autocapitalize(Extra.autocapitalize? = nil)
    case autofocus(Bool? = false)
    case `class`([String]? = nil)
    case contenteditable(Extra.contenteditable? = nil)
    case data(_ id: String, _ value: String? = nil)
    case dir(Extra.dir? = nil)
    case draggable(Extra.draggable? = nil)
    case enterkeyhint(Extra.enterkeyhint? = nil)
    case exportparts([String]? = nil)
    case hidden(Extra.hidden? = nil)
    case id(String? = nil)
    case inert(Bool? = false)
    case inputmode(Extra.inputmode? = nil)
    case `is`(String? = nil)
    case itemid(String? = nil)
    case itemprop(String? = nil)
    case itemref(String? = nil)
    case itemscope(Bool? = false)
    case itemtype(String? = nil)
    case lang(String? = nil)
    case nonce(String? = nil)
    case part([String]? = nil)
    case popover(Extra.popover? = nil)
    case slot(String? = nil)
    case spellcheck(Extra.spellcheck? = nil)

    #if canImport(CSS)
    case style([CSSStyle]? = nil)
    #endif

    case tabindex(Int? = nil)
    case title(String? = nil)
    case translate(Extra.translate? = nil)
    case virtualkeyboardpolicy(Extra.virtualkeyboardpolicy? = nil)
    case writingsuggestions(Extra.writingsuggestions? = nil)

    /// This attribute adds a space and forward slash character (" /") before closing a void element tag, and does nothing to a non-void element.
    /// 
    /// Usually only used to support foreign content.
    case trailingSlash

    #if canImport(HTMX)
    case htmx(_ attribute: HTMXAttribute? = nil)
    #endif

    case custom(_ id: String, _ value: String?)

    @available(*, deprecated, message: "General consensus considers this \"bad practice\" and you shouldn't mix your HTML and JavaScript. This will never be removed and remains deprecated to encourage use of other techniques. Learn more at https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Building_blocks/Events#inline_event_handlers_—_dont_use_these.")
    case event(HTMLEvent, _ value: String? = nil)

    // MARK: key
    @inlinable
    public var key : String {
        switch self {
        case .accesskey:             return "accesskey"
        case .ariaattribute(let value):
            guard let value:HTMLAttribute.Extra.ariaattribute = value else { return "" }
            return "aria-" + value.key
        case .role:                  return "role"
        case .autocapitalize:        return "autocapitalize"
        case .autofocus:             return "autofocus"
        case .class:                 return "class"
        case .contenteditable:       return "contenteditable"
        case .data(let id, _):          return "data-" + id
        case .dir:                   return "dir"
        case .draggable:             return "draggable"
        case .enterkeyhint:          return "enterkeyhint"
        case .exportparts:           return "exportparts"
        case .hidden:                return "hidden"
        case .id:                    return "id"
        case .inert:                 return "inert"
        case .inputmode:             return "inputmode"
        case .is:                    return "is"
        case .itemid:                return "itemid"
        case .itemprop:              return "itemprop"
        case .itemref:               return "itemref"
        case .itemscope:             return "itemscope"
        case .itemtype:              return "itemtype"
        case .lang:                  return "lang"
        case .nonce:                 return "nonce"
        case .part:                  return "part"
        case .popover:               return "popover"
        case .slot:                  return "slot"
        case .spellcheck:            return "spellcheck"

        #if canImport(CSS)
        case .style:                 return "style"
        #endif

        case .tabindex:              return "tabindex"
        case .title:                 return "title"
        case .translate:             return "translate"
        case .virtualkeyboardpolicy: return "virtualkeyboardpolicy"
        case .writingsuggestions:    return "writingsuggestions"

        case .trailingSlash:            return ""

        #if canImport(HTMX)
        case .htmx(let htmx):
            switch htmx {
            case .ws(let value):
                return (value != nil ? "ws-" + value!.key : "")
            case .sse(let value):
                return (value != nil ? "sse-" + value!.key : "")
            default:
                return (htmx != nil ? "hx-" + htmx!.key : "")
            }
        #endif

        case .custom(let id, _):        return id
        case .event(let event, _):      return "on" + event.rawValue
        }
    }

    // MARK: htmlValue
    @inlinable
    public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
        switch self {
        case .accesskey(let value):             return value
        case .ariaattribute(let value):         return value?.htmlValue(encoding: encoding, forMacro: forMacro)
        case .role(let value):                  return value?.rawValue
        case .autocapitalize(let value):        return value?.rawValue
        case .autofocus(let value):             return value == true ? "" : nil
        case .class(let value):                 return value?.joined(separator: " ")
        case .contenteditable(let value):       return value?.htmlValue(encoding: encoding, forMacro: forMacro)
        case .data(_, let value):               return value
        case .dir(let value):                   return value?.rawValue
        case .draggable(let value):             return value?.rawValue
        case .enterkeyhint(let value):          return value?.rawValue
        case .exportparts(let value):           return value?.joined(separator: ",")
        case .hidden(let value):                return value?.htmlValue(encoding: encoding, forMacro: forMacro)
        case .id(let value):                    return value
        case .inert(let value):                 return value == true ? "" : nil
        case .inputmode(let value):             return value?.rawValue
        case .is(let value):                    return value
        case .itemid(let value):                return value
        case .itemprop(let value):              return value
        case .itemref(let value):               return value
        case .itemscope(let value):             return value == true ? "" : nil
        case .itemtype(let value):              return value
        case .lang(let value):                  return value
        case .nonce(let value):                 return value
        case .part(let value):                  return value?.joined(separator: " ")
        case .popover(let value):               return value?.rawValue
        case .slot(let value):                  return value
        case .spellcheck(let value):            return value?.rawValue

        #if canImport(CSS)
        case .style(let value):                 return value?.compactMap({ $0.htmlValue(encoding: encoding, forMacro: forMacro) }).joined(separator: ";")
        #endif
        
        case .tabindex(let value):              return value?.description
        case .title(let value):                 return value
        case .translate(let value):             return value?.rawValue
        case .virtualkeyboardpolicy(let value): return value?.rawValue
        case .writingsuggestions(let value):    return value?.rawValue

        case .trailingSlash:                    return nil

        #if canImport(HTMX)
        case .htmx(let htmx):                   return htmx?.htmlValue(encoding: encoding, forMacro: forMacro)
        #endif

        case .custom(_, let value):             return value
        case .event(_, let value):              return value
        }
    }

    // MARK: htmlValueIsVoidable
    @inlinable
    public var htmlValueIsVoidable : Bool {
        switch self {
        case .autofocus, .hidden, .inert, .itemscope:
            return true
            
        #if canImport(HTMX)
        case .htmx(let value):
            return value?.htmlValueIsVoidable ?? false
        #endif

        default:
            return false
        }
    }

    // MARK: htmlValueDelimiter
    @inlinable
    public func htmlValueDelimiter(encoding: HTMLEncoding, forMacro: Bool) -> String {
        switch self {

        #if canImport(HTMX)
        case .htmx(let v):
            switch v {
            case .request(_, _, _, _), .headers(_, _): return "'"
            default: return encoding.stringDelimiter(forMacro: forMacro)
            }
        #endif

        default: return encoding.stringDelimiter(forMacro: forMacro)
        }
    }
}

// MARK: ElementData
extension HTMLKitUtilities {
    public struct ElementData {
        public let encoding:HTMLEncoding
        public let globalAttributes:[HTMLAttribute]
        public let attributes:[String:Any]
        public let innerHTML:[CustomStringConvertible]
        public let trailingSlash:Bool

        package init(
            _ encoding: HTMLEncoding,
            _ globalAttributes: [HTMLAttribute],
            _ attributes: [String:Any],
            _ innerHTML: [CustomStringConvertible],
            _ trailingSlash: Bool
        ) {
            self.encoding = encoding
            self.globalAttributes = globalAttributes
            self.attributes = attributes
            self.innerHTML = innerHTML
            self.trailingSlash = trailingSlash
        }
    }
}