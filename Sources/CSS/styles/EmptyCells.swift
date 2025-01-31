//
//  EmptyCells.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities

extension CSSStyle {
    public enum EmptyCells : String, HTMLParsable {
        case hide
        case inherit
        case initial
        case show
    }
}