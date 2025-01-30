//
//  Zoom.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

extension CSSStyle {
    public enum Zoom : HTMLInitializable {
        case float(SFloat?)
        case inherit
        case initial
        case normal
        case percent(SFloat?)
        case reset
        case revert
        case revertLayer
        case unset

        public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
            switch key {
            case "float": self = .float(arguments.first!.expression.float(context: context, key: key))
            case "inherit": self = .inherit
            case "initial": self = .initial
            case "normal": self = .normal
            case "percent": self = .percent(arguments.first!.expression.float(context: context, key: key))
            case "reset": self = .reset
            case "revert": self = .revert
            case "revertLayer": self = .revertLayer
            case "unset": self = .revertLayer
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
            case .normal: return "normal"
            case .percent(let p): return unwrap(p, suffix: "%")
            case .reset: return "reset"
            case .revert: return "revert"
            case .revertLayer: return "revertLayer"
            case .unset: return "unset"
            }
        }

        public var htmlValueIsVoidable : Bool { false }
    }
}