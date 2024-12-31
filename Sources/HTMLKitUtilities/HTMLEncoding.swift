//
//  HTMLEncoding.swift
//
//
//  Created by Evan Anderson on 11/21/24.
//

/// The value type the data should be encoded to when returned from the macro.
/// 
/// ### Interpolation Promotion
/// 
/// Swift HTMLKit tries to [promote](https://github.com/RandomHashTags/swift-htmlkit/blob/94793984763308ef5275dd9f71ea0b5e83fea417/Sources/HTMLKitMacros/HTMLElement.swift#L423) known interpolation at compile time with an equivalent string literal for the best performance, regardless of encoding.
/// It is currently limited due to macro expansions being sandboxed and lexical contexts/AST not being available for the macro argument types.
/// This means referencing content in an html macro won't get promoted to its expected value.
/// [Read more about this limitation](https://forums.swift.org/t/swift-lexical-lookup-for-referenced-stuff-located-outside-scope-current-file/75776/6).
/// 
/// #### Promotion Example
/// 
/// ```swift
/// let _:StaticString = #html(div("\("string")")) // ✅ promotion makes this "<div>string</div>"
/// let _:StaticString = #html(div("\(5)")) // ✅ promotion makes this "<div>5</div>"
/// let _:StaticString = #html(div(5)) // ✅ promotion makes this "<div>5</div>"
/// ````
/// 
/// #### Promotion Limitation
/// 
/// ```swift
/// let string:StaticString = "Test"
/// let _:StaticString = #html(div(string)) // ❌ promotion cannot be applied; StaticString not allowed
/// let _:String = #html(div(string)) // ⚠️ promotion cannot be applied; compiles to "<div>" + String(describing: string) + "</div>"`
/// ```
/// 
public enum HTMLEncoding {
    /// `String`/`StaticString`
    case string

    /// `[UInt8]`
    case utf8Bytes

    /// `ContiguousArray<CChar>`
    case utf8CString

    /// `[UInt16]`
    case utf16Bytes

    /// `Data`
    /// - Warning: You need to import `Foundation` to use this!
    case foundationData

    /// `ByteBuffer`
    /// - Warning: You need to import `NIOCore` to use this! Swift HTMLKit does not depend on `swift-nio`!
    case byteBuffer

    /// Encode the HTML into a custom type.
    /// 
    /// Use `$0` for the compiled HTML.
    /// - Parameters:
    ///   - logic: The encoding logic, represented as a string.
    /// - Warning: The custom type needs to conform to `CustomStringConvertible` to be returned by the html macro!
    /// ### Example Usage
    /// ```swift
    /// let _:String = #html(encoding: .custom(#"String("$0")"#), p(5)) // String("<p>5</p>")
    /// ```
    /// 
    case custom(_ logic: String, stringDelimiter: String = "\\\"")

    public init?(rawValue: String) {
        switch rawValue {
            case "string": self = .string
            case "utf8Bytes": self = .utf8Bytes
            case "utf8CString": self = .utf8CString
            case "utf16Bytes": self = .utf16Bytes
            case "foundationData": self = .foundationData
            case "byteBuffer": self = .byteBuffer
            default: return nil
        }
    }
    
    public func stringDelimiter(forMacro: Bool) -> String {
        switch self {
            case .string:
                return forMacro ? "\\\"" : "\""
            case .utf8Bytes, .utf16Bytes, .utf8CString, .foundationData, .byteBuffer:
                return "\""
            case .custom(_, let delimiter):
                return delimiter
        }
    }
}