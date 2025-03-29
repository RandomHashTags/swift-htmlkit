//
//  Duration.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import CSS
import HTMLKitUtilities

extension CSSStyle.Duration : HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        switch context.key {
        case "auto": self = .auto
        case "inherit": self = .inherit
        case "initial": self = .initial
        case "ms": self = .ms(context.int())
        case "multiple": self = .multiple(context.arrayEnumeration() ?? [])
        case "revert": self = .revert
        case "revertLayer": self = .revertLayer
        case "s": self = .s(context.float())
        case "unset": self = .unset
        default: return nil
        }
    }
}