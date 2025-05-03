//
//  Isolation.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities

extension CSSStyle {
    public enum Isolation: String, HTMLParsable {
        case auto
        case inherit
        case initial
        case isloate
    }
}