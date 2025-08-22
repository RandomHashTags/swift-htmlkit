
import HTMLKitUtilities

extension CSSStyle {
    public enum WritingMode: String, HTMLInitializable {
        case horizontalTB
        case verticalRL
        case verticalLR

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .horizontalTB: return "horizontal-tb"
            case .verticalLR: return "vertical-lr"
            case .verticalRL: return "vertical-rl"
            }
        }
    }
}