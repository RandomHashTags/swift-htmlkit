//
//  CustomElements.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLAttributes
import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

// MARK: svg
/// The `svg` HTML element.
// TODO: finish
struct svg : HTMLElement {
    public static let otherAttributes:[String:String] = [:]
    
    public let tag:String = "svg"
    public var attributes:[HTMLAttribute]
    public var innerHTML:[CustomStringConvertible & Sendable]
    public var height:String?
    public var preserveAspectRatio:Attributes.PreserveAspectRatio?
    public var viewBox:String?
    public var width:String?
    public var x:String?
    public var y:String?

    @usableFromInline internal var encoding:HTMLEncoding = .string
    public let isVoid:Bool = false
    public var trailingSlash:Bool
    public var escaped:Bool = false

    @usableFromInline internal var fromMacro:Bool = false

    public init(_ encoding: HTMLEncoding, _ data: HTMLKitUtilities.ElementData) {
        self.encoding = encoding
        fromMacro = true
        trailingSlash = data.trailingSlash
        attributes = data.globalAttributes
        innerHTML = data.innerHTML
    }
    public init(
        attributes: [HTMLAttribute] = [],
        _ innerHTML: CustomStringConvertible...
    ) {
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

// MARK: Attributes
extension svg {
    public enum Attributes {
        public enum PreserveAspectRatio : HTMLInitializable {
            case none
            case xMinYMin(Keyword?)
            case xMidYMin(Keyword?)
            case xMaxYMin(Keyword?)
            case xMinYMid(Keyword?)
            case xMidYMid(Keyword?)
            case xMaxYMid(Keyword?)
            case xMinYMax(Keyword?)
            case xMidYMax(Keyword?)
            case xMaxYMax(Keyword?)

            public var key : String { "" }
            @inlinable public var htmlValueIsVoidable : Bool { false }

            @inlinable
            public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
                switch self {
                case .none: return "none"
                case .xMinYMin(let v),
                        .xMidYMin(let v),
                        .xMaxYMin(let v),
                        .xMinYMid(let v),
                        .xMidYMid(let v),
                        .xMaxYMid(let v),
                        .xMinYMax(let v),
                        .xMidYMax(let v),
                        .xMaxYMax(let v):
                    return v?.rawValue
                }
            }
        }

        public enum Keyword : String, HTMLParsable {
            case meet
            case slice
        }
    }
}