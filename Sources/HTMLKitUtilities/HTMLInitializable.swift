//
//  HTMLInitializable.swift
//
//
//  Created by Evan Anderson on 12/1/24.
//

public protocol HTMLInitializable: Hashable, Sendable {

    @inlinable
    var key: String { get }

    @inlinable
    func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String?

    @inlinable
    var htmlValueIsVoidable: Bool { get }
}

extension HTMLInitializable {
    @inlinable
    public func unwrap<T>(_ value: T?, suffix: String? = nil) -> String? {
        guard let value else { return nil }
        return "\(value)" + (suffix ?? "")
    }
}

extension HTMLInitializable where Self: RawRepresentable, RawValue == String {
    @inlinable
    public var key: String { rawValue }

    @inlinable
    public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? { rawValue }

    @inlinable
    public var htmlValueIsVoidable: Bool { false }
}