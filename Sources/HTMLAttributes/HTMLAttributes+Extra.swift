
#if canImport(CSS)
import CSS
#endif

#if canImport(HTMLKitUtilities)
import HTMLKitUtilities
#endif

// MARK: HTMLAttribute.Extra
extension HTMLAttribute {
    public enum Extra {
        public static func memoryLayout(for key: String) -> (alignment: Int, size: Int, stride: Int)? {
            func get<T>(_ dude: T.Type) -> (Int, Int, Int) {
                return (MemoryLayout<T>.alignment, MemoryLayout<T>.size, MemoryLayout<T>.stride)
            }
            switch key {
            case "as": return get(`as`.self)
            case "autocapitalize": return get(autocapitalize.self)
            case "autocomplete": return get(autocomplete.self)
            case "autocorrect": return get(autocorrect.self)
            case "blocking": return get(blocking.self)
            case "buttontype": return get(buttontype.self)
            case "capture": return get(capture.self)
            case "command": return get(command.self)
            case "contenteditable": return get(contenteditable.self)
            case "controlslist": return get(controlslist.self)
            case "crossorigin": return get(crossorigin.self)
            case "decoding": return get(decoding.self)
            case "dir": return get(dir.self)
            case "dirname": return get(dirname.self)
            case "draggable": return get(draggable.self)
            case "download": return get(download.self)
            case "enterkeyhint": return get(enterkeyhint.self)
            case "event": return get(HTMLEvent.self)
            case "fetchpriority": return get(fetchpriority.self)
            case "formenctype": return get(formenctype.self)
            case "formmethod": return get(formmethod.self)
            case "formtarget": return get(formtarget.self)
            case "hidden": return get(hidden.self)
            case "httpequiv": return get(httpequiv.self)
            case "inputmode": return get(inputmode.self)
            case "inputtype": return get(inputtype.self)
            case "kind": return get(kind.self)
            case "loading": return get(loading.self)
            case "numberingtype": return get(numberingtype.self)
            case "popover": return get(popover.self)
            case "popovertargetaction": return get(popovertargetaction.self)
            case "preload": return get(preload.self)
            case "referrerpolicy": return get(referrerpolicy.self)
            case "rel": return get(rel.self)
            case "sandbox": return get(sandbox.self)
            case "scripttype": return get(scripttype.self)
            case "scope": return get(scope.self)
            case "shadowrootmode": return get(shadowrootmode.self)
            case "shadowrootclonable": return get(shadowrootclonable.self)
            case "shape": return get(shape.self)
            case "spellcheck": return get(spellcheck.self)
            case "target": return get(target.self)
            case "translate": return get(translate.self)
            case "virtualkeyboardpolicy": return get(virtualkeyboardpolicy.self)
            case "wrap": return get(wrap.self)
            case "writingsuggestions": return get(writingsuggestions.self)

            case "width": return get(width.self)
            case "height": return get(height.self)
            default: return nil
            }
        }
    }
}

extension HTMLAttribute.Extra {
    public typealias height = CSSUnit
    public typealias width = CSSUnit

    // MARK: aria attributes
    // https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes
    public enum ariaattribute: HTMLInitializable {
        case activedescendant(String?)
        case atomic(Bool?)
        case autocomplete(Autocomplete?)

        case braillelabel(String?)
        case brailleroledescription(String?)
        case busy(Bool?)
        
        case checked(Checked?)
        case colcount(Int?)
        case colindex(Int?)
        case colindextext(String?)
        case colspan(Int?)
        case controls([String]?)
        case current(Current?)

        case describedby([String]?)
        case description(String?)
        case details([String]?)
        case disabled(Bool?)
        case dropeffect(DropEffect?)

        case errormessage(String?)
        case expanded(Expanded?)
        
        case flowto([String]?)
        
        case grabbed(Grabbed?)

        case haspopup(HasPopup?)
        case hidden(Hidden?)

        case invalid(Invalid?)

        case keyshortcuts(String?)

