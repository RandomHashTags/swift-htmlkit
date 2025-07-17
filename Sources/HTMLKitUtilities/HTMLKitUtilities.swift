
#if canImport(SwiftSyntax)
import SwiftSyntax
#endif

// MARK: HTMLKitUtilities
public enum HTMLKitUtilities {
    @usableFromInline
    package static let lineFeedPlaceholder:String = {
        return "%HTMLKitLineFeed\(Int.random(in: Int.min...Int.max))%"
    }()
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
        var string = self
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
        var string = self
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
    package var booleanLiteral: BooleanLiteralExprSyntax? { self.as(BooleanLiteralExprSyntax.self) }
    package var stringLiteral: StringLiteralExprSyntax? { self.as(StringLiteralExprSyntax.self) }
    package var integerLiteral: IntegerLiteralExprSyntax? { self.as(IntegerLiteralExprSyntax.self) }
    package var floatLiteral: FloatLiteralExprSyntax? { self.as(FloatLiteralExprSyntax.self) }
    package var array: ArrayExprSyntax? { self.as(ArrayExprSyntax.self) }
    package var dictionary: DictionaryExprSyntax? { self.as(DictionaryExprSyntax.self) }
    package var memberAccess: MemberAccessExprSyntax? { self.as(MemberAccessExprSyntax.self) }
    package var macroExpansion: MacroExpansionExprSyntax? { self.as(MacroExpansionExprSyntax.self) }
    package var functionCall: FunctionCallExprSyntax? { self.as(FunctionCallExprSyntax.self) }
    package var declRef: DeclReferenceExprSyntax? { self.as(DeclReferenceExprSyntax.self) }
}
extension ExprSyntaxProtocol {
    package var booleanIsTrue: Bool {
        booleanLiteral?.literal.text == "true"
    }
}
extension SyntaxChildren.Element {
    package var labeled: LabeledExprSyntax? {
        self.as(LabeledExprSyntax.self)
    }
}
extension StringLiteralExprSyntax {
    @inlinable 
    package func string(encoding: HTMLEncoding) -> String {
        if openingQuote.debugDescription.hasPrefix("multilineStringQuote") {
            var value = ""
            for segment in segments {
                value += segment.as(StringSegmentSyntax.self)?.content.text ?? ""
            }
            switch encoding {
            case .string:
                value.replace("\n", with: HTMLKitUtilities.lineFeedPlaceholder)
                value.replace("\"", with: "\\\"")
            default:
                break
            }
            return value
        }
        /*if segments.count > 1 {
            var value = segments.compactMap({
                guard let s = $0.as(StringSegmentSyntax.self)?.content.text, !s.isEmpty else { return nil }
                return s
            }).joined()
            switch encoding {
            case .string:
                value.replace("\n", with: "\\n")
            default:
                break
            }
            return value
        }*/
        return "\(segments)"
    }
}
extension Collection {
    /// - Returns: The element at the given index, checking if the index is within bounds (`>= startIndex && < endIndex`).
    @inlinable
    package func get(_ index: Index) -> Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
    /// - Returns: The element at the given index, only checking if the index is less than `endIndex`.
    @inlinable
    package func getPositive(_ index: Index) -> Element? {
        return index < endIndex ? self[index] : nil
    }
}
extension LabeledExprListSyntax {
    @inlinable
    package func get(_ index: Int) -> Element? {
        return self.get(self.index(at: index))
    }
    @inlinable
    package func getPositive(_ index: Int) -> Element? {
        return self.getPositive(self.index(at: index))
    }
}
#endif