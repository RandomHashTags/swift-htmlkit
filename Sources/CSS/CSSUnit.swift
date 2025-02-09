//
//  CSSUnit.swift
//
//
//  Created by Evan Anderson on 11/19/24.
//

#if canImport(HTMLKitUtilities)
import HTMLKitUtilities
#endif

#if canImport(SwiftSyntax)
import SwiftSyntax
#endif

public enum CSSUnit : HTMLInitializable { // https://www.w3schools.com/cssref/css_units.php
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
    public var key : String {
        switch self {
        case .centimeters:    return "centimeters"
        case .millimeters:    return "millimeters"
        case .inches:         return "inches"
        case .pixels:         return "pixels"
        case .points:         return "points"
        case .picas:          return "picas"

        case .em:             return "em"
        case .ex:             return "ex"
        case .ch:             return "ch"
        case .rem:            return "rem"
        case .viewportWidth:  return "viewportWidth"
        case .viewportHeight: return "viewportHeight"
        case .viewportMin:    return "viewportMin"
        case .viewportMax:    return "viewportMax"
        case .percent:        return "percent"
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
            guard let v:Float = v else { return nil }
            var s:String = String(describing: v)
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
    public var htmlValueIsVoidable : Bool { false }

    @inlinable
    public var suffix : String {
        switch self {
        case .centimeters:    return "cm"
        case .millimeters:    return "mm"
        case .inches:         return "in"
        case .pixels:         return "px"
        case .points:         return "pt"
        case .picas:          return "pc"
            
        case .em:             return "em"
        case .ex:             return "ex"
        case .ch:             return "ch"
        case .rem:            return "rem"
        case .viewportWidth:  return "vw"
        case .viewportHeight: return "vh"
        case .viewportMin:    return "vmin"
        case .viewportMax:    return "vmax"
        case .percent:        return "%"
        }
    }
}

#if canImport(SwiftSyntax)
// MARK: HTMLParsable
extension CSSUnit : HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        func float() -> Float? {
            guard let expression:ExprSyntax = context.expression,
                    let s:String = expression.integerLiteral?.literal.text ?? expression.floatLiteral?.literal.text
            else {
                return nil
            }
            return Float(s)
        }
        switch context.key {
        case "centimeters": self = .centimeters(float())
        case "millimeters": self = .millimeters(float())
        case "inches": self = .inches(float())
        case "pixels": self = .pixels(float())
        case "points": self = .points(float())
        case "picas": self = .picas(float())

        case "em": self = .em(float())
        case "ex": self = .ex(float())
        case "ch": self = .ch(float())
        case "rem": self = .rem(float())
        case "viewportWidth": self = .viewportWidth(float())
        case "viewportHeight": self = .viewportHeight(float())
        case "viewportMin": self = .viewportMin(float())
        case "viewportMax": self = .viewportMax(float())
        case "percent": self = .percent(float())
        default: return nil
        }
    }
}
#endif