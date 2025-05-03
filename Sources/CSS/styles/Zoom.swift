//
//  Zoom.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities

extension CSSStyle {
    public enum Zoom: HTMLInitializable {
        case float(Swift.Float?)
        case inherit
        case initial
        case normal
        case percent(Swift.Float?)
        case reset
        case revert
        case revertLayer
        case unset

        public var key: String { "" }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .float(let f): return unwrap(f)
            case .inherit: return "inherit"
            case .initial: return "initial"
            case .normal: return "normal"
            case .percent(let p): return unwrap(p, suffix: "%")
            case .reset: return "reset"
            case .revert: return "revert"
            case .revertLayer: return "revertLayer"
            case .unset: return "unset"
            }
        }

        public var htmlValueIsVoidable: Bool { false }
    }
}