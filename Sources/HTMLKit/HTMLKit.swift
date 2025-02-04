//
//  HTMLKit.swift
//
//
//  Created by Evan Anderson on 9/14/24.
//

@_exported import CSS
@_exported import HTMLAttributes
@_exported import HTMLElements
@_exported import HTMLKitUtilities
@_exported import HTMLKitParse
@_exported import HTMX

// MARK: StaticString equality
extension StaticString {
    public static func == (left: Self, right: Self) -> Bool { left.description == right.description }
    public static func != (left: Self, right: Self) -> Bool { left.description != right.description }
}
// MARK: StaticString and StringProtocol equality
extension StringProtocol {
    public static func == (left: Self, right: StaticString) -> Bool { left == right.description }
    public static func == (left: StaticString, right: Self) -> Bool { left.description == right }
}

// MARK: Escape HTML
@freestanding(expression)
public macro escapeHTML(
    encoding: HTMLEncoding = .string,
    _ innerHTML: CustomStringConvertible & Sendable...
) -> String = #externalMacro(module: "HTMLKitMacros", type: "EscapeHTML")

// MARK: HTML
@freestanding(expression)
public macro html<T: CustomStringConvertible>(
    encoding: HTMLEncoding = .string,
    lookupFiles: [StaticString] = [],
    _ innerHTML: CustomStringConvertible & Sendable...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElementMacro")

// MARK: Unchecked
/// Same as `#html` but ignoring compiler warnings.
@freestanding(expression)
public macro uncheckedHTML<T: CustomStringConvertible>(
    encoding: HTMLEncoding = .string,
    lookupFiles: [StaticString] = [],
    _ innerHTML: CustomStringConvertible & Sendable...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElementMacro")