//
//  Duration.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities

extension CSSStyle {
    public enum Duration : HTMLInitializable {
        case auto
        case inherit
        case initial
        case ms(Int?)
        indirect case multiple([Duration])
        case revert
        case revertLayer
        case s(SFloat?)
        case unset

        public var key : String { "" }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .auto: return "auto"
            case .inherit: return "inherit"
            case .initial: return "initial"
            case .ms(let ms): return unwrap(ms, suffix: "ms")
            case .multiple(let durations): return durations.compactMap({ $0.htmlValue(encoding: encoding, forMacro: forMacro) }).joined(separator: ",")
            case .revert: return "revert"
            case .revertLayer: return "revertLayer"
            case .s(let s): return unwrap(s, suffix: "s")
            case .unset: return "unset"
            }
        }

        @inlinable
        public var htmlValueIsVoidable : Bool { false }
    }
}