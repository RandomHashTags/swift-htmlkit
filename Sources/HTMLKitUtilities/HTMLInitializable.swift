
public protocol HTMLInitializable: Hashable, Sendable {

    @inlinable
    var key: String { get }

    @inlinable
    func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String?

    /// Default is `false`.
    @inlinable
    var htmlValueIsVoidable: Bool { get }
}

extension HTMLInitializable {
    @inlinable
    public func unwrap<T>(_ value: T?, suffix: String? = nil) -> String? {
        guard let value else { return nil }
        return "\(value)\(suffix ?? "")"
    }

    @inlinable
    public var htmlValueIsVoidable: Bool {
        false
    }
}

extension HTMLInitializable where Self: RawRepresentable, RawValue == String {
    @inlinable
    public var key: String {
        rawValue
    }

    @inlinable
    public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
        rawValue
    }
}