        case label(String?)
        case labelledby([String]?)
        case level(Int?)
        case live(Live?)

        case modal(Bool?)
        case multiline(Bool?)
        case multiselectable(Bool?)

        case orientation(Orientation?)
        case owns([String]?)

        case placeholder(String?)
        case posinset(Int?)
        case pressed(Pressed?)

        case readonly(Bool?)

        case relevant(Relevant?)
        case required(Bool?)
        case roledescription(String?)
        case rowcount(Int?)
        case rowindex(Int?)
        case rowindextext(String?)
        case rowspan(Int?)

        case selected(Selected?)
        case setsize(Int?)
        case sort(Sort?)

        case valuemax(Float?)
        case valuemin(Float?)
        case valuenow(Float?)
        case valuetext(String?)

        @inlinable
        public var key: String {
            switch self {
            case .activedescendant: "activedescendant"
            case .atomic: "atomic"
            case .autocomplete: "autocomplete"
            case .braillelabel: "braillelabel"
            case .brailleroledescription: "brailleroledescription"
            case .busy: "busy"
            case .checked: "checked"
            case .colcount: "colcount"
            case .colindex: "colindex"
            case .colindextext: "colindextext"
            case .colspan: "colspan"
            case .controls: "controls"
            case .current: "current"
            case .describedby: "describedby"
            case .description: "description"
            case .details: "details"
            case .disabled: "disabled"
            case .dropeffect: "dropeffect"
            case .errormessage: "errormessage"
            case .expanded: "expanded"
            case .flowto: "flowto"
            case .grabbed: "grabbed"
            case .haspopup: "haspopup"
            case .hidden: "hidden"
            case .invalid: "invalid"
            case .keyshortcuts: "keyshortcuts"
            case .label: "label"
            case .labelledby: "labelledby"
            case .level: "level"
            case .live: "live"
            case .modal: "modal"
            case .multiline: "multiline"
            case .multiselectable: "multiselectable"
            case .orientation: "orientation"
            case .owns: "owns"
            case .placeholder: "placeholder"
            case .posinset: "posinset"
            case .pressed: "pressed"
            case .readonly: "readonly"
            case .relevant: "relevant"
            case .required: "required"
            case .roledescription: "roledescription"
            case .rowcount: "rowcount"
            case .rowindex: "rowindex"
            case .rowindextext: "rowindextext"
            case .rowspan: "rowspan"
            case .selected: "selected"
            case .setsize: "setsize"
            case .sort: "sort"
            case .valuemax: "valuemax"
            case .valuemin: "valuemin"
            case .valuenow: "valuenow"
            case .valuetext: "valuetext"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .activedescendant(let value): value
            case .atomic(let value): unwrap(value)
            case .autocomplete(let value): value?.rawValue
            case .braillelabel(let value): value
            case .brailleroledescription(let value): value
            case .busy(let value): unwrap(value)
            case .checked(let value): value?.rawValue
            case .colcount(let value): unwrap(value)
            case .colindex(let value): unwrap(value)
            case .colindextext(let value): value
            case .colspan(let value): unwrap(value)
            case .controls(let value): value?.joined(separator: " ")
            case .current(let value): value?.rawValue
            case .describedby(let value): value?.joined(separator: " ")
            case .description(let value): value
            case .details(let value): value?.joined(separator: " ")
            case .disabled(let value): unwrap(value)
            case .dropeffect(let value): value?.rawValue
            case .errormessage(let value): value
            case .expanded(let value): value?.rawValue
            case .flowto(let value): value?.joined(separator: " ")
            case .grabbed(let value): value?.rawValue
            case .haspopup(let value): value?.rawValue
            case .hidden(let value): value?.rawValue
            case .invalid(let value): value?.rawValue
            case .keyshortcuts(let value): value
            case .label(let value): value
            case .labelledby(let value): value?.joined(separator: " ")
            case .level(let value): unwrap(value)
            case .live(let value): value?.rawValue
            case .modal(let value): unwrap(value)
            case .multiline(let value): unwrap(value)
            case .multiselectable(let value): unwrap(value)
            case .orientation(let value): value?.rawValue
            case .owns(let value): value?.joined(separator: " ")
            case .placeholder(let value): value
            case .posinset(let value): unwrap(value)
            case .pressed(let value): value?.rawValue
            case .readonly(let value): unwrap(value)
            case .relevant(let value): value?.rawValue
            case .required(let value): unwrap(value)
            case .roledescription(let value): value
            case .rowcount(let value): unwrap(value)
            case .rowindex(let value): unwrap(value)
            case .rowindextext(let value): value
            case .rowspan(let value): unwrap(value)
            case .selected(let value): value?.rawValue
            case .setsize(let value): unwrap(value)
            case .sort(let value): value?.rawValue
            case .valuemax(let value): unwrap(value)
            case .valuemin(let value): unwrap(value)
            case .valuenow(let value): unwrap(value)
            case .valuetext(let value): value
            }
        }

