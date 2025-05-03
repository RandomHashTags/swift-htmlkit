//
//  Break.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities

extension CSSStyle {
    public enum Break: String, HTMLParsable {
        case after
        case before
        case inside
    }
}