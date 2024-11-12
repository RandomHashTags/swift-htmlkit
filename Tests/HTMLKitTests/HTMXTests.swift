//
//  HTMXTests.swift
//
//
//  Created by Evan Anderson on 11/12/24.
//

import Testing
import HTMLKit

struct HTMXTests {
    @Test func get() {
        let string:StaticString = #div(attributes: [.htmx(.get("/test"))])
        #expect(string == "<div hx-get=\"/test\"></div>")
    }

    @Test func post() {
        let string:StaticString = #div(attributes: [.htmx(.post("https://github.com/RandomHashTags"))])
        #expect(string == "<div hx-post=\"https://github.com/RandomHashTags\"></div>")
    }
}