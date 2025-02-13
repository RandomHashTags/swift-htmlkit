//
//  Cursor.swift
//
//
//  Created by Evan Anderson on 2/13/25.
//

import CSS
import HTMLKitUtilities

extension CSSStyle.Cursor : HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        switch context.key {
        case "alias": self = .alias
        case "allScroll": self = .allScroll
        case "auto": self = .auto
        case "cell": self = .cell
        case "colResize": self = .colResize
        case "contextMenu": self = .contextMenu
        case "copy": self = .copy
        case "crosshair": self = .crosshair
        case "default": self = .default
        case "eResize": self = .eResize
        case "ewResize": self = .ewResize
        case "grab": self = .grab
        case "grabbing": self = .grabbing
        case "help": self = .help
        case "inherit": self = .inherit
        case "initial": self = .initial
        case "move": self = .move
        case "nResize": self = .nResize
        case "neResize": self = .neResize
        case "neswResize": self = .neswResize
        case "nsResize": self = .nsResize
        case "nwResize": self = .nwResize
        case "nwseResize": self = .nwseResize
        case "noDrop": self = .noDrop
        case "none": self = .none
        case "notAllowed": self = .notAllowed
        case "pointer": self = .pointer
        case "progress": self = .progress
        case "rowResize": self = .rowResize
        case "sResize": self = .sResize
        case "seResize": self = .seResize
        case "swResize": self = .swResize
        case "text": self = .text
        case "urls": self = .urls(context.array_string())
        case "verticalText": self = .verticalText
        case "wResize": self = .wResize
        case "wait": self = .wait
        case "zoomIn": self = .zoomIn
        case "zoomOut": self = .zoomOut
        default: return nil
        }
    }
}