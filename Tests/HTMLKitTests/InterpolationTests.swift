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

    @Test func multiline_decl_interpolation() {
        let test:String = "prophecy"
        let string:String = #html(
            div(
                "dune ",
                test
            )
        )
        #expect(string == "<div>dune prophecy</div>")
    }

    @Test func multiline_func_interpolation() {
        var string:String = #html(
            div(
                "Bikini Bottom: ",
                InterpolationTests.spongebobCharacter(
                    "spongebob"
                ),
                ", ",
                InterpolationTests.spongebobCharacter("patrick"
                ),
                ", ",
                InterpolationTests.spongebobCharacter(
                    "squidward"),
                ", ",
                InterpolationTests
                .spongebobCharacter(
                    "krabs"
                ),
                ", ",
                InterpolationTests.sandyCheeks (),
                ", ",
                InterpolationTests
                .spongebobCharacter(
                    "pearl krabs"
                )
            )
        )
        #expect(string == "<div>Bikini Bottom: Spongebob Squarepants, Patrick Star, Squidward Tentacles, Mr. Krabs, Sandy Cheeks, Pearl Krabs</div>")

        string = #html(
            div(
                "Don't forget ",
                InterpolationTests.BikiniBottom.gary(),
                "!"
            )
        )
        #expect(string == "<div>Don&#39t forget Gary!</div>")

        string = #html(
            div(
                InterpolationTests
                .spongebob(
                    isBoob:false,
                    isSquare:
                    true,
                    middleName: Shrek
                        .isLife
                        .rawValue,
                    lastName: InterpolationTests
                        .sandyCheeks()
                )
            )
        )
        #expect(string == "<div>Spongeboob</div>")
    }

    @Test func multiline_member_interpolation() {
        var string:String = #html(
            div(
                "Shrek ",
                Shrek.isLove.rawValue,
                ", Shrek ",
                Shrek
                .isLife.rawValue
            )
        )
        #expect(string == "<div>Shrek isLove, Shrek isLife</div>")

        string = #html(
            div(
                "Shrek ",
                InterpolationTests.Shrek.isLove.rawValue,
                ", Shrek ",
                InterpolationTests.Shrek.isLife.rawValue
            )
        )
        #expect(string == "<div>Shrek isLove, Shrek isLife</div>")
    }

    @Test func inferred_type_interpolation() {
        var array:[String] = ["toothless", "hiccup"]
        var string:String = array.map({
            #html(option(value: $0))
        }).joined()
        #expect(string == "<option value=\"toothless\"></option><option value=\"hiccup\"></option>")

        array = ["cloudjumper", "light fury"]
        string = array.map({ dragon in
            #html(option(value: dragon))
        }).joined()
        #expect(string == "<option value=\"cloudjumper\"></option><option value=\"light fury\"></option>")
    }

    @Test func force_unwrap_interpolation() {
        let optionals:[String?] = ["stormfly", "sneaky"]
        var string:String = optionals.map({
            #html(option(value: $0!))
        }).joined()
        #expect(string == "<option value=\"stormfly\"></option><option value=\"sneaky\"></option>")

        let array:[String] = ["sharpshot", "thornshade"]
        string = #html(option(value: array.get(0)!))
        #expect(string == "<option value=\"sharpshot\"></option>")

        string = #html(option(value: array
        .get(
            1
        )!))
        #expect(string == "<option value=\"thornshade\"></option>")
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

fileprivate extension Array {
    func get(_ index: Index) -> Element? {
        return index < endIndex ? self[index] : nil
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
    enum BikiniBottom {
        static func gary() -> String { "Gary" }
    }
    static let spongebob:String = "Spongebob Squarepants"
    static let patrick:String = "Patrick Star"
    static func spongebobCharacter(_ string: String) -> String {
        switch string {
        case "spongebob": return "Spongebob Squarepants"
        case "patrick":   return "Patrick Star"
        case "squidward": return "Squidward Tentacles"
        case "krabs":     return "Mr. Krabs"
        case "pearl krabs": return "Pearl Krabs"
        case "karen":     return "Karen"
        default:          return "Plankton"
        }
    }
    static func sandyCheeks() -> String {
        return "Sandy Cheeks"
    }
    static func spongebob(isBoob: Bool, isSquare: Bool, middleName: String, lastName: String) -> String {
        return "Spongeboob"
    }
    
    @Test func third_party_literal() {
        var string:String = #html(div(attributes: [.title(InterpolationTests.spongebob)]))
        #expect(string == "<div title=\"Spongebob Squarepants\"></div>")

        string = #html(div(attributes: [.title(InterpolationTests.patrick)]))
        #expect(string == "<div title=\"Patrick Star\"></div>")

        var static_string:StaticString = #html(div(attributes: [.title("Mr. Krabs")]))
        #expect(static_string == "<div title=\"Mr. Krabs\"></div>")

        static_string = #html(div(attributes: [.title("Mr. Krabs")]))
        #expect(static_string == "<div title=\"Mr. Krabs\"></div>")
    }
    @Test func third_party_func() {
        let string:String = #html(div(attributes: [.title(InterpolationTests.spongebobCharacter("patrick"))]))
        #expect(string == "<div title=\"Patrick Star\"></div>")
    }
}