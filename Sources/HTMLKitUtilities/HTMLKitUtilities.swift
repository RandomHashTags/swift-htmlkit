//
//  HTMLKitUtilities.swift
//
//
//  Created by Evan Anderson on 9/19/24.
//

// MARK: Data Representation
/// Determines what value type the HTML is compiled to.
public enum HTMLDataRepresentation : String {
    // native Swift
    /// the raw compiled `StaticString`/`String`
    case string
    /// converts the compiled output to `[UInt8]` using utf8 encoding
    case uint8Array
    /// converts the compiled output to `[UInt16]` using utf16 encoding
    case uint16Array

    // Foundation
    #if canImport(Foundation)
    /// converts the compiled output to `Data` using utf8 encoding
    case data
    #endif

    // NIOCore
    #if canImport(NIOCore)
    /// converts the compiled output to `ByteBuffer` using utf8 encoding
    case byteBuffer
    #endif
}

// MARK: Escape HTML
public extension String {
    /// Escapes all occurrences of source-breaking HTML characters
    /// - Parameters:
    ///   - escapeAttributes: Whether or not to escape source-breaking HTML attribute characters
    /// - Returns: A new `String` escaping source-breaking HTML
    func escapingHTML(escapeAttributes: Bool) -> String {
        var string:String = self
        string.escapeHTML(escapeAttributes: escapeAttributes)
        return string
    }
    /// Escapes all occurrences of source-breaking HTML characters
    /// - Parameters:
    ///   - escapeAttributes: Whether or not to escape source-breaking HTML attribute characters
    mutating func escapeHTML(escapeAttributes: Bool) {
        self.replace("&", with: "&amp;")
        self.replace("<", with: "&lt;")
        self.replace(">", with: "&gt;")
        if escapeAttributes {
            self.escapeHTMLAttributes()
        }
    }
    /// Escapes all occurrences of source-breaking HTML attribute characters
    /// - Returns: A new `String` escaping source-breaking HTML attribute characters
    func escapingHTMLAttributes() -> String {
        var string:String = self
        string.escapeHTMLAttributes()
        return string
    }
    /// Escapes all occurrences of source-breaking HTML attribute characters
    mutating func escapeHTMLAttributes() {
        self.replace("\"", with: "&quot;")
        self.replace("'", with: "&#39")
    }
}

// MARK: CSSUnit
public extension HTMLElementAttribute {
    struct CSSUnit {
    }
}
public extension HTMLElementAttribute.CSSUnit { // https://www.w3schools.com/cssref/css_units.php
    // absolute
    static func centimeters(_ value: Float) -> Self { Self() }
    static func millimeters(_ value: Float) -> Self { Self() }
    /// 1 inch = 96px = 2.54cm
    static func inches(_ value: Float) -> Self      { Self() }
    /// 1 pixel = 1/96th of 1inch
    static func pixels(_ value: Float) -> Self      { Self() }
    /// 1 point = 1/72 of 1inch
    static func points(_ value: Float) -> Self      { Self() }
    /// 1 pica = 12 points
    static func picas(_ value: Float) -> Self       { Self() }
    
    // relative
    /// Relative to the font-size of the element (2em means 2 times the size of the current font)
    static func em(_ value: Float) -> Self             { Self() }
    /// Relative to the x-height of the current font (rarely used)
    static func ex(_ value: Float) -> Self             { Self() }
    /// Relative to the width of the "0" (zero)
    static func ch(_ value: Float) -> Self             { Self() }
    /// Relative to font-size of the root element
    static func rem(_ value: Float) -> Self            { Self() }
    /// Relative to 1% of the width of the viewport
    static func viewportWidth(_ value: Float) -> Self  { Self() }
    /// Relative to 1% of the height of the viewport
    static func viewportHeight(_ value: Float) -> Self { Self() }
    /// Relative to 1% of viewport's smaller dimension
    static func viewportMin(_ value: Float) -> Self    { Self() }
    /// Relative to 1% of viewport's larger dimension
    static func viewportMax(_ value: Float) -> Self    { Self() }
    /// Relative to the parent element
    static func percent(_ value: Float) -> Self        { Self() }
}

