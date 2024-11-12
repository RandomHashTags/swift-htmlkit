//
//  HTMLKitUtilities.swift
//
//
//  Created by Evan Anderson on 9/19/24.
//

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

    case ariaattribute(Extra.ariaattribute? = nil)
    case role(Extra.ariarole? = nil)

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
    case slot((any ExpressibleByStringLiteral)? = nil)
    case spellcheck(Extra.spellcheck? = nil)
    case style((any ExpressibleByStringLiteral)? = nil)
    case tabindex(Int? = nil)
    case title((any ExpressibleByStringLiteral)? = nil)
    case translate(Extra.translate? = nil)
    case virtualkeyboardpolicy(Extra.virtualkeyboardpolicy? = nil)
    case writingsuggestions(Extra.writingsuggestions? = nil)

    /// This attribute adds a space and slash (" /") character before closing a void element tag.
    ///
    /// Usually only used if certain browsers need it for compatibility.
    case trailingSlash

    case htmx(_ attribute: HTMLElementAttribute.HTMX)

    case custom(_ id: any ExpressibleByStringLiteral, _ value: (any ExpressibleByStringLiteral)?)

    @available(*, deprecated, message: "General consensus considers this \"bad practice\" and you shouldn't mix your HTML and JavaScript. This will never be removed and remains deprecated to encourage use of other techniques. Learn more at https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Building_blocks/Events#inline_event_handlers_—_dont_use_these.")
    case event(Extra.event, _ value: (any ExpressibleByStringLiteral)? = nil)
}
// MARK: Extra attributes 
public extension HTMLElementAttribute {
    enum Extra {
    }
}
public extension HTMLElementAttribute.Extra {
    typealias height = HTMLElementAttribute.CSSUnit
    typealias width = HTMLElementAttribute.CSSUnit

    // MARK: aria attributes (states and properties)
    // https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes
    enum ariaattribute {
        case activedescendant(String)
        case atomic(Bool)
        case autocomplete(Autocomplete)

        case braillelabel(String)
        case brailleroledescription(String)
        case busy(Bool)
        
        case checked(Checked)
        case colcount(Int)
        case colindex(Int)
        case colindextext(String)
        case colspan(Int)
        case controls([String])
        case current(Current)

        case describedby([String])
        case description(String)
        case details([String])
        case disabled(Bool)
        case dropeffect(DropEffect)

        case errormessage(String)
        case expanded(Expanded)
        
        case flowto([String])
        
        case grabbed(Grabbed)

        case haspopup(HasPopup)
        case hidden(Hidden)

        case invalid(Invalid)

        case keyshortcuts(String)

        case label(String)
        case labelledby([String])
        case level(Int)
        case live(Live)

        case modal(Bool)
        case multiline(Bool)
        case multiselectable(Bool)

        case orientation(Orientation)
        case owns([String])

        case placeholder(String)
        case posinset(Int)
        case pressed(Pressed)

        case readonly(Bool)

        case relevant(Relevant)
        case required(Bool)
        case roledescription(String)
        case rowcount(Int)
        case rowindex(Int)
        case rowindextext(String)
        case rowspan(Int)

        case selected(Selected)
        case setsize(Int)
        case sort(Sort)

