//
//  CSSStyle.swift
//
//
//  Created by Evan Anderson on 2/3/25.
//

import CSS
import HTMLKitUtilities

extension CSSStyle : HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        func enumeration<T : HTMLParsable>() -> T? { context.enumeration() }
        switch context.key {
        case "all": self = .all(enumeration())
        case "appearance": self = .appearance(enumeration())

        case "backfaceVisibility": self = .backfaceVisibility(enumeration())
        case "box": self = .box(enumeration())
        case "break": self = .break(enumeration())
        
        case "captionSide": self = .captionSide(enumeration())
        case "clear": self = .clear(enumeration())
        case "color": self = .color(enumeration())
        case "colorScheme": self = .colorScheme(enumeration())

        case "direction": self = .direction(enumeration())
        case "display": self = .display(enumeration())

        case "emptyCells": self = .emptyCells(enumeration())

        case "float": self = .float(enumeration())

        case "height": self = .height(enumeration())
        case "hyphens": self = .hyphens(enumeration())

        case "imageRendering": self = .imageRendering(enumeration())
        case "isolation": self = .isolation(enumeration())

        case "objectFit": self = .objectFit(enumeration())
        case "opacity": self = .opacity(enumeration())

        case "visibility": self = .visibility(enumeration())

        case "whiteSpace": self = .whiteSpace(enumeration())
        case "width": self = .width(enumeration())
        case "windows": self = .windows(enumeration())
        case "writingMode": self = .writingMode(enumeration())

        case "zoom": self = .zoom(enumeration())
        case "zIndex": self = .zIndex(enumeration())
        default: return nil
        }
    }
}