// MARK: HTMLElement Attributes
public enum HTMLElementAttribute {
    case accesskey((any ExpressibleByStringLiteral)? = nil)
    case autocapitalize(Extra.autocapitalize? = nil)
    case autofocus(Bool = false)
    case `class`([any ExpressibleByStringLiteral] = [])
    case contenteditable(Extra.contenteditable? = nil)
    case data(_ id: any ExpressibleByStringLiteral, _ value: (any ExpressibleByStringLiteral)? = nil)
    case dir(Extra.dir? = nil)
    case draggable(Extra.draggable? = nil)
    case enterkeyhint(Extra.enterkeyhint? = nil)
    case exportparts([any ExpressibleByStringLiteral] = [])
    case hidden(Extra.hidden? = nil)
    case id((any ExpressibleByStringLiteral)? = nil)
    case inert(Bool = false)
    case inputmode(Extra.inputmode? = nil)
    case `is`((any ExpressibleByStringLiteral)? = nil)
    case itemid((any ExpressibleByStringLiteral)? = nil)
    case itemprop((any ExpressibleByStringLiteral)? = nil)
    case itemref((any ExpressibleByStringLiteral)? = nil)
    case itemscope(Bool = false)
    case itemtype((any ExpressibleByStringLiteral)? = nil)
    case lang((any ExpressibleByStringLiteral)? = nil)
    case nonce((any ExpressibleByStringLiteral)? = nil)
    case part([(any ExpressibleByStringLiteral)] = [])
    case popover(Extra.popover? = nil)
    case role(Extra.role? = nil)
    case slot((any ExpressibleByStringLiteral)? = nil)
    case spellcheck(Extra.spellcheck? = nil)
    case style((any ExpressibleByStringLiteral)? = nil)
    case tabindex(Int? = nil)
    case title((any ExpressibleByStringLiteral)? = nil)
    case translate(Extra.translate? = nil)
    case virtualkeyboardpolicy(Extra.virtualkeyboardpolicy? = nil)
    case writingsuggestions(Extra.writingsuggestions? = nil)

    case custom(_ id: any ExpressibleByStringLiteral, _ value: (any ExpressibleByStringLiteral)?)

    @available(*, deprecated, message: "General consensus considers this \"bad practice\" and you shouldn't mix your HTML and JavaScript. This will never be removed and remains deprecated to encourage use of other techniques. Learn more at https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Building_blocks/Events#inline_event_handlers_—_dont_use_these.")
    case event(Extra.event, _ value: (any ExpressibleByStringLiteral)? = nil)
}
public extension HTMLElementAttribute {
    enum Extra {
    }
}
public extension HTMLElementAttribute.Extra {
    typealias height = HTMLElementAttribute.CSSUnit
    typealias width = HTMLElementAttribute.CSSUnit

    enum `as` : String {
        case audio, document, embed, fetch, font, image, object, script, style, track, video, worker
    }

    enum autocapitalize : String {
        case on, off
        case none
        case sentences, words, characters
    }

    enum autocomplete : String {
        case off, on
    }

    enum blocking : String {
        case render
    }

    enum buttontype : String {
        case submit, reset, button
    }

    enum capture : String {
        case user, environment
    }

    enum contenteditable : String {
        case `true`, `false`
        case plaintextOnly

        public var htmlValue : String {
            switch self {
                case .plaintextOnly: return "plaintext-only"
                default:             return rawValue
            }
        }
    }

    enum controlslist : String {
        case nodownload, nofullscreen, noremoteplayback
    }

    enum crossorigin : String {
        case anonymous
        case useCredentials

        public var htmlValue : String {
            switch self {
                case .useCredentials: return "use-credentials"
                default:              return rawValue
            }
        }
    }

    enum decoding : String {
        case sync, async, auto
    }

    enum dir : String {
        case auto, ltr, rtl
    }

    enum dirname : String {
        case ltr, rtl
    }

    enum draggable : String {
        case `true`, `false`
    }

    enum download : String {
        case filename
    }

    enum enterkeyhint : String {
        case enter, done, go, next, previous, search, send
    }

