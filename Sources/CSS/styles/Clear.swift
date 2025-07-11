
import HTMLKitUtilities

extension CSSStyle {
    public enum Clear: String, HTMLParsable {
        case both
        case inherit
        case initial
        case left
        case none
        case right
    }
}