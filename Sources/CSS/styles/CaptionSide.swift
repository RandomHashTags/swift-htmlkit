
import HTMLKitUtilities

extension CSSStyle {
    public enum CaptionSide: String, HTMLParsable {
        case bottom
        case inherit
        case initial
        case revert
        case revertLayer
        case top
        case unset

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .revertLayer: return "revert-layer"
            default: return rawValue
            }
        }
    }
}