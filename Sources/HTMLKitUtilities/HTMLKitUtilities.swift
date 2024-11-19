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
        public let htmlValue:String?

        private init(_ value: Float) {
            htmlValue = value.description
        }
    }
}
public extension HTMLElementAttribute.CSSUnit { // https://www.w3schools.com/cssref/css_units.php
    // absolute
    static func centimeters(_ value: Float) -> Self { Self(value) }
    static func millimeters(_ value: Float) -> Self { Self(value) }
    /// 1 inch = 96px = 2.54cm
    static func inches(_ value: Float) -> Self      { Self(value) }
    /// 1 pixel = 1/96th of 1inch
    static func pixels(_ value: Float) -> Self      { Self(value) }
    /// 1 point = 1/72 of 1inch
    static func points(_ value: Float) -> Self      { Self(value) }
    /// 1 pica = 12 points
    static func picas(_ value: Float) -> Self       { Self(value) }
    
    // relative
    /// Relative to the font-size of the element (2em means 2 times the size of the current font)
    static func em(_ value: Float) -> Self             { Self(value) }
    /// Relative to the x-height of the current font (rarely used)
    static func ex(_ value: Float) -> Self             { Self(value) }
    /// Relative to the width of the "0" (zero)
    static func ch(_ value: Float) -> Self             { Self(value) }
    /// Relative to font-size of the root element
    static func rem(_ value: Float) -> Self            { Self(value) }
    /// Relative to 1% of the width of the viewport
    static func viewportWidth(_ value: Float) -> Self  { Self(value) }
    /// Relative to 1% of the height of the viewport
    static func viewportHeight(_ value: Float) -> Self { Self(value) }
    /// Relative to 1% of viewport's smaller dimension
    static func viewportMin(_ value: Float) -> Self    { Self(value) }
    /// Relative to 1% of viewport's larger dimension
    static func viewportMax(_ value: Float) -> Self    { Self(value) }
    /// Relative to the parent element
    static func percent(_ value: Float) -> Self        { Self(value) }
}


