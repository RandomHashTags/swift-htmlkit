//
//  Widows.swift
//
//
//  Created by Evan Anderson on 2/3/25.
//

import CSS
import HTMLKitUtilities

extension CSSStyle.Widows : HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        switch context.key {
        case "inherit": self = .inherit
        case "int": self = .int(context.int())
        case "initial": self = .initial
        case "revert": self = .revert
        case "revertLayer": self = .revertLayer
        case "unset": self = .unset
        default: return nil
        }
    }
}