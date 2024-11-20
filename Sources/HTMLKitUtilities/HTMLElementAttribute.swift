//
//  HTMLElementAttribute.swift
//
//
//  Created by Evan Anderson on 11/19/24.
//

import SwiftSyntax

public enum HTMLElementAttribute : Hashable {
    case accesskey(String? = nil)

    case ariaattribute(Extra.ariaattribute? = nil)
    case role(Extra.ariarole? = nil)

    case autocapitalize(Extra.autocapitalize? = nil)
    case autofocus(Bool = false)
    case `class`([String] = [])
    case contenteditable(Extra.contenteditable? = nil)
    case data(_ id: String, _ value: String? = nil)
    case dir(Extra.dir? = nil)
    case draggable(Extra.draggable? = nil)
    case enterkeyhint(Extra.enterkeyhint? = nil)
    case exportparts([String] = [])
    case hidden(Extra.hidden? = nil)
    case id(String? = nil)
    case inert(Bool = false)
    case inputmode(Extra.inputmode? = nil)
    case `is`(String? = nil)
    case itemid(String? = nil)
    case itemprop(String? = nil)
    case itemref(String? = nil)
    case itemscope(Bool = false)
    case itemtype(String? = nil)
    case lang(String? = nil)
    case nonce(String? = nil)
    case part([String] = [])
    case popover(Extra.popover? = nil)
    case slot(String? = nil)
    case spellcheck(Extra.spellcheck? = nil)
    case style(String? = nil)
    case tabindex(Int? = nil)
    case title(String? = nil)
    case translate(Extra.translate? = nil)
    case virtualkeyboardpolicy(Extra.virtualkeyboardpolicy? = nil)
    case writingsuggestions(Extra.writingsuggestions? = nil)

    /// This attribute adds a space and slash (" /") character before closing a void element tag.
    ///
    /// Usually only used if certain browsers need it for compatibility.
    case trailingSlash

    case htmx(_ attribute: HTMLElementAttribute.HTMX)

    case custom(_ id: String, _ value: String?)

    @available(*, deprecated, message: "General consensus considers this \"bad practice\" and you shouldn't mix your HTML and JavaScript. This will never be removed and remains deprecated to encourage use of other techniques. Learn more at https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Building_blocks/Events#inline_event_handlers_—_dont_use_these.")
    case event(Extra.event, _ value: String? = nil)

    // MARK: init rawValue
    public init?(key: String, _ function: FunctionCallExprSyntax) {
        let expression:ExprSyntax = function.arguments.first!.expression
        func string() -> String         { expression.stringLiteral!.string }
        func boolean() -> Bool          { expression.booleanLiteral!.literal.text == "true" }
        func enumeration<T : HTMLInitializable>() -> T {
            let function:FunctionCallExprSyntax = expression.functionCall!
            return T(key: function.calledExpression.memberAccess!.declName.baseName.text, arguments: function.arguments)!
        }
        func int() -> Int               { Int(expression.integerLiteral!.literal.text) ?? -1 }
        func array_string() -> [String] { expression.array!.elements.map({ $0.expression.stringLiteral!.string }) }
        func float() -> Float           { Float(expression.floatLiteral!.literal.text) ?? -1 }
        switch key {
            case "accesskey":             self = .accesskey(string())
            case "ariaattribute":         self = .ariaattribute(enumeration())
            case "role":                  self = .role(enumeration())
            case "autocapitalize":        self = .autocapitalize(enumeration())
            case "autofocus":             self = .autofocus(boolean())
            case "class":                 self = .class(array_string())
            case "contenteditable":       self = .contenteditable(enumeration())
            case "data":                  self = .data("", "") // TODO: fix
            case "dir":                   self = .dir(enumeration())
            case "draggable":             self = .draggable(enumeration())
            case "enterkeyhint":          self = .enterkeyhint(enumeration())
            case "exportparts":           self = .exportparts(array_string())
            case "hidden":                self = .hidden(enumeration())
            case "id":                    self = .id(string())
            case "inert":                 self = .inert(boolean())
            case "inputmode":             self = .inputmode(enumeration())
            case "is":                    self = .is(string())
            case "itemid":                self = .itemid(string())
            case "itemprop":              self = .itemprop(string())
            case "itemref":               self = .itemref(string())
            case "itemscope":             self = .itemscope(boolean())
            case "itemtype":              self = .itemtype(string())
            case "lang":                  self = .lang(string())
            case "nonce":                 self = .nonce(string())
            case "part":                  self = .part(array_string())
            case "popover":               self = .popover(enumeration())
            case "slot":                  self = .slot(string())
            case "spellcheck":            self = .spellcheck(enumeration())
            case "style":                 self = .style(string())
            case "tabindex":              self = .tabindex(int())
            case "title":                 self = .title(string())
            case "translate":             self = .translate(enumeration())
            case "virtualkeyboardpolicy": self = .virtualkeyboardpolicy(enumeration())
            case "writingsuggestions":    self = .writingsuggestions(enumeration())
            case "trailingSlash":         self = .trailingSlash
            case "htmx":                  self = .htmx(enumeration())
            case "custom":                self = .custom("", "") // TODO: fix
            case "event":                 self = .event(.click, "") // TODO: fix
            default: return nil
        }
    }

