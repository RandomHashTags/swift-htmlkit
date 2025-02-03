//
//  Windows.swift
//
//
//  Created by Evan Anderson on 2/3/25.
//

import HTMLKitUtilities

extension CSSStyle {
    public enum Windows : HTMLInitializable {
        case inherit
        case initial
        case int(Int?)
        case revert
        case revertLayer
        case unset

        public var key: String { "" }

        @inlinable public var htmlValueIsVoidable : Bool { false }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .inherit: return "inherit"
            case .initial: return "initial"
            case .int(let v): guard let v:Int = v else { return nil }; return "\(v)"
            case .revert: return "revert"
            case .revertLayer: return "revert-layer"
            case .unset: return "unset"
            }
        }
    }
}