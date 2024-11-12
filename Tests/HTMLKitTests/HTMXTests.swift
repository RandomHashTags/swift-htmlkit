//
//  HTMXTests.swift
//
//
//  Created by Evan Anderson on 11/12/24.
//

import Testing
import HTMLKit

struct HTMXTests {
    // MARK: get
    @Test func get() {
        let string:StaticString = #div(attributes: [.htmx(.get("/test"))])
        #expect(string == "<div hx-get=\"/test\"></div>")
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

    // MARK: replaceURL
    @Test func replaceURL() {
        var string:StaticString = #div(attributes: [.htmx(.replaceURL(.true))])
        #expect(string == "<div hx-replace-url=\"true\"></div>")

        string = #div(attributes: [.htmx(.replaceURL(.url("https://litleagues.com")))])
        #expect(string == "<div hx-replace-url=\"https://litleagues.com\"></div>")
    }

    // MARK: ws
    @Test func ws() {
        var string:StaticString = #div(attributes: [.htmx(.ws(.connect("https://paradigm-app.com")))])
        #expect(string == "<div ws-connect=\"https://paradigm-app.com\"></div>")

        string = #div(attributes: [.htmx(.ext("ws")), .htmx(.ws(.send("https://linktr.ee/anderson_evan")))])
        #expect(string == "<div hx-ext=\"ws\" ws-send=\"https://linktr.ee/anderson_evan\"></div>")
    }
}