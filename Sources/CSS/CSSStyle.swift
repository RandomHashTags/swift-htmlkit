
import HTMLKitUtilities

public enum CSSStyle: HTMLInitializable {
    //case accentColor(AccentColor?)
    //case align(Align?)
    case all(All?)
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

    case captionSide(CaptionSide?)
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
    case height(CSSUnit?)
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
    case visibility(Visibility?)

    case whiteSpace(WhiteSpace?)
    case whiteSpaceCollapse(WhiteSpaceCollapse?)
    case widows(Widows?)
    case width(CSSUnit?)
    //case word(Word?)
    case writingMode(WritingMode?)

    case zIndex(ZIndex?)
    case zoom(Zoom?)

    // MARK: Key
    @inlinable
    public var key: String {
        switch self {
        //case .accentColor: "accentColor"
        //case .align: "align"
        case .all: "all"
        //case .animation: "animation"
        case .appearance: "appearance"
        case .aspectRatio: "aspect-ratio"

        case .backdropFilter: "backdrop-filter"
        case .backfaceVisibility: "backface-visibility"
        //case .background: "background"
        case .blockSize: "block-size"
        //case .border: "border"
        case .bottom: "bottom"
        case .box: "box"
        case .break: "break"

        case .captionSide: "caption-side"
        case .caretColor: "caret-color"
        case .clear: "clear"
        case .clipPath: "clip-path"
        case .color: "color"
        case .colorScheme: "color-scheme"
        //case .column: "column"
        case .columns: "columns"
        case .content: "content"
        case .counterIncrement: "counter-increment"
        case .counterReset: "counter-reset"
        case .counterSet: "counter-set"
        case .cursor: "cursor"
        
        case .direction: "direction"
        case .display: "display"

        case .emptyCells: "empty-cells"

        case .filter: "filter"
        case .flex: "flex"
        case .float: "float"
        case .font: "font"

        case .gap: "gap"
        case .grid: "grid"

        case .hangingPunctuation: "hanging-punctuation"
        case .height: "height"
        case .hyphens: "hyphens"
        case .hypenateCharacter: "hypenate-character"

        case .imageRendering: "image-rendering"
        case .initialLetter: "initial-letter"
        case .inlineSize: "inline-size"
        case .inset: "inset"
        case .isolation: "isolation"

        case .justify: "justify"

        case .left: "left"
        case .letterSpacing: "letter-spacing"
        case .lineBreak: "line-break"
        case .lineHeight: "line-height"
        case .listStyle: "list-style"

        case .margin: "margin"
        case .marker: "marker"
        case .mask: "mask"
        case .max: "max"
        case .min: "min"

        case .objectFit: "object-fit"
        case .objectPosition: "object-position"
        case .offset: "offset"
        case .opacity: "opacity"
        case .order: "order"
        case .orphans: "orphans"
        case .outline: "outline"
        case .overflow: "overflow"
        case .overscroll: "overscroll"

        case .padding: "padding"
        case .pageBreak: "page-break"
        case .paintOrder: "paint-order"
        case .perspective: "perspective"
        case .place: "place"
        case .pointerEvents: "pointer-events"
        case .position: "position"

        case .quotes: "quotes"

        case .resize: "resize"
        case .right: "right"
        case .rotate: "rotate"
        case .rowGap: "row-gap"

        case .scale: "scale"
        case .scroll: "scroll"
        case .scrollbarColor: "scrollbar-color"
        case .shapeOutside: "shape-outside"

        case .tabSize: "tab-size"
        case .tableLayout: "table-layout"
        case .text: "text"
        case .top: "top"
        case .transform: "transform"
        case .transition: "transition"
        case .translate: "translate"

        case .unicodeBidi: "unicode-bidi"
        case .userSelect: "user-select"

        case .verticalAlign: "vertical-align"
        case .visibility: "visibility"

        case .whiteSpace: "white-space"
        case .whiteSpaceCollapse: "white-space-collapse"
        case .widows: "widows"
        case .width: "width"
        //case .word: "word"
        case .writingMode: "writing-mode"

        case .zIndex: "z-index"
        case .zoom: "zoom"
        }
    }
}

// MARK: HTML value
extension CSSStyle {
    @inlinable
    public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
        func get<T: HTMLInitializable>(_ value: T?) -> String? {
            guard let v = value?.htmlValue(encoding: encoding, forMacro: forMacro) else { return nil }
            return key + ":" + v
        }
        switch self {
        case .all(let v): return get(v)
        case .appearance(let v): return get(v)

        case .backfaceVisibility(let v): return get(v)
        case .box(let v): return get(v)
        case .break(let v): return get(v)

        case .captionSide(let v): return get(v)
        case .clear(let v): return get(v)
        case .color(let v): return get(v)
        case .colorScheme(let v): return get(v)
        case .cursor(let v): return get(v)

        case .direction(let v): return get(v)
        case .display(let v): return get(v)

        case .emptyCells(let v): return get(v)

        case .float(let v): return get(v)

        case .height(let v): return get(v)
        case .hyphens(let v): return get(v)

        case .imageRendering(let v): return get(v)
        case .isolation(let v): return get(v)

        case .objectFit(let v): return get(v)
        case .opacity(let v): return get(v)
        case .order(let v): return get(v)

        case .visibility(let v): return get(v)

        case .whiteSpace(let v): return get(v)
        case .whiteSpaceCollapse(let v): return get(v)
        case .width(let v): return get(v)
        case .widows(let v): return get(v)
        case .writingMode(let v): return get(v)

        case .zoom(let v): return get(v)
        case .zIndex(let v): return get(v)
        default: return nil
        }
    }
}