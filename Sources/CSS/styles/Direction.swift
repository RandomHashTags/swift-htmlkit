//
//  Direction.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities

extension CSSStyle {
    public enum Direction : String, HTMLParsable {
        case ltr
        case inherit
        case initial
        case rtl
    }
}