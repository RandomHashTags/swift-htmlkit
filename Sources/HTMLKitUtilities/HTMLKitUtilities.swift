//
//  HTMLKitUtilities.swift
//
//
//  Created by Evan Anderson on 9/19/24.
//

#if canImport(SwiftSyntax)
import SwiftSyntax
#endif

// MARK: HTMLKitUtilities
public enum HTMLKitUtilities {
}

// MARK: Escape HTML
extension String {
    /// Escapes all occurrences of source-breaking HTML characters.
    /// 
    /// - Parameters:
    ///   - escapeAttributes: Whether or not to escape source-breaking HTML attribute characters.
    /// - Returns: A new `String` escaping source-breaking HTML.
    @inlinable
    public func escapingHTML(escapeAttributes: Bool) -> String {
        var string:String = self
        string.escapeHTML(escapeAttributes: escapeAttributes)
        return string
    }

    /// Escapes all occurrences of source-breaking HTML characters.
    /// 
    /// - Parameters:
    ///   - escapeAttributes: Whether or not to escape source-breaking HTML attribute characters.
    @inlinable
    public mutating func escapeHTML(escapeAttributes: Bool) {
        self.replace("&", with: "&amp;")
        self.replace("<", with: "&lt;")
        self.replace(">", with: "&gt;")
        if escapeAttributes {
            self.escapeHTMLAttributes()
        }
    }

    /// Escapes all occurrences of source-breaking HTML attribute characters.
    /// 
    /// - Returns: A new `String` escaping source-breaking HTML attribute characters.
    @inlinable
    public func escapingHTMLAttributes() -> String {
        var string:String = self
        string.escapeHTMLAttributes()
        return string
    }

    /// Escapes all occurrences of source-breaking HTML attribute characters.
    @inlinable
    public mutating func escapeHTMLAttributes() {
        self.replace("\\\"", with: "&quot;")
        self.replace("\"", with: "&quot;")
        self.replace("'", with: "&#39")
    }
}

#if canImport(SwiftSyntax)
// MARK: SwiftSyntax
extension ExprSyntaxProtocol {
    package var booleanLiteral : BooleanLiteralExprSyntax? { self.as(BooleanLiteralExprSyntax.self) }
    package var stringLiteral : StringLiteralExprSyntax? { self.as(StringLiteralExprSyntax.self) }
    package var integerLiteral : IntegerLiteralExprSyntax? { self.as(IntegerLiteralExprSyntax.self) }
    package var floatLiteral : FloatLiteralExprSyntax? { self.as(FloatLiteralExprSyntax.self) }
    package var array : ArrayExprSyntax? { self.as(ArrayExprSyntax.self) }
    package var dictionary : DictionaryExprSyntax? { self.as(DictionaryExprSyntax.self) }
    package var memberAccess : MemberAccessExprSyntax? { self.as(MemberAccessExprSyntax.self) }
    package var macroExpansion : MacroExpansionExprSyntax? { self.as(MacroExpansionExprSyntax.self) }
    package var functionCall : FunctionCallExprSyntax? { self.as(FunctionCallExprSyntax.self) }
    package var declRef : DeclReferenceExprSyntax? { self.as(DeclReferenceExprSyntax.self) }
}
extension SyntaxChildren.Element {
    package var labeled : LabeledExprSyntax? { self.as(LabeledExprSyntax.self) }
}
extension StringLiteralExprSyntax {
    package func string(encoding: HTMLEncoding) -> String {
        if openingQuote.debugDescription.hasPrefix("multilineStringQuote") {
            var value:String = segments.compactMap({ $0.as(StringSegmentSyntax.self)?.content.text }).joined()
            switch encoding {
            case .string:
                value.replace("\n", with: "\\n")
            default:
                break
            }
            return value
        }
        return "\(segments)"
    }
}
extension LabeledExprListSyntax {
    package func get(_ index: Int) -> Element? {
        return index < count ? self[self.index(at: index)] : nil
    }
}
#endif