//
//  Minify.swift
//
//
//  Created by Evan Anderson on 3/31/25.
//

extension HTMLKitUtilities {
    @usableFromInline
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
    @inlinable
    public static func minify(
        html: String,
        preservingWhitespaceForTags: Set<Substring> = []
    ) -> String {
        var result:String = ""
        result.reserveCapacity(html.count)
        let tagRanges = html.ranges(of: try! Regex("(<[^>]+>)"))
        var tagIndex = 0
        for tagRange in tagRanges {
            let originalTag = html[tagRange]
            var tag = originalTag.split(separator: " ")[0]
            if tag.last != ">" {
                tag.append(">")
            }
            result += originalTag
            if let next = tagRanges.get(tagIndex + 1) {
                let slice = html[tagRange.upperBound..<next.lowerBound]
                if !(Self.defaultPreservedWhitespaceTags.contains(tag) || preservingWhitespaceForTags.contains(tag)) {
                    for char in slice {
                        if !(char.isWhitespace || char.isNewline) {
                            result.append(char)
                        }
                    }
                } else {
                    result += slice
                }
            }
            tagIndex += 1
        }
        return result
    }
}