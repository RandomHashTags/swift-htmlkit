//
//  Duration.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

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

        public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
            switch key {
            case "auto": self = .auto
            case "inherit": self = .inherit
            case "initial": self = .initial
            case "ms": self = .ms(arguments.first!.expression.int(context: context, key: key))
            case "multiple": self = .multiple(arguments.first!.expression.array!.elements.compactMap({ $0.expression.enumeration(context: context, isUnchecked: isUnchecked, key: key, arguments: arguments) }))
            case "revert": self = .revert
            case "revertLayer": self = .revertLayer
            case "s": self = .s(arguments.first!.expression.float(context: context, key: key))
            case "unset": self = .unset
            default: return nil
            }
        }

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