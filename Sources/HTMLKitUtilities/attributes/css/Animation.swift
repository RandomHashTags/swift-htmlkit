//
//  Animation.swift
//
//
//  Created by Evan Anderson on 12/10/24.
//

import SwiftSyntax
import SwiftSyntaxMacros

public extension HTMLElementAttribute.CSS {
    enum Animation {
        case delay(HTMLElementAttribute.CSS.Duration?)
        case direction(Direction?)
        case duration(HTMLElementAttribute.CSS.Duration?)
        case fillMode(FillMode?)
        case iterationCount
        case name
        case playState(PlayState?)
        case timingFunction

        case shortcut
    }
}

// MARK: Direction
public extension HTMLElementAttribute.CSS.Animation {
    enum Direction : HTMLInitializable {
        case alternate
        case alternateReverse
        case inherit
        case initial
        indirect case multiple([Direction])
        case normal
        case reverse
        case revert
        case revertLayer
        case unset

        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            switch key {
                case "alternate": self = .alternate
                case "alternateReverse": self = .alternateReverse
                case "inherit": self = .inherit
                case "initial": self = .initial
                case "multiple": self = .multiple(arguments.first!.array!.elements.map({ $0.expression.enumeration(context: context, key: key, arguments: arguments)! }))
                case "normal": self = .normal
                case "reverse": self = .reverse
                case "revert": self = .revert
                case "revertLayer": self = .revertLayer
                case "unset": self = .unset
                default: return nil
            }
        }

        public var key : String { "" }

        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .alternate: return "alternate"
                case .alternateReverse: return "alternate-reverse"
                case .inherit: return "inherit"
                case .initial: return "initial"
                case .multiple(let directions): return directions.compactMap({ $0.htmlValue(encoding: encoding, forMacro: forMacro) }).joined(separator: ",")
                case .normal: return "normal"
                case .reverse: return "reverse"
                case .revert: return "revert"
                case .revertLayer: return "revertLayer"
                case .unset: return "unset"
            }
        }

        public var htmlValueIsVoidable : Bool { false }
    }
}

// MARK: Fill Mode
public extension HTMLElementAttribute.CSS.Animation {
    enum FillMode : HTMLInitializable {
        case backwards
        case both
        case forwards
        case inherit
        case initial
        indirect case multiple([FillMode])
        case none
        case revert
        case revertLayer
        case unset

        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            switch key {
                case "backwards": self = .backwards
                case "both": self = .both
                case "forwards": self = .forwards
                case "inherit": self = .inherit
                case "initial": self = .initial
                case "multiple": self = .multiple(arguments.first!.expression.array!.elements.compactMap({ $0.expression.enumeration(context: context, key: key, arguments: arguments) }))
                case "none": self = .none
                case "revert": self = .revert
                case "revertLayer": self = .revertLayer
                case "unset": self = .unset
                default: return nil
            }
        }

        public var key : String { "" }

        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .backwards: return "backwards"
                case .both: return "both"
                case .forwards: return "forwards"
                case .inherit: return "inherit"
                case .initial: return "initial"
                case .multiple(let modes): return modes.compactMap({ $0.htmlValue(encoding: encoding, forMacro: forMacro) }).joined(separator: ",")
                case .none: return "none"
                case .revert: return "revert"
                case .revertLayer: return "revert-layer"
                case .unset: return "unset"
            }
        }

        public var htmlValueIsVoidable : Bool { false }
    }
}

// MARK: Play State
public extension HTMLElementAttribute.CSS.Animation {
    enum PlayState : HTMLInitializable {
        case inherit
        case initial
        indirect case multiple([PlayState])
        case paused
        case revert
        case revertLayer
        case running
        case unset

        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            switch key {
                case "inherit": self = .inherit
                case "initial": self = .initial
                case "multiple": self = .multiple(arguments.first!.expression.array!.elements.compactMap({ $0.expression.enumeration(context: context, key: key, arguments: arguments) }))
                case "paused": self = .paused
                case "revert": self = .revert
                case "revertLayer": self = .revertLayer
                case "running": self = .running
                case "unset": self = .unset
                default: return nil
            }
        }

        public var key : String { "" }

        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .inherit: return "inherit"
                case .initial: return "initial"
                case .multiple(let states): return states.compactMap({ $0.htmlValue(encoding: encoding, forMacro: forMacro) }).joined(separator: ",")
                case .paused: return "paused"
                case .revert: return "revert"
                case .revertLayer: return "revertLayer"
                case .running: return "running"
                case .unset: return "unset"
            }
        }

        public var htmlValueIsVoidable : Bool { false }
    }
}