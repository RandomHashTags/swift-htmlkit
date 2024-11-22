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
        var string:String = #html(meta(content: test))
        #expect(string == "<meta content=\"\(test)\">")

        test = "test"
        string = #html(a(href: "\(test)", "Test"))
        #expect(string == "<a href=\"\(test)\">Test</a>")
    }

    @Test func flatten() {
        let title:String = "flattening"
        var string:String = #html(meta(content: "\("interpolation \(title)")", name: "description"))
        #expect(string == "<meta content=\"interpolation \(title)\" name=\"description\">")

        string = #html(meta(content: "interpolation \(title)", name: "description"))
        #expect(string == "<meta content=\"interpolation \(title)\" name=\"description\">")

        string = #html(meta(content: "interpolation\(title)", name: "description"))
        #expect(string == "<meta content=\"interpolation\(title)\" name=\"description\">")

        string = #html(meta(content: "\(title) interpolation", name: "description"))
        #expect(string == "<meta content=\"flattening interpolation\" name=\"description\">")

        string = #html(meta(content: "\(title)interpolation", name: "description"))
        #expect(string == "<meta content=\"flatteninginterpolation\" name=\"description\">")

        string = #html(meta(content: "\(title)\("interpolation")", name: "description"))
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
        var string:String = #html(a(attributes: [.title(Shrek.isLove.rawValue)]))
        #expect(string == "<a title=\"isLove\"></a>")

        string = #html(a(attributes: [.title("\(Shrek.isLife)")]))
        #expect(string == "<a title=\"isLife\"></a>")
    }
}

extension InterpolationTests {
    static let spongebob:String = "Spongebob Squarepants"
    static let patrick:String = "Patrick Star"
    static func spongebobCharacter(_ string: String) -> String {
        switch string {
        case "spongebob": return "Spongebob Squarepants"
        case "patrick":   return "Patrick Star"
        default:          return "Plankton"
        }
    }
    
    @Test func third_party_literal() {
        var string:String = #html(div(attributes: [.title(InterpolationTests.spongebob)]))
        #expect(string == "<div title=\"Spongebob Squarepants\"></div>")

        string = #html(div(attributes: [.title(InterpolationTests.patrick)]))
        #expect(string == "<div title=\"Patrick Star\"></div>")

        var static_string:StaticString = #html(div(attributes: [.title("Mr. Crabs")]))
        #expect(static_string == "<div title=\"Mr. Crabs\"></div>")

        static_string = #html(div(attributes: [.title("Mr. Crabs")]))
        #expect(static_string == "<div title=\"Mr. Crabs\"></div>")
    }
    @Test func third_party_func() {
        let string:String = #html(div(attributes: [.title(InterpolationTests.spongebobCharacter("patrick"))]))
        #expect(string == "<div title=\"Patrick Star\"></div>")
    }
}