//
//  HyphenateCharacter.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

extension CSSStyle {
    public enum HyphenateCharacter : HTMLInitializable {
        case auto
        case char(Character)
        case inherit
        case initial

        public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
            return nil
        }

        public var key : String {
            switch self {
            case .char: return "char"
            default: return "\(self)"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .char(let c): return "\(c)"
            default: return "\(self)"
            }
        }

        @inlinable
        public var htmlValueIsVoidable : Bool { false }
    }
}