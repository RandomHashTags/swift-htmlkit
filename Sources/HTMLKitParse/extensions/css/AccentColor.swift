//
//  AccentColor.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import CSS
import HTMLKitUtilities

extension CSSStyle.AccentColor : HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        switch context.key {
        case "auto": self = .auto
        case "color": self = .color(context.enumeration())
        case "inherit": self = .inherit
        case "initial": self = .initial
        case "revert": self = .revert
        case "revertLayer": self = .revertLayer
        case "unset": self = .unset
        default: return nil
        }
    }
}