
#if compiler(>=6.0)

import Testing
import HTMLKit

#if canImport(FoundationEssentials)
import struct FoundationEssentials.Data
#elseif canImport(Foundation)
import struct Foundation.Data
#endif

// MARK: StaticString equality
extension StaticString {
    static func == (left: Self, right: Self) -> Bool { left.description == right.description }
    static func != (left: Self, right: Self) -> Bool { left.description != right.description }
}
// MARK: StaticString and StringProtocol equality
extension StringProtocol {
    static func == (left: Self, right: StaticString) -> Bool { left == right.description }
    static func == (left: StaticString, right: Self) -> Bool { left.description == right }
}

// MARK: Encodings
struct HTMLKitTests {
    @Test
    func anyHTML() {
        let _ = #anyHTML(p())
        let _ = #anyHTML(encoding: .string, p())
        let _ = #anyHTML(encoding: .utf8Bytes, p())
        let _ = #anyHTML(encoding: .utf16Bytes, p())
    }
    @Test
    func encodingStaticStirng() -> StaticString {
        let _:StaticString = #html(p())
        let _:StaticString = #html(encoding: .string, p())
        return #html(p(123))
    }
    @Test
    func encodingString() -> String {
        let _:String = #html(p())
        let _:String = #html(encoding: .string, p())
        return #html(p(123))
    }
    @Test
    func encodingUTF8Bytes1() -> [UInt8] {
        let _:[UInt8] = #html(encoding: .utf8Bytes, p())
        return #html(encoding: .utf8Bytes, p(123))
    }
    @Test
    func encodingUTF8Bytes2() -> ContiguousArray<UInt8> {
        let _:ContiguousArray<UInt8> = #html(encoding: .utf8Bytes, p())
        return #html(encoding: .utf8Bytes, p(123))
    }
    @Test
    func encodingUTF16Bytes1() -> [UInt16] {
        let _:[UInt16] = #html(encoding: .utf16Bytes, p())
        return #html(encoding: .utf16Bytes, p(123))
    }
    @Test
    func encodingUTF16Bytes2() -> ContiguousArray<UInt16> {
        let _:ContiguousArray<UInt16> = #html(encoding: .utf16Bytes, p())
        return #html(encoding: .utf16Bytes, p(123))
    }
    @Test
    func encodingUTF8CString() -> ContiguousArray<CChar> {
        let _:ContiguousArray<CChar> = #html(encoding: .utf8CString, p())
        return #html(encoding: .utf8CString, p(123))
    }
    @Test
    func encodingCustom() {
        let _:String = #html(encoding: .custom(#""$0""#), p(5))
    }
    #if canImport(FoundationEssentials) || canImport(Foundation)
    @Test
    func encodingData() -> Data {
        let _:Data = #html(encoding: .foundationData, p())
        return #html(encoding: .foundationData, p(123))
    }
    #endif
    /*
    func representation7() -> ByteBuffer {
        #htmlByteBuffer("")
    }*/
}

// MARK: Representations
extension HTMLKitTests {
    @Test
    func representations() {
        let yeah = "yeah"
        let _:String = #html(resultType: .literal) {
            div("oh yeah")
        }
        let _:String = #html(resultType: .literal) {
            div("oh \(yeah)")
        }
        /*let _:String = #html(resultType: .literalOptimized) {
            div("oh yeah")
        }
        let _:String = #html(resultType: .literalOptimized) {
            div("oh \(yeah)")
        }*/

        let _:[String] = #html(resultType: .chunked()) {
            div("oh yeah")
        }
        let _:[StaticString] = #html(resultType: .chunked()) {
            div("oh yeah")
        }
        /*let _:[String] = #html(resultType: .chunked(chunkSize: 3)) { // TODO: fix
            div("oh \(yeah)")
        }*/

        let _:AsyncStream<String> = #html(resultType: .streamed()) {
            div("oh yeah")
        }
        let _:AsyncStream<StaticString> = #html(resultType: .streamed()) {
            div("oh yeah")
        }
        let _:AsyncStream<String> = #html(resultType: .streamed(chunkSize: 3)) {
            div("oh yeah")
        }
        let _:AsyncStream<StaticString> = #html(resultType: .streamed(chunkSize: 3)) {
            div("oh yeah")
        }
        /*let _:AsyncStream<String> = #html(resultType: .streamed(chunkSize: 3)) {
            div("oh\(yeah)") // TODO: fix
        }*/

        let _:AsyncStream<String> = #html(resultType: .streamedAsync()) {
            div("oh yeah")
        }
        let _:AsyncStream<String> = #html(resultType: .streamedAsync(chunkSize: 3)) {
            div("oh yeah")
        }
        let _:AsyncStream<String> = #html(resultType: .streamedAsync({ _ in
            try await Task.sleep(for: .milliseconds(50))
        })) {
            div("oh yeah")
        }
        let _:AsyncStream<String> = #html(resultType: .streamedAsync(chunkSize: 3, { _ in
            try await Task.sleep(for: .milliseconds(50))
        })) {
            div("oh yeah")
        }
    }
}

