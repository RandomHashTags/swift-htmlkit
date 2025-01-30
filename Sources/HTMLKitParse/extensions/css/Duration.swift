//
//  Duration.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import CSS
import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

extension CSSStyle.Duration : HTMLParsable {
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
}