//
//  ColumnCount.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities

extension CSSStyle {
    public enum ColumnCount : HTMLParsable {
        case auto
        case inherit
        case initial
        case int(Int)

        public init?(context: HTMLExpansionContext) {
            return nil
        }

        public var key : String {
            switch self {
            case .int: return "int"
            default: return "\(self)"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .int(let i): return "\(i)"
            default: return "\(self)"
            }
        }

        @inlinable
        public var htmlValueIsVoidable : Bool { false }
    }
}