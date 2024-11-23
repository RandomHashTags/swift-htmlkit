//
//  HTMLKitUtilities.swift
//
//
//  Created by Evan Anderson on 9/19/24.
//

import SwiftSyntax
import SwiftSyntaxMacros

// MARK: HTMLKitUtilities
public enum HTMLKitUtilities {
    public struct ElementData {
        public let encoding:HTMLEncoding
        public let globalAttributes:[HTMLElementAttribute]
        public let attributes:[String:Any]
        public let innerHTML:[CustomStringConvertible]
        public let trailingSlash:Bool

        init(
            _ encoding: HTMLEncoding,
            _ globalAttributes: [HTMLElementAttribute],
            _ attributes: [String:Any],
            _ innerHTML: [CustomStringConvertible],
            _ trailingSlash: Bool
        ) {
            self.encoding = encoding
            self.globalAttributes = globalAttributes
            self.attributes = attributes
            self.innerHTML = innerHTML
            self.trailingSlash = trailingSlash
        }
    }
}

// MARK: Escape HTML
public extension String {
    /// Escapes all occurrences of source-breaking HTML characters
    /// - Parameters:
    ///   - escapeAttributes: Whether or not to escape source-breaking HTML attribute characters
    /// - Returns: A new `String` escaping source-breaking HTML
    func escapingHTML(escapeAttributes: Bool) -> String {
        var string:String = self
        string.escapeHTML(escapeAttributes: escapeAttributes)
        return string
    }
    /// Escapes all occurrences of source-breaking HTML characters
    /// - Parameters:
    ///   - escapeAttributes: Whether or not to escape source-breaking HTML attribute characters
    mutating func escapeHTML(escapeAttributes: Bool) {
        self.replace("&", with: "&amp;")
        self.replace("<", with: "&lt;")
        self.replace(">", with: "&gt;")
        if escapeAttributes {
            self.escapeHTMLAttributes()
        }
    }
    /// Escapes all occurrences of source-breaking HTML attribute characters
    /// - Returns: A new `String` escaping source-breaking HTML attribute characters
    func escapingHTMLAttributes() -> String {
        var string:String = self
        string.escapeHTMLAttributes()
        return string
    }
    /// Escapes all occurrences of source-breaking HTML attribute characters
    mutating func escapeHTMLAttributes() {
        self.replace("\\\"", with: "&quot;")
        self.replace("\"", with: "&quot;")
        self.replace("'", with: "&#39")
    }
}

// MARK: CSSUnit
public extension HTMLElementAttribute {
    enum CSSUnit : HTMLInitializable { // https://www.w3schools.com/cssref/css_units.php
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

        public init?(context: some MacroExpansionContext, key: String, arguments: LabeledExprListSyntax) {
            let expression:ExprSyntax = arguments.first!.expression
            func float() -> Float? {
                guard let s:String = expression.integerLiteral?.literal.text ?? expression.floatLiteral?.literal.text else { return nil }
                return Float(s)
            }
            switch key {
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

        public var key : String {
            switch self {
                case .centimeters(_):    return "centimeters"
                case .millimeters(_):    return "millimeters"
                case .inches(_):         return "inches"
                case .pixels(_):         return "pixels"
                case .points(_):         return "points"
                case .picas(_):          return "picas"

                case .em(_):             return "em"
                case .ex(_):             return "ex"
                case .ch(_):             return "ch"
                case .rem(_):            return "rem"
                case .viewportWidth(_):  return "viewportWidth"
                case .viewportHeight(_): return "viewportHeight"
                case .viewportMin(_):    return "viewportMin"
                case .viewportMax(_):    return "viewportMax"
                case .percent(_):        return "percent"
            }
        }

        public var htmlValue : String? {
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

        public var htmlValueIsVoidable : Bool { false }

        public var suffix : String {
            switch self {
                case .centimeters(_):    return "cm"
                case .millimeters(_):    return "mm"
                case .inches(_):         return "in"
                case .pixels(_):         return "px"
                case .points(_):         return "pt"
                case .picas(_):          return "pc"
                    
                case .em(_):             return "em"
                case .ex(_):             return "ex"
                case .ch(_):             return "ch"
                case .rem(_):            return "rem"
                case .viewportWidth(_):  return "vw"
                case .viewportHeight(_): return "vh"
                case .viewportMin(_):    return "vmin"
                case .viewportMax(_):    return "vmax"
                case .percent(_):        return "%"
            }
        }
    }
}

// MARK: LiteralReturnType
public enum LiteralReturnType {
    case boolean(Bool)
    case string(String)
    case int(Int)
    case float(Float)
    case interpolation(String)
    case array([Any])

    public var isInterpolation : Bool {
        switch self {
            case .interpolation(_): return true
            default: return false
        }
    }
    public var isString : Bool {
        switch self {
            case .string(_): return true
            default: return false
        }
    }

    public func value(key: String) -> String? {
        switch self {
            case .boolean(let b): return b ? key : nil
            case .string(var string):
                if string.isEmpty && key == "attributionsrc" {
                    return ""
                }
                string.escapeHTML(escapeAttributes: true)
                return string
            case .int(let int):
                return String(describing: int)
            case .float(let float):
                return String(describing: float)
            case .interpolation(let string):
                return string
            case .array(_):
                return nil
        }
    }
}