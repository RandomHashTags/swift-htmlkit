
import HTMLKitUtilities

extension CSSStyle {
    public enum EmptyCells: String, HTMLParsable {
        case hide
        case inherit
        case initial
        case show
    }
}