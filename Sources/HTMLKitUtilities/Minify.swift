//
//  Minify.swift
//
//
//  Created by Evan Anderson on 3/31/25.
//

import SwiftSyntax

extension HTMLKitUtilities {
    static let defaultPreservedWhitespaceTags:Set<String> = Set([
        "a", "abbr",
        "b", "bdi", "bdo", "button",
        "cite", "code",
        "data", "dd", "dfn", "dt",
        "em",
        "h1", "h2", "h3", "h4", "h5", "h6",
        "i",
        "kbd",
        "label", "li",
        "mark",
        "p",
        "q",
        "rp",
        "rt",
        "ruby",
        "s", "samp", "small", "span", "strong", "sub", "sup",
        "td", "time", "title", "tr",
        "u",
        "var",
        "wbr"
    ].map { "<" + $0 + ">" })

    /// Removes whitespace between elements.
    public static func minify(
        html: String,
        preservingWhitespaceForTags: Set<String> = []
    ) -> String {
        var preservedWhitespaceTags:Set<String> = Self.defaultPreservedWhitespaceTags
        preservedWhitespaceTags.formUnion(preservingWhitespaceForTags)
        var result:String = ""
        result.reserveCapacity(html.count)
        let tagRegex = "[^/>]+"
        let openElementRegex = "(<\(tagRegex)>)"
        let openElementRanges = html.ranges(of: try! Regex(openElementRegex))

        let closeElementRegex = "(</\(tagRegex)>)"
        let closeElementRanges = html.ranges(of: try! Regex(closeElementRegex))

        var openingRangeIndex = 0
        var ignoredClosingTags:Set<Range<String.Index>> = []
        for openingRange in openElementRanges {
            let tag = html[openingRange]
            result += tag
            let closure:(Character) -> Bool = preservedWhitespaceTags.contains(String(tag)) ? { _ in true } : {
                !($0.isWhitespace || $0.isNewline)
            }
            let closestClosingRange = closeElementRanges.first(where: { $0.lowerBound > openingRange.upperBound })
            if let nextOpeningRange = openElementRanges.get(openingRangeIndex + 1) {
                var i = openingRange.upperBound
                var lowerBound = nextOpeningRange.lowerBound
                if let closestClosingRange {
                    if closestClosingRange.upperBound < lowerBound {
                        lowerBound = closestClosingRange.upperBound
                    }
                    if closestClosingRange.lowerBound < nextOpeningRange.lowerBound {
                        ignoredClosingTags.insert(closestClosingRange)
                    }
                }
                // anything after the opening tag, upto the end of the next closing tag
                while i < lowerBound {
                    let char = html[i]
                    if closure(char) {
                        result.append(char)
                    }
                    html.formIndex(after: &i)
                }
                // anything after the closing tag and before the next opening tag
                while i < nextOpeningRange.lowerBound {
                    let char = html[i]
                    if !char.isNewline {
                        result.append(char)
                    }
                    html.formIndex(after: &i)
                }
            } else if let closestClosingRange {
                // anything after the opening tag and before the next closing tag
                let slice = html[openingRange.upperBound..<closestClosingRange.lowerBound]
                for char in slice {
                    if closure(char) {
                        result.append(char)
                    }
                }
            }
            openingRangeIndex += 1
        }
        for closingRange in closeElementRanges {
            if !ignoredClosingTags.contains(closingRange) {
                result += html[closingRange]
            }
        }
        return result
    }
}