    // MARK: key
    public var key : String {
        switch self {
            case .accesskey(_):             return "accesskey"
            case .ariaattribute(let value):
                guard let value:HTMLElementAttribute.Extra.ariaattribute = value else { return "" }
                return "aria-" + value.key
            case .role(_):                  return "role"
            case .autocapitalize(_):        return "autocapitalize"
            case .autofocus(_):             return "autofocus"
            case .class(_):                 return "class"
            case .contenteditable(_):       return "contenteditable"
            case .data(let id, _):          return "data-" + id
            case .dir(_):                   return "dir"
            case .draggable(_):             return "draggable"
            case .enterkeyhint(_):          return "enterkeyhint"
            case .exportparts(_):           return "exportparts"
            case .hidden(_):                return "hidden"
            case .id(_):                    return "id"
            case .inert(_):                 return "inert"
            case .inputmode(_):             return "inputmode"
            case .is(_):                    return "is"
            case .itemid(_):                return "itemid"
            case .itemprop(_):              return "itemprop"
            case .itemref(_):               return "itemref"
            case .itemscope(_):             return "itemscope"
            case .itemtype(_):              return "itemtype"
            case .lang(_):                  return "lang"
            case .nonce(_):                 return "nonce"
            case .part(_):                  return "part"
            case .popover(_):               return "popover"
            case .slot(_):                  return "slot"
            case .spellcheck(_):            return "spellcheck"
            case .style(_):                 return "style"
            case .tabindex(_):              return "tabindex"
            case .title(_):                 return "title"
            case .translate(_):             return "translate"
            case .virtualkeyboardpolicy(_): return "virtualkeyboardpolicy"
            case .writingsuggestions(_):    return "writingsuggestions"

            case .trailingSlash:            return ""

            case .htmx(let htmx):
                switch htmx {
                    case .ws(let value):
                        return "ws-" + value.key
                    case .sse(let value):
                        return "sse-" + value.key
                    default:
                        return "hx-" + htmx.key
                }
            case .custom(let id, _):        return id
            case .event(let event, _):      return "on" + event.rawValue
        }
    }

    // MARK: htmlValue
    public var htmlValue : String? {
        switch self {
            case .accesskey(let value):             return value
            case .ariaattribute(let value):         return value?.htmlValue
            case .role(let value):                  return value?.rawValue
            case .autocapitalize(let value):        return value?.rawValue
            case .autofocus(let value):             return value ? "" : nil
            case .class(let value):                 return value.joined(separator: " ")
            case .contenteditable(let value):       return value?.htmlValue
            case .data(_, let value):          return value
            case .dir(let value):                   return value?.rawValue
            case .draggable(let value):             return value?.rawValue
            case .enterkeyhint(let value):          return value?.rawValue
            case .exportparts(let value):           return value.joined(separator: ",")
            case .hidden(let value):                return value?.htmlValue
            case .id(let value):                    return value
            case .inert(let value):                 return value ? "" : nil
            case .inputmode(let value):             return value?.rawValue
            case .is(let value):                    return value
            case .itemid(let value):                return value
            case .itemprop(let value):              return value
            case .itemref(let value):               return value
            case .itemscope(let value):             return value ? "" : nil
            case .itemtype(let value):              return value
            case .lang(let value):                  return value
            case .nonce(let value):                 return value
            case .part(let value):                  return value.joined(separator: " ")
            case .popover(let value):               return value?.rawValue
            case .slot(let value):                  return value
            case .spellcheck(let value):            return value?.rawValue
            case .style(let value):                 return value
            case .tabindex(let value):              return value?.description
            case .title(let value):                 return value
            case .translate(let value):             return value?.rawValue
            case .virtualkeyboardpolicy(let value): return value?.rawValue
            case .writingsuggestions(let value):    return value?.rawValue

            case .trailingSlash:            return nil

            case .htmx(let htmx):           return htmx.htmlValue
            case .custom(_, let value):        return value
            case .event(_, let value):      return value
        }
    }
}
// MARK: Extra attributes 
extension HTMLElementAttribute {
    public enum Extra {
    }
}
public protocol HTMLInitializable : Hashable {
    init?(key: String, arguments: LabeledExprListSyntax)

