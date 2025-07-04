
import HTMLKitUtilities

extension CSSStyle {
    public enum Appearance: String, HTMLParsable {
        case auto
        case button
        case checkbox
        case inherit
        case initial
        case menulistButton
        case none
        case revert
        case revertLayer
        case textfield
        case unset

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .menulistButton: return "menulist-button"
            case .revertLayer: return "revert-layer"
            default: return rawValue
            }
        }
    }
}