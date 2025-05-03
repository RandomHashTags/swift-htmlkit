//
//  Box.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities

extension CSSStyle {
    public enum Box: String, HTMLParsable {
        case decorationBreak
        case reflect
        case shadow
        case sizing
    }
}