        public enum Autocomplete: String, HTMLInitializable {
            case none, inline, list, both
        }
        public enum Checked: String, HTMLInitializable {
            case `false`, `true`, mixed, undefined
        }
        public enum Current: String, HTMLInitializable {
            case page, step, location, date, time, `true`, `false`
        }
        public enum DropEffect: String, HTMLInitializable {
            case copy, execute, link, move, none, popup
        }
        public enum Expanded: String, HTMLInitializable {
            case `false`, `true`, undefined
        }
        public enum Grabbed: String, HTMLInitializable {
            case `true`, `false`, undefined
        }
        public enum HasPopup: String, HTMLInitializable {
            case `false`, `true`, menu, listbox, tree, grid, dialog
        }
        public enum Hidden: String, HTMLInitializable {
            case `false`, `true`, undefined
        }
        public enum Invalid: String, HTMLInitializable {
            case grammar, `false`, spelling, `true`
        }
        public enum Live: String, HTMLInitializable {
            case assertive, off, polite
        }
        public enum Orientation: String, HTMLInitializable {
            case horizontal, undefined, vertical
        }
        public enum Pressed: String, HTMLInitializable {
            case `false`, mixed, `true`, undefined
        }
        public enum Relevant: String, HTMLInitializable {
            case additions, all, removals, text
        }
        public enum Selected: String, HTMLInitializable {
            case `true`, `false`, undefined
        }
        public enum Sort: String, HTMLInitializable {
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
    public enum ariarole: String, HTMLInitializable {
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
    public enum `as`: String, HTMLInitializable {
        case audio, document, embed, fetch, font, image, object, script, style, track, video, worker
    }

    // MARK: autocapitalize
    public enum autocapitalize: String, HTMLInitializable {
        case on, off
        case none
        case sentences, words, characters
    }

    // MARK: autocomplete
    public enum autocomplete: String, HTMLInitializable {
        case off, on
    }

    // MARK: autocorrect
    public enum autocorrect: String, HTMLInitializable {
        case off, on
    }

    // MARK: blocking
    public enum blocking: String, HTMLInitializable {
        case render
    }

    // MARK: buttontype
    public enum buttontype: String, HTMLInitializable {
        case submit, reset, button
    }

    // MARK: capture
    public enum capture: String, HTMLInitializable {
        case user, environment
    }

    // MARK: command
    public enum command: HTMLInitializable {
        case showModal
        case close
        case showPopover
        case hidePopover
        case togglePopover
        case custom(String)

        @inlinable
        public var key: String {
            switch self {
            case .showModal:       "showModal"
            case .close:           "close"
            case .showPopover:     "showPopover"
            case .hidePopover:     "hidePopover"
            case .togglePopover:   "togglePopover"
            case .custom:          "custom"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .showModal:          "show-modal"
            case .close:              "close"
            case .showPopover:        "show-popover"
            case .hidePopover:        "hide-popover"
            case .togglePopover:      "toggle-popover"
            case .custom(let value): "--" + value
            }
        }
    }

