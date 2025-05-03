//
//  WhiteSpaceCollapse.swift
//
//
//  Created by Evan Anderson on 2/3/25.
//

import HTMLKitUtilities

// https://developer.mozilla.org/en-US/docs/Web/CSS/white-space-collapse
extension CSSStyle {
    public enum WhiteSpaceCollapse: String, HTMLParsable {
        case breakSpaces
        case collapse
        case inherit
        case initial
        case preserve
        case preserveBreaks
        case preserveSpaces
        case revert
        case revertLayer
        case unset

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .breakSpaces: return "break-spaces"
            case .preserveBreaks: return "preserve-breaks"
            case .preserveSpaces: return "preserve-spaces"
            case .revertLayer: return "revert-layer"
            default: return rawValue
            }
        }
    }
}