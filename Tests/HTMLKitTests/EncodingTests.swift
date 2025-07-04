
#if compiler(>=6.0)

#if canImport(FoundationEssentials)
import FoundationEssentials
#elseif canImport(Foundation)
import Foundation
#endif

import HTMLKit
import Testing

extension Collection where Element == UInt8 {
    static func == (left: Self, right: String) -> Bool {
        return String(decoding: left, as: UTF8.self) == right
    }
}
extension Collection where Element == UInt16 {
    static func == (left: Self, right: String) -> Bool {
        return String(decoding: left, as: UTF16.self) == right
    }
}

struct EncodingTests {
    let backslash:UInt8 = 92

    // MARK: utf8Array
    @Test func encodingUTF8Array() {
        var expected:String = #html(option(attributes: [.class(["row"])], value: "wh'at?"))
        var uint8Array:[UInt8] = #html(encoding: .utf8Bytes,
            option(attributes: [.class(["row"])], value: "wh'at?")
        )
        #expect(uint8Array == expected)
        #expect(uint8Array.firstIndex(of: backslash) == nil)

        expected = #html(div(attributes: [.htmx(.request(js: false, timeout: nil, credentials: "true", noHeaders: nil))]))
        uint8Array = #html(encoding: .utf8Bytes,
            div(attributes: [.htmx(.request(js: false, timeout: nil, credentials: "true", noHeaders: nil))])
        )
        #expect(uint8Array == expected)
        #expect(uint8Array.firstIndex(of: backslash) == nil)

        uint8Array = #html(encoding: .utf8Bytes,
            div(attributes: [.htmx(.headers(js: false, ["womp":"womp", "ding dong":"d1tched", "EASY":"C,L.a;P!"]))])
        )
        #if canImport(FoundationEssentials) || canImport(Foundation)
        let set:Set<Data?> = Set(HTMXTests.dictionary_json_results(tag: "div", closingTag: true, attribute: "hx-headers", delimiter: "'", ["womp":"womp", "ding dong":"d1tched", "EASY":"C,L.a;P!"]).map({
            $0.data(using: .utf8)
        }))
        #expect(set.contains(Data(uint8Array)))
        #endif
        #expect(uint8Array.firstIndex(of: backslash) == nil)
    }

    #if canImport(FoundationEssentials) || canImport(Foundation)

        // MARK: foundationData
        @Test func encodingFoundationData() {
            let expected:String = #html(option(attributes: [.class(["row"])], value: "what?"))

            let foundationData:Data = #html(encoding: .foundationData,
                option(attributes: [.class(["row"])], value: "what?")
            )
            #expect(foundationData == expected.data(using: .utf8))
            #expect(foundationData.firstIndex(of: backslash) == nil)
        }

    #endif

    // MARK: custom
    @Test func encodingCustom() {
        let expected:String = "<option class=!row! value=!bro!></option>"
        let result:String = #html(encoding: .custom(#""$0""#, stringDelimiter: "!"),
            option(attributes: [.class(["row"])], value: "bro")
        )
        #expect(result == expected)
    }
}

#endif