//
//  HTMLParsable.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

#if canImport(SwiftSyntax)
import SwiftSyntax
import SwiftSyntaxMacros
#endif

public protocol HTMLParsable : HTMLInitializable { // TODO: rename HTMLInitializable to HTMLParsable
    #if canImport(SwiftSyntax)
    init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax)
    #endif
}

#if canImport(SwiftSyntax)
extension HTMLInitializable where Self: RawRepresentable, RawValue == String {
    public init?(context: some MacroExpansionContext, isUnchecked: Bool, key: String, arguments: LabeledExprListSyntax) {
        guard let value:Self = .init(rawValue: key) else { return nil }
        self = value
    }
}
#endif