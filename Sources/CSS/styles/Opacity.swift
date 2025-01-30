//
//  Opacity.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

extension CSSStyle {
    public enum Opacity : HTMLInitializable {
        case float(SFloat?)
        case inherit
        case initial
        case percent(SFloat?)
        case revert
        case revertLayer
        case unset

        public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
            switch key {
            case "float": self = .float(arguments.first!.expression.float(context: context, key: key))
            case "inherit": self = .inherit
            case "initial": self = .initial
            case "percent": self = .percent(arguments.first!.expression.float(context: context, key: key))
            case "revert": self = .revert
            case "revertLayer": self = .revertLayer
            case "unset": self = .unset
            default: return nil
            }
        }

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