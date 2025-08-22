
@_exported import CSS
@_exported import HTMLAttributes
@_exported import HTMLElements
@_exported import HTMLKitUtilities
@_exported import HTMX

// MARK: Escape HTML
@freestanding(expression)
public macro escapeHTML(
    encoding: HTMLEncoding = .string,
    resultType: HTMLExpansionResultType = .literal,
    _ innerHTML: Sendable...
) -> String = #externalMacro(module: "HTMLKitMacros", type: "EscapeHTML")

// MARK: HTML
/// - Returns: The inferred concrete type.
@freestanding(expression)
//@available(*, deprecated, message: "innerHTML is now initialized using brackets instead of parentheses")
public macro html<T>(
    encoding: HTMLEncoding = .string,
    resultType: HTMLExpansionResultType = .literal,
    lookupFiles: [StaticString] = [],
    _ innerHTML: Sendable...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElementMacro")

// MARK: HTML
/// - Returns: The inferred concrete type.
@freestanding(expression)
public macro html<T>(
    encoding: HTMLEncoding = .string,
    resultType: HTMLExpansionResultType = .literal,
    lookupFiles: [StaticString] = [],
    _ innerHTML: () -> Sendable...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElementMacro")

/// - Returns: `any Sendable`.
@freestanding(expression)
public macro anyHTML(
    encoding: HTMLEncoding = .string,
    resultType: HTMLExpansionResultType = .literal,
    lookupFiles: [StaticString] = [],
    _ innerHTML: Sendable...
) -> any Sendable = #externalMacro(module: "HTMLKitMacros", type: "HTMLElementMacro")

// MARK: Unchecked
/// Same as `#html` but ignoring compiler warnings.
/// 
/// - Returns: The inferred concrete type.
@freestanding(expression)
public macro uncheckedHTML<T>(
    encoding: HTMLEncoding = .string,
    resultType: HTMLExpansionResultType = .literal,
    lookupFiles: [StaticString] = [],
    _ innerHTML: Sendable...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElementMacro")

// MARK: Raw
/// Does not escape the `innerHTML`.
/// 
/// - Returns: The inferred concrete type.
@freestanding(expression)
public macro rawHTML<T>(
    encoding: HTMLEncoding = .string,
    resultType: HTMLExpansionResultType = .literal,
    lookupFiles: [StaticString] = [],
    minify: Bool = false,
    _ innerHTML: Sendable...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "RawHTML")

/// Does not escape the `innerHTML`.
/// 
/// - Returns: `any Sendable`.
@freestanding(expression)
public macro anyRawHTML(
    encoding: HTMLEncoding = .string,
    resultType: HTMLExpansionResultType = .literal,
    lookupFiles: [StaticString] = [],
    minify: Bool = false,
    _ innerHTML: Sendable...
) -> any Sendable = #externalMacro(module: "HTMLKitMacros", type: "RawHTML")