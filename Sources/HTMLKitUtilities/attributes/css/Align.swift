//
//  Align.swift
//
//
//  Created by Evan Anderson on 12/10/24.
//

import SwiftSyntax
import SwiftSyntaxMacros

public extension HTMLElementAttribute.CSS {
    enum Align {
        case content(Content?)
        case items(Items?)
        case `self`(AlignSelf?)
    }
}

// MARK: Align Content
public extension HTMLElementAttribute.CSS.Align {
    enum Content : String, HTMLInitializable {
        case baseline
        case end
        case firstBaseline
        case flexEnd
        case flexStart
        case center
        case inherit
        case initial
        case lastBaseline
        case normal
        case revert
        case revertLayer
        case spaceAround
        case spaceBetween
        case spaceEvenly
        case safeCenter
        case start
        case stretch
        case unsafeCenter
        case unset

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .firstBaseline: return "first baseline"
                case .flexEnd: return "flex-end"
                case .flexStart: return "flex-start"
                case .lastBaseline: return "last baseline"
                case .revertLayer: return "revert-layer"
                case .safeCenter: return "safe center"
                case .spaceAround: return "space-around"
                case .spaceBetween: return "space-between"
                case .spaceEvenly: return "space-evenly"
                case .unsafeCenter: return "unsafe center"
                default: return rawValue
            }
        }
    }
}

// MARK: Align Items
public extension HTMLElementAttribute.CSS.Align {
    enum Items : String, HTMLInitializable {
        case anchorCenter
        case baseline
        case center
        case end
        case firstBaseline
        case flexEnd
        case flexStart
        case inherit
        case initial
        case lastBaseline
        case normal
        case revert
        case revertLayer
        case safeCenter
        case selfEnd
        case selfStart
        case start
        case stretch
        case unsafeCenter
        case unset

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .anchorCenter: return "anchor-center"
                case .firstBaseline: return "first baseline"
                case .flexEnd: return "flex-end"
                case .flexStart: return "flex-start"
                case .lastBaseline: return "last baseline"
                case .revertLayer: return "revert-layer"
                case .safeCenter: return "safe center"
                case .selfEnd: return "self-end"
                case .selfStart: return "self-start"
                case .unsafeCenter: return "unsafe center"
                default: return rawValue
            }
        }
    }
}

// MARK: Align Self
public extension HTMLElementAttribute.CSS {
    enum AlignSelf : String, HTMLInitializable {
        case anchorCenter
        case auto
        case baseline
        case end
        case firstBaseline
        case flexEnd
        case flexStart
        case center
        case inherit
        case initial
        case lastBaseline
        case normal
        case revert
        case revertLayer
        case safeCenter
        case selfEnd
        case selfStart
        case start
        case stretch
        case unsafeCenter
        case unset

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .anchorCenter: return "anchor-center"
                case .firstBaseline: return "first baseline"
                case .flexEnd: return "flex-end"
                case .flexStart: return "flex-start"
                case .lastBaseline: return "last baseline"
                case .revertLayer: return "revert-layer"
                case .safeCenter: return "safe center"
                case .selfEnd: return "self-end"
                case .selfStart: return "self-start"
                case .unsafeCenter: return "unsafe center"
                default: return rawValue
            }
        }
    }
}