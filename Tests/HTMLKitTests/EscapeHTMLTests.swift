//
//  EscapeHTMLTests.swift
//
//
//  Created by Evan Anderson on 11/29/24.
//

#if compiler(>=6.0)

#if canImport(FoundationEssentials)
import FoundationEssentials
#elseif canImport(Foundation)
import Foundation
#endif

import HTMLKit
import Testing

struct EscapeHTMLTests {
    let backslash:UInt8 = 92

    // MARK: macro
    @Test func escapeHTML() {
        var expected = "&lt;!DOCTYPE html&gt;&lt;html&gt;Test&lt;/html&gt;"
        var escaped = #escapeHTML(html("Test"))
        #expect(escaped == expected)

        escaped = #html(#escapeHTML(html("Test")))
        #expect(escaped == expected)

        expected = #escapeHTML("<>\"")
        escaped = #escapeHTML(encoding: .utf8Bytes, "<>\"")
        #expect(escaped == expected)

        expected = #escapeHTML("<>\"")
        escaped = #escapeHTML(encoding: .utf16Bytes, "<>\"")
        #expect(escaped == expected)

        expected = #escapeHTML("<>\"")
        escaped = #escapeHTML(encoding: .utf8CString, "<>\"")
        #expect(escaped == expected)

        expected = #escapeHTML("<>\"")
        escaped = #escapeHTML(encoding: .foundationData, "<>\"")
        #expect(escaped == expected)

        expected = #escapeHTML("<>\"")
        escaped = #escapeHTML(encoding: .byteBuffer, "<>\"")
        #expect(escaped == expected)
    }
    
    // MARK: string
    @Test func escapeEncodingString() throws {
        let unescaped:String = #html(html("Test"))
        let escaped:String = #escapeHTML(html("Test"))
        var expected:String = "<p>\(escaped)</p>"

        var string:String = #html(p("<!DOCTYPE html><html>Test</html>"))
        #expect(string == expected)

        string = #escapeHTML("<!DOCTYPE html><html>Test</html>")
        #expect(string == escaped)

        string = #escapeHTML(html("Test"))
        #expect(string == escaped)

        string = #html(p(#escapeHTML(html("Test"))))
        #expect(string == expected)

        string = #html(p(unescaped.escapingHTML(escapeAttributes: false)))
        #expect(string == expected)

        expected = "<div title=\"&lt;p&gt;\">&lt;p&gt;&lt;/p&gt;</div>"
        string = #html(div(attributes: [.title("<p>")], StaticString("<p></p>")))
        #expect(string == expected)

        string = #html(div(attributes: [.title("<p>")], "<p></p>"))
        #expect(string == expected)

        string = #html(p("What's 9 + 10? \"21\"!"))
        #expect(string == "<p>What&#39s 9 + 10? &quot;21&quot;!</p>")

        string = #html(option(value: "bad boy <html>"))
        expected = "<option value=\"bad boy &lt;html&gt;\"></option>"
        #expect(string == expected)
    }

    // MARK: utf8Array
    @Test func escapeEncodingUTF8Array() {
        var expected:String = #html(option(value: "juice WRLD <<<&>>> 999"))
        var value:[UInt8] = #html(encoding: .utf8Bytes, option(value: "juice WRLD <<<&>>> 999"))
        #expect(value == expected)
        #expect(value.firstIndex(of: backslash) == nil)

        expected = #html(option(#escapeHTML(option(value: "juice WRLD <<<&>>> 999"))))
        value = #html(encoding: .utf8Bytes, option(#escapeHTML(option(value: "juice WRLD <<<&>>> 999"))))
        #expect(value == expected)
        #expect(value.firstIndex(of: backslash) == nil)

        expected = #html(div(attributes: [.id("test")]))
        value = #html(encoding: .utf8Bytes, div(attributes: [.id("test")]))
        #expect(value == expected)
        #expect(value.firstIndex(of: backslash) == nil)
    }

    // MARK: utf16Array
    @Test func escapeEncodingUTF16Array() {
        let backslash:UInt16 = UInt16(backslash)
        var expected:String = #html(option(value: "juice WRLD <<<&>>> 999"))
        var value:[UInt16] = #html(encoding: .utf16Bytes, option(value: "juice WRLD <<<&>>> 999"))
        #expect(value == expected)
        #expect(value.firstIndex(of: backslash) == nil)

        expected = #html(option(#escapeHTML(option(value: "juice WRLD <<<&>>> 999"))))
        value = #html(encoding: .utf16Bytes, option(#escapeHTML(option(value: "juice WRLD <<<&>>> 999"))))
        #expect(value == expected)
        #expect(value.firstIndex(of: backslash) == nil)

        expected = #html(div(attributes: [.id("test")]))
        value = #html(encoding: .utf16Bytes, div(attributes: [.id("test")]))
        #expect(value == expected)
        #expect(value.firstIndex(of: backslash) == nil)
    }

    #if canImport(FoundationEssentials) || canImport(Foundation)
    // MARK: data
    @Test func escapeEncodingData() {
        var expected:String = #html(option(value: "juice WRLD <<<&>>> 999"))
        var value:Data = #html(encoding: .foundationData, option(value: "juice WRLD <<<&>>> 999"))
        #expect(String(data: value, encoding: .utf8) == expected)
        #expect(value.firstIndex(of: backslash) == nil)

        expected = #html(option(#escapeHTML(option(value: "juice WRLD <<<&>>> 999"))))
        value = #html(encoding: .foundationData, option(#escapeHTML(option(value: "juice WRLD <<<&>>> 999"))))
        #expect(String(data: value, encoding: .utf8) == expected)
        #expect(value.firstIndex(of: backslash) == nil)

        expected = #html(div(attributes: [.id("test")]))
        value = #html(encoding: .foundationData, div(attributes: [.id("test")]))
        #expect(String(data: value, encoding: .utf8) == expected)
        #expect(value.firstIndex(of: backslash) == nil)
    }
    #endif
}

#endif