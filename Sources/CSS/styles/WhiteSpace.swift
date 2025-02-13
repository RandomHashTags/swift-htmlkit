//
//  WhiteSpace.swift
//
//
//  Created by Evan Anderson on 2/3/25.
//

import HTMLKitUtilities

// https://developer.mozilla.org/en-US/docs/Web/CSS/white-space
extension CSSStyle {
    public enum WhiteSpace : String, HTMLParsable {
        case collapse
        case inherit
        case initial
        case normal
        case pre
        case preserveNowrap
        case preWrap
        case preLine
        case revert
        case revertLayer
        case unset
        case wrap

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .preWrap: return "pre-wrap"
            case .preLine: return "pre-line"
            case .preserveNowrap: return "preserve nowrap"
            case .revertLayer: return "revert-layer"
            default: return rawValue
            }
        }
    }
}