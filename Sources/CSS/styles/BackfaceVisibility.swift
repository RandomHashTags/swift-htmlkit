//
//  AccentColor.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities

extension CSSStyle {
    public enum BackfaceVisibility : String, HTMLParsable {
        case hidden
        case inherit
        case initial
        case revert
        case revertLayer
        case unset
        case visible

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .revertLayer: return "revert-layer"
            default: return rawValue
            }
        }
    }
}