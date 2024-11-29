//
//  EncodingTests.swift
//
//
//  Created by Evan Anderson on 11/27/24.
//

#if canImport(Foundation)
import Foundation
#endif

import HTMLKit
import Testing

struct EncodingTests {
    let backslash:UInt8 = 92

    #if canImport(Foundation)

        // MARK: utf8Array
        @Test func encoding_utf8Array() {
            var expected_result:String = #html(option(attributes: [.class(["row"])], value: "wh'at?"))
            var uint8Array:[UInt8] = #html(encoding: .utf8Bytes,
                option(attributes: [.class(["row"])], value: "wh'at?")
            )
            #expect(String(data: Data(uint8Array), encoding: .utf8) == expected_result)
            #expect(uint8Array.firstIndex(of: backslash) == nil)

            expected_result = #html(div(attributes: [.htmx(.request(js: false, timeout: nil, credentials: "true", noHeaders: nil))]))
            uint8Array = #html(encoding: .utf8Bytes,
                div(attributes: [.htmx(.request(js: false, timeout: nil, credentials: "true", noHeaders: nil))])
            )
            #expect(String(data: Data(uint8Array), encoding: .utf8) == expected_result)
            #expect(uint8Array.firstIndex(of: backslash) == nil)

            let set:Set<Data?> = Set(HTMXTests.dictionary_json_results(tag: "div", closingTag: true, attribute: "hx-headers", delimiter: "'", ["womp":"womp", "ding dong":"d1tched", "EASY":"C,L.a;P!"]).map({
                $0.data(using: .utf8)
            }))
            uint8Array = #html(encoding: .utf8Bytes,
                div(attributes: [.htmx(.headers(js: false, ["womp":"womp", "ding dong":"d1tched", "EASY":"C,L.a;P!"]))])
            )
            #expect(set.contains(Data(uint8Array)))
            #expect(uint8Array.firstIndex(of: backslash) == nil)
        }

        // MARK: foundationData
        @Test func encoding_foundationData() {
            let expected_result:String = #html(option(attributes: [.class(["row"])], value: "what?"))

            let foundationData:Data = #html(encoding: .foundationData,
                option(attributes: [.class(["row"])], value: "what?")
            )
            #expect(foundationData == expected_result.data(using: .utf8))
            #expect(foundationData.firstIndex(of: backslash) == nil)
        }

    #endif

    // MARK: custom
    @Test func encoding_custom() {
        let expected_result:String = "<option class=!row! value=!bro!></option>"
        let result:String = #html(encoding: .custom(#""$0""#, stringDelimiter: "!"),
            option(attributes: [.class(["row"])], value: "bro")
        )
        #expect(result == expected_result)
    }
}