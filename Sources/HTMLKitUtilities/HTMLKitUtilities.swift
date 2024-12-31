//
//  HTMLKitUtilities.swift
//
//
//  Created by Evan Anderson on 9/19/24.
//

import SwiftSyntax
import SwiftSyntaxMacros

// MARK: HTMLKitUtilities
public enum HTMLKitUtilities {
    public struct ElementData {
        public let encoding:HTMLEncoding
        public let globalAttributes:[HTMLElementAttribute]
        public let attributes:[String:Any]
        public let innerHTML:[CustomStringConvertible]
        public let trailingSlash:Bool

        init(
            _ encoding: HTMLEncoding,
            _ globalAttributes: [HTMLElementAttribute],
            _ attributes: [String:Any],
            _ innerHTML: [CustomStringConvertible],
            _ trailingSlash: Bool
        ) {
            self.encoding = encoding
            self.globalAttributes = globalAttributes
            self.attributes = attributes
            self.innerHTML = innerHTML
            self.trailingSlash = trailingSlash
        }
    }
}

// MARK: Escape HTML
public extension String {
    /// Escapes all occurrences of source-breaking HTML characters.
    /// 
    /// - Parameters:
    ///   - escapeAttributes: Whether or not to escape source-breaking HTML attribute characters.
    /// - Returns: A new `String` escaping source-breaking HTML.
    func escapingHTML(escapeAttributes: Bool) -> String {
        var string:String = self
        string.escapeHTML(escapeAttributes: escapeAttributes)
        return string
    }

    /// Escapes all occurrences of source-breaking HTML characters.
    /// 
    /// - Parameters:
    ///   - escapeAttributes: Whether or not to escape source-breaking HTML attribute characters.
    mutating func escapeHTML(escapeAttributes: Bool) {
        self.replace("&", with: "&amp;")
        self.replace("<", with: "&lt;")
        self.replace(">", with: "&gt;")
        if escapeAttributes {
            self.escapeHTMLAttributes()
        }
    }

    /// Escapes all occurrences of source-breaking HTML attribute characters.
    /// 
    /// - Returns: A new `String` escaping source-breaking HTML attribute characters.
    func escapingHTMLAttributes() -> String {
        var string:String = self
        string.escapeHTMLAttributes()
        return string
    }

    /// Escapes all occurrences of source-breaking HTML attribute characters.
    mutating func escapeHTMLAttributes() {
        self.replace("\\\"", with: "&quot;")
        self.replace("\"", with: "&quot;")
        self.replace("'", with: "&#39")
    }
}