// MARK: StaticString Example
extension HTMLKitTests {
    @Test func example1() {
        let test:StaticString = #html(
            html(
                body(
                    div(
                        attributes: [
                            .class(["dark-mode", "row"]),
                            .draggable(.false),
                            .hidden(.true),
                            .inputmode(.email),
                            .title("Hey, you're pretty cool")
                        ],
                        "Random text",
                        div(),
                        a(
                            div(
                                abbr()
                            ),
                            address()
                        ),
                        div(),
                        button(disabled: true),
                        video(autoplay: true, controls: false, preload: .auto, src: "https://github.com/RandomHashTags/litleagues", width: .centimeters(1))
                    )
                )
            )
        )
        #expect(test == "<!DOCTYPE html><html><body><div class=\"dark-mode row\" draggable=\"false\" hidden inputmode=\"email\" title=\"Hey, you&#39re pretty cool\">Random text<div></div><a><div><abbr></abbr></div><address></address></a><div></div><button disabled></button><video autoplay preload=\"auto\" src=\"https://github.com/RandomHashTags/litleagues\" width=\"1cm\"></video></div></body></html>")
    }
}

// MARK: Dynamic test
extension HTMLKitTests {
    @Test func dynamic() {
        let charset:String = "utf-8", title_literal:String = "Dynamic"
        var qualities:String = ""
        for quality in ["one", "two", "three", "four"] {
            qualities += li(quality).description
        }
        let string:String = #html(
            html(
                head(
                    meta(charset: charset),
                    title(title_literal),
                    meta(content: "\("description \(title_literal)")", name: "description"),
                    meta(content: "\("keywords")", name: "keywords")
                ),
                body(
                    h1("\("Heading")"),
                    div(attributes: [.id("desc")],
                        p("\("bro")")
                    ),
                    h2("\("Details")"),
                    h3("\("Qualities")"),
                    ul(attributes: [.id("user-qualities")], qualities)
                )
            )
        )
        #expect(string == "<!DOCTYPE html><html><head><meta charset=\"\(charset)\"><title>\(title_literal)</title><meta content=\"description \(title_literal)\" name=\"description\"><meta content=\"keywords\" name=\"keywords\"></head><body><h1>Heading</h1><div id=\"desc\"><p>bro</p></div><h2>Details</h2><h3>Qualities</h3><ul id=\"user-qualities\">\(qualities)</ul></body></html>")
    }
}

// MARK: Example2
extension HTMLKitTests {
    @Test func example2() {
        var test:TestStruct = TestStruct(name: "one", array: ["1", "2", "3"])
        #expect(test.html == "<p>one123</p>")
        
        test.name = "two"
        test.array = [4, 5, 6, 7, 8]
        #expect(test.html == "<p>two45678</p>")
    }
    struct TestStruct {
        var name:String
        var array:[CustomStringConvertible] {
            didSet {
                array_string = array.map({ "\($0)" }).joined()
            }
        }
        private var array_string:String
        
        init(name: String, array: [CustomStringConvertible]) {
            self.name = name
            self.array = array
            self.array_string = array.map({ "\($0)" }).joined()
        }

        var html: String { #html(p(name, array_string)) }
    }
}

#endif