//
//  AccentColor.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities

extension CSSStyle {
    public enum AccentColor: HTMLInitializable {
        case auto
        case color(Color?)
        case inherit
        case initial
        case revert
        case revertLayer
        case unset

        @inlinable
        public var key: String {
            switch self {
            case .auto: return "auto"
            case .color: return "color"
            case .inherit: return "inherit"
            case .initial: return "initial"
            case .revert: return "revert"
            case .revertLayer: return "revertLayer"
            case .unset: return "unset"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .auto: return "auto"
            case .color(let color): return color?.htmlValue(encoding: encoding, forMacro: forMacro)
            case .inherit: return "inherit"
            case .initial: return "initial"
            case .revert: return "revert"
            case .revertLayer: return "revert-layer"
            case .unset: return "unset"
            }
        }

        @inlinable
        public var htmlValueIsVoidable: Bool { false }
    }
}