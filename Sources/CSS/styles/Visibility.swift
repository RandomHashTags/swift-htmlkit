
import HTMLKitUtilities

// https://developer.mozilla.org/en-US/docs/Web/CSS/visibility
extension CSSStyle {
    public enum Visibility: String, HTMLParsable {
        case collapse
        case hidden
        case inherit
        case initial
        case revert
        case revertLayer
        case unset
        case visible

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .revertLayer: return "revert-layer"
            default: return rawValue
            }
        }
    }
}