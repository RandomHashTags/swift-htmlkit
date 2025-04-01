//
//  Minify.swift
//
//
//  Created by Evan Anderson on 3/31/25.
//

extension HTMLKitUtilities {
    static let defaultPreservedWhitespaceTags:Set<Substring> = Set(Array<HTMLElementType>(arrayLiteral:
        .a, .abbr,
        .b, .bdi, .bdo, .button,
        .cite, .code,
        .data, .dd, .dfn, .dt,
        .em,
        .h1, .h2, .h3, .h4, .h5, .h6,
        .i,
        .kbd,
        .label, .li,
        .mark,
        .p,
        .q,
        .rp,
        .rt,
        .ruby,
        .s, .samp, .small, .span, .strong, .sub, .sup,
        .td, .time, .title, .tr,
        .u,
        .variable,
        .wbr
    ).map { "<" + $0.tagName + ">" })

    /// Removes whitespace between elements.
    public static func minify(
        html: String,
        preservingWhitespaceForTags: Set<Substring> = []
    ) -> String {
        var result:String = ""
        result.reserveCapacity(html.count)
        let tagRegex = "[^/>]+"
        let openElementRanges = html.ranges(of: try! Regex("(<\(tagRegex)>)"))
        let closeElementRanges = html.ranges(of: try! Regex("(</\(tagRegex)>)"))

        var openingRangeIndex = 0
        var ignoredClosingTags:Set<Range<String.Index>> = []
        for openingRange in openElementRanges {
            let tag = html[openingRange]
            result += tag
            let closure = Self.defaultPreservedWhitespaceTags.contains(tag) || preservingWhitespaceForTags.contains(tag) ? appendAll : appendIfPreserved
            let closestClosingRange = closeElementRanges.first(where: { $0.lowerBound > openingRange.upperBound })
            if let nextOpeningRange = openElementRanges.getPositive(openingRangeIndex + 1) {
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
                closure(html, &i, lowerBound, &result)
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
                var i = openingRange.upperBound
                closure(html, &i, closestClosingRange.lowerBound, &result)
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

// MARK: append
extension HTMLKitUtilities {
    fileprivate static func appendAll(
        html: String,
        i: inout String.Index,
        bound: String.Index,
        result: inout String
    ) {
        result += html[i..<bound]
        i = bound
    }
    fileprivate static func appendIfPreserved(
        html: String,
        i: inout String.Index,
        bound: String.Index,
        result: inout String
    ) {
        while i < bound {
            let char = html[i]
            if !(char.isWhitespace || char.isNewline) {
                result.append(char)
            }
            html.formIndex(after: &i)
        }
    }
}