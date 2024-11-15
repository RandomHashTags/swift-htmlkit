//
//  HTMXTests.swift
//
//
//  Created by Evan Anderson on 11/12/24.
//

import Testing
import HTMLKit

struct HTMXTests {
    // MARK: boost
    @Test func boost() {
        var string:StaticString = #div(attributes: [.htmx(.boost(.true))])
        #expect(string == "<div hx-boost=\"true\"></div>")

        string = #div(attributes: [.htmx(.boost(.false))])
        #expect(string == "<div hx-boost=\"false\"></div>")
    }

    // MARK: disable
    @Test func disable() {
        var string:StaticString = #div(attributes: [.htmx(.disable(true))])
        #expect(string == "<div hx-disable></div>")

        string = #div(attributes: [.htmx(.disable(false))])
        #expect(string == "<div></div>")
    }

    // MARK: get
    @Test func get() {
        var string:StaticString = #div(attributes: [.htmx(.get("/test"))])
        #expect(string == "<div hx-get=\"/test\"></div>")

        string = #div(attributes: [.htmx(.get(""))])
        #expect(string == "<div hx-get=\"\"></div>")
    }

    // MARK: headers
    @Test func headers() {
        let set:Set<String> = dictionary_json_results(tag: "div", closingTag: true, attribute: "hx-headers", delimiter: "'", ["womp":"womp", "ding dong":"d1tched", "EASY":"C,L.a;P!"])
        let string:StaticString = #div(attributes: [.htmx(.headers(js: false, ["womp":"womp", "ding dong":"d1tched", "EASY":"C,L.a;P!"]))])
        #expect(set.contains(string.description), Comment(rawValue: "string=\(string)\nset=\(set)"))
    }
    func dictionary_json_results(
        tag: String,
        closingTag: Bool,
        attribute: String,
        delimiter: String,
        _ dictionary: [String:String]
    ) -> Set<String> { // TODO: fix (doesn't check all available values)
        var set:Set<String> = []
        let prefix:String = "<" + tag + " " + attribute + "=" + delimiter
        let suffix:String = delimiter + ">" + (closingTag ? "</" + tag + ">" : "")
        set.reserveCapacity(dictionary.count*dictionary.count)
        for (key1, value1) in dictionary {
            let string:String = prefix + "{\"" + key1 + "\":\"" + value1 + "\","

            var string1:String = string
            for (key2, value2) in dictionary {
                if key1 != key2 {
                    string1 += "\"" + key2 + "\":\"" + value2 + "\","
                }
            }
            string1.removeLast()
            string1 += "}" + suffix
            set.insert(string1)

            var string2:String = string
            for (key2, value2) in dictionary.reversed() {
                if key1 != key2 {
                    string2 += "\"" + key2 + "\":\"" + value2 + "\","
                }
            }
            string2.removeLast()
            string2 += "}" + suffix
            set.insert(string2)
        }
        return set
    }

    // MARK: history-elt
    @Test func historyElt() {
        var string:StaticString = #div(attributes: [.htmx(.historyElt(true))])
        #expect(string == "<div hx-history-elt></div>")

        string = #div(attributes: [.htmx(.historyElt(false))])
        #expect(string == "<div></div>")
    }

    // MARK: on
    @Test func on() {
        var string:StaticString = #div(attributes: [.htmx(.on(.abort, "bruh"))])
        #expect(string == "<div hx-on::abort=\"bruh\"></div>")

        string = #div(attributes: [.htmx(.on(.afterOnLoad, "test()"))])
        #expect(string == "<div hx-on::after-on-load=\"test()\"></div>")
    }

    // MARK: onevent
    @Test func onevent() {
        var string:StaticString = #div(attributes: [.htmx(.onevent(.click, "thing()"))])
        #expect(string == "<div hx-on:click=\"thing()\"></div>")

        string = #div(attributes: [.htmx(.onevent(.durationchange, "durationChanged()"))])
        #expect(string == "<div hx-on:durationchange=\"durationChanged()\"></div>")
    }

    // MARK: post
    @Test func post() {
        let string:StaticString = #div(attributes: [.htmx(.post("https://github.com/RandomHashTags"))])
        #expect(string == "<div hx-post=\"https://github.com/RandomHashTags\"></div>")
    }

    // MARK: preserve
    @Test func preserve() {
        var string:StaticString = #div(attributes: [.htmx(.preserve(true))])
        #expect(string == "<div hx-preserve></div>")

        string = #div(attributes: [.htmx(.preserve(false))])
        #expect(string == "<div></div>")
    }

    // MARK: replaceURL
    @Test func replaceURL() {
        var string:StaticString = #div(attributes: [.htmx(.replaceURL(.true))])
        #expect(string == "<div hx-replace-url=\"true\"></div>")

        string = #div(attributes: [.htmx(.replaceURL(.url("https://litleagues.com")))])
        #expect(string == "<div hx-replace-url=\"https://litleagues.com\"></div>")
    }

    // MARK: request
    @Test func request() {
        var string:StaticString = #div(attributes: [.htmx(.request(js: false, timeout: "5", credentials: nil, noHeaders: nil))])
        #expect(string == "<div hx-request='{\"timeout\":5}'></div>")

        string = #div(attributes: [.htmx(.request(js: true, timeout: "getTimeout()", credentials: nil, noHeaders: nil))])
        #expect(string == "<div hx-request='js: timeout:getTimeout()'></div>")

        string = #div(attributes: [.htmx(.request(js: false, timeout: nil, credentials: "true", noHeaders: nil))])
        #expect(string == "<div hx-request='{\"credentials\":true}'></div>")

        string = #div(attributes: [.htmx(.request(js: false, timeout: nil, credentials: nil, noHeaders: "true"))])
        #expect(string == "<div hx-request='{\"noHeaders\":true}'></div>")
    }

    // MARK: sync
    @Test func sync() {
        var string:StaticString = #div(attributes: [.htmx(.sync("closest form", strategy: .abort))])
        #expect(string == "<div hx-sync=\"closest form:abort\"></div>")

        string = #div(attributes: [.htmx(.sync("#submit-button", strategy: .queue(.first)))])
        #expect(string == "<div hx-sync=\"#submit-button:queue first\"></div>")
    }

    // MARK: sse
    @Test func sse() {
        var string:StaticString = #div(attributes: [.htmx(.sse(.connect("/connect")))])
        #expect(string == "<div sse-connect=\"/connect\"></div>")

        string = #div(attributes: [.htmx(.sse(.swap("message")))])
        #expect(string == "<div sse-swap=\"message\"></div>")

        string = #div(attributes: [.htmx(.sse(.close("message")))])
        #expect(string == "<div sse-close=\"message\"></div>")
    }

    // MARK: trigger
    @Test func trigger() {
        let string:StaticString = #div(attributes: [.htmx(.trigger("sse:chatter"))])
        #expect(string == "<div hx-trigger=\"sse:chatter\"></div>")
    }

    // MARK: ws
    @Test func ws() {
        var string:StaticString = #div(attributes: [.htmx(.ws(.connect("/chatroom")))])
        #expect(string == "<div ws-connect=\"/chatroom\"></div>")

        string = #div(attributes: [.htmx(.ext("ws")), .htmx(.ws(.send(true)))])
        #expect(string == "<div hx-ext=\"ws\" ws-send></div>")

        string = #div(attributes: [.htmx(.ext("ws")), .htmx(.ws(.send(false)))])
        #expect(string == "<div hx-ext=\"ws\"></div>")
    }
}