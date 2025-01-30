//
//  Opacity.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import CSS
import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

extension CSSStyle.Opacity : HTMLParsable {
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
}