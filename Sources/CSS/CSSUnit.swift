
#if canImport(HTMLKitUtilities)
import HTMLKitUtilities
#endif

public enum CSSUnit: HTMLInitializable { // https://www.w3schools.com/cssref/css_units.php
    // absolute
    case centimeters(_ value: Float?)
    case millimeters(_ value: Float?)
    /// 1 inch = 96px = 2.54cm
    case inches(_ value: Float?)
    /// 1 pixel = 1/96th of 1inch
    case pixels(_ value: Float?)
    /// 1 point = 1/72 of 1inch
    case points(_ value: Float?)
    /// 1 pica = 12 points
    case picas(_ value: Float?)
    
    // relative
    /// Relative to the font-size of the element (2em means 2 times the size of the current font)
    case em(_ value: Float?)
    /// Relative to the x-height of the current font (rarely used)
    case ex(_ value: Float?)
    /// Relative to the width of the "0" (zero)
    case ch(_ value: Float?)
    /// Relative to font-size of the root element
    case rem(_ value: Float?)
    /// Relative to 1% of the width of the viewport
    case viewportWidth(_ value: Float?)
    /// Relative to 1% of the height of the viewport
    case viewportHeight(_ value: Float?)
    /// Relative to 1% of viewport's smaller dimension
    case viewportMin(_ value: Float?)
    /// Relative to 1% of viewport's larger dimension
    case viewportMax(_ value: Float?)
    /// Relative to the parent element
    case percent(_ value: Float?)

    @inlinable
    public var key: String {
        switch self {
        case .centimeters:    "centimeters"
        case .millimeters:    "millimeters"
        case .inches:         "inches"
        case .pixels:         "pixels"
        case .points:         "points"
        case .picas:          "picas"

        case .em:             "em"
        case .ex:             "ex"
        case .ch:             "ch"
        case .rem:            "rem"
        case .viewportWidth:  "viewportWidth"
        case .viewportHeight: "viewportHeight"
        case .viewportMin:    "viewportMin"
        case .viewportMax:    "viewportMax"
        case .percent:        "percent"
        }
    }

    @inlinable
    public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
        switch self {
        case .centimeters(let v),
            .millimeters(let v),
            .inches(let v),
            .pixels(let v),
            .points(let v),
            .picas(let v),
            
            .em(let v),
            .ex(let v),
            .ch(let v),
            .rem(let v),
            .viewportWidth(let v),
            .viewportHeight(let v),
            .viewportMin(let v),
            .viewportMax(let v),
            .percent(let v):
            guard let v else { return nil }
            var s = String(describing: v)
            while s.last == "0" {
                s.removeLast()
            }
            if s.last == "." {
                s.removeLast()
            }
            return s + suffix
        }
    }

    @inlinable
    public var suffix: String {
        switch self {
        case .centimeters:    "cm"
        case .millimeters:    "mm"
        case .inches:         "in"
        case .pixels:         "px"
        case .points:         "pt"
        case .picas:          "pc"
            
        case .em:             "em"
        case .ex:             "ex"
        case .ch:             "ch"
        case .rem:            "rem"
        case .viewportWidth:  "vw"
        case .viewportHeight: "vh"
        case .viewportMin:    "vmin"
        case .viewportMax:    "vmax"
        case .percent:        "%"
        }
    }
}