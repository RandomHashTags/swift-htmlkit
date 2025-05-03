/*
//
//  a.swift
//
//
//  Generated 12 Jan 2025 at 3:36:21 PM GMT-6.
//

import SwiftSyntax

/// The `a` (_anchor_) HTML element.
/// 
/// [Its `href` attribute](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a#href) creates a hyperlink to web pages, files, email addresses, locations in the same page, or anything else a URL can address.
///  
/// Content within each `<a>` _should_ indicate the link's destination. If the `href` attribute is present, pressing the enter key while focused on the `<a>` element will activate it.
///  
/// [Read more](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a).
public struct a: HTMLElement {
    @usableFromInline internal var encoding:HTMLEncoding = .string
    
    /// Causes the browser to treat the linked URL as a download. Can be used with or without a `filename` value.
    /// 
    /// Without a value, the browser will suggest a filename/extension, generated from various sources:
    /// - The [`Content-Disposition`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Disposition) HTTP header
    /// - The final segment in the URL [path](https://developer.mozilla.org/en-US/docs/Web/API/URL/pathname)
    /// - The [media type](https://developer.mozilla.org/en-US/docs/Glossary/MIME_type) (from the [`Content-Type`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type) header, the start of a [`data:` URL](https://developer.mozilla.org/en-US/docs/Web/URI/Schemes/data), or [`Blob.type`](https://developer.mozilla.org/en-US/docs/Web/API/Blob/type) for a [`blob:` URL](https://developer.mozilla.org/en-US/docs/Web/API/URL/createObjectURL_static))
    public var download:HTMLElementAttribute.Extra.download? = nil
    public var href:String? = nil
    public var hrefLang:String? = nil
    public let tag:String = "a"
    public var type:String? = nil
    public var attributes:[HTMLElementAttribute] = []
    public var attributionsrc:[String] = []
    public var innerHTML:[CustomStringConvertible] = []
    public var ping:[String] = []
    public var rel:[HTMLElementAttribute.Extra.rel] = []
    public var escaped:Bool = false
    @usableFromInline internal var fromMacro:Bool = false
    public let isVoid:Bool = false
    public var referrerPolicy:HTMLElementAttribute.Extra.referrerpolicy? = nil
    public var target:HTMLElementAttribute.Extra.target? = nil
    public var trailingSlash:Bool = false

    @inlinable
    public var description: String {
        func attributes() -> String {
            let sd:String = encoding.stringDelimiter(forMacro: fromMacro)
            var items:[String] = self.attributes.compactMap({
                guard let v:String = $0.htmlValue(encoding: encoding, forMacro: fromMacro) else { return nil }
                let d:String = $0.htmlValueDelimiter(encoding: encoding, forMacro: fromMacro)
                return $0.key + ($0.htmlValueIsVoidable && v.isEmpty ? "" : "=" + d + v + d)
            })
            if let download, let v:String = download.htmlValue(encoding: encoding, forMacro: fromMacro) {
                let s:String = download.htmlValueIsVoidable && v.isEmpty ? "" : "=" + sd + v + sd
                items.append("download" + s)
            }
            if let href {
                items.append("href" + sd + href + sd)
            }
            if let hrefLang {
                items.append("hreflang" + sd + hrefLang + sd)
            }
            if let type {
                items.append("type" + sd + type + sd)
            }
            if !attributionsrc.isEmpty {
                var v:String = sd
                for e in attributionsrc {
                    v += e + " "
                }
                v.removeLast()
                items.append("attributionsrc=" + v + sd)
            }
            if !ping.isEmpty {
                var v:String = sd
                for e in ping {
                    v += e + " "
                }
                v.removeLast()
                items.append("ping=" + v + sd)
            }
            if !rel.isEmpty {
                var v:String = sd
                for e in rel {
                    if let e:String = e.htmlValue(encoding: encoding, forMacro: fromMacro) {
                        v += e + " "
                    }
                }
                v.removeLast()
                items.append("rel=" + v + sd)
            }
            if let referrerPolicy, let v:String = referrerPolicy.htmlValue(encoding: encoding, forMacro: fromMacro) {
                let s:String = referrerPolicy.htmlValueIsVoidable && v.isEmpty ? "" : "=" + sd + v + sd
                items.append("referrerpolicy" + s)
            }
            if let target, let v:String = target.htmlValue(encoding: encoding, forMacro: fromMacro) {
                let s:String = target.htmlValueIsVoidable && v.isEmpty ? "" : "=" + sd + v + sd
                items.append("target" + s)
            }
            return (items.isEmpty ? "" : " ") + items.joined(separator: " ")
        }
        let string:String = innerHTML.map({ String(describing: $0) }).joined()
        let l:String, g:String
        if escaped {
            l = "&lt;"
            g = "&gt;"
        } else {
            l = "<"
            g = ">"
        }
        return l + tag + attributes() + g + string + l + "/" + tag + g
    }
}

public extension a {
    enum AttributeKeys {
        case attributionsrc([String] = [])
        case download(HTMLElementAttribute.Extra.download? = nil)
        case fromMacro(Bool = false)
        case href(String? = nil)
        case hrefLang(String? = nil)
        case innerHTML([CustomStringConvertible] = [])
        case isVoid(Bool = false)
        case ping([String] = [])
        case referrerPolicy(HTMLElementAttribute.Extra.referrerpolicy? = nil)
        case rel([HTMLElementAttribute.Extra.rel] = [])
        case target(HTMLElementAttribute.Extra.target? = nil)
        case trailingSlash(Bool = false)
        case type(String? = nil)
    }
}*/