    enum event : String {
        case accept, afterprint, animationend, animationiteration, animationstart
        case beforeprint, beforeunload, blur
        case canplay, canplaythrough, change, click, contextmenu, copy, cut
        case dblclick, drag, dragend, dragenter, dragleave, dragover, dragstart, drop, durationchange
        case ended, error
        case focus, focusin, focusout, fullscreenchange, fullscreenerror
        case hashchange
        case input, invalid
        case keydown, keypress, keyup
        case languagechange, load, loadeddata, loadedmetadata, loadstart
        case message, mousedown, mouseenter, mouseleave, mousemove, mouseover, mouseout, mouseup
        case offline, online, open
        case pagehide, pageshow, paste, pause, play, playing, popstate, progress
        case ratechange, resize, reset
        case scroll, search, seeked, seeking, select, show, stalled, storage, submit, suspend
        case timeupdate, toggle, touchcancel, touchend, touchmove, touchstart, transitionend
        case unload
        case volumechange
        case waiting, wheel
    }

    enum fetchpriority : String {
        case high, low, auto
    }

    enum formenctype : String {
        case applicationXWWWFormURLEncoded
        case multipartFormData
        case textPlain

        public var htmlValue : String {
            switch self {
                case .applicationXWWWFormURLEncoded: return "application/x-www-form-urlencoded"
                case .multipartFormData:             return "multipart/form-data"
                case .textPlain:                     return "text/plain"
            }
        }
    }

    enum formmethod : String {
        case get, post, dialog
    }

    enum formtarget : String {
        case _self, _blank, _parent, _top
    }

    enum hidden : String {
        case `true`
        case untilFound

        public var htmlValue : String {
            switch self {
                case .true: return ""
                case .untilFound: return "until-found"
            }
        }
    }

    enum httpequiv : String {
        case contentSecurityPolicy
        case contentType
        case defaultStyle
        case xUACompatible
        case refresh

        public var htmlValue : String {
            switch self {
                case .contentSecurityPolicy: return "content-security-policy"
                case .contentType:           return "content-type"
                case .defaultStyle:          return "default-style"
                case .xUACompatible:         return "x-ua-compatible"
                default:                     return rawValue
            }
        }
    }

    enum inputmode : String {
        case none, text, decimal, numeric, tel, search, email, url
    }
    
    enum inputtype : String {
        case button, checkbox, color, date
        case datetimeLocal
        case email, file, hidden, image, month, number, password, radio, range, reset, search, submit, tel, text, time, url, week

        public var htmlValue : String {
            switch self {
                case .datetimeLocal: return "datetime-local"
                default: return rawValue
            }
        }
    }

    enum loading : String {
        case eager, lazy
    }

    enum numberingtype : String {
        case a, A, i, I, one

        public var htmlValue : String {
            switch self {
                case .one: return "1"
                default:   return rawValue
            }
        }
    }

    enum popover : String {
        case auto, manual
    }
    enum popovertargetaction : String {
        case hide, show, toggle
    }

    enum preload : String {
        case none, metadata, auto
    }

    enum referrerpolicy : String {
        case noReferrer
        case noReferrerWhenDowngrade
        case origin
        case originWhenCrossOrigin
        case sameOrigin
        case strictOrigin
        case strictOriginWhenCrossOrigin
        case unsafeURL

        public var htmlValue : String {
            switch self {
                case .noReferrer:                  return "no-referrer"
                case .noReferrerWhenDowngrade:     return "no-referrer-when-downgrade"
                case .originWhenCrossOrigin:       return "origin-when-cross-origin"
                case .strictOrigin:                return "strict-origin"
                case .strictOriginWhenCrossOrigin: return "strict-origin-when-cross-origin"
                case .unsafeURL:                   return "unsafe-url"
                default:                           return rawValue
            }
        }
    }

