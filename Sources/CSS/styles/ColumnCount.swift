
import HTMLKitUtilities

extension CSSStyle {
    public enum ColumnCount: HTMLInitializable {
        case auto
        case inherit
        case initial
        case int(Int)

        public var key: String {
            switch self {
            case .int: return "int"
            default: return "\(self)"
            }
        }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .int(let i): return "\(i)"
            default: return "\(self)"
            }
        }
    }
}