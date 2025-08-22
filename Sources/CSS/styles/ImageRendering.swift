
import HTMLKitUtilities

extension CSSStyle {
    public enum ImageRendering: String, HTMLInitializable {
        case auto
        case crispEdges
        case highQuality
        case initial
        case inherit
        case pixelated
        case smooth

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .crispEdges: return "crisp-edges"
            case .highQuality: return "high-quality"
            default: return rawValue
            }
        }
    }
}