
import HTMLKitUtilities

extension CSSStyle {
    public enum ObjectFit: String, HTMLParsable {
        case contain
        case cover
        case fill
        case inherit
        case initial
        case none
        case scaleDown

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .scaleDown: return "scale-down"
            default: return rawValue
            }
        }
    }
}