
import CSS
import HTMLKitUtilities

public protocol HTMLParsable: HTMLInitializable {
    init?(context: HTMLExpansionContext)
}

extension HTMLParsable where Self: RawRepresentable, RawValue == String {
    public init?(context: HTMLExpansionContext) {
        guard let value:Self = .init(rawValue: context.key) else { return nil }
        self = value
    }
}

// MARK: Extensions
extension HTMLEvent: HTMLParsable {}


// MARK: CSS
extension CSSStyle.ObjectFit: HTMLParsable {}