
import HTMLKitUtilities

extension CSSStyle {
    public enum HyphenateCharacter: HTMLParsable {
        case auto
        case char(Character)
        case inherit
        case initial

        public init?(context: HTMLExpansionContext) {
            return nil
        }

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