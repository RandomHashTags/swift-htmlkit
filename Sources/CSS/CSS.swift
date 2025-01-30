//
//  CSS.swift
//
//
//  Created by Evan Anderson on 12/1/24.
//

import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

public enum CSSStyle : HTMLInitializable {
    public typealias SFloat = Swift.Float

    case accentColor(AccentColor?)
    //case align(Align?)
    case all
    //case animation(Animation?)
    case appearance(Appearance?)
    case aspectRatio

    case backdropFilter
    case backfaceVisibility(BackfaceVisibility?)
    //case background(Background?)
    case blockSize
    //case border(Border?)
    case bottom
    case box(Box?)
    case `break`(Break?)

    case captionSide
    case caretColor
    case clear(Clear?)
    case clipPath
    case color(Color?)
    case colorScheme(ColorScheme?)
    //case column(Column?)
    case columns
    case content
    case counterIncrement
    case counterReset
    case counterSet
    //case cursor(Cursor?)
    
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
    case height(CSSUnit)
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
    //case order(Order?)
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
    case width(CSSUnit)
    //case word(Word?)
    case writingMode(WritingMode?)

    //case zIndex(ZIndex?)
    case zoom(Zoom)

    public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
        return nil
    }
    public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
        return nil
    }

    // MARK: Key
    @inlinable
    public var key : String {
        switch self {
        case .accentColor: return "accentColor"
        //case .align: return "align"
        case .all: return "all"
        //case .animation: return "animation"
        case .appearance: return "appearance"
        case .aspectRatio: return "aspect-ratio"

        case .backdropFilter: return "backdrop-filter"
        case .backfaceVisibility: return "backface-visibility"
        //case .background: return "background"
        case .blockSize: return "block-size"
        //case .border: return "border"
        case .bottom: return "bottom"
        case .box: return "box"
        case .break: return "break"

        case .captionSide: return "caption-side"
        case .caretColor: return "caret-color"
        case .clear: return "clear"
        case .clipPath: return "clip-path"
        case .color: return "color"
        case .colorScheme: return "color-scheme"
        //case .column: return "column"
        case .columns: return "columns"
        case .content: return "content"
        case .counterIncrement: return "counter-increment"
        case .counterReset: return "counter-reset"
        case .counterSet: return "counter-set"
        //case .cursor: return "cursor"
        
        case .direction: return "direction"
        case .display: return "display"

        case .emptyCells: return "empty-cells"

        case .filter: return "filter"
        case .flex: return "flex"
        case .float: return "float"
        case .font: return "font"

        case .gap: return "gap"
        case .grid: return "grid"

        case .hangingPunctuation: return "hanging-punctuation"
        case .height: return "height"
        case .hyphens: return "hyphens"
        case .hypenateCharacter: return "hypenate-character"

        case .imageRendering: return "image-rendering"
        case .initialLetter: return "initial-letter"
        case .inlineSize: return "inline-size"
        case .inset: return "inset"
        case .isolation: return "isolation"

        case .justify: return "justify"

        case .left: return "left"
        case .letterSpacing: return "letter-spacing"
        case .lineBreak: return "line-break"
        case .lineHeight: return "line-height"
        case .listStyle: return "list-style"

        case .margin: return "margin"
        case .marker: return "marker"
        case .mask: return "mask"
        case .max: return "max"
        case .min: return "min"

        case .objectFit: return "object-fit"
        case .objectPosition: return "object-position"
        case .offset: return "offset"
        case .opacity: return "opacity"
        //case .order: return "order"
        case .orphans: return "orphans"
        case .outline: return "outline"
        case .overflow: return "overflow"
        case .overscroll: return "overscroll"

        case .padding: return "padding"
        case .pageBreak: return "page-break"
        case .paintOrder: return "paint-order"
        case .perspective: return "perspective"
        case .place: return "place"
        case .pointerEvents: return "pointer-events"
        case .position: return "position"

        case .quotes: return "quotes"

        case .resize: return "resize"
        case .right: return "right"
        case .rotate: return "rotate"
        case .rowGap: return "row-gap"

        case .scale: return "scale"
        case .scroll: return "scroll"
        case .scrollbarColor: return "scrollbar-color"
        case .shapeOutside: return "shape-outside"

        case .tabSize: return "tab-size"
        case .tableLayout: return "table-layout"
        case .text: return "text"
        case .top: return "top"
        case .transform: return "transform"
        case .transition: return "transition"
        case .translate: return "translate"

        case .unicodeBidi: return "unicode-bidi"
        case .userSelect: return "user-select"

        case .verticalAlign: return "vertical-align"
        case .visibility: return "visibility"

        case .whiteSpace: return "white-space"
        case .windows: return "windows"
        case .width: return "width"
        //case .word: return "word"
        case .writingMode: return "writing-mode"

        //case .zIndex: return "z-index"
        case .zoom: return "zoom"
        }
    }

    // MARK: HTML value is voidable
    @inlinable
    public var htmlValueIsVoidable : Bool { false }
}