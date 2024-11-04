//
//  InterpolationTests.swift
//
//
//  Created by Evan Anderson on 11/3/24.
//

import Testing
import HTMLKit

struct InterpolationTests {
    @Test func interpolation() {
        var test:String = "again"
        var string:String = #meta(content: test)
        #expect(string == "<meta content=\"\(test)\">")

        test = "test"
        string = #a(href: "\(test)", "Test")
        #expect(string == "<a href=\"\(test)\">Test</a>")
    }

    @Test func flatten() {
        let title:String = "flattening"
        var string:String = #meta(content: "\("interpolation \(title)")", name: "description")
        #expect(string == "<meta content=\"interpolation \(title)\" name=\"description\">")

        string = #meta(content: "interpolation \(title)", name: "description")
        #expect(string == "<meta content=\"interpolation \(title)\" name=\"description\">")

        string = #meta(content: "interpolation\(title)", name: "description")
        #expect(string == "<meta content=\"interpolation\(title)\" name=\"description\">")

        string = #meta(content: "\(title) interpolation", name: "description")
        #expect(string == "<meta content=\"flattening interpolation\" name=\"description\">")

        string = #meta(content: "\(title)interpolation", name: "description")
        #expect(string == "<meta content=\"flatteninginterpolation\" name=\"description\">")

        string = #meta(content: "\(title)\("interpolation")", name: "description")
        #expect(string == "<meta content=\"flatteninginterpolation\" name=\"description\">")
    }
    
    @Test func flatten_with_lookup_files() {
        //var string:StaticString = #html(lookupFiles: ["/home/paradigm/Desktop/GitProjects/swift-htmlkit/Tests/HTMLKitTests/InterpolationTests.swift"], attributes: [.title(InterpolationTests.spongebob)])
        //var string:String = #html(lookupFiles: ["/Users/randomhashtags/GitProjects/swift-htmlkit/Tests/HTMLKitTests/InterpolationTests.swift"], attributes: [.title(InterpolationTests.spongebob)])
    }
}

// MARK: 3rd party tests
extension InterpolationTests {
    enum Shrek : String {
        case isLove, isLife
    }
    @Test func third_party_enum() {
        var string:String = #a(attributes: [.title(Shrek.isLove.rawValue)])
        #expect(string == "<a title=\"isLove\"></a>")

        string = #a(attributes: [.title("\(Shrek.isLife)")])
        #expect(string == "<a title=\"isLife\"></a>")
    }
}

extension InterpolationTests {
    static let spongebob:String = "Spongebob Squarepants"
    static let patrick:StaticString = "Patrick Star"
    static func spongebobCharacter(_ string: String) -> StaticString {
        switch string {
        case "spongebob": return "Spongebob Squarepants"
        case "patrick":   return "Patrick Star"
        default:          return "Plankton"
        }
    }
    
    @Test func third_party_literal() {
        var string:String = #div(attributes: [.title(InterpolationTests.spongebob)])
        #expect(string == "<div title=\"Spongebob Squarepants\"></div>")

        string = #div(attributes: [.title(InterpolationTests.patrick)])
        #expect(string == "<div title=\"Patrick Star\"></div>")

        var static_string:StaticString = #div(attributes: [.title(StaticString("Mr. Crabs"))])
        #expect(static_string == "<div title=\"Mr. Crabs\"></div>")

        static_string = #div(attributes: [.title("Mr. Crabs")])
        #expect(static_string == "<div title=\"Mr. Crabs\"></div>")
    }
    @Test func third_party_func() {
        let string:String = #div(attributes: [.title(InterpolationTests.spongebobCharacter("patrick"))])
        #expect(string == "<div title=\"Patrick Star\"></div>")
    }
}