// MARK: HTMLElementType
package enum HTMLElementType : String, CaseIterable {
    case escapeHTML

    case html, htmlUTF8Bytes, htmlUTF16Bytes, htmlUTF8CString
    
    #if canImport(Foundation)
    case htmlData
    #endif

    case htmlByteBuffer
    
    case a
    case abbr
    case address
    case area
    case article
    case aside
    case audio

    case b
    case base
    case bdi
    case bdo
    case blockquote
    case body
    case br
    case button

    case canvas
    case caption
    case cite
    case code
    case col
    case colgroup

    case data
    case datalist
    case dd
    case del
    case details
    case dfn
    case dialog
    case div
    case dl
    case dt

    case em
    case embed

    case fencedframe
    case fieldset
    case figcaption
    case figure
    case footer
    case form

    case h1, h2, h3, h4, h5, h6
    case head
    case header
    case hgroup
    case hr
    
    case i
    case iframe
    case img
    case input
    case ins

    case kbd

    case label
    case legend
    case li
    case link

    case main
    case map
    case mark
    case menu
    case meta
    case meter

    case nav
    case noscript

    case object
    case ol
    case optgroup
    case option
    case output

    case p
    case picture
    case portal
    case pre
    case progress

    case q

    case rp
    case rt
    case ruby
    
    case s
    case samp
    case script
    case search
    case section
    case select
    case slot
    case small
    case source
    case span
    case strong
    case style
    case sub
    case summary
    case sup

    case table
    case tbody
    case td
    case template
    case textarea
    case tfoot
    case th
    case thead
    case time
    case title
    case tr
    case track

    case u
    case ul

    case `var`
    case video

    case wbr

    package var isVoid : Bool {
        switch self {
        case .area, .base, .br, .col, .embed, .hr, .img, .input, .link, .meta, .source, .track, .wbr:
            return true
        default:
            return false
        }
    }
}
// MARK: HTMLElementValueType
package indirect enum HTMLElementValueType {
    case string
    case int
    case float
    case bool
    case booleanDefaultValue(Bool)
    case attribute
    case otherAttribute(String)
    case cssUnit
    case array(of: HTMLElementValueType)

    private static func cleanup(_ range: inout Substring) {
        while (range.first?.isWhitespace ?? false) || range.first == "," {
            range.removeFirst()
        }
    }
    static func consumable(key: String, range: inout Substring) -> Bool {
        guard range.hasPrefix(key + ":") else { return false }
        range = range[range.index(range.startIndex, offsetBy: key.count+1)...]
        cleanup(&range)
        return true
    }
    static func consume(_ range: inout Substring, length: Int) -> String {
        let slice:Substring = range[range.startIndex..<range.index(range.startIndex, offsetBy: length)]
        range = range[range.index(range.startIndex, offsetBy: length)...]
        cleanup(&range)
        return String(slice)
    }
    static func cString(key: String, _ range: inout Substring) -> String? {
        guard consumable(key: key, range: &range) else { return nil }
        guard !range.isEmpty else { return "" }
        while !range.isEmpty && range.first != "\"" {
            range.removeFirst()
        }
        guard !range.isEmpty else { return "" }
        range.removeFirst() // "
        guard let index:Substring.Index = range.firstIndex(of: ",") ?? range.firstIndex(of: ")") else { return nil }
        var string:String = String(range[range.startIndex..<index])
        range.removeFirst(string.count + 1)
        if string.last == "\"" {
            string.removeLast()
        }
        cleanup(&range)
        return string
    }
    static func cBool(key: String, _ range: inout Substring) -> Bool {
        guard consumable(key: key, range: &range) else { return false }
        if range.hasPrefix("true") {
            _ = consume(&range, length: 4)
            return true
        }
        if range.hasPrefix("false") {
            _ = consume(&range, length: 5)
            return false
        }
        return false
    }
    static func cInt(key: String, _ range: inout Substring) -> Int? {
        guard consumable(key: key, range: &range) else { return nil }
        var string:String = ""
        while (range.first?.isNumber ?? false) || range.first == "_" {
            string.append(range.removeFirst())
        }
        cleanup(&range)
        return Int(string)
    }
    static func cFloat(key: String, _ range: inout Substring) -> Float? {
        guard consumable(key: key, range: &range) else { return nil }
        guard range.first?.isNumber ?? false else { return nil }
        var string:String = ""
        while (range.first?.isNumber ?? false) || range.first == "." || range.first == "_" {
            string.append(range.removeFirst())
        }
        cleanup(&range)
        return Float(string)
    }
    static func cAttribute<T: HTMLInitializable>(key: String, _ range: inout Substring) -> T? {
        guard consumable(key: key, range: &range) else { return nil }
        while range.first == "." {
            range.removeFirst()
        }
        var string:String = "", depth:Int = 1
        while let char:Character = range.first {
            if char == "(" {
                depth += 1
            } else if char == ")" {
                depth -= 1
            }
            if depth == 0 {
                break
            } else if depth == 1 && char == "," {
                break
            }
            string.append(range.removeFirst())
        }
        guard let value:T = T(rawValue: string) else { return nil }
        cleanup(&range)
        return value
    }
    static func cArray<T>(key: String, _ range: inout Substring, parse: (String) -> T?) -> [T] {
        guard consumable(key: key, range: &range), range.first == "[" else { return [] }
        range.removeFirst()
        var string:String = "", depth:Int = 1
        while let char:Character = range.first {
            if char == "[" {
                depth += 1
            } else if char == "]" {
                depth -= 1
                if depth == 0 {
                    range.removeFirst()
                    break
                }
            }
            string.append(range.removeFirst())
        }
        var values:[T] = []
        for var ss in string.split(separator: ",") {
            while ss.first?.isWhitespace ?? false {
                ss.removeFirst()
            }
            if let value:T = parse(String(ss)) {
                values.append(value)
            }
        }
        cleanup(&range)
        return values
    }
    static func cInnerHTML(_ range: inout Substring) -> String {
        cleanup(&range)
        var values:[String] = []
        while let char:Character = range.first {
            if char == "\"" {
                range.removeFirst()
                if let index:Substring.Index = range.firstIndex(of: "\"") {
                    let string:String = consume(&range, length: range.distance(from: range.startIndex, to: index))
                    range.removeFirst() // "
                    values.append(string)
                }
            } else if let parenth:Substring.Index = range.firstIndex(of: "(") {
                let key:String = String(range[range.startIndex..<parenth])
                if HTMLElementType(rawValue: key) != nil || key == "custom" {
                    var depth:Int = 0
                    var string:String = ""
                    while let character:Character = range.first {
                        if character == "(" {
                            depth += 1
                        } else if character == ")" {
                            depth -= 1
                            if depth == 0 {
                                string.append(range.removeFirst())
                                break
                            }
                        }
                        string.append(range.removeFirst())
                    }
                    if let element:HTMLElement = parse_element(rawValue: string) {
                        values.append(element.description)
                    }
                } else {
                    range.removeFirst()
                }
            } else {
                range.removeFirst()
            }
        }
        return values.joined()
    }
    // MARK: Parse element
    package static func parse_element(rawValue: String) -> HTMLElement? {
        guard let key:Substring = rawValue.split(separator: "(").first else { return nil }
        switch key {
            case "a": return a(rawValue: rawValue)
            case "abbr": return abbr(rawValue: rawValue)
            case "address": return address(rawValue: rawValue)
            case "area": return area(rawValue: rawValue)
            case "article": return article(rawValue: rawValue)
            case "aside": return aside(rawValue: rawValue)
            case "audio": return audio(rawValue: rawValue)
            case "b": return b(rawValue: rawValue)
            case "base": return base(rawValue: rawValue)
            case "bdi": return bdi(rawValue: rawValue)
            case "bdo": return bdo(rawValue: rawValue)
            case "blockquote": return blockquote(rawValue: rawValue)
            case "body": return body(rawValue: rawValue)
            case "br": return br(rawValue: rawValue)
            case "button": return button(rawValue: rawValue)
            case "canvas": return canvas(rawValue: rawValue)
            case "caption": return caption(rawValue: rawValue)
            case "cite": return cite(rawValue: rawValue)
            case "code": return code(rawValue: rawValue)
            case "col": return col(rawValue: rawValue)
            case "colgroup": return colgroup(rawValue: rawValue)
            case "data": return data(rawValue: rawValue)
            case "datalist": return datalist(rawValue: rawValue)
            case "dd": return dd(rawValue: rawValue)
            case "del": return del(rawValue: rawValue)
            case "details": return details(rawValue: rawValue)
            case "dfn": return dfn(rawValue: rawValue)
            case "dialog": return dialog(rawValue: rawValue)
            case "div": return div(rawValue: rawValue)
            case "dl": return dl(rawValue: rawValue)
            case "dt": return dt(rawValue: rawValue)
            case "em": return em(rawValue: rawValue)
            case "embed": return embed(rawValue: rawValue)
            case "fencedframe": return fencedframe(rawValue: rawValue)
            case "fieldset": return fieldset(rawValue: rawValue)
            case "figcaption": return figcaption(rawValue: rawValue)
            case "figure": return figure(rawValue: rawValue)
            case "footer": return footer(rawValue: rawValue)
            case "form": return form(rawValue: rawValue)
            case "h1": return h1(rawValue: rawValue)
            case "h2": return h2(rawValue: rawValue)
            case "h3": return h3(rawValue: rawValue)
            case "h4": return h4(rawValue: rawValue)
            case "h5": return h5(rawValue: rawValue)
            case "h6": return h6(rawValue: rawValue)
            case "head": return head(rawValue: rawValue)
            case "header": return header(rawValue: rawValue)
            case "hgroup": return hgroup(rawValue: rawValue)
            case "hr": return hr(rawValue: rawValue)
            case "i": return i(rawValue: rawValue)
            case "iframe": return iframe(rawValue: rawValue)
            case "img": return img(rawValue: rawValue)
            case "input": return input(rawValue: rawValue)
            case "ins": return ins(rawValue: rawValue)
            case "kbd": return kbd(rawValue: rawValue)
            case "label": return label(rawValue: rawValue)
            case "legend": return legend(rawValue: rawValue)
            case "li": return li(rawValue: rawValue)
            case "link": return link(rawValue: rawValue)
            case "main": return main(rawValue: rawValue)
            case "map": return map(rawValue: rawValue)
            case "mark": return mark(rawValue: rawValue)
            case "menu": return menu(rawValue: rawValue)
            case "meta": return meta(rawValue: rawValue)
            case "meter": return meter(rawValue: rawValue)
            case "nav": return nav(rawValue: rawValue)
            case "noscript": return noscript(rawValue: rawValue)
            case "object": return object(rawValue: rawValue)
            case "ol": return ol(rawValue: rawValue)
            case "optgroup": return optgroup(rawValue: rawValue)
            case "option": return option(rawValue: rawValue)
            case "output": return output(rawValue: rawValue)
            case "p": return p(rawValue: rawValue)
            case "picture": return picture(rawValue: rawValue)
            case "portal": return portal(rawValue: rawValue)
            case "pre": return pre(rawValue: rawValue)
            case "progress": return progress(rawValue: rawValue)
            case "q": return q(rawValue: rawValue)
            case "rp": return rp(rawValue: rawValue)
            case "rt": return rt(rawValue: rawValue)
            case "ruby": return ruby(rawValue: rawValue)
            case "s": return s(rawValue: rawValue)
            case "samp": return samp(rawValue: rawValue)
            case "script": return script(rawValue: rawValue)
            case "search": return search(rawValue: rawValue)
            case "section": return section(rawValue: rawValue)
            case "select": return select(rawValue: rawValue)
            case "slot": return slot(rawValue: rawValue)
            case "small": return small(rawValue: rawValue)
            case "source": return source(rawValue: rawValue)
            case "span": return span(rawValue: rawValue)
            case "strong": return strong(rawValue: rawValue)
            case "style": return style(rawValue: rawValue)
            case "sub": return sub(rawValue: rawValue)
            case "summary": return summary(rawValue: rawValue)
            case "sup": return sup(rawValue: rawValue)
            case "table": return table(rawValue: rawValue)
            case "tbody": return tbody(rawValue: rawValue)
            case "td": return td(rawValue: rawValue)
            case "template": return template(rawValue: rawValue)
            case "textarea": return textarea(rawValue: rawValue)
            case "tfoot": return tfoot(rawValue: rawValue)
            case "th": return th(rawValue: rawValue)
            case "thead": return thead(rawValue: rawValue)
            case "time": return time(rawValue: rawValue)
            case "title": return title(rawValue: rawValue)
            case "tr": return tr(rawValue: rawValue)
            case "track": return track(rawValue: rawValue)
            case "u": return u(rawValue: rawValue)
            case "ul": return ul(rawValue: rawValue)
            //case "var": return `var`(rawValue: rawValue)
            case "video": return video(rawValue: rawValue)
            case "wbr": return wbr(rawValue: rawValue)

            case "custom": return custom(rawValue: rawValue)
            default:        return nil
        }
    }
}