    // MARK: contenteditable
    public enum contenteditable: String, HTMLInitializable {
        case `true`, `false`
        case plaintextOnly

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .plaintextOnly: "plaintext-only"
            default:             rawValue
            }
        }
    }

    // MARK: controlslist
    public enum controlslist: String, HTMLInitializable {
        case nodownload, nofullscreen, noremoteplayback
    }

    // MARK: crossorigin
    public enum crossorigin: String, HTMLInitializable {
        case anonymous
        case useCredentials

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .useCredentials: "use-credentials"
            default:              rawValue
            }
        }
    }

    // MARK: decoding
    public enum decoding: String, HTMLInitializable {
        case sync, async, auto
    }

    // MARK: dir
    public enum dir: String, HTMLInitializable {
        case auto, ltr, rtl
    }

    // MARK: dirname
    public enum dirname: String, HTMLInitializable {
        case ltr, rtl
    }

    // MARK: draggable
    public enum draggable: String, HTMLInitializable {
        case `true`, `false`
    }

    // MARK: download
    public enum download: HTMLInitializable {
        case empty
        case filename(String)

        @inlinable
        public var key: String {
            switch self {
            case .empty:    "empty"
            case .filename: "filename"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .empty: ""
            case .filename(let value): value
            }
        }

        @inlinable
        public var htmlValueIsVoidable: Bool {
            switch self {
            case .empty: true
            default: false
            }
        }
    }

    // MARK: enterkeyhint
    public enum enterkeyhint: String, HTMLInitializable {
        case enter, done, go, next, previous, search, send
    }

    // MARK: fetchpriority
    public enum fetchpriority: String, HTMLInitializable {
        case high, low, auto
    }

    // MARK: formenctype
    public enum formenctype: String, HTMLInitializable {
        case applicationXWWWFormURLEncoded
        case multipartFormData
        case textPlain

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .applicationXWWWFormURLEncoded: "application/x-www-form-urlencoded"
            case .multipartFormData:             "multipart/form-data"
            case .textPlain:                     "text/plain"
            }
        }
    }

    // MARK: formmethod
    public enum formmethod: String, HTMLInitializable {
        case get, post, dialog
    }

    // MARK: formtarget
    public enum formtarget: String, HTMLInitializable {
        case _self, _blank, _parent, _top
    }

    // MARK: hidden
    public enum hidden: String, HTMLInitializable {
        case `true`
        case untilFound

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .true: ""
            case .untilFound: "until-found"
            }
        }
    }

    // MARK: httpequiv
    public enum httpequiv: String, HTMLInitializable {
        case contentSecurityPolicy
        case contentType
        case defaultStyle
        case xUACompatible
        case refresh

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .contentSecurityPolicy: "content-security-policy"
            case .contentType:           "content-type"
            case .defaultStyle:          "default-style"
            case .xUACompatible:         "x-ua-compatible"
            default:                     rawValue
            }
        }
    }

    // MARK: inputmode
    public enum inputmode: String, HTMLInitializable {
        case none, text, decimal, numeric, tel, search, email, url
    }
    
    // MARK: inputtype
    public enum inputtype: String, HTMLInitializable {
        case button, checkbox, color, date
        case datetimeLocal
        case email, file, hidden, image, month, number, password, radio, range, reset, search, submit, tel, text, time, url, week

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .datetimeLocal: "datetime-local"
            default: rawValue
            }
        }
    }

    // MARK: kind
    public enum kind: String, HTMLInitializable {
        case subtitles, captions, chapters, metadata
    }

    // MARK: loading
    public enum loading: String, HTMLInitializable {
        case eager, lazy
    }

    // MARK: numberingtype
    public enum numberingtype: String, HTMLInitializable {
        case a, A, i, I, one

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .one: "1"
            default:   rawValue
            }
        }
    }

    // MARK: popover
    public enum popover: String, HTMLInitializable {
        case auto, manual
    }

    // MARK: popovertargetaction
    public enum popovertargetaction: String, HTMLInitializable {
        case hide, show, toggle
    }

    // MARK: preload
    public enum preload: String, HTMLInitializable {
        case none, metadata, auto
    }

    // MARK: referrerpolicy
    public enum referrerpolicy: String, HTMLInitializable {
        case noReferrer
        case noReferrerWhenDowngrade
        case origin
        case originWhenCrossOrigin
        case sameOrigin
        case strictOrigin
        case strictOriginWhenCrossOrigin
        case unsafeURL

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .noReferrer:                  "no-referrer"
            case .noReferrerWhenDowngrade:     "no-referrer-when-downgrade"
            case .originWhenCrossOrigin:       "origin-when-cross-origin"
            case .strictOrigin:                "strict-origin"
            case .strictOriginWhenCrossOrigin: "strict-origin-when-cross-origin"
            case .unsafeURL:                   "unsafe-url"
            default:                           rawValue
            }
        }
    }

    // MARK: rel
    public enum rel: String, HTMLInitializable {
        case alternate, author
        case bookmark
        case canonical, compressionDictionary
        case dnsPrefetch
        case external, expect, help, icon, license
        case manifest, me, modulepreload
        case next, nofollow, noopener, noreferrer
        case opener
        case pingback, preconnect, prefetch, preload, prerender, prev, privacyPolicy
        case search, stylesheet
        case tag, termsOfService

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .compressionDictionary: "compression-dictionary"
            case .dnsPrefetch:           "dns-prefetch"
            case .privacyPolicy:         "privacy-policy"
            case .termsOfService:        "terms-of-service"
            default:                     rawValue
            }
        }
    }

    // MARK: sandbox
    public enum sandbox: String, HTMLInitializable {
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

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .allowDownloads:                      "allow-downloads"
            case .allowForms:                          "allow-forms"
            case .allowModals:                         "allow-modals"
            case .allowOrientationLock:                "allow-orientation-lock"
            case .allowPointerLock:                    "allow-pointer-lock"
            case .allowPopups:                         "allow-popups"
            case .allowPopupsToEscapeSandbox:          "allow-popups-to-escape-sandbox"
            case .allowPresentation:                   "allow-presentation"
            case .allowSameOrigin:                     "allow-same-origin"
            case .allowScripts:                        "allow-scripts"
            case .allowStorageAccessByUserActiviation: "allow-storage-access-by-user-activation"
            case .allowTopNavigation:                  "allow-top-navigation"
            case .allowTopNavigationByUserActivation:  "allow-top-navigation-by-user-activation"
            case .allowTopNavigationToCustomProtocols: "allow-top-navigation-to-custom-protocols"
            }
        }
    }

    // MARK: scripttype
    public enum scripttype: String, HTMLInitializable {
        case importmap, module, speculationrules
    }

    // MARK: scope
    public enum scope: String, HTMLInitializable {
        case row, col, rowgroup, colgroup
    }

    // MARK: shadowrootmode
    public enum shadowrootmode: String, HTMLInitializable {
        case open, closed
    }

    // MARK: shadowrootclonable
    public enum shadowrootclonable: String, HTMLInitializable {
        case `true`, `false`
    }

    // MARK: shape
    public enum shape: String, HTMLInitializable {
        case rect, circle, poly, `default`
    }

    // MARK: spellcheck
    public enum spellcheck: String, HTMLInitializable {
        case `true`, `false`
    }

    // MARK: target
    public enum target: String, HTMLInitializable {
        case _self, _blank, _parent, _top, _unfencedTop
    }

    // MARK: translate
    public enum translate: String, HTMLInitializable {
        case yes, no
    }

    // MARK: virtualkeyboardpolicy
    public enum virtualkeyboardpolicy: String, HTMLInitializable {
        case auto, manual
    }

    // MARK: wrap
    public enum wrap: String, HTMLInitializable {
        case hard, soft
    }

    // MARK: writingsuggestions
    public enum writingsuggestions: String, HTMLInitializable {
        case `true`, `false`
    }
}