//
//  HTMLParsable.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

public protocol HTMLParsable : HTMLInitializable {
    #if canImport(SwiftSyntax)
    init?(context: HTMLExpansionContext)
    #endif
}

#if canImport(SwiftSyntax)
extension HTMLParsable where Self: RawRepresentable, RawValue == String {
    public init?(context: HTMLExpansionContext) {
        guard let value:Self = .init(rawValue: context.key) else { return nil }
        self = value
    }
}
#endif