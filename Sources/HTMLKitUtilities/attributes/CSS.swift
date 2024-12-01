//
//  CSS.swift
//
//
//  Created by Evan Anderson on 12/1/24.
//

public extension HTMLElementAttribute {
    enum CSS {
        case accentColor
        case alignContent
        case alignItems
        case alignSelf
        case all
        case animation(Animation?)
        case aspectRatio

        case backdropFilter
        case backfaceVisibility
        case background(Background?)
        
        case blockSize
        case border(Border?)
        
        case display(Display?)

        case emptyCells

        case filter
        case flex
        case float
        case font

        case gap
        case grid

        case hangingPunctuation
        case height
        case hyphens
        case hypenateCharacter

        case imageRendering
        case initialLetter
        case inlineSize
        case inset
        case isolation

        case justify

        case left
        case letterSpacing
        case lineBreak
        case lineHeight
        case listStyle

        case margin
        case marker
        case mask
        case max
        case min

        case objectFit
        case objectPosition
        case offset
        case opacity
        case order
        case orphans
        case outline
        case overflow
        case overscroll

        case padding
        case pageBreak
        case paintOrder
        case perspective
        case place
        case pointerEvents
        case position

        case quotes

        case resize
        case right
        case rotate
        case rowGap

        case scale
        case scroll
        case scrollbarColor
        case shapeOutside

        case tabSize
        case tableLayout
        case text
        case top
        case transform
        case transition
        case translate

        case unicodeBidi
        case userSelect

        case verticalAlign
        case visibility

        case whiteSpace
        case windows
        case width
        case word
        case writingMode

        case zIndex
        case zoom
    }
}

// MARK: Animation
public extension HTMLElementAttribute.CSS {
    enum Animation {
        case delay
        case direction
        case duration
        case fillMode
        case iterationCount
        case name
        case playState
        case timingFunction

        case shortcut
    }
}

// MARK: Background
public extension HTMLElementAttribute.CSS {
    enum Background {
        case attachment
        case blendMode
        case clip
        case color
        case image
        case origin
        case position
        case positionX
        case positionY
        case `repeat`
        case size

        case shorthand
    }
}

// MARK: Border
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

// MARK: Border Block
public extension HTMLElementAttribute.CSS.Border {
    enum Block {
        case color
        case end
        case endColor
        case endStyle
        case endWidth
        case start
        case startColor
        case startStyle
        case startWidth
        case style
        case width

        case shorthand
    }
}

// MARK: Border Bottom
public extension HTMLElementAttribute.CSS.Border {
    enum Bottom {
        case color
        case leftRadius
        case rightRadius
        case style
        case width

        case shorthand
    }
}

// MARK: Border End
public extension HTMLElementAttribute.CSS.Border {
    enum End {
        case endRadius
        case startRadius
    }
}

// MARK: Border Image
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

// MARK: Border Inline
public extension HTMLElementAttribute.CSS.Border {
    enum Inline {
        case color
        case end
        case endColor
        case endStyle
        case endWidth
        case start
        case startColor
        case startStyle
        case startWidth
        case style
        case width

        case shorthand
    }
}

// MARK: Display
public extension HTMLElementAttribute.CSS {
    enum Display : String, HTMLInitializable {
        /// Displays an element as a block element (like `<p>`). It starts on a new line, and takes up the whole width
        case block
        /// Makes the container disappear, making the child elements children of the element the next level up in the DOM
        case contents
        /// Displays an element as a block-level flex container
        case flex
        /// Displays an element as a block-level grid container
        case grid
        /// Displays an element as an inline element (like `<span>`). Any height and width properties will have no effect. This is default.
        case inline
        /// Displays an element as an inline-level block container. The element itself is formatted as an inline element, but you can apply height and width values
        case inlineBlock
        /// Displays an element as an inline-level flex container
        case inlineFlex
        /// Displays an element as an inline-level grid container
        case inlineGrid
        /// The element is displayed as an inline-level table
        case inlineTable 
        /// Inherits this property from its parent element. [Read about _inherit_](https://www.w3schools.com/cssref/css_inherit.php)
        case inherit
        /// Sets this property to its default value. [Read about _initial_](https://www.w3schools.com/cssref/css_initial.php)
        case initial
        /// Let the element behave like a `<li>` element  
        case listItem
        /// The element is completely removed
        case none
        /// Displays an element as either block or inline, depending on context 
        case runIn
        /// Let the element behave like a `<table>` element
        case table
        /// Let the element behave like a `<caption>` element
        case tableCaption
        /// Let the element behave like a `<td>` element
        case tableCell
        /// Let the element behave like a `<col>` element
        case tableColumn
        /// Let the element behave like a `<colgroup>` element
        case tableColumnGroup
        /// Let the element behave like a `<tfoot>` element
        case tableFooterGroup
        /// Let the element behave like a `<thead>` element
        case tableHeaderGroup
        /// Let the element behave like a `<tr>` element
        case tableRow
        /// Let the element behave like a `<tbody>` element
        case tableRowGroup
        
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .inlineBlock: return "inline-block"
                case .inlineFlex: return "inline-flex"
                case .inlineGrid: return "inline-grid"
                case .inlineTable: return "inline-table"
                case .listItem: return "list-item"
                case .runIn: return "run-in"
                case .tableCaption: return "table-caption"
                case .tableCell: return "table-cell"
                case .tableColumn: return "table-column"
                case .tableColumnGroup: return "table-column-group"
                case .tableFooterGroup: return "table-footer-group"
                case .tableHeaderGroup: return "table-header-group"
                case .tableRow: return "table-row"
                case .tableRowGroup: return "table-row-group"
                default: return rawValue
            }
        }
    }
}