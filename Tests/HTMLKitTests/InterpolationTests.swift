
#if compiler(>=6.0)

import Testing
import HTMLKit

struct InterpolationTests {
    // MARK: default/static
    @Test func interpolation() {
        var test:String = "again"
        var result:String = #html(meta(content: test))
        var expected:String = "<meta content=\"\(test)\">"
        #expect(result == expected)

        expected = #html {
            meta(content: test)
        }
        #expect(result == expected)

        test = "test"
        expected = #html(a(href: "\(test)", "Test"))
        #expect(expected == "<a href=\"\(test)\">Test</a>")

        expected = #html(div(attributes: [.id("sheesh-dude")], "sheesh-dude"))
        test = "dude"
        result = #html(div(attributes: [.id("sheesh-\(test)")], "sheesh-\(test)"))
        #expect(result == expected)
    }

    // MARK: dynamic
    @Test func interpolationDynamic() {
        var expected:String = #html(
            ul(
                li(attributes: [.id("one")], "one"),
                li(attributes: [.id("two")], "two"),
                li(attributes: [.id("three")], "three"))
        )
        var interp:String = ""
        for i in ["one", "two", "three"] {
            interp += String(describing: li(attributes: [.id(i)], i))
        }
        var result:String = #html(ul(interp))
        #expect(result == expected)

        expected = #html(
            ul(
                li(attributes: [.id("0zero")], "0zero"),
                li(attributes: [.id("1one")], "1one"),
                li(attributes: [.id("2two")], "2two")
            )
        )
        interp = ""
        for (i, s) in ["zero", "one", "two"].enumerated() {
            interp += li(attributes: [.id("\(i)\(s)")], "\(i)\(s)").description
        }
        result = #html(ul(interp))
        #expect(result == expected)
    }

    // MARK: multi-line decl
    @Test func interpolationMultilineDecl() {
        let test:String = "prophecy"
        let string:String = #html(
            div(
                "dune ",
                test
            )
        )
        #expect(string == "<div>dune prophecy</div>")
    }

    // MARK: multi-line func
    @Test func interpolationMultilineFunc() {
        var expected:String = "<div>Bikini Bottom: Spongebob Squarepants, Patrick Star, Squidward Tentacles, Mr. Krabs, Sandy Cheeks, Pearl Krabs</div>"
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
        #expect(string == expected)
        
        expected = "<div>Don&#39t forget Gary!</div>"
        string = #html(
            div(
                "Don't forget ",
                InterpolationTests.BikiniBottom.gary(),
                "!"
            )
        )
        #expect(string == expected)

        expected = "<div>Spongeboob</div>"
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
        #expect(string == expected)
    }

    // MARK: multi-line closure
    @Test func interpolationMultilineClosure() {
        var expected:String = "<div>Mrs. Puff</div>"
        var string:String = #html(div(InterpolationTests.character2 {
            var bro = ""
            let yikes:Bool = true
            if yikes {
            } else if false {
                bro = "bruh"
            } else {
            }
            switch bro {
            case "um":
                break
            default:
                break
            }
            return false ? bro : "Mrs. Puff"
        } ))
        #expect(string == expected)
    }

    // MARK: multi-line member
    @Test func interpolationMultilineMember() {
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

    // MARK: closure
    @Test func interpolationClosure() {
        let expected:String = "<div>Mrs. Puff</div>"
        var string:String = #html(div(InterpolationTests.character1(body: { "Mrs. Puff" })))
        #expect(string == expected)

        string = #html(div(InterpolationTests.character2({ "Mrs. Puff" })))
        #expect(string == expected)

        string = #html(div(InterpolationTests.character2 { "Mrs. Puff" } ))
        #expect(string == expected)

        string = #html(div(InterpolationTests.character2 { let test:String = "Mrs. Puff"; return test } ))
        #expect(string == expected)

        string = #html(div(InterpolationTests.character3 { _ in let test:String = "Mrs. Puff"; return test } ))
        #expect(string == expected)

        string = #html(div(InterpolationTests.character3 { isTrue in let test:String = "Mrs. Puff"; return isTrue ? test : "" } ))
        #expect(string == expected)

        string = #html(div(InterpolationTests.character3 { (isTrue:Bool) in let test:String = "Mrs. Puff"; return isTrue ? test : "" } ))
        #expect(string == expected)

        string = #html(div(InterpolationTests.character4 { (string, integer, isTrue) in let test:String = "Mrs. Puff"; return (isTrue.first ?? false) ? test : "" } ))
        #expect(string == expected)
    }

    // MARK: inferred type
    @Test func interpolationInferredType() {
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

    // MARK: force unwrap
    @Test func interpolationForceUnwrap() {
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

    // MARK: promote
    @Test func interpolationPromotion() {
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
    
    // MARK: promote w/lookup files
    @Test func interpolationPromotionWithLookupFiles() {
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
    enum Shrek: String {
        case isLove, isLife
    }
    @Test func interpolationEnum() {
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
    static func character1(body: () -> String) -> String { body() }
    static func character2(_ body: () -> String) -> String { body() }
    static func character3(_ body: (Bool) -> String) -> String { body(true) }
    static func character4(_ body: (String, Int, Bool...) -> String) -> String { body("", 0, true) }
    static func sandyCheeks() -> String {
        return "Sandy Cheeks"
    }
    static func spongebob(isBoob: Bool, isSquare: Bool, middleName: String, lastName: String) -> String {
        return "Spongeboob"
    }
    
    @Test func interpolationLiteral() {
        var string:String = #html(div(attributes: [.title(InterpolationTests.spongebob)]))
        #expect(string == "<div title=\"Spongebob Squarepants\"></div>")

        string = #html(div(attributes: [.title(InterpolationTests.patrick)]))
        #expect(string == "<div title=\"Patrick Star\"></div>")

        var static_string:StaticString = #html(div(attributes: [.title("Mr. Krabs")]))
        #expect(static_string == "<div title=\"Mr. Krabs\"></div>")

        static_string = #html(div(attributes: [.title("Mr. Krabs")]))
        #expect(static_string == "<div title=\"Mr. Krabs\"></div>")
    }
    @Test func interpolationFunc() {
        let string:String = #html(div(attributes: [.title(InterpolationTests.spongebobCharacter("patrick"))]))
        #expect(string == "<div title=\"Patrick Star\"></div>")
    }

    @Test func uncheckedInterpolation() {
        let _:String = #uncheckedHTML(encoding: .string, div(InterpolationTests.patrick))
    }

    @Test func closureInterpolation() {
        let bro:String = "bro"
        let _:String = #html {
            div {
                p {
                    bro
                }
                p(bro)
                bro
            }
        }
    }
}

#endif