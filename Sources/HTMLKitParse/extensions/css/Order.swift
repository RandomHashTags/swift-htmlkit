//
//  Order.swift
//
//
//  Created by Evan Anderson on 2/13/25.
//

import CSS
import HTMLKitUtilities

extension CSSStyle.Order : HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        switch context.key {
        case "int": self = .int(context.int())
        case "inherit": self = .inherit
        case "initial": self = .initial
        case "revert": self = .revert
        case "revertLayer": self = .revertLayer
        case "unset": self = .unset
        default: return nil
        }
    }
}