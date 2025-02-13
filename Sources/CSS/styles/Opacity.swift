//
//  Opacity.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities

// https://developer.mozilla.org/en-US/docs/Web/CSS/opacity
extension CSSStyle {
    public enum Opacity : HTMLInitializable {
        case float(Swift.Float?)
        case inherit
        case initial
        case percent(Swift.Float?)
        case revert
        case revertLayer
        case unset

        public var key : String { "" }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .float(let f): return unwrap(f)
            case .inherit: return "inherit"
            case .initial: return "initial"
            case .percent(let p): return unwrap(p, suffix: "%")
            case .revert: return "revert"
            case .revertLayer: return "revert-layer"
            case .unset: return "unset"
            }
        }

        @inlinable
        public var htmlValueIsVoidable : Bool { false }
    }
}