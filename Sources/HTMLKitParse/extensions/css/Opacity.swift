//
//  Opacity.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import CSS
import HTMLKitUtilities

extension CSSStyle.Opacity: HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        switch context.key {
        case "float": self = .float(context.float())
        case "inherit": self = .inherit
        case "initial": self = .initial
        case "percent": self = .percent(context.float())
        case "revert": self = .revert
        case "revertLayer": self = .revertLayer
        case "unset": self = .unset
        default: return nil
        }
    }
}