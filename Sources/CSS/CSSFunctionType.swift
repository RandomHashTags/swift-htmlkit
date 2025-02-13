//
//  CSSFunctionType.swift
//
//
//  Created by Evan Anderson on 2/13/25.
//

// https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Functions
public enum CSSFunctionType : String {
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
    public var key : String {
        switch self {
        case .anchorSize: return "anchor-size"
        case .calcSize: return "calc-size"
        case .colorMix: return "color-mix"
        case .conicGradient: return "conic-gradient"
        case .crossFade: return "cross-fade"
        case .cubicBezier: return "cubic-bezier"
        case .deviceCmyk: return "device-cmyk"
        case .dropShadow: return "drop-shadow"
        case .fitContent: return "fit-content"
        case .hueRotate: return "hue-rotate"
        case .imageSet: return "image-set"
        case .lightDark: return "light-dark"
        case .linearGradient: return "linear-gradient"
        case .paletteMix: return "palette-mix"
        case .radialGradient: return "radial-gradient"
        case .repeatingConicGradient: return "repeating-conic-gradient"
        case .repeatingLinearGradient: return "repeating-linear-gradient"
        case .repeatingRadialGradient: return "repeating-radial-gradient"
        default: return rawValue
        }
    }
}