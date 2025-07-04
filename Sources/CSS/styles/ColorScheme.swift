
import HTMLKitUtilities

extension CSSStyle {
    public enum ColorScheme: String, HTMLParsable {
        case dark
        case light
        case lightDark
        case normal
        case onlyDark
        case onlyLight

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .lightDark: return "light dark"
            case .onlyDark: return "only dark"
            case .onlyLight: return "only light"
            default: return rawValue
            }
        }
    }
}