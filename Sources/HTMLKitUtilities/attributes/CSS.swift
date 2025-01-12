//
//  CSS.swift
//
//
//  Created by Evan Anderson on 12/1/24.
//

import SwiftSyntax
import SwiftSyntaxMacros

public extension HTMLElementAttribute {
    enum CSS {
        public typealias SFloat = Swift.Float

        case accentColor(AccentColor?)
        case align(Align?)
        case all
        case animation(Animation?)
        case appearance(Appearance?)
        case aspectRatio

        case backdropFilter
        case backfaceVisibility(BackfaceVisibility?)
        case background(Background?)
        case blockSize
        case border(Border?)
        case bottom
        case box(Box?)
        case `break`(Break?)

        case captionSide
        case caretColor
        case clear(Clear?)
        case clipPath
        case color(Color?)
        case colorScheme(ColorScheme?)
        case column(Column?)
        case columns
        case content
        case counterIncrement
        case counterReset
        case counterSet
        case cursor(Cursor?)
        
        case direction(Direction?)
        case display(Display?)

        case emptyCells(EmptyCells?)

        case filter
        case flex
        case float(Float?)
        case font

        case gap
        case grid

        case hangingPunctuation
        case height
        case hyphens(Hyphens?)
        case hypenateCharacter

        case imageRendering(ImageRendering?)
        case initialLetter
        case inlineSize
        case inset
        case isolation(Isolation?)

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

        case objectFit(ObjectFit?)
        case objectPosition
        case offset
        case opacity(Opacity?)
        case order(Order?)
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
        case word(Word?)
        case writingMode(WritingMode?)

        case zIndex(ZIndex?)
        case zoom(Zoom)
    }
}

// MARK: AccentColor
public extension HTMLElementAttribute.CSS {
    enum AccentColor : HTMLInitializable {
        case auto
        case color(Color?)
        case inherit
        case initial
        case revert
        case revertLayer
        case unset

        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            switch key {
                case "auto": self = .auto
                case "color": self = .color(arguments.first!.expression.enumeration(context: context, key: key, arguments: arguments))
                case "inherit": self = .inherit
                case "initial": self = .initial
                case "revert": self = .revert
                case "revertLayer": self = .revertLayer
                case "unset": self = .unset
                default: return nil
            }
        }

        public var key : String { "" }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .auto: return "auto"
                case .color(let color): return color?.htmlValue(encoding: encoding, forMacro: forMacro)
                case .inherit: return "inherit"
                case .initial: return "initial"
                case .revert: return "revert"
                case .revertLayer: return "revert-layer"
                case .unset: return "unset"
            }
        }

        @inlinable
        public var htmlValueIsVoidable : Bool { false }
    }
}

// MARK: Appearance
public extension HTMLElementAttribute.CSS {
    enum Appearance : String, HTMLInitializable {
        case auto
        case button
        case checkbox
        case inherit
        case initial
        case menulistButton
        case none
        case revert
        case revertLayer
        case textfield
        case unset

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .menulistButton: return "menulist-button"
                case .revertLayer: return "revert-layer"
                default: return rawValue
            }
        }
    }
}

// MARK: Backface Visibility
public extension HTMLElementAttribute.CSS {
    enum BackfaceVisibility : String, HTMLInitializable {
        case hidden
        case inherit
        case initial
        case revert
        case revertLayer
        case unset
        case visible

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .revertLayer: return "revert-layer"
                default: return rawValue
            }
        }
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

// MARK: Box
public extension HTMLElementAttribute.CSS {
    enum Box : String, HTMLInitializable {
        case decorationBreak
        case reflect
        case shadow
        case sizing
    }
}

// MARK: Break
public extension HTMLElementAttribute.CSS {
    enum Break : String, HTMLInitializable {
        case after
        case before
        case inside
    }
}

// MARK: Clear
public extension HTMLElementAttribute.CSS {
    enum Clear : String, HTMLInitializable {
        case both
        case inherit
        case initial
        case left
        case none
        case right
    }
}

// MARK: ColorScheme
public extension HTMLElementAttribute.CSS {
    enum ColorScheme : String, HTMLInitializable {
        case dark
        case light
        case lightDark
        case normal
        case onlyDark
        case onlyLight

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .lightDark: return "light dark"
                case .onlyDark: return "only dark"
                case .onlyLight: return "only light"
                default: return rawValue
            }
        }
    }
}

// MARK: Column
public extension HTMLElementAttribute.CSS {
    enum Column {
        case count(ColumnCount?)
        case fill
        case gap
        case rule(Rule?)
        case span
        case width
    }
}

// MARK: Column Count
public extension HTMLElementAttribute.CSS {
    enum ColumnCount : HTMLInitializable {
        case auto
        case inherit
        case initial
        case int(Int)

