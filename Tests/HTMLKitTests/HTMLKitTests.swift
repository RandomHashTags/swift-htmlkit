//
//  HTMLKitTests.swift
//
//
//  Created by Evan Anderson on 9/16/24.
//

#if compiler(>=6.0)

import Testing
import HTMLKit

#if canImport(Foundation)
import struct Foundation.Data
#endif

// MARK: Representations
struct HTMLKitTests {
    @Test
    func memoryLayout() {
        //print("before=\((MemoryLayout<a>.alignment, MemoryLayout<a>.size, MemoryLayout<a>.stride))")
        //print("after=\((MemoryLayout<NewA>.alignment, MemoryLayout<NewA>.size, MemoryLayout<NewA>.stride))")
    }

    public struct NewA : HTMLElement {
        private var encoding:HTMLEncoding = .string
        
        /// Causes the browser to treat the linked URL as a download. Can be used with or without a `filename` value.
        /// 
        /// Without a value, the browser will suggest a filename/extension, generated from various sources:
        /// - The [`Content-Disposition`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Disposition) HTTP header
        /// - The final segment in the URL [path](https://developer.mozilla.org/en-US/docs/Web/API/URL/pathname)
        /// - The [media type](https://developer.mozilla.org/en-US/docs/Glossary/MIME_type) (from the [`Content-Type`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type) header, the start of a [`data:` URL](https://developer.mozilla.org/en-US/docs/Web/URI/Schemes/data), or [`Blob.type`](https://developer.mozilla.org/en-US/docs/Web/API/Blob/type) for a [`blob:` URL](https://developer.mozilla.org/en-US/docs/Web/API/URL/createObjectURL_static))
        public var download:HTMLElementAttribute.Extra.download? = nil
        public var href:String? = nil
        public var hrefLang:String? = nil
        public let tag:String = "a"
        public var type:String? = nil
        public var attributes:[HTMLElementAttribute] = []
        public var attributionsrc:[String] = []
        public var innerHTML:[CustomStringConvertible] = []
        public var ping:[String] = []
        public var rel:[HTMLElementAttribute.Extra.rel] = []
        public var escaped:Bool = false
        private var fromMacro:Bool = false
        public let isVoid:Bool = false
        public var referrerPolicy:HTMLElementAttribute.Extra.referrerpolicy? = nil
        public var target:HTMLElementAttribute.Extra.target? = nil
        public var trailingSlash:Bool = false

        public var description : String { ""  }
    }

    @Test
    func representations() {
        let _:StaticString = #html()
        let _:StaticString = #html(encoding: .string)
        let _:String = #html()
        let _:String = #html(encoding: .string)
        let _:[UInt8] = #html(encoding: .utf8Bytes, p())
        let _:[UInt16] = #html(encoding: .utf16Bytes, p())
        let _:ContiguousArray<CChar> = #html(encoding: .utf8CString, p())
        #if canImport(Foundation)
        let _:Data = #html(encoding: .foundationData, p())
        #endif
        //let _:ByteBuffer = #html(encoding: .byteBuffer, "")
        let _:String = #html(encoding: .custom(#""$0""#), p(5))
    }
    @Test
    func representation1() -> StaticString {
        #html(p(123))
    }
    @Test
    func representation2() -> String {
        #html(p(123))
    }
    @Test
    func representation3() -> [UInt8] {
        #html(encoding: .utf8Bytes, p(123))
    }
    @Test
    func representation4() -> [UInt16] {
        #html(encoding: .utf16Bytes, p(123))
    }
    @Test
    func representation5() -> ContiguousArray<CChar> {
        #html(encoding: .utf8CString, p(123))
    }
    #if canImport(Foundation)
    @Test
    func representation6() -> Data {
        #html(encoding: .foundationData, p(123))
    }
    #endif
    /*
    func representation7() -> ByteBuffer {
        #htmlByteBuffer("")
    }*/
}

// MARK: StaticString Example
extension HTMLKitTests {
    @Test func example_1() {
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
                    ul(attributes: [.id("user-qualities")], String(describing: qualities))
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

        var html : String { #html(p(name, array_string)) }
    }
}

#endif