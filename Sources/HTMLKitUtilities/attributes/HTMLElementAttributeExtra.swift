//
//  HTMLElementAttributeExtra.swift
//
//
//  Created by Evan Anderson on 11/21/24.
//

#if canImport(SwiftSyntax)
import SwiftSyntax
import SwiftSyntaxMacros
#endif

// MARK: HTMLInitializable
public protocol HTMLInitializable : Hashable, Sendable {
    #if canImport(SwiftSyntax)
    init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax)
    #endif

    @inlinable
    var key : String { get }

    @inlinable
    func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String?

    @inlinable
    var htmlValueIsVoidable : Bool { get }
}
extension HTMLInitializable {
    public func unwrap<T>(_ value: T?, suffix: String? = nil) -> String? {
        guard let value:T = value else { return nil }
        return "\(value)" + (suffix ?? "")
    }
}
extension HTMLInitializable where Self: RawRepresentable, RawValue == String {
    @inlinable
    public var key : String { rawValue }

    @inlinable
    public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? { rawValue }

    @inlinable
    public var htmlValueIsVoidable : Bool { false }

    #if canImport(SwiftSyntax)
    public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
        guard let value:Self = .init(rawValue: key) else { return nil }
        self = value
    }
    #endif
}

// MARK: HTMLElementAttribute.Extra
extension HTMLElementAttribute {
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
            case "event": return get(event.self)
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

        #if canImport(SwiftSyntax)
        public static func parse(context: some MacroExpansionContext, isUnchecked: Bool, key: String, expr: ExprSyntax) -> (any HTMLInitializable)? {
            func get<T : HTMLInitializable>(_ type: T.Type) -> T? {
                let inner_key:String, arguments:LabeledExprListSyntax
                if let function:FunctionCallExprSyntax = expr.functionCall {
                    inner_key = function.calledExpression.memberAccess!.declName.baseName.text
                    arguments = function.arguments
                } else if let member:MemberAccessExprSyntax = expr.memberAccess {
                    inner_key = member.declName.baseName.text
                    arguments = LabeledExprListSyntax()
                } else {
                    return nil
                }
                return T(context: context, isUnchecked: isUnchecked, key: inner_key, arguments: arguments)
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
            case "event": return get(event.self)
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
        #endif
    }
}
extension HTMLElementAttribute.Extra {
    public typealias height = HTMLElementAttribute.CSSUnit
    public typealias width = HTMLElementAttribute.CSSUnit

    // MARK: aria attributes
    // https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes
    public enum ariaattribute : HTMLInitializable {
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

        #if canImport(SwiftSyntax)
        public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
            let expression:ExprSyntax = arguments.first!.expression
            func string() -> String?        { expression.string(context: context, isUnchecked: isUnchecked, key: key) }
            func boolean() -> Bool?         { expression.boolean(context: context, key: key) }
            func enumeration<T : HTMLInitializable>() -> T? { expression.enumeration(context: context, isUnchecked: isUnchecked, key: key, arguments: arguments) }
            func int() -> Int? { expression.int(context: context, key: key) }
            func array_string() -> [String]? { expression.array_string(context: context, isUnchecked: isUnchecked, key: key) }
            func float() -> Float? { expression.float(context: context, key: key) }
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
        #endif

        @inlinable
        public var key : String {
            switch self {
            case .activedescendant(_): return "activedescendant"
            case .atomic(_): return "atomic"
            case .autocomplete(_): return "autocomplete"
            case .braillelabel(_): return "braillelabel"
            case .brailleroledescription(_): return "brailleroledescription"
            case .busy(_): return "busy"
            case .checked(_): return "checked"
            case .colcount(_): return "colcount"
            case .colindex(_): return "colindex"
            case .colindextext(_): return "colindextext"
            case .colspan(_): return "colspan"
            case .controls(_): return "controls"
            case .current(_): return "current"
            case .describedby(_): return "describedby"
            case .description(_): return "description"
            case .details(_): return "details"
            case .disabled(_): return "disabled"
            case .dropeffect(_): return "dropeffect"
            case .errormessage(_): return "errormessage"
            case .expanded(_): return "expanded"
            case .flowto(_): return "flowto"
            case .grabbed(_): return "grabbed"
            case .haspopup(_): return "haspopup"
            case .hidden(_): return "hidden"
            case .invalid(_): return "invalid"
            case .keyshortcuts(_): return "keyshortcuts"
            case .label(_): return "label"
            case .labelledby(_): return "labelledby"
            case .level(_): return "level"
            case .live(_): return "live"
            case .modal(_): return "modal"
            case .multiline(_): return "multiline"
            case .multiselectable(_): return "multiselectable"
            case .orientation(_): return "orientation"
            case .owns(_): return "owns"
            case .placeholder(_): return "placeholder"
            case .posinset(_): return "posinset"
            case .pressed(_): return "pressed"
            case .readonly(_): return "readonly"
            case .relevant(_): return "relevant"
            case .required(_): return "required"
            case .roledescription(_): return "roledescription"
            case .rowcount(_): return "rowcount"
            case .rowindex(_): return "rowindex"
            case .rowindextext(_): return "rowindextext"
            case .rowspan(_): return "rowspan"
            case .selected(_): return "selected"
            case .setsize(_): return "setsize"
            case .sort(_): return "sort"
            case .valuemax(_): return "valuemax"
            case .valuemin(_): return "valuemin"
            case .valuenow(_): return "valuenow"
            case .valuetext(_): return "valuetext"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .activedescendant(let value): return value
            case .atomic(let value): return unwrap(value)
            case .autocomplete(let value): return value?.rawValue
            case .braillelabel(let value): return value
            case .brailleroledescription(let value): return value
            case .busy(let value): return unwrap(value)
            case .checked(let value): return value?.rawValue
            case .colcount(let value): return unwrap(value)
            case .colindex(let value): return unwrap(value)
            case .colindextext(let value): return value
            case .colspan(let value): return unwrap(value)
            case .controls(let value): return value?.joined(separator: " ")
            case .current(let value): return value?.rawValue
            case .describedby(let value): return value?.joined(separator: " ")
            case .description(let value): return value
            case .details(let value): return value?.joined(separator: " ")
            case .disabled(let value): return unwrap(value)
            case .dropeffect(let value): return value?.rawValue
            case .errormessage(let value): return value
            case .expanded(let value): return value?.rawValue
            case .flowto(let value): return value?.joined(separator: " ")
            case .grabbed(let value): return value?.rawValue
            case .haspopup(let value): return value?.rawValue
            case .hidden(let value): return value?.rawValue
            case .invalid(let value): return value?.rawValue
            case .keyshortcuts(let value): return value
            case .label(let value): return value
            case .labelledby(let value): return value?.joined(separator: " ")
            case .level(let value): return unwrap(value)
            case .live(let value): return value?.rawValue
            case .modal(let value): return unwrap(value)
            case .multiline(let value): return unwrap(value)
            case .multiselectable(let value): return unwrap(value)
            case .orientation(let value): return value?.rawValue
            case .owns(let value): return value?.joined(separator: " ")
            case .placeholder(let value): return value
            case .posinset(let value): return unwrap(value)
            case .pressed(let value): return value?.rawValue
            case .readonly(let value): return unwrap(value)
            case .relevant(let value): return value?.rawValue
            case .required(let value): return unwrap(value)
            case .roledescription(let value): return value
            case .rowcount(let value): return unwrap(value)
            case .rowindex(let value): return unwrap(value)
            case .rowindextext(let value): return value
            case .rowspan(let value): return unwrap(value)
            case .selected(let value): return value?.rawValue
            case .setsize(let value): return unwrap(value)
            case .sort(let value): return value?.rawValue
            case .valuemax(let value): return unwrap(value)
            case .valuemin(let value): return unwrap(value)
            case .valuenow(let value): return unwrap(value)
            case .valuetext(let value): return value
            }
        }

        public var htmlValueIsVoidable : Bool { false }

        public enum Autocomplete : String, HTMLInitializable {
            case none, inline, list, both
        }
        public enum Checked : String, HTMLInitializable {
            case `false`, `true`, mixed, undefined
        }
        public enum Current : String, HTMLInitializable {
            case page, step, location, date, time, `true`, `false`
        }
        public enum DropEffect : String, HTMLInitializable {
            case copy, execute, link, move, none, popup
        }
        public enum Expanded : String, HTMLInitializable {
            case `false`, `true`, undefined
        }
        public enum Grabbed : String, HTMLInitializable {
            case `true`, `false`, undefined
        }
        public enum HasPopup : String, HTMLInitializable {
            case `false`, `true`, menu, listbox, tree, grid, dialog
        }
        public enum Hidden : String, HTMLInitializable {
            case `false`, `true`, undefined
        }
        public enum Invalid : String, HTMLInitializable {
            case grammar, `false`, spelling, `true`
        }
        public enum Live : String, HTMLInitializable {
            case assertive, off, polite
        }
        public enum Orientation : String, HTMLInitializable {
            case horizontal, undefined, vertical
        }
        public enum Pressed : String, HTMLInitializable {
            case `false`, mixed, `true`, undefined
        }
        public enum Relevant : String, HTMLInitializable {
            case additions, all, removals, text
        }
        public enum Selected : String, HTMLInitializable {
            case `true`, `false`, undefined
        }
        public enum Sort : String, HTMLInitializable {
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
    public enum ariarole : String, HTMLInitializable {
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
    public enum `as` : String, HTMLInitializable {
        case audio, document, embed, fetch, font, image, object, script, style, track, video, worker
    }

    // MARK: autocapitalize
    public enum autocapitalize : String, HTMLInitializable {
        case on, off
        case none
        case sentences, words, characters
    }

    // MARK: autocomplete
    public enum autocomplete : String, HTMLInitializable {
        case off, on
    }

    // MARK: autocorrect
    public enum autocorrect : String, HTMLInitializable {
        case off, on
    }

    // MARK: blocking
    public enum blocking : String, HTMLInitializable {
        case render
    }

    // MARK: buttontype
    public enum buttontype : String, HTMLInitializable {
        case submit, reset, button
    }

    // MARK: capture
    public enum capture : String, HTMLInitializable{
        case user, environment
    }

    // MARK: command
    public enum command : HTMLInitializable {
        case showModal
        case close
        case showPopover
        case hidePopover
        case togglePopover
        case custom(String)

        #if canImport(SwiftSyntax)
        public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
            switch key {
            case "showModal":     self = .showModal
            case "close":         self = .close
            case "showPopover":   self = .showPopover
            case "hidePopover":   self = .hidePopover
            case "togglePopover": self = .togglePopover
            case "custom":        self = .custom(arguments.first!.expression.stringLiteral!.string)
            default:              return nil
            }
        }
        #endif

        @inlinable
        public var key : String {
            switch self {
            case .showModal:          return "showModal"
            case .close:              return "close"
            case .showPopover:        return "showPopover"
            case .hidePopover:        return "hidePopover"
            case .togglePopover:      return "togglePopover"
            case .custom(_):          return "custom"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .showModal:          return "show-modal"
            case .close:              return "close"
            case .showPopover:        return "show-popover"
            case .hidePopover:        return "hide-popover"
            case .togglePopover:      return "toggle-popover"
            case .custom(let value): return "--" + value
            }
        }

        @inlinable
        public var htmlValueIsVoidable : Bool { false }
    }

    // MARK: contenteditable
    public enum contenteditable : String, HTMLInitializable {
        case `true`, `false`
        case plaintextOnly

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .plaintextOnly: return "plaintext-only"
            default:             return rawValue
            }
        }
    }

    // MARK: controlslist
    public enum controlslist : String, HTMLInitializable {
        case nodownload, nofullscreen, noremoteplayback
    }