        case valuemax(Float)
        case valuemin(Float)
        case valuenow(Float)
        case valuetext(String)

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
            func int() -> Int {
                return Int(rawValue[rawValue.index(start, offsetBy: key.count + 1)..<end])!
            }
            func array_string() -> [String] {
                let string:String = string()
                let ranges:[Range<String.Index>] = try! string.ranges(of: Regex("\"([^\"]+)\"")) // TODO: fix? (doesn't parse correctly if the string contains escaped quotation marks)
                return ranges.map({
                    let item:String = String(string[$0])
                    return String(item[item.index(after: item.startIndex)..<item.index(before: item.endIndex)])
                })
            }
            func float() -> Float {
                return Float(rawValue[rawValue.index(start, offsetBy: key.count + 1)..<end])!
            }
            switch key {
                case "activedescendant":       self = .activedescendant(string())
                case "atomic":                 self = .atomic(boolean())
                case "autocomplete":           self = .autocomplete(enumeration())
                case "braillelabel":           self = .braillelabel(string())
                case "brailleroledescription": self = .brailleroledescription(string())
                case "busy":                   self = .busy(boolean())
                case "checked":                self = .checked(enumeration())
                case "colcount":               self = .colcount(int())
                case "colindex":               self = .colindex(int())
                case "colindextext":           self = .colindextext(string())
                case "colspan":                self = .colspan(int())
                case "controls":               self = .controls(array_string())
                case "current":                self = .current(enumeration())
                case "describedby":            self = .describedby(array_string())
                case "description":            self = .description(string())
                case "details":                self = .details(array_string())
                case "disabled":               self = .disabled(boolean())
                case "dropeffect":             self = .dropeffect(enumeration())
                case "errormessage":           self = .errormessage(string())
                case "expanded":               self = .expanded(enumeration())
                case "flowto":                 self = .flowto(array_string())
                case "grabbed":                self = .grabbed(enumeration())
                case "haspopup":               self = .haspopup(enumeration())
                case "hidden":                 self = .hidden(enumeration())
                case "invalid":                self = .invalid(enumeration())
                case "keyshortcuts":           self = .keyshortcuts(string())
                case "label":                  self = .label(string())
                case "labelledby":             self = .labelledby(array_string())
                case "level":                  self = .level(int())
                case "live":                   self = .live(enumeration())
                case "modal":                  self = .modal(boolean())
                case "multiline":              self = .multiline(boolean())
                case "multiselectable":        self = .multiselectable(boolean())
                case "orientation":            self = .orientation(enumeration())
                case "owns":                   self = .owns(array_string())
                case "placeholder":            self = .placeholder(string())
                case "posinset":               self = .posinset(int())
                case "pressed":                self = .pressed(enumeration())
                case "readonly":               self = .readonly(boolean())
                case "relevant":               self = .relevant(enumeration())
                case "required":               self = .required(boolean())
                case "roledescription":        self = .roledescription(string())
                case "rowcount":               self = .rowcount(int())
                case "rowindex":               self = .rowindex(int())
                case "rowindextext":           self = .rowindextext(string())
                case "rowspan":                self = .rowspan(int())
                case "selected":               self = .selected(enumeration())
                case "setsize":                self = .setsize(int())
                case "sort":                   self = .sort(enumeration())
                case "valuemax":               self = .valuemax(float())
                case "valuemin":               self = .valuemin(float())
                case "valuenow":               self = .valuenow(float())
                case "valuetext":              self = .valuetext(string())
                default:                       return nil
            }
        }

        public var htmlValue : String {
            switch self {
                case .activedescendant(let value): return value
                case .atomic(let value): return "\(value)"
                case .autocomplete(let value): return value.rawValue
                case .braillelabel(let value): return value
                case .brailleroledescription(let value): return value
                case .busy(let value): return "\(value)"
                case .checked(let value): return value.rawValue
                case .colcount(let value): return "\(value)"
                case .colindex(let value): return "\(value)"
                case .colindextext(let value): return value
                case .colspan(let value): return "\(value)"
                case .controls(let value): return value.joined(separator: " ")
                case .current(let value): return value.rawValue
                case .describedby(let value): return value.joined(separator: " ")
                case .description(let value): return value
                case .details(let value): return value.joined(separator: " ")
                case .disabled(let value): return "\(value)"
                case .dropeffect(let value): return value.rawValue
                case .errormessage(let value): return value
                case .expanded(let value): return value.rawValue
                case .flowto(let value): return value.joined(separator: " ")
                case .grabbed(let value): return value.rawValue
                case .haspopup(let value): return value.rawValue
                case .hidden(let value): return value.rawValue
                case .invalid(let value): return value.rawValue
                case .keyshortcuts(let value): return value
                case .label(let value): return value
                case .labelledby(let value): return value.joined(separator: " ")
                case .level(let value): return "\(value)"
                case .live(let value): return value.rawValue
                case .modal(let value): return "\(value)"
                case .multiline(let value): return "\(value)"
                case .multiselectable(let value): return "\(value)"
                case .orientation(let value): return value.rawValue
                case .owns(let value): return value.joined(separator: " ")
                case .placeholder(let value): return value
                case .posinset(let value): return "\(value)"
                case .pressed(let value): return value.rawValue
                case .readonly(let value): return "\(value)"
                case .relevant(let value): return value.rawValue
                case .required(let value): return "\(value)"
                case .roledescription(let value): return value
                case .rowcount(let value): return "\(value)"
                case .rowindex(let value): return "\(value)"
                case .rowindextext(let value): return value
                case .rowspan(let value): return "\(value)"
                case .selected(let value): return value.rawValue
                case .setsize(let value): return "\(value)"
                case .sort(let value): return value.rawValue
                case .valuemax(let value): return "\(value)"
                case .valuemin(let value): return "\(value)"
                case .valuenow(let value): return "\(value)"
                case .valuetext(let value): return value
            }
        }

