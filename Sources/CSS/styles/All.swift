//
//  All.swift
//
//
//  Created by Evan Anderson on 2/3/25.
//

import HTMLKitUtilities

extension CSSStyle {
    public enum All: String, HTMLParsable {
        case initial
        case inherit
        case unset
        case revert
        case revertLayer

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .revertLayer: return "revert-layer"
            default: return rawValue
            }
        }
    }
}