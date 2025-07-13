
import HTMLAttributes
import HTMLKitUtilities

// MARK: custom
/// A custom HTML element.
public struct custom: HTMLElement {
    public static let otherAttributes = [String:String]()
    
    public let tag:String
    public var attributes:[HTMLAttribute]
    public var innerHTML:[Sendable]

    public private(set) var encoding = HTMLEncoding.string
    public var isVoid:Bool
    public var trailingSlash:Bool
    public var escaped = false

    public private(set) var fromMacro = false

    public init(_ encoding: HTMLEncoding, _ data: HTMLKitUtilities.ElementData) {
        self.encoding = encoding
        fromMacro = true
        tag = data.attributes["tag"] as? String ?? ""
        isVoid = data.attributes["isVoid"] as? Bool ?? false
        trailingSlash = data.trailingSlash
        attributes = data.globalAttributes
        innerHTML = data.innerHTML
    }
    public init(
        tag: String,
        isVoid: Bool,
        attributes: [HTMLAttribute] = [],
        _ innerHTML: Sendable...
    ) {
        self.tag = tag
        self.isVoid = isVoid
        trailingSlash = attributes.contains(.trailingSlash)
        self.attributes = attributes
        self.innerHTML = innerHTML
    }

    @inlinable
    public var description: String {
        let attributesString = self.attributes.compactMap({
            guard let v = $0.htmlValue(encoding: encoding, forMacro: fromMacro) else { return nil }
            let delimiter = $0.htmlValueDelimiter(encoding: encoding, forMacro: fromMacro)
            return $0.key + ($0.htmlValueIsVoidable && v.isEmpty ? "" : "=\(delimiter)\(v)\(delimiter)")
        }).joined(separator: " ")
        let l:String, g:String
        if escaped {
            l = "&lt;"
            g = "&gt;"
        } else {
            l = "<"
            g = ">"
        }
        return l + tag + (isVoid && trailingSlash ? " /" : "") + g + (attributesString.isEmpty ? "" : " " + attributesString) + (isVoid ? "" : l + "/" + tag + g)
    }
}