        public enum Autocomplete : String {
            case none, inline, list, both
        }
        public enum Checked : String {
            case `false`, `true`, mixed, undefined
        }
        public enum Current : String {
            case page, step, location, date, time, `true`, `false`
        }
        public enum DropEffect : String {
            case copy, execute, link, move, none, popup
        }
        public enum Expanded : String {
            case `false`, `true`, undefined
        }
        public enum Grabbed : String {
            case `true`, `false`, undefined
        }
        public enum HasPopup : String {
            case `false`, `true`, menu, listbox, tree, grid, dialog
        }
        public enum Hidden : String {
            case `false`, `true`, undefined
        }
        public enum Invalid : String {
            case grammar, `false`, spelling, `true`
        }
        public enum Live : String {
            case assertive, off, polite
        }
        public enum Orientation : String {
            case horizontal, undefined, vertical
        }
        public enum Pressed : String {
            case `false`, mixed, `true`, undefined
        }
        public enum Relevant : String {
            case additions, all, removals, text
        }
        public enum Selected : String {
            case `true`, `false`, undefined
        }
        public enum Sort : String {
            case ascending, descending, none, other
        }
    }

    // MARK: aria role
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
    enum ariarole : String {
        case alert, alertdialog
        case application
        case article
        case associationlist, associationlistitemkey, associationlistitemvalue

        case banner
        case blockquote
        case button

        case caption
        case cell
        case checkbox
        case code
        case columnheader
        case combobox
        case command
        case comment
        case complementary
        case composite
        case contentinfo

        case definition
        case deletion
        case dialog
        case directory
        case document

        case emphasis

        case feed
        case figure
        case form

        case generic
        case grid, gridcell
        case group

        case heading

        case img
        case input
        case insertion

        case landmark
        case link
        case listbox, listitem
        case log

        case main
        case mark
        case marquee
        case math
        case menu, menubar
        case menuitem, menuitemcheckbox, menuitemradio
        case meter

        case navigation
        case none
        case note

        case option
        
        case paragraph
        case presentation
        case progressbar

        case radio, radiogroup
        case range
        case region
        case roletype
        case row, rowgroup, rowheader

        case scrollbar
        case search, searchbox
        case section, sectionhead
        case select
        case separator
        case slider
        case spinbutton
        case status
        case structure
        case strong
        case `subscript`
        case superscript
        case suggestion
        case `switch`

        case tab, tablist, tabpanel
        case table
        case term
        case textbox
        case time
        case timer
        case toolbar
        case tooltip
        case tree, treegrid, treeitem

        case widget
        case window
    }

    // MARK: as
    enum `as` : String {
        case audio, document, embed, fetch, font, image, object, script, style, track, video, worker
    }

    // MARK: autocapitalize
    enum autocapitalize : String {
        case on, off
        case none
        case sentences, words, characters
    }

    // MARK: autocomplete
    enum autocomplete : String {
        case off, on
    }

    // MARK: autocorrect
    enum autocorrect : String {
        case off, on
    }

    // MARK: blocking
    enum blocking : String {
        case render
    }

    // MARK: buttontype
    enum buttontype : String {
        case submit, reset, button
    }

    // MARK: capture
    enum capture : String {
        case user, environment
    }

    // MARK: command
    enum command {
        case showModal
        case close
        case showPopover
        case hidePopover
        case togglePopover
        case custom(String)

        public init?(rawValue: String) {
            switch rawValue {
                case "showModal":     self = .showModal
                case "close":         self = .close
                case "showPopover":   self = .showPopover
                case "hidePopover":   self = .hidePopover
                case "togglePopover": self = .togglePopover
                default:
                    if rawValue.starts(with: "custom(\"") && rawValue.hasSuffix("\")") {
                        let value:String = String(rawValue[rawValue.index(rawValue.startIndex, offsetBy: 8)..<rawValue.index(rawValue.endIndex, offsetBy: -2)])
                        self = .custom(value)
                    } else {
                        return nil
                    }
            }
        }

        public var htmlValue : String {
            switch self {
                case .showModal:          return "show-modal"
                case .close:              return "close"
                case .showPopover:        return "show-popover"
                case .hidePopover:        return "hide-popover"
                case .togglePopover:      return "toggle-popover"
                case .custom(let value): return "--" + value
            }
        }
    }

    // MARK: contenteditable
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

    // MARK: controlslist
    enum controlslist : String {
        case nodownload, nofullscreen, noremoteplayback
    }

    // MARK: crossorigin
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

    // MARK: decoding
    enum decoding : String {
        case sync, async, auto
    }

    // MARK: dir
    enum dir : String {
        case auto, ltr, rtl
    }

    // MARK: dirname
    enum dirname : String {
        case ltr, rtl
    }

    // MARK: draggable
    enum draggable : String {
        case `true`, `false`
    }

    // MARK: download
    enum download {
        case empty
        case filename(String)

        public init?(rawValue: String) {
            if rawValue == "empty" {
                self = .empty
            } else {
                if rawValue.starts(with: "filename(\"") && rawValue.hasSuffix("\")") {
                    let value:String = String(rawValue[rawValue.index(rawValue.startIndex, offsetBy: 10)..<rawValue.index(rawValue.endIndex, offsetBy: -2)])
                    self = .filename(value)
                } else {
                    return nil
                }
            }
        }

        public var htmlValue : String {
            switch self {
                case .empty: return ""
                case .filename(let value): return value
            }
        }
    }

    // MARK: enterkeyhint
    enum enterkeyhint : String {
        case enter, done, go, next, previous, search, send
    }

    // MARK: event
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

    // MARK: fetchpriority
    enum fetchpriority : String {
        case high, low, auto
    }

    // MARK: formenctype
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

    // MARK: formmethod
    enum formmethod : String {
        case get, post, dialog
    }

    // MARK: formtarget
    enum formtarget : String {
        case _self, _blank, _parent, _top
    }

    // MARK: hidden
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

    // MARK: httpequiv
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

    // MARK: inputmode
    enum inputmode : String {
        case none, text, decimal, numeric, tel, search, email, url
    }
    
    // MARK: inputtype
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

    // MARK: kind
    enum kind : String {
        case subtitles, captions, chapters, metadata
    }

    // MARK: loading
    enum loading : String {
        case eager, lazy
    }

    // MARK: numberingtype
    enum numberingtype : String {
        case a, A, i, I, one

        public var htmlValue : String {
            switch self {
                case .one: return "1"
                default:   return rawValue
            }
        }
    }

    // MARK: popover
    enum popover : String {
        case auto, manual
    }

    // MARK: popovertargetaction
    enum popovertargetaction : String {
        case hide, show, toggle
    }

    // MARK: preload
    enum preload : String {
        case none, metadata, auto
    }

    // MARK: referrerpolicy
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

    // MARK: rel
    enum rel : String {
        case alternate, author, bookmark, canonical
        case dnsPrefetch
        case external, expect, help, icon, license
        case manifest, me, modulepreload, next, nofollow, noopener, noreferrer
        case opener, pingback, preconnect, prefetch, preload, prerender, prev
        case privacyPolicy
        case search, stylesheet, tag
        case termsOfService

        public var htmlValue : String {
            switch self {
                case .dnsPrefetch:    return "dns-prefetch"
                case .privacyPolicy:  return "privacy-policy"
                case .termsOfService: return "terms-of-service"
                default:               return rawValue
            }
        }
    }

    // MARK: sandbox
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

    // MARK: scripttype
    enum scripttype : String {
        case importmap, module, speculationrules
    }

    // MARK: scope
    enum scope : String {
        case row, col, rowgroup, colgroup
    }

    // MARK: shadowrootmode
    enum shadowrootmode : String {
        case open, closed
    }

    // MARK: shadowrootclonable
    enum shadowrootclonable : String {
        case `true`, `false`
    }

    // MARK: shape
    enum shape : String {
        case rect, circle, poly, `default`
    }

    // MARK: spellcheck
    enum spellcheck : String {
        case `true`, `false`
    }

    // MARK: target
    enum target : String {
        case _self, _blank, _parent, _top, _unfencedTop
    }

    // MARK: translate
    enum translate : String {
        case yes, no
    }

    // MARK: virtualkeyboardpolicy
    enum virtualkeyboardpolicy : String {
        case auto, manual
    }

    // MARK: wrap
    enum wrap : String {
        case hard, soft
    }

    // MARK: writingsuggestions
    enum writingsuggestions : String {
        case `true`, `false`
    }
}