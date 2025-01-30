//
//  HTMLInitializable.swift
//
//
//  Created by Evan Anderson on 12/1/24.
//

#if canImport(SwiftSyntax)
import SwiftSyntax
import SwiftSyntaxMacros
#endif

public protocol HTMLInitializable : Hashable, Sendable {
    #if canImport(SwiftSyntax)
    init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax)
    #endif

    @inlinable
    var key : String { get }

    @inlinable
    func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String?

    @inlinable
    var htmlValueIsVoidable : Bool { get }
}

extension HTMLInitializable {
    public func unwrap<T>(_ value: T?, suffix: String? = nil) -> String? {
        guard let value:T = value else { return nil }
        return "\(value)" + (suffix ?? "")
    }
}

extension HTMLInitializable where Self: RawRepresentable, RawValue == String {
    @inlinable
    public var key : String { rawValue }

    @inlinable
    public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? { rawValue }

    @inlinable
    public var htmlValueIsVoidable : Bool { false }

    #if canImport(SwiftSyntax)
    public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
        guard let value:Self = .init(rawValue: key) else { return nil }
        self = value
    }
    #endif
}