// MARK: HTMLElement Attributes
public enum HTMLElementAttribute {
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
    case part([(String)] = [])
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

    public var key : String {
        switch self {
            case .accesskey(_):             return "accesskey"
            case .ariaattribute(_):         return "aria-attribute"
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

            case .htmx(let htmx):           return "htmx-" + htmx.key
            case .custom(let id, _):        return id
            case .event(let event, _):      return "on" + event.rawValue
        }
    }

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

    static func literal(key: Substring, rawValue: String) -> String {
        let start:String.Index = rawValue.startIndex, end:String.Index = rawValue.index(before: rawValue.endIndex)
        return String(rawValue[rawValue.index(start, offsetBy: key.count + 2)..<end])
    }
    static func string(key: Substring, rawValue: String) -> String {
        let start:String.Index = rawValue.startIndex, end:String.Index = rawValue.index(before: rawValue.endIndex), end_minus_one:String.Index = rawValue.index(before: end)
        return String(rawValue[rawValue.index(start, offsetBy: key.count + 2)..<end_minus_one])
    }
    static func boolean(key: Substring, rawValue: String) -> Bool {
        let start:String.Index = rawValue.startIndex, end:String.Index = rawValue.index(before: rawValue.endIndex)
        return rawValue[rawValue.index(start, offsetBy: key.count + 1)..<end] == "true"
    }
    static func enumeration<T : RawRepresentable>(key: Substring, rawValue: String) -> T where T.RawValue == String {
        let start:String.Index = rawValue.startIndex, end:String.Index = rawValue.index(before: rawValue.endIndex)
        return T(rawValue: String(rawValue[rawValue.index(start, offsetBy: key.count + 2)..<end]))!
    }
    static func int(key: Substring, rawValue: String) -> Int {
        let start:String.Index = rawValue.startIndex, end:String.Index = rawValue.index(before: rawValue.endIndex)
        return Int(rawValue[rawValue.index(start, offsetBy: key.count + 1)..<end])!
    }
    static func array_string(key: Substring, rawValue: String) -> [String] {
        let string:String = string(key: key, rawValue: rawValue)
        let ranges:[Range<String.Index>] = try! string.ranges(of: Regex("\"([^\"]+)\"")) // TODO: fix? (doesn't parse correctly if the string contains escaped quotation marks)
        return ranges.map({
            let item:String = String(string[$0])
            return String(item[item.index(after: item.startIndex)..<item.index(before: item.endIndex)])
        })
    }
    static func float(key: Substring, rawValue: String) -> Float {
        let start:String.Index = rawValue.startIndex, end:String.Index = rawValue.index(before: rawValue.endIndex)
        return Float(rawValue[rawValue.index(start, offsetBy: key.count + 1)..<end])!
    }
}
public protocol HTMLInitializable {
    init?(rawValue: String)

    var key : String { get }
    var htmlValue : String? { get }
}
public extension HTMLInitializable where Self: RawRepresentable, RawValue == String {
    var key : String { rawValue }
    var htmlValue : String? { rawValue }
}
public extension HTMLElementAttribute.Extra {
    typealias height = HTMLElementAttribute.CSSUnit
    typealias width = HTMLElementAttribute.CSSUnit

    // MARK: aria attributes (states and properties)
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

        public init?(rawValue: String) {
            guard rawValue.last == ")" else { return nil }
            let key:Substring = rawValue.split(separator: "(")[0]
            func string() -> String         { HTMLElementAttribute.string(key: key, rawValue: rawValue) }
            func boolean() -> Bool          { HTMLElementAttribute.boolean(key: key, rawValue: rawValue) }
            func enumeration<T : RawRepresentable>() -> T where T.RawValue == String { HTMLElementAttribute.enumeration(key: key, rawValue: rawValue) }
            func int() -> Int               { HTMLElementAttribute.int(key: key, rawValue: rawValue) }
            func array_string() -> [String] { HTMLElementAttribute.array_string(key: key, rawValue: rawValue) }
            func float() -> Float           { HTMLElementAttribute.float(key: key, rawValue: rawValue) }
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