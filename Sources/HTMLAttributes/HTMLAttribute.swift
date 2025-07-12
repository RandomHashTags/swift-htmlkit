
#if canImport(CSS)
import CSS
#endif

import HTMLElementTypes
import HTMLAttributeTypes

#if canImport(HTMLKitUtilities)
import HTMLKitUtilities
#endif

#if canImport(HTMX)
import HTMX
#endif

// MARK: ElementData
extension HTMLKitUtilities {
    public struct ElementData: Sendable {
        public let encoding:HTMLEncoding
        public let globalAttributes:[any Attribute]
        public let attributes:[String:Sendable]
        public let innerHTML:[CustomStringConvertible & Sendable]
        public let trailingSlash:Bool

        package init(
            _ encoding: HTMLEncoding,
            _ globalAttributes: [any Attribute],
            _ attributes: [String:Sendable],
            _ innerHTML: [CustomStringConvertible & Sendable],
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