        public init?(context: some MacroExpansionContext, key: String, arguments: SwiftSyntax.LabeledExprListSyntax) {
            return nil
        }

        public var key : String {
            switch self {
                case .int(_): return "int"
                default: return "\(self)"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .int(let i): return "\(i)"
                default: return "\(self)"
            }
        }

        @inlinable
        public var htmlValueIsVoidable : Bool { false }
    }
}

// MARK: Column Rule
public extension HTMLElementAttribute.CSS.Column {
    enum Rule : String, HTMLInitializable {
        case color
        case style
        case width
        
        case shorthand
    }
}

// MARK: Cursor
public extension HTMLElementAttribute.CSS {
    enum Cursor {
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
        case urls([String])
        case verticalText
        case wResize
        case wait
        case zoomIn
        case zoomOut
    }
}

// MARK: Direction
public extension HTMLElementAttribute.CSS {
    enum Direction : String, HTMLInitializable {
        case ltr
        case inherit
        case initial
        case rtl
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

        @inlinable
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

// MARK: Duration
public extension HTMLElementAttribute.CSS {
    enum Duration : HTMLInitializable {
        case auto
        case inherit
        case initial
        case ms(Int?)
        indirect case multiple([Duration])
        case revert
        case revertLayer
        case s(SFloat?)
        case unset

        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            switch key {
                case "auto": self = .auto
                case "inherit": self = .inherit
                case "initial": self = .initial
                case "ms": self = .ms(arguments.first!.expression.int(context: context, key: key))
                case "multiple": self = .multiple(arguments.first!.expression.array!.elements.compactMap({ $0.expression.enumeration(context: context, key: key, arguments: arguments) }))
                case "revert": self = .revert
                case "revertLayer": self = .revertLayer
                case "s": self = .s(arguments.first!.expression.float(context: context, key: key))
                case "unset": self = .unset
                default: return nil
            }
        }

        public var key : String { "" }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .auto: return "auto"
                case .inherit: return "inherit"
                case .initial: return "initial"
                case .ms(let ms): return unwrap(ms, suffix: "ms")
                case .multiple(let durations): return durations.compactMap({ $0.htmlValue(encoding: encoding, forMacro: forMacro) }).joined(separator: ",")
                case .revert: return "revert"
                case .revertLayer: return "revertLayer"
                case .s(let s): return unwrap(s, suffix: "s")
                case .unset: return "unset"
            }
        }

        @inlinable
        public var htmlValueIsVoidable : Bool { false }
    }
}

// MARK: EmptyCells
public extension HTMLElementAttribute.CSS {
    enum EmptyCells : String, HTMLInitializable {
        case hide
        case inherit
        case initial
        case show
    }
}

// MARK: Float
public extension HTMLElementAttribute.CSS {
    enum Float : String, HTMLInitializable {
        case inherit
        case initial
        case left
        case none
        case right
    }
}

// MARK: Hyphens
public extension HTMLElementAttribute.CSS {
    enum Hyphens : String, HTMLInitializable {
        case auto
        case inherit
        case initial
        case manual
        case none
    }
}

// MARK: Hyphenate Character
public extension HTMLElementAttribute.CSS {
    enum HyphenateCharacter : HTMLInitializable {
        case auto
        case char(Character)
        case inherit
        case initial

        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            return nil
        }

        public var key : String {
            switch self {
                case .char(_): return "char"
                default: return "\(self)"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .char(let c): return "\(c)"
                default: return "\(self)"
            }
        }

        @inlinable
        public var htmlValueIsVoidable : Bool { false }
    }
}

// MARK: Image Rendering
public extension HTMLElementAttribute.CSS {
    enum ImageRendering : String, HTMLInitializable {
        case auto
        case crispEdges
        case highQuality
        case initial
        case inherit
        case pixelated
        case smooth

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .crispEdges: return "crisp-edges"
                case .highQuality: return "high-quality"
                default: return rawValue
            }
        }
    }
}

// MARK: Isolation
public extension HTMLElementAttribute.CSS {
    enum Isolation : String, HTMLInitializable {
        case auto
        case inherit
        case initial
        case isloate
    }
}

// MARK: Object Fit
public extension HTMLElementAttribute.CSS {
    enum ObjectFit : String, HTMLInitializable {
        case contain
        case cover
        case fill
        case inherit
        case initial
        case none
        case scaleDown

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .scaleDown: return "scale-down"
                default: return rawValue
            }
        }
    }
}

