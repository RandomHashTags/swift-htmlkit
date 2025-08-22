
import HTMLKitUtilities

extension CSSStyle {
    public enum HyphenateCharacter: HTMLInitializable {
        case auto
        case char(Character)
        case inherit
        case initial

        public var key: String {
            switch self {
            case .char: return "char"
            default: return "\(self)"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .char(let c): return "\(c)"
            default: return "\(self)"
            }
        }
    }
}