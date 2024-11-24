//
//  HTMLKit.swift
//
//
//  Created by Evan Anderson on 9/14/24.
//

@_exported import HTMLKitUtilities

// MARK: StaticString equality
public extension StaticString {
    static func == (left: Self, right: Self) -> Bool { left.description == right.description }
    static func != (left: Self, right: Self) -> Bool { left.description != right.description }
}
// MARK: StaticString and StringProtocol equality
public extension StringProtocol {
    static func == (left: Self, right: StaticString) -> Bool { left == right.description }
    static func == (left: StaticString, right: Self) -> Bool { left.description == right }
}

@freestanding(expression)
public macro escapeHTML(_ innerHTML: CustomStringConvertible...) -> String = #externalMacro(module: "HTMLKitMacros", type: "EscapeHTML")

// MARK: HTML Representation
@freestanding(expression)
public macro html<T: CustomStringConvertible>(
    encoding: HTMLEncoding = .string,
    lookupFiles: [StaticString] = [],
    _ innerHTML: HTMLElement...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElementMacro")