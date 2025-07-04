
import HTMLKitUtilities

// https://developer.mozilla.org/en-US/docs/Web/CSS/order
extension CSSStyle {
    public enum Order: HTMLInitializable {
        case int(Int?)
        case inherit
        case initial
        case revert
        case revertLayer
        case unset

        /// - Warning: Never use.
        @inlinable
        public var key: String { "" }

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .int(let v): guard let v:Int = v else { return nil }; return "\(v)"
            case .revertLayer: return "revert-layer"
            default: return "\(self)"
            }
        }
    }
}