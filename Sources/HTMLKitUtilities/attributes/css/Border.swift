//
//  Border.swift
//
//
//  Created by Evan Anderson on 12/10/24.
//

import SwiftSyntax
import SwiftSyntaxMacros

public extension HTMLElementAttribute.CSS {
    enum Border {
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
public extension HTMLElementAttribute.CSS.Border {
    enum Block {
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
public extension HTMLElementAttribute.CSS.Border {
    enum Bottom {
        case color(HTMLElementAttribute.CSS.Color?)
        case leftRadius
        case rightRadius
        case style
        case width

        case shorthand
    }
}

// MARK: End
public extension HTMLElementAttribute.CSS.Border {
    enum End {
        case endRadius
        case startRadius
    }
}

// MARK: Image
public extension HTMLElementAttribute.CSS.Border {
    enum Image {
        case outset
        case `repeat`
        case slice
        case source
        case width

        case shorthand
    }
}

// MARK: Inline
public extension HTMLElementAttribute.CSS.Border {
    enum Inline {
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