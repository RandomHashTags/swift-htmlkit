//
//  AttributeTests.swift
//
//
//  Created by Evan Anderson on 11/3/24.
//

import Testing
import HTMLKit

struct AttributeTests {
    @Test func data() {
        let string:StaticString = #div(attributes: [.data("id", "5")])
        #expect(string == "<div data-id=\"5\"></div>")
    }
    @Test func hidden() {
        var string:StaticString = #div(attributes: [.hidden(.true)])
        #expect(string == "<div hidden></div>")

        string = #div(attributes: [.hidden(.untilFound)])
        #expect(string == "<div hidden=\"until-found\"></div>")
    }

    @Test func custom() {
        var string:StaticString = #div(attributes: [.custom("potofgold", "north")])
        #expect(string == "<div potofgold=\"north\"></div>")
        
        string = #div(attributes: [.custom("potofgold", "\(1)")])
        #expect(string == "<div potofgold=\"1\"></div>")

        string = #div(attributes: [.custom("potofgold1", "\(1)"), .custom("potofgold2", "2")])
        #expect(string == "<div potofgold1=\"1\" potofgold2=\"2\"></div>")
    }

    @Test func trailingSlash() {
        var string:StaticString = #meta(attributes: [.trailingSlash])
        #expect(string == "<meta />")

        string = #custom(tag: "slash", isVoid: true, attributes: [.trailingSlash])
        #expect(string == "<slash />")
    }
}