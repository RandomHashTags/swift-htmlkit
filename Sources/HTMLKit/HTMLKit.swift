//
//  HTMLKit.swift
//
//
//  Created by Evan Anderson on 9/14/24.
//

import HTMLKitUtilities

#if canImport(Foundation)
import struct Foundation.Data
#endif

import struct NIOCore.ByteBuffer

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
public macro escapeHTML<T: ExpressibleByStringLiteral>(_ innerHTML: T...) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: HTML Representation
@freestanding(expression)
public macro html<T: ExpressibleByStringLiteral>(
    lookupFiles: [StaticString] = [],
    attributes: [HTMLElementAttribute] = [],
    xmlns: T? = nil,
    _ innerHTML: HTML...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro htmlUTF8Bytes<T: ExpressibleByStringLiteral>(lookupFiles: [StaticString] = [], attributes: [HTMLElementAttribute] = [], xmlns: T? = nil, _ innerHTML: T...) -> [UInt8] = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro htmlUTF16Bytes<T: ExpressibleByStringLiteral>(lookupFiles: [StaticString] = [], attributes: [HTMLElementAttribute] = [], xmlns: T? = nil, _ innerHTML: T...) -> [UInt16] = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro htmlUTF8CString<T: ExpressibleByStringLiteral>(lookupFiles: [StaticString] = [], attributes: [HTMLElementAttribute] = [], xmlns: T? = nil, _ innerHTML: T...) -> ContiguousArray<CChar> = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

#if canImport(Foundation)
@freestanding(expression)
public macro htmlData<T: ExpressibleByStringLiteral>(lookupFiles: [StaticString] = [], attributes: [HTMLElementAttribute] = [], xmlns: T? = nil, _ innerHTML: T...) -> Data = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")
#endif

@freestanding(expression)
public macro htmlByteBuffer<T: ExpressibleByStringLiteral>(lookupFiles: [StaticString] = [], attributes: [HTMLElementAttribute] = [], xmlns: T? = nil, _ innerHTML: T...) -> ByteBuffer = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: Elements

@freestanding(expression)
public macro custom<T: ExpressibleByStringLiteral>(tag: String, isVoid: Bool, attributes: [HTMLElementAttribute] = [], _ innerHTML: T...) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")