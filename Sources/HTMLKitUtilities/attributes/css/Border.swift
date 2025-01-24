//
//  Border.swift
//
//
//  Created by Evan Anderson on 12/10/24.
//

import SwiftSyntax
import SwiftSyntaxMacros

extension HTMLElementAttribute.CSS {
    public enum Border {
        case block(Block?)
        case bottom(Bottom?)
        case collapse
        case color
        case end(End?)
        case width

        case shorthand
    }
}

// MARK: Block
extension HTMLElementAttribute.CSS.Border {
    public enum Block {
        case color(HTMLElementAttribute.CSS.Color?)
        case end
        case endColor(HTMLElementAttribute.CSS.Color?)
        case endStyle
        case endWidth
        case start
        case startColor(HTMLElementAttribute.CSS.Color?)
        case startStyle
        case startWidth
        case style
        case width

        case shorthand
    }
}

// MARK: Bottom
extension HTMLElementAttribute.CSS.Border {
    public enum Bottom {
        case color(HTMLElementAttribute.CSS.Color?)
        case leftRadius
        case rightRadius
        case style
        case width

        case shorthand
    }
}

// MARK: End
extension HTMLElementAttribute.CSS.Border {
    public enum End {
        case endRadius
        case startRadius
    }
}

// MARK: Image
extension HTMLElementAttribute.CSS.Border {
    public enum Image {
        case outset
        case `repeat`
        case slice
        case source
        case width

        case shorthand
    }
}

// MARK: Inline
extension HTMLElementAttribute.CSS.Border {
    public enum Inline {
        case color(HTMLElementAttribute.CSS.Color?)
        case end
        case endColor(HTMLElementAttribute.CSS.Color?)
        case endStyle
        case endWidth
        case start
        case startColor(HTMLElementAttribute.CSS.Color?)
        case startStyle
        case startWidth
        case style
        case width

        case shorthand
    }
}