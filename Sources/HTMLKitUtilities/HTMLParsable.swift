
public protocol HTMLParsable: HTMLInitializable {
    #if canImport(SwiftSyntax)
    init?(context: HTMLExpansionContext)
    #endif
}

#if canImport(SwiftSyntax)
extension HTMLParsable where Self: RawRepresentable, RawValue == String {
    public init?(context: HTMLExpansionContext) {
        guard let value = Self(rawValue: context.key) else { return nil }
        self = value
    }
}

extension HTMLParsable where Self: RawRepresentable, RawValue == Bool {
    public init?(context: HTMLExpansionContext) {
        guard let value = Self(rawValue: true) else { return nil } // TODO: fix?
        self = value
    }
}
#endif