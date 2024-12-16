//
//  AttributeTests.swift
//
//
//  Created by Evan Anderson on 11/3/24.
//

#if compiler(>=6.0)

import Testing
import HTMLKit

struct AttributeTests {
    // MARK: ariarole
    @Test func ariarole() {
        //let array:String = HTMLElementType.allCases.map({ "case \"\($0)\": return \($0)(rawValue: rawValue)" }).joined(separator: "\n")
        //print(array)
        let string:StaticString = #html(div(attributes: [.role(.widget)]))
        #expect(string == "<div role=\"widget\"></div>")
    }

    // MARK: ariaattribute
    @Test func ariaattribute() {
        var string:StaticString = #html(div(attributes: [.ariaattribute(.atomic(true))]))
        #expect(string == "<div aria-atomic=\"true\"></div>")

        string = #html(div(attributes: [.ariaattribute(.activedescendant("mario-and-luigi"))]))
        #expect(string == "<div aria-activedescendant=\"mario-and-luigi\"></div>")

        string = #html(div(attributes: [.ariaattribute(.autocomplete(.list))]))
        #expect(string == "<div aria-autocomplete=\"list\"></div>")

        string = #html(div(attributes: [.ariaattribute(.controls(["testing", "123", "yup"]))]))
        #expect(string == "<div aria-controls=\"testing 123 yup\"></div>")
    }

    // MARK: attributionsrc
    @Test func attributionsrc() {
        var string:StaticString = #html(a(attributionsrc: []))
        #expect(string == "<a attributionsrc></a>")

        string = #html(a(attributionsrc: ["https://github.com/RandomHashTags", "https://litleagues.com"]))
        #expect(string == "<a attributionsrc=\"https://github.com/RandomHashTags https://litleagues.com\"></a>")
    }

    // MARK: class
    @Test func class_attribute() {
        let string:StaticString = #html(a(attributes: [.class(["womp", "donk", "g2-esports"])]))
        #expect(string == "<a class=\"womp donk g2-esports\"></a>")
    }

    // MARK: data
    @Test func data() {
        let string:StaticString = #html(div(attributes: [.data("id", "5")]))
        #expect(string == "<div data-id=\"5\"></div>")
    }

    // MARK: hidden
    @Test func hidden() {
        var string:StaticString = #html(div(attributes: [.hidden(.true)]))
        #expect(string == "<div hidden></div>")

        string = #html(div(attributes: [.hidden(.untilFound)]))
        #expect(string == "<div hidden=\"until-found\"></div>")
    }

    // MARK: custom
    @Test func custom_attribute() {
        var string:StaticString = #html(div(attributes: [.custom("potofgold", "north")]))
        #expect(string == "<div potofgold=\"north\"></div>")
        
        string = #html(div(attributes: [.custom("potofgold", "\(1)")]))
        #expect(string == "<div potofgold=\"1\"></div>")

        string = #html(div(attributes: [.custom("potofgold1", "\(1)"), .custom("potofgold2", "2")]))
        #expect(string == "<div potofgold1=\"1\" potofgold2=\"2\"></div>")
    }

    // MARK: trailingSlash
    @Test func trailingSlash() {
        var string:StaticString = #html(meta(attributes: [.trailingSlash]))
        #expect(string == "<meta />")

        string = #html(custom(tag: "slash", isVoid: true, attributes: [.trailingSlash]))
        #expect(string == "<slash />")

        string = #html(custom(tag: "slash", isVoid: false, attributes: [.trailingSlash]))
        #expect(string == "<slash></slash>")
    }
}

#endif