//
//  CustomElement.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLAttributes
import HTMLKitUtilities

// MARK: custom
/// A custom HTML element.
public struct custom : HTMLElement {
    public static let otherAttributes:[String:String] = [:]
    
    public let tag:String
    public var attributes:[HTMLAttribute]
    public var innerHTML:[CustomStringConvertible & Sendable]

    @usableFromInline internal var encoding:HTMLEncoding = .string
    public var isVoid:Bool
    public var trailingSlash:Bool
    public var escaped:Bool = false

    @usableFromInline internal var fromMacro:Bool = false

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
        _ innerHTML: CustomStringConvertible...
    ) {
        self.tag = tag
        self.isVoid = isVoid
        trailingSlash = attributes.contains(.trailingSlash)
        self.attributes = attributes
        self.innerHTML = innerHTML
    }

    @inlinable
    public var description : String {
        let attributes_string:String = self.attributes.compactMap({
            guard let v:String = $0.htmlValue(encoding: encoding, forMacro: fromMacro) else { return nil }
            let delimiter:String = $0.htmlValueDelimiter(encoding: encoding, forMacro: fromMacro)
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
        return l + tag + (isVoid && trailingSlash ? " /" : "") + g + (attributes_string.isEmpty ? "" : " " + attributes_string) + (isVoid ? "" : l + "/" + tag + g)
    }
}