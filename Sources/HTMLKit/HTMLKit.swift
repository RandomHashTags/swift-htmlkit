
@_exported import CSS
@_exported import HTMLAttributes
@_exported import HTMLElements
@_exported import HTMLKitUtilities
@_exported import HTMLKitParse
@_exported import HTMX

// MARK: Escape HTML
@freestanding(expression)
public macro escapeHTML(
    encoding: HTMLEncoding = .string,
    representation: HTMLResultRepresentation = .literalOptimized,
    _ innerHTML: CustomStringConvertible & Sendable...
) -> String = #externalMacro(module: "HTMLKitMacros", type: "EscapeHTML")

// MARK: HTML
/// - Returns: The inferred concrete type that conforms to `CustomStringConvertible & Sendable`.
@freestanding(expression)
//@available(*, deprecated, message: "innerHTML is now initialized using brackets instead of parentheses")
public macro html<T>(
    encoding: HTMLEncoding = .string,
    representation: HTMLResultRepresentation = .literalOptimized,
    lookupFiles: [StaticString] = [],
    _ innerHTML: CustomStringConvertible & Sendable...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElementMacro")

// MARK: HTML
/// - Returns: The inferred concrete type that conforms to `CustomStringConvertible & Sendable`.
@freestanding(expression)
public macro html<T>(
    encoding: HTMLEncoding = .string,
    representation: HTMLResultRepresentation = .literalOptimized,
    lookupFiles: [StaticString] = [],
    _ innerHTML: () -> CustomStringConvertible & Sendable...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElementMacro")

/// - Returns: An existential conforming to `CustomStringConvertible & Sendable`.
@freestanding(expression)
public macro anyHTML(
    encoding: HTMLEncoding = .string,
    representation: HTMLResultRepresentation = .literalOptimized,
    lookupFiles: [StaticString] = [],
    _ innerHTML: CustomStringConvertible & Sendable...
) -> any CustomStringConvertible & Sendable = #externalMacro(module: "HTMLKitMacros", type: "HTMLElementMacro")

// MARK: Unchecked
/// Same as `#html` but ignoring compiler warnings.
/// 
/// - Returns: The inferred concrete type that conforms to `CustomStringConvertible & Sendable`.
@freestanding(expression)
public macro uncheckedHTML<T: CustomStringConvertible & Sendable>(
    encoding: HTMLEncoding = .string,
    representation: HTMLResultRepresentation = .literalOptimized,
    lookupFiles: [StaticString] = [],
    _ innerHTML: CustomStringConvertible & Sendable...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElementMacro")

// MARK: Raw
/// Does not escape the `innerHTML`.
/// 
/// - Returns: The inferred concrete type that conforms to `CustomStringConvertible & Sendable`.
@freestanding(expression)
public macro rawHTML<T: CustomStringConvertible & Sendable>(
    encoding: HTMLEncoding = .string,
    representation: HTMLResultRepresentation = .literalOptimized,
    lookupFiles: [StaticString] = [],
    minify: Bool = false,
    _ innerHTML: CustomStringConvertible & Sendable...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "RawHTML")

/// Does not escape the `innerHTML`.
/// 
/// - Returns: An existential conforming to `CustomStringConvertible & Sendable`.
@freestanding(expression)
public macro anyRawHTML(
    encoding: HTMLEncoding = .string,
    representation: HTMLResultRepresentation = .literalOptimized,
    lookupFiles: [StaticString] = [],
    minify: Bool = false,
    _ innerHTML: CustomStringConvertible & Sendable...
) -> any CustomStringConvertible & Sendable = #externalMacro(module: "HTMLKitMacros", type: "RawHTML")

// MARK: HTML Context
@freestanding(expression)
macro htmlContext<T: CustomStringConvertible & Sendable>(
    _ value: () -> T
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLContext")