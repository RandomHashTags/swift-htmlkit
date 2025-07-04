
import HTMLKitUtilities

// https://developer.mozilla.org/en-US/docs/Web/CSS/float
extension CSSStyle {
    public enum Float: String, HTMLParsable {
        case inherit
        case initial
        case inlineEnd
        case inlineStart
        case left
        case none
        case revert
        case revertLayer
        case right
        case unset

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .inlineEnd: return "inline-end"
            case .inlineStart: return "inline-start"
            case .revertLayer: return "revert-layer"
            default: return rawValue
            }
        }
    }
}