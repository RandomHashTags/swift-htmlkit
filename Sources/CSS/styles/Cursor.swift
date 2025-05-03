//
//  Cursor.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities

// https://developer.mozilla.org/en-US/docs/Web/CSS/cursor
extension CSSStyle {
    public enum Cursor: HTMLInitializable {
        case alias
        case allScroll
        case auto
        case cell
        case colResize
        case contextMenu
        case copy
        case crosshair
        case `default`
        case eResize
        case ewResize
        case grab
        case grabbing
        case help
        case inherit
        case initial
        case move
        case nResize
        case neResize
        case neswResize
        case nsResize
        case nwResize
        case nwseResize
        case noDrop
        case none
        case notAllowed
        case pointer
        case progress
        case rowResize
        case sResize
        case seResize
        case swResize
        case text
        case urls([String]?)
        case verticalText
        case wResize
        case wait
        case zoomIn
        case zoomOut

        /// - Warning: Never use.
        @inlinable
        public var key: String { "" }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .allScroll: return "all-scroll"
            case .colResize: return "col-resize"
            case .contextMenu: return "context-menu"
            case .eResize: return "e-resize"
            case .ewResize: return "ew-resize"
            case .nResize: return "n-resize"
            case .neResize: return "ne-resize"
            case .neswResize: return "nesw-resize"
            case .nsResize: return "ns-resize"
            case .nwResize: return "nw-resize"
            case .nwseResize: return "nwse-resize"
            case .noDrop: return "no-drop"
            case .notAllowed: return "not-allowed"
            case .rowResize: return "row-resize"
            case .sResize: return "s-resize"
            case .seResize: return "se-resize"
            case .swResize: return "sw-resize"
            case .urls(let v): return v?.map({ "url(\($0))" }).joined(separator: ",")
            case .verticalText: return "vertical-text"
            case .wResize: return "w-resize"
            case .zoomIn: return "zoom-in"
            case .zoomOut: return "zoom-out"
            default: return "\(self)"
            }
        }

        @inlinable
        public var htmlValueIsVoidable: Bool { false }
    }
}