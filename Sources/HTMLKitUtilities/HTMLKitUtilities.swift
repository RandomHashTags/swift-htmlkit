
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