    var key : String { get }
    var htmlValue : String? { get }
}
public extension HTMLInitializable where Self: RawRepresentable, RawValue == String {
    var key : String { rawValue }
    var htmlValue : String? { rawValue }

    init?(key: String, arguments: LabeledExprListSyntax) {
        guard let value:Self = .init(rawValue: key) else { return nil }
        self = value
    }
}
public extension HTMLElementAttribute.Extra {
    typealias height = HTMLElementAttribute.CSSUnit
    typealias width = HTMLElementAttribute.CSSUnit

    // MARK: aria attributes
    // https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes
    enum ariaattribute : HTMLInitializable {
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

        public init?(key: String, arguments: LabeledExprListSyntax) {
            let expression:ExprSyntax = arguments.first!.expression
            func string() -> String         { expression.stringLiteral!.string }
            func boolean() -> Bool          { expression.booleanLiteral!.literal.text == "true" }
            func enumeration<T : HTMLInitializable>() -> T {
                let function:FunctionCallExprSyntax = expression.functionCall!
                return T(key: function.calledExpression.memberAccess!.declName.baseName.text, arguments: function.arguments)!
            }
            func int() -> Int               { Int(expression.integerLiteral!.literal.text) ?? -1 }
            func array_string() -> [String] { expression.array!.elements.map({ $0.expression.stringLiteral!.string }) }
            func float() -> Float           { Float(expression.floatLiteral!.literal.text) ?? -1 }
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

        public var htmlValue : String? {
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
    enum ariarole : String, HTMLInitializable {
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
    enum `as` : String, HTMLInitializable {
        case audio, document, embed, fetch, font, image, object, script, style, track, video, worker
    }

    // MARK: autocapitalize
    enum autocapitalize : String, HTMLInitializable {
        case on, off
        case none
        case sentences, words, characters
    }

    // MARK: autocomplete
    enum autocomplete : String, HTMLInitializable {
        case off, on
    }

    // MARK: autocorrect
    enum autocorrect : String, HTMLInitializable {
        case off, on
    }

    // MARK: blocking
    enum blocking : String, HTMLInitializable {
        case render
    }

    // MARK: buttontype
    enum buttontype : String, HTMLInitializable {
        case submit, reset, button
    }

    // MARK: capture
    enum capture : String, HTMLInitializable{
        case user, environment
    }

    // MARK: command
    enum command : HTMLInitializable {
        case showModal
        case close
        case showPopover
        case hidePopover
        case togglePopover
        case custom(String)

        public init?(key: String, arguments: LabeledExprListSyntax) {
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

        public var htmlValue : String? {
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
    enum contenteditable : String, HTMLInitializable {
        case `true`, `false`
        case plaintextOnly

        public var htmlValue : String? {
            switch self {
                case .plaintextOnly: return "plaintext-only"
                default:             return rawValue
            }
        }
    }

    // MARK: controlslist
    enum controlslist : String, HTMLInitializable {
        case nodownload, nofullscreen, noremoteplayback
    }

    // MARK: crossorigin
    enum crossorigin : String, HTMLInitializable {
        case anonymous
        case useCredentials

        public var htmlValue : String? {
            switch self {
                case .useCredentials: return "use-credentials"
                default:              return rawValue
            }
        }
    }

    // MARK: decoding
    enum decoding : String, HTMLInitializable {
        case sync, async, auto
    }

    // MARK: dir
    enum dir : String, HTMLInitializable {
        case auto, ltr, rtl
    }

    // MARK: dirname
    enum dirname : String, HTMLInitializable {
        case ltr, rtl
    }

    // MARK: draggable
    enum draggable : String, HTMLInitializable {
        case `true`, `false`
    }

    // MARK: download
    enum download : HTMLInitializable {
        case empty
        case filename(String)

        public init?(key: String, arguments: LabeledExprListSyntax) {
            switch key {
                case "empty":    self = .empty
                case "filename": self = .filename(arguments.first!.expression.stringLiteral!.string)
                default:         return nil
            }
        }

        public var key : String {
            switch self {
                case .empty:       return "empty"
                case .filename(_): return "filename"
            }
        }

        public var htmlValue : String? {
            switch self {
                case .empty: return ""
                case .filename(let value): return value
            }
        }
    }

    // MARK: enterkeyhint
    enum enterkeyhint : String, HTMLInitializable {
        case enter, done, go, next, previous, search, send
    }

    // MARK: event
    enum event : String, HTMLInitializable {
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
    enum fetchpriority : String, HTMLInitializable {
        case high, low, auto
    }

    // MARK: formenctype
    enum formenctype : String, HTMLInitializable {
        case applicationXWWWFormURLEncoded
        case multipartFormData
        case textPlain

        public var htmlValue : String? {
            switch self {
                case .applicationXWWWFormURLEncoded: return "application/x-www-form-urlencoded"
                case .multipartFormData:             return "multipart/form-data"
                case .textPlain:                     return "text/plain"
            }
        }
    }

    // MARK: formmethod
    enum formmethod : String, HTMLInitializable {
        case get, post, dialog
    }

    // MARK: formtarget
    enum formtarget : String, HTMLInitializable {
        case _self, _blank, _parent, _top
    }

    // MARK: hidden
    enum hidden : String, HTMLInitializable {
        case `true`
        case untilFound

        public var htmlValue : String? {
            switch self {
                case .true: return ""
                case .untilFound: return "until-found"
            }
        }
    }

    // MARK: httpequiv
    enum httpequiv : String, HTMLInitializable {
        case contentSecurityPolicy
        case contentType
        case defaultStyle
        case xUACompatible
        case refresh

        public var htmlValue : String? {
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
    enum inputmode : String, HTMLInitializable {
        case none, text, decimal, numeric, tel, search, email, url
    }
    
    // MARK: inputtype
    enum inputtype : String, HTMLInitializable {
        case button, checkbox, color, date
        case datetimeLocal
        case email, file, hidden, image, month, number, password, radio, range, reset, search, submit, tel, text, time, url, week

        public var htmlValue : String? {
            switch self {
                case .datetimeLocal: return "datetime-local"
                default: return rawValue
            }
        }
    }

    // MARK: kind
    enum kind : String, HTMLInitializable {
        case subtitles, captions, chapters, metadata
    }

    // MARK: loading
    enum loading : String, HTMLInitializable {
        case eager, lazy
    }

    // MARK: numberingtype
    enum numberingtype : String, HTMLInitializable {
        case a, A, i, I, one

        public var htmlValue : String? {
            switch self {
                case .one: return "1"
                default:   return rawValue
            }
        }
    }

    // MARK: popover
    enum popover : String, HTMLInitializable {
        case auto, manual
    }

    // MARK: popovertargetaction
    enum popovertargetaction : String, HTMLInitializable {
        case hide, show, toggle
    }

    // MARK: preload
    enum preload : String, HTMLInitializable {
        case none, metadata, auto
    }

    // MARK: referrerpolicy
    enum referrerpolicy : String, HTMLInitializable {
        case noReferrer
        case noReferrerWhenDowngrade
        case origin
        case originWhenCrossOrigin
        case sameOrigin
        case strictOrigin
        case strictOriginWhenCrossOrigin
        case unsafeURL

        public var htmlValue : String? {
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
    enum rel : String, HTMLInitializable {
        case alternate, author, bookmark, canonical
        case dnsPrefetch
        case external, expect, help, icon, license
        case manifest, me, modulepreload, next, nofollow, noopener, noreferrer
        case opener, pingback, preconnect, prefetch, preload, prerender, prev
        case privacyPolicy
        case search, stylesheet, tag
        case termsOfService

        public var htmlValue : String? {
            switch self {
                case .dnsPrefetch:    return "dns-prefetch"
                case .privacyPolicy:  return "privacy-policy"
                case .termsOfService: return "terms-of-service"
                default:               return rawValue
            }
        }
    }

    // MARK: sandbox
    enum sandbox : String, HTMLInitializable {
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

        public var htmlValue : String? {
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
    enum scripttype : String, HTMLInitializable {
        case importmap, module, speculationrules
    }

    // MARK: scope
    enum scope : String, HTMLInitializable {
        case row, col, rowgroup, colgroup
    }

    // MARK: shadowrootmode
    enum shadowrootmode : String, HTMLInitializable {
        case open, closed
    }

    // MARK: shadowrootclonable
    enum shadowrootclonable : String, HTMLInitializable {
        case `true`, `false`
    }

    // MARK: shape
    enum shape : String, HTMLInitializable {
        case rect, circle, poly, `default`
    }

    // MARK: spellcheck
    enum spellcheck : String, HTMLInitializable {
        case `true`, `false`
    }

    // MARK: target
    enum target : String, HTMLInitializable {
        case _self, _blank, _parent, _top, _unfencedTop
    }

    // MARK: translate
    enum translate : String, HTMLInitializable {
        case yes, no
    }

    // MARK: virtualkeyboardpolicy
    enum virtualkeyboardpolicy : String, HTMLInitializable {
        case auto, manual
    }

    // MARK: wrap
    enum wrap : String, HTMLInitializable {
        case hard, soft
    }

    // MARK: writingsuggestions
    enum writingsuggestions : String, HTMLInitializable {
        case `true`, `false`
    }
}