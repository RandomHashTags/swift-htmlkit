
import HTMLAttributes
import HTMLKitUtilities

/// An HTML element.
public protocol HTMLElement: CustomStringConvertible, Sendable {
    /// Remapped attribute names.
    static var otherAttributes: [String:String] { get }

    var encoding: HTMLEncoding { get }
    var fromMacro: Bool { get }

    /// Whether or not this element is a void element.
    var isVoid: Bool { get }

    /// Whether or not this element should include a forward slash in the tag name.
    var trailingSlash: Bool { get }

    /// Whether or not to HTML escape the `<` and `>` characters directly adjacent of the opening and closing tag names when rendering.
    var escaped: Bool { get set }

    /// This element's tag name.
    var tag: String { get }

    /// The global attributes of this element.
    var attributes: [HTMLAttribute] { get }

    /// The inner HTML content of this element.
    var innerHTML: [CustomStringConvertible & Sendable] { get }

    init(_ encoding: HTMLEncoding, _ data: HTMLKitUtilities.ElementData)
}

extension HTMLElement {
    public static var otherAttributes: [String:String] {
        return [:]
    }
    @inlinable
    func render(
        prefix: String = "",
        suffix: String = "",
        items: [String]
    ) -> String {
        let l:String, g:String
        if escaped {
            l = "&lt;"
            g = "&gt;"
        } else {
            l = "<"
            g = ">"
        }
        var s:String = ""
        if !prefix.isEmpty {
            s += l + prefix + g
        }
        s += l + tag
        for attr in self.attributes {
            if let v = attr.htmlValue(encoding: encoding, forMacro: fromMacro) {
                let d = attr.htmlValueDelimiter(encoding: encoding, forMacro: fromMacro)
                s += " " + attr.key + (attr.htmlValueIsVoidable && v.isEmpty ? "" : "=" + d + v + d)
            }
        }
        for item in items {
            s += " " + item
        }
        if isVoid && trailingSlash {
            s += " /"
        }
        s += g
        for i in innerHTML {
            s += String(describing: i)
        }
        if !suffix.isEmpty {
            s += l + suffix + g
        }
        return s
    }
}