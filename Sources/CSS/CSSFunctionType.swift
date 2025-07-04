
// https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Functions
public enum CSSFunctionType: String {
    case abs
    case acos
    case anchor
    case anchorSize
    case asin
    case atan
    case atan2
    case attr
    case blur
    case brightness
    case calcSize
    case calc
    case circle
    case clamp
    case colorMix
    case color
    case conicGradient
    case contrast
    case cos
    case counter
    case counters
    case crossFade
    case cubicBezier
    case deviceCmyk
    case dropShadow
    case element
    case ellipse
    case env
    case exp
    case fitContent
    case grayscale
    case hsl
    case hueRotate
    case hwb
    case hypot
    case imageSet
    case image
    case inset
    case invert
    case lab
    case layer
    case lch
    case lightDark
    case linearGradient
    case linear
    case log
    case matrix
    case matrix3d
    case max
    case min
    case minmax
    case mod
    case oklab
    case oklch
    case opacity
    case paint
    case paletteMix
    case path
    case perspective
    case polygon
    case pow
    case radialGradient
    case ray
    case rect
    case rem
    case `repeat`
    case repeatingConicGradient
    case repeatingLinearGradient
    case repeatingRadialGradient
    case rgb
    case rotate
    case rotate3d
    case rotateX
    case rotateY
    case rotateZ
    case round
    case saturate
    case scale
    case scale3d
    case scaleX
    case scaleY
    case scaleZ
    case scroll
    case sepia
    case shape
    case sign
    case sin
    case skew
    case skewX
    case skewY
    case sqrt
    case steps
    case symbols
    case tan
    case translate
    case translate3d
    case translateX
    case translateY
    case translateZ
    case url
    case `var`
    case view
    case xywh

    @inlinable
    public var key: String {
        switch self {
        case .anchorSize: "anchor-size"
        case .calcSize: "calc-size"
        case .colorMix: "color-mix"
        case .conicGradient: "conic-gradient"
        case .crossFade: "cross-fade"
        case .cubicBezier: "cubic-bezier"
        case .deviceCmyk: "device-cmyk"
        case .dropShadow: "drop-shadow"
        case .fitContent: "fit-content"
        case .hueRotate: "hue-rotate"
        case .imageSet: "image-set"
        case .lightDark: "light-dark"
        case .linearGradient: "linear-gradient"
        case .paletteMix: "palette-mix"
        case .radialGradient: "radial-gradient"
        case .repeatingConicGradient: "repeating-conic-gradient"
        case .repeatingLinearGradient: "repeating-linear-gradient"
        case .repeatingRadialGradient: "repeating-radial-gradient"
        default: rawValue
        }
    }
}