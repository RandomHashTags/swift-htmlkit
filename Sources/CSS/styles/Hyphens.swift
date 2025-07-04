
import HTMLKitUtilities

extension CSSStyle {
    public enum Hyphens: String, HTMLParsable {
        case auto
        case inherit
        case initial
        case manual
        case none
    }
}