    // MARK: crossorigin
    public enum crossorigin : String, HTMLInitializable {
        case anonymous
        case useCredentials

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .useCredentials: return "use-credentials"
            default:              return rawValue
            }
        }
    }

    // MARK: decoding
    public enum decoding : String, HTMLInitializable {
        case sync, async, auto
    }

    // MARK: dir
    public enum dir : String, HTMLInitializable {
        case auto, ltr, rtl
    }

    // MARK: dirname
    public enum dirname : String, HTMLInitializable {
        case ltr, rtl
    }

    // MARK: draggable
    public enum draggable : String, HTMLInitializable {
        case `true`, `false`
    }

    // MARK: download
    public enum download : HTMLInitializable {
        case empty
        case filename(String)

        #if canImport(SwiftSyntax)
        public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
            switch key {
            case "empty":    self = .empty
            case "filename": self = .filename(arguments.first!.expression.stringLiteral!.string)
            default:         return nil
            }
        }
        #endif

        @inlinable
        public var key : String {
            switch self {
            case .empty:       return "empty"
            case .filename(_): return "filename"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .empty: return ""
            case .filename(let value): return value
            }
        }

        @inlinable
        public var htmlValueIsVoidable : Bool {
            switch self {
            case .empty: return true
            default: return false
            }
        }
    }

    // MARK: enterkeyhint
    public enum enterkeyhint : String, HTMLInitializable {
        case enter, done, go, next, previous, search, send
    }

    // MARK: event
    public enum event : String, HTMLInitializable {
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
    public enum fetchpriority : String, HTMLInitializable {
        case high, low, auto
    }

    // MARK: formenctype
    public enum formenctype : String, HTMLInitializable {
        case applicationXWWWFormURLEncoded
        case multipartFormData
        case textPlain

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .applicationXWWWFormURLEncoded: return "application/x-www-form-urlencoded"
            case .multipartFormData:             return "multipart/form-data"
            case .textPlain:                     return "text/plain"
            }
        }
    }

    // MARK: formmethod
    public enum formmethod : String, HTMLInitializable {
        case get, post, dialog
    }

    // MARK: formtarget
    public enum formtarget : String, HTMLInitializable {
        case _self, _blank, _parent, _top
    }

    // MARK: hidden
    public enum hidden : String, HTMLInitializable {
        case `true`
        case untilFound

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .true: return ""
            case .untilFound: return "until-found"
            }
        }
    }

    // MARK: httpequiv
    public enum httpequiv : String, HTMLInitializable {
        case contentSecurityPolicy
        case contentType
        case defaultStyle
        case xUACompatible
        case refresh

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
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
    public enum inputmode : String, HTMLInitializable {
        case none, text, decimal, numeric, tel, search, email, url
    }
    
    // MARK: inputtype
    public enum inputtype : String, HTMLInitializable {
        case button, checkbox, color, date
        case datetimeLocal
        case email, file, hidden, image, month, number, password, radio, range, reset, search, submit, tel, text, time, url, week

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .datetimeLocal: return "datetime-local"
            default: return rawValue
            }
        }
    }

    // MARK: kind
    public enum kind : String, HTMLInitializable {
        case subtitles, captions, chapters, metadata
    }

    // MARK: loading
    public enum loading : String, HTMLInitializable {
        case eager, lazy
    }

    // MARK: numberingtype
    public enum numberingtype : String, HTMLInitializable {
        case a, A, i, I, one

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .one: return "1"
            default:   return rawValue
            }
        }
    }

    // MARK: popover
    public enum popover : String, HTMLInitializable {
        case auto, manual
    }

    // MARK: popovertargetaction
    public enum popovertargetaction : String, HTMLInitializable {
        case hide, show, toggle
    }

    // MARK: preload
    public enum preload : String, HTMLInitializable {
        case none, metadata, auto
    }

    // MARK: referrerpolicy
    public enum referrerpolicy : String, HTMLInitializable {
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
    public enum rel : String, HTMLInitializable {
        case alternate, author, bookmark, canonical
        case dnsPrefetch
        case external, expect, help, icon, license
        case manifest, me, modulepreload, next, nofollow, noopener, noreferrer
        case opener, pingback, preconnect, prefetch, preload, prerender, prev
        case privacyPolicy
        case search, stylesheet, tag
        case termsOfService

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .dnsPrefetch:    return "dns-prefetch"
            case .privacyPolicy:  return "privacy-policy"
            case .termsOfService: return "terms-of-service"
            default:               return rawValue
            }
        }
    }

    // MARK: sandbox
    public enum sandbox : String, HTMLInitializable {
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
    public enum scripttype : String, HTMLInitializable {
        case importmap, module, speculationrules
    }

    // MARK: scope
    public enum scope : String, HTMLInitializable {
        case row, col, rowgroup, colgroup
    }

    // MARK: shadowrootmode
    public enum shadowrootmode : String, HTMLInitializable {
        case open, closed
    }

    // MARK: shadowrootclonable
    public enum shadowrootclonable : String, HTMLInitializable {
        case `true`, `false`
    }

    // MARK: shape
    public enum shape : String, HTMLInitializable {
        case rect, circle, poly, `default`
    }

    // MARK: spellcheck
    public enum spellcheck : String, HTMLInitializable {
        case `true`, `false`
    }

    // MARK: target
    public enum target : String, HTMLInitializable {
        case _self, _blank, _parent, _top, _unfencedTop
    }

    // MARK: translate
    public enum translate : String, HTMLInitializable {
        case yes, no
    }

    // MARK: virtualkeyboardpolicy
    public enum virtualkeyboardpolicy : String, HTMLInitializable {
        case auto, manual
    }

    // MARK: wrap
    public enum wrap : String, HTMLInitializable {
        case hard, soft
    }

    // MARK: writingsuggestions
    public enum writingsuggestions : String, HTMLInitializable {
        case `true`, `false`
    }
}