// MARK: Opacity
public extension HTMLElementAttribute.CSS {
    enum Opacity : HTMLInitializable {
        case float(SFloat?)
        case inherit
        case initial
        case percent(SFloat?)
        case revert
        case revertLayer
        case unset

        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            switch key {
                case "float": self = .float(arguments.first!.expression.float(context: context, key: key))
                case "inherit": self = .inherit
                case "initial": self = .initial
                case "percent": self = .percent(arguments.first!.expression.float(context: context, key: key))
                case "revert": self = .revert
                case "revertLayer": self = .revertLayer
                case "unset": self = .unset
                default: return nil
            }
        }

        public var key : String { "" }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .float(let f): return unwrap(f)
                case .inherit: return "inherit"
                case .initial: return "initial"
                case .percent(let p): return unwrap(p, suffix: "%")
                case .revert: return "revert"
                case .revertLayer: return "revert-layer"
                case .unset: return "unset"
            }
        }

        @inlinable
        public var htmlValueIsVoidable : Bool { false }
    }
}

// MARK: Order
public extension HTMLElementAttribute.CSS {
    enum Order {
        case int(Int)
        case initial
        case inherit
    }
}

// MARK: Text
public extension HTMLElementAttribute.CSS {
    enum Text {
        case align(Align?)
        case alignLast(Align.Last?)
        case shorthand
    }
}

// MARK: Text Align
public extension HTMLElementAttribute.CSS.Text {
    enum Align : String, HTMLInitializable {
        case center
        case end
        case inherit
        case initial
        case justify
        case left
        case matchParent
        case revert
        case revertLayer
        case right
        case start
        case unset

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .matchParent: return "match-parent"
                case .revertLayer: return "revert-layer"
                default: return rawValue
            }
        }
    }
}

// MARK: Text Align Last
public extension HTMLElementAttribute.CSS.Text.Align {
    enum Last : String, HTMLInitializable {
        case auto
        case center
        case end
        case inherit
        case initial
        case justify
        case left
        case revert
        case revertLayer
        case right
        case start
        case unset

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .revertLayer: return "revert-layer"
                default: return rawValue
            }
        }
    }
}

// MARK: Word
public extension HTMLElementAttribute.CSS {
    enum Word {
        case `break`(Break?)
        case spacing(Spacing?)
        case wrap(Wrap?)
    }
}

// MARK: Word Break
public extension HTMLElementAttribute.CSS.Word {
    enum Break : String, HTMLInitializable {
        case breakAll
        case breakWord
        case inherit
        case initial
        case keepAll
        case normal

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .breakAll: return "break-all"
                case .breakWord: return "break-word"
                case .keepAll: return "keep-all"
                default: return rawValue
            }
        }
    }
}

// MARK: Word Spacing
public extension HTMLElementAttribute.CSS.Word {
    enum Spacing {
        case inherit
        case initial
        case normal
        case unit(HTMLElementAttribute.CSSUnit?)
    }
}

// MARK: Word Wrap
public extension HTMLElementAttribute.CSS.Word {
    enum Wrap : String, HTMLInitializable {
        case breakWord
        case inherit
        case initial
        case normal

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .breakWord: return "break-word"
                default: return rawValue
            }
        }
    }
}

// MARK: Writing Mode
public extension HTMLElementAttribute.CSS {
    enum WritingMode : String, HTMLInitializable {
        case horizontalTB
        case verticalRL
        case verticalLR

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .horizontalTB: return "horizontal-tb"
                case .verticalLR: return "vertical-lr"
                case .verticalRL: return "vertical-rl"
            }
        }
    }
}

// MARK: Z Index
public extension HTMLElementAttribute.CSS {
    enum ZIndex {
        case auto
        case inherit
        case initial
        case int(Int)
    }
}

// MARK: Zoom
public extension HTMLElementAttribute.CSS {
    enum Zoom : HTMLInitializable {
        case float(SFloat?)
        case inherit
        case initial
        case normal
        case percent(SFloat?)
        case reset
        case revert
        case revertLayer
        case unset

        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            switch key {
                case "float": self = .float(arguments.first!.expression.float(context: context, key: key))
                case "inherit": self = .inherit
                case "initial": self = .initial
                case "normal": self = .normal
                case "percent": self = .percent(arguments.first!.expression.float(context: context, key: key))
                case "reset": self = .reset
                case "revert": self = .revert
                case "revertLayer": self = .revertLayer
                case "unset": self = .revertLayer
                default: return nil
            }
        }

        public var key : String { "" }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
                case .float(let f): return unwrap(f)
                case .inherit: return "inherit"
                case .initial: return "initial"
                case .normal: return "normal"
                case .percent(let p): return unwrap(p, suffix: "%")
                case .reset: return "reset"
                case .revert: return "revert"
                case .revertLayer: return "revertLayer"
                case .unset: return "unset"
            }
        }

        public var htmlValueIsVoidable : Bool { false }
    }
}