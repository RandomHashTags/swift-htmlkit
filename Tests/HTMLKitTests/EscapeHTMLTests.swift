//
//  EscapeHTMLTests.swift
//
//
//  Created by Evan Anderson on 11/29/24.
//

#if swift(>=6.0)

#if canImport(Foundation)
import Foundation
#endif

import HTMLKit
import Testing

struct EscapeHTMLTests {
    let backslash:UInt8 = 92

    // MARK: macro
    @Test func escape_macro() {
        var expected_result:String = "&lt;!DOCTYPE html&gt;&lt;html&gt;Test&lt;/html&gt;"
        var escaped:String = #escapeHTML(html("Test"))
        #expect(escaped == expected_result)

        escaped = #html(#escapeHTML(html("Test")))
        #expect(escaped == expected_result)

        expected_result = #escapeHTML("<>\"")
        escaped = #escapeHTML(encoding: .utf8Bytes, "<>\"")
        #expect(escaped == expected_result)

        expected_result = #escapeHTML("<>\"")
        escaped = #escapeHTML(encoding: .utf16Bytes, "<>\"")
        #expect(escaped == expected_result)

        expected_result = #escapeHTML("<>\"")
        escaped = #escapeHTML(encoding: .utf8CString, "<>\"")
        #expect(escaped == expected_result)

        expected_result = #escapeHTML("<>\"")
        escaped = #escapeHTML(encoding: .foundationData, "<>\"")
        #expect(escaped == expected_result)

        expected_result = #escapeHTML("<>\"")
        escaped = #escapeHTML(encoding: .byteBuffer, "<>\"")
        #expect(escaped == expected_result)
    }
    
    // MARK: string
    @Test func escape_encoding_string() throws {
        let unescaped:String = #html(html("Test"))
        let escaped:String = #escapeHTML(html("Test"))
        var expected_result:String = "<p>\(escaped)</p>"

        var string:String = #html(p("<!DOCTYPE html><html>Test</html>"))
        #expect(string == expected_result)

        string = #escapeHTML("<!DOCTYPE html><html>Test</html>")
        #expect(string == escaped)

        string = #escapeHTML(html("Test"))
        #expect(string == escaped)

        string = #html(p(#escapeHTML(html("Test"))))
        #expect(string == expected_result)

        string = #html(p(unescaped.escapingHTML(escapeAttributes: false)))
        #expect(string == expected_result)

        expected_result = "<div title=\"&lt;p&gt;\">&lt;p&gt;&lt;/p&gt;</div>"
        string = #html(div(attributes: [.title("<p>")], StaticString("<p></p>")))
        #expect(string == expected_result)

        string = #html(div(attributes: [.title("<p>")], "<p></p>"))
        #expect(string == expected_result)

        string = #html(p("What's 9 + 10? \"21\"!"))
        #expect(string == "<p>What&#39s 9 + 10? &quot;21&quot;!</p>")

        string = #html(option(value: "bad boy <html>"))
        expected_result = "<option value=\"bad boy &lt;html&gt;\"></option>"
        #expect(string == expected_result)
    }

    #if canImport(Foundation)
    // MARK: utf8Array
    @Test func escape_encoding_utf8Array() {
        var expected_result:String = #html(option(value: "juice WRLD <<<&>>> 999"))
        var value:[UInt8] = #html(encoding: .utf8Bytes, option(value: "juice WRLD <<<&>>> 999"))
        #expect(String(data: Data(value), encoding: .utf8) == expected_result)
        #expect(value.firstIndex(of: backslash) == nil)

        expected_result = #html(option(#escapeHTML(option(value: "juice WRLD <<<&>>> 999"))))
        value = #html(encoding: .utf8Bytes, option(#escapeHTML(option(value: "juice WRLD <<<&>>> 999"))))
        #expect(String(data: Data(value), encoding: .utf8) == expected_result)
        #expect(value.firstIndex(of: backslash) == nil)

        expected_result = #html(div(attributes: [.id("test")]))
        value = #html(encoding: .utf8Bytes, div(attributes: [.id("test")]))
        #expect(String(data: Data(value), encoding: .utf8) == expected_result)
        #expect(value.firstIndex(of: backslash) == nil)
    }
    #endif
}

#endif