    /// [The first rule](https://www.w3.org/TR/using-aria/#rule1) of ARIA use is "If you can use a native HTML element or attribute with the semantics and behavior you require already built in, instead of re-purposing an element and adding an ARIA role, state or property to make it accessible, then do so."
    /// 
    /// - Note: There is a saying "No ARIA is better than bad ARIA." In [WebAim's survey of over one million home pages](https://webaim.org/projects/million/#aria), they found that Home pages with ARIA present averaged 41% more detected errors than those without ARIA. While ARIA is designed to make web pages more accessible, if used incorrectly, it can do more harm than good.
    /// 
    /// Like any other web technology, there are varying degrees of support for ARIA. Support is based on the operating system and browser being used, as well as the kind of assistive technology interfacing with it. In addition, the version of the operating system, browser, and assistive technology are contributing factors. Older software versions may not support certain ARIA roles, have only partial support, or misreport its functionality.
    ///
    /// It is also important to acknowledge that some people who rely on assistive technology are reluctant to upgrade their software, for fear of losing the ability to interact with their computer and browser. Because of this, it is important to use semantic HTML elements whenever possible, as semantic HTML has far better support for assistive technology.
    /// 
    /// It is also important to test your authored ARIA with actual assistive technology. This is because browser emulators and simulators are not really effective for testing full support. Similarly, proxy assistive technology solutions are not sufficient to fully guarantee functionality.
    ///
    /// Learn more at https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA .
    enum role : String {
        case alert
        case alertdialog
        case associationlist
        case associationlistitemkey
        case associationlistitemvalue

        case banner
        case blockquote

        case caption
        case code
        case combobox
        case comment
        case complementary
        case contentinfo

        case deletion
        case dialog

        case emphasis

        case feed
        case form

        case generic

        case insertion

        case log

        case main
        case mark
        case marquee
        case math
        case menu
        case menubar

        case navigation
        case none
        case note
        
        case paragraph
        case presentation

        case region

        case scrollbar
        case search
        case searchbox
        case sectionhead
        case separator
        case slider
        case spinbutton
        case status
        case strong
        case `subscript`
        case superscript
        case suggestion
        case `switch`

        case tab
        case tablist
        case tabpanel
        case time
        case timer
        case toolbar
        case tooltip
        case tree
        case treegrid
        case treeitem
    }

    enum sandbox : String {
        case allowDownloads
        case allowForms
        case allowModals
        case allowOrientationLock
        case allowPointerLock
        case allowPopups
        case allowPopupsToEscapeSandbox
        case allowPresentation
        case allowSameOrigin
        case allowScripts
        case allowStorageAccessByUserActiviation
        case allowTopNavigation
        case allowTopNavigationByUserActivation
        case allowTopNavigationToCustomProtocols

        public var htmlValue : String {
            switch self {
                case .allowDownloads:                      return "allow-downloads"
                case .allowForms:                          return "allow-forms"
                case .allowModals:                         return "allow-modals"
                case .allowOrientationLock:                return "allow-orientation-lock"
                case .allowPointerLock:                    return "allow-pointer-lock"
                case .allowPopups:                         return "allow-popups"
                case .allowPopupsToEscapeSandbox:          return "allow-popups-to-escape-sandbox"
                case .allowPresentation:                   return "allow-presentation"
                case .allowSameOrigin:                     return "allow-same-origin"
                case .allowScripts:                        return "allow-scripts"
                case .allowStorageAccessByUserActiviation: return "allow-storage-access-by-user-activation"
                case .allowTopNavigation:                  return "allow-top-navigation"
                case .allowTopNavigationByUserActivation:  return "allow-top-navigation-by-user-activation"
                case .allowTopNavigationToCustomProtocols: return "allow-top-navigation-to-custom-protocols"
            }
        }
    }

    enum scripttype : String {
        case importmap, module, speculationrules
    }

    enum scope : String {
        case row, col, rowgroup, colgroup
    }

    enum shadowrootmode : String {
        case open, closed
    }
    enum shadowrootclonable : String {
        case `true`, `false`
    }

    enum shape : String {
        case rect, circle, poly, `default`
    }

    enum spellcheck : String {
        case `true`, `false`
    }

    enum target : String {
        case _self, _blank, _parent, _top, _unfencedTop
    }

    enum kind : String {
        case subtitles, captions, chapters, metadata
    }

    enum translate : String {
        case yes, no
    }

    enum virtualkeyboardpolicy : String {
        case auto, manual
    }

    enum wrap : String {
        case hard, soft
    }

    enum writingsuggestions : String {
        case `true`, `false`
    }
}
