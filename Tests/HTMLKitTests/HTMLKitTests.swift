//
//  HTMLKitTests.swift
//
//
//  Created by Evan Anderson on 9/16/24.
//

import Testing
import HTMLKit

#if canImport(Foundation)
import struct Foundation.Data
#endif

#if canImport(NIOCore)
import struct NIOCore.ByteBuffer
#endif

// MARK: Escaping HTML
struct HTMLKitTests {
    @Test func escape_html() {
        let unescaped:String = "<!DOCTYPE html><html>Test</html>"
        let escaped:String = "&lt;!DOCTYPE html&gt;&lt;html&gt;Test&lt;/html&gt;"
        var expected_result:String = "<p>\(escaped)</p>"

        var string:String = #p("<!DOCTYPE html><html>Test</html>")
        #expect(string == expected_result)

        string = #escapeHTML("<!DOCTYPE html><html>Test</html>")
        #expect(string == escaped)

        string = #p(#escapeHTML(#html("Test")))
        #expect(string == expected_result)

        string = #p("\(unescaped.escapingHTML(escapeAttributes: false))")
        #expect(string == expected_result)

        expected_result = "<div title=\"&lt;p&gt;\">&lt;p&gt;&lt;/p&gt;</div>"
        string = #div(attributes: [.title(StaticString("<p>"))], StaticString("<p></p>")).description
        #expect(string == expected_result)

        string = #div(attributes: [.title("<p>")], StaticString("<p></p>")).description
        #expect(string == expected_result)

        string = #div(attributes: [.title("<p>")], "<p></p>")
        #expect(string == expected_result)
    }
}

// MARK: Representations
extension HTMLKitTests {
    func representations() {
        let _:StaticString = #html()
        let _:String = #html()
        let _:[UInt8] = #htmlUTF8Bytes("")
        let _:[UInt16] = #htmlUTF16Bytes("")
        let _:ContiguousArray<CChar> = #htmlUTF8CString("")
        #if canImport(Foundation)
        let _:Data = #htmlData("")
        #endif
        #if canImport(NIOCore)
        let _:ByteBuffer = #htmlByteBuffer("")
        #endif

        //let bro:String = ""
        //let _:[UInt8] = #htmlUTF8Bytes("\(bro)")
    }
    func representation1() -> StaticString {
        #html()
    }
    func representation2() -> String {
        #html()
    }
    func representation3() -> [UInt8] {
        #htmlUTF8Bytes("")
    }
    func representation4() -> [UInt16] {
        #htmlUTF16Bytes("")
    }
    func representation5() -> ContiguousArray<CChar> {
        #htmlUTF8CString("")
    }
    #if canImport(Foundation)
    func representation5() -> Data {
        #htmlData("")
    }
    #endif
    #if canImport(NIOCore)
    func representation6() -> ByteBuffer {
        #htmlByteBuffer("")
    }
    #endif
}

// MARK: Element tests
extension HTMLKitTests {
    @Test func element_html() {
        var string:StaticString = #html()
        #expect(string == "<!DOCTYPE html><html></html>")

        string = #html(xmlns: "test")
        #expect(string == "<!DOCTYPE html><html xmlns=\"test\"></html>")
    }
    @Test func element_area() {
        var string:StaticString = #area(coords: [1, 2, 3])
        #expect(string == "<area coords=\"1,2,3\">")

        string = #area(coords: [])
        #expect(string == "<area>")
    }
    @Test func element_audio() {
        let string:StaticString = #audio(controlslist: .nodownload)
        #expect(string == "<audio controlslist=\"nodownload\"></audio>")
    }
    @Test func element_button() {
        var string:StaticString = #button(type: .submit)
        #expect(string == "<button type=\"submit\"></button>")

        string = #button(formenctype: .applicationXWWWFormURLEncoded, formmethod: .get, formtarget: ._blank, popovertargetaction: .hide)
        #expect(string == "<button formenctype=\"application/x-www-form-urlencoded\" formmethod=\"get\" formtarget=\"_blank\" popovertargetaction=\"hide\"></button>")

        string = #button(formenctype: .multipartFormData, formmethod: .post, popovertargetaction: .show)
        #expect(string == "<button formenctype=\"multipart/form-data\" formmethod=\"post\" popovertargetaction=\"show\"></button>")

        string = #button(formenctype: .textPlain, formmethod: .get, type: .reset)
        #expect(string == "<button formenctype=\"text/plain\" formmethod=\"get\" type=\"reset\"></button>")
    }
    @Test func element_canvas() {
        let string:StaticString = #canvas(height: .percent(4), width: .em(2.69))
        #expect(string == "<canvas height=\"4%\" width=\"2.69em\"></canvas>")
    }
    @Test func element_form() {
        let string:StaticString = #form(acceptCharset: ["utf-8"], autocomplete: .on)
        #expect(string == "<form accept-charset=\"utf-8\" autocomplete=\"on\"></form>")
    }
    @Test func element_iframe() {
        let string:StaticString = #iframe(sandbox: [.allowDownloads, .allowForms])
        #expect(string == "<iframe sandbox=\"allow-downloads allow-forms\"></iframe>")
    }
    @Test func element_input() {
        var string:StaticString = #input(autocomplete: ["email", "password"], type: .text)
        #expect(string == "<input autocomplete=\"email password\" type=\"text\">")

        string = #input(type: .password)
        #expect(string == "<input type=\"password\">")

        string = #input(type: .datetimeLocal)
        #expect(string == "<input type=\"datetime-local\">")
    }
    @Test func element_img() {
        let string:StaticString = #img(sizes: ["(max-height: 500px) 1000px", "(min-height: 25rem)"], srcset: ["https://paradigm-app.com", "https://litleagues.com"])
        #expect(string == "<img sizes=\"(max-height: 500px) 1000px,(min-height: 25rem)\" srcset=\"https://paradigm-app.com,https://litleagues.com\">")
    }
    @Test func element_link() {
        let string:StaticString = #link(as: .document, imagesizes: ["lmno", "p"])
        #expect(string == "<link as=\"document\" imagesizes=\"lmno,p\">")
    }
    @Test func element_ol() {
        var string:StaticString = #ol()
        #expect(string == "<ol></ol>")

        string = #ol(type: .a)
        #expect(string == "<ol type=\"a\"></ol>")

        string = #ol(type: .A)
        #expect(string == "<ol type=\"A\"></ol>")

        string = #ol(type: .i)
        #expect(string == "<ol type=\"i\"></ol>")

        string = #ol(type: .I)
        #expect(string == "<ol type=\"I\"></ol>")

        string = #ol(type: .one)
        #expect(string == "<ol type=\"1\"></ol>")
    }
    @Test func element_script() {
        var string:StaticString = #script()
        #expect(string == "<script></script>")

        string = #script(type: .importmap)
        #expect(string == "<script type=\"importmap\"></script>")

        string = #script(type: .module)
        #expect(string == "<script type=\"module\"></script>")

        string = #script(type: .speculationrules)
        #expect(string == "<script type=\"speculationrules\"></script>")
    }
    @Test func element_style() {
        let string:StaticString = #style(blocking: .render)
        #expect(string == "<style blocking=\"render\"></style>")
    }
    @Test func element_template() {
        let string:StaticString = #template(shadowrootclonable: .false, shadowrootdelegatesfocus: false, shadowrootmode: .closed, shadowrootserializable: true)
        #expect(string == "<template shadowrootclonable=\"false\" shadowrootmode=\"closed\" shadowrootserializable></template>")
    }
    @Test func element_textarea() {
        let string:StaticString = #textarea(autocomplete: ["email", "password"], dirname: .ltr, rows: 5, wrap: .soft)
        #expect(string == "<textarea autocomplete=\"email password\" dirname=\"ltr\" rows=\"5\" wrap=\"soft\"></textarea>")
    }
    @Test func element_th() {
        let string:StaticString = #th(rowspan: 2, scope: .colgroup)
        #expect(string == "<th rowspan=\"2\" scope=\"colgroup\"></th>")
    }
    @Test func element_track() {
        let string:StaticString = #track(default: true, kind: .captions, label: "tesT")
        #expect(string == "<track default kind=\"captions\" label=\"tesT\">")
    }
    @Test func element_video() {
        var string:StaticString = #video(controlslist: [.nodownload, .nofullscreen, .noremoteplayback])
        #expect(string == "<video controlslist=\"nodownload nofullscreen noremoteplayback\"></video>")

        string = #video(crossorigin: .anonymous)
        #expect(string == "<video crossorigin=\"anonymous\"></video>")

        string = #video(crossorigin: .useCredentials)
        #expect(string == "<video crossorigin=\"use-credentials\"></video>")

        string = #video(preload: .metadata)
        #expect(string == "<video preload=\"metadata\"></video>")
    }

    @Test func element_custom() {
        var bro:StaticString = #custom(tag: "bro", isVoid: false)
        #expect(bro == "<bro></bro>")

        bro = #custom(tag: "bro", isVoid: true)
        #expect(bro == "<bro>")
    }

    @Test func element_events() {
        let third_thing:StaticString = "doAThirdThing()"
        let string:String = #div(attributes: [.event(.click, "doThing()"), .event(.change, "doAnotherThing()"), .event(.focus, "\(third_thing)")])
        #expect(string == "<div onclick=\"doThing()\" onchange=\"doAnotherThing()\" onfocus=\"doAThirdThing()\"></div>")
    }

    @Test func elements_void() {
        let string:StaticString = #area(#base(), #br(), #col(), #embed(), #hr(), #img(), #input(), #link(), #meta(), #source(), #track(), #wbr())
        #expect(string == "<area><base><br><col><embed><hr><img><input><link><meta><source><track><wbr>")
    }
}

// MARK: Misc element tests
extension HTMLKitTests {
    @Test func recursive_elements() {
        let string:StaticString = #div(
            #div(),
            #div(#div(), #div(), #div()),
            #div()
        )
        #expect(string == "<div><div></div><div><div></div><div></div><div></div></div><div></div></div>")
    }

    @Test func no_value_type() {
        let expected_string:String = "<!DOCTYPE html><html><body><h1>HTMLKitTests</h1></body></html>"
        let test1 = #html(#body(#h1("HTMLKitTests")))
        #expect(type(of: test1) == String.self)
        #expect(test1 == expected_string)
        let test2 = #html(#body(#h1(StaticString("HTMLKitTests"))))
        #expect(type(of: test2) == StaticString.self)
        #expect(test2 == expected_string)
    }

    /*@Test func nil_values() {
        #expect(#a("yippie", (true ? nil : "yiyo")) == "<a>yippie</a>") // improper
        #expect(#a("yippie", (false ? nil : "yiyo")) == "<a>yippieyiyo</a>") // improper
        #expect(#a(nil, "sheesh", nil, nil, " capeesh") == "<a>sheesh capeesh</a>")

        let ss:StaticString = #a((true ? "Oh yeah" : nil)) // improper
        #expect(ss == "<a>Oh yeah</a>")
    }*/
    
    /*@Test func multiline_value_type() {
        let string:StaticString = #script("""
        bro
        """
        )
        #expect(string == "<script>bro</script>")
    }*/

    /*@Test func not_allowed() {
        let _:StaticString = #div(attributes: [.id("1"), .id("2"), .id("3"), .id("4")])
        let _:StaticString = #a(
            attributes: [
                .class(["lets go"])
            ],
            attributionSrc: ["lets go"],
            ping: ["lets go"]
        )
        let _:StaticString = #input(
            accept: ["lets,go"],
            autocomplete: ["lets go"]
        )
        let _:StaticString = #link(
            imagesizes: ["lets,go"],
            imagesrcset: ["lets,go"],
            rel: ["lets go"],
            sizes: ["lets,go"]
        )
        var bro:String = "yup"
        let _:String = #a(bro)
        let _:String = #div(attributes: [.custom("potof gold1", "\(1)"), .custom("potof gold2", "2")])

        let test:[Int] = [1]
        bro = #area(coords: test)
    }*/
}

// MARK: Attribute tests
extension HTMLKitTests {
    @Test func attribute_data() {
        let string:StaticString = #div(attributes: [.data("id", "5")])
        #expect(string == "<div data-id=\"5\"></div>")
    }
    @Test func attribute_hidden() {
        var string:StaticString = #div(attributes: [.hidden(.true)])
        #expect(string == "<div hidden></div>")

        string = #div(attributes: [.hidden(.untilFound)])
        #expect(string == "<div hidden=\"until-found\"></div>")
    }

    @Test func attribute_custom() {
        var string:StaticString = #div(attributes: [.custom("potofgold", "north")])
        #expect(string == "<div potofgold=\"north\"></div>")
        
        string = #div(attributes: [.custom("potofgold", "\(1)")])
        #expect(string == "<div potofgold=\"1\"></div>")

        string = #div(attributes: [.custom("potofgold1", "\(1)"), .custom("potofgold2", "2")])
        #expect(string == "<div potofgold1=\"1\" potofgold2=\"2\"></div>")
    }
}

// MARK: 3rd party tests
extension HTMLKitTests {
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

extension HTMLKitTests {
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
        var string:String = #div(attributes: [.title(HTMLKitTests.spongebob)])
        #expect(string == "<div title=\"Spongebob Squarepants\"></div>")

        string = #div(attributes: [.title(HTMLKitTests.patrick)])
        #expect(string == "<div title=\"Patrick Star\"></div>")

        var static_string:StaticString = #div(attributes: [.title(StaticString("Mr. Crabs"))])
        #expect(static_string == "<div title=\"Mr. Crabs\"></div>")

        static_string = #div(attributes: [.title("Mr. Crabs")])
        #expect(static_string == "<div title=\"Mr. Crabs\"></div>")
    }
    @Test func third_party_func() {
        let string:String = #div(attributes: [.title(HTMLKitTests.spongebobCharacter("patrick"))])
        #expect(string == "<div title=\"Patrick Star\"></div>")
    }
}

// MARK: StaticString Example
extension HTMLKitTests {
    @Test func example_1() {
        let test:StaticString = #html(
            #body(
                #div(
                    attributes: [
                        .class(["dark-mode", "row"]),
                        .draggable(.false),
                        .hidden(.true),
                        .inputmode(.email),
                        .title("Hey, you're pretty cool")
                    ],
                    "Random text",
                    #div(),
                    #a(
                        #div(
                            #abbr()
                        ),
                        #address()
                    ),
                    #div(),
                    #button(disabled: true),
                    #video(autoplay: true, controls: false, preload: .auto, src: "https://github.com/RandomHashTags/litleagues", width: .centimeters(1))
                )
            )
        )
        #expect(test == "<!DOCTYPE html><html><body><div class=\"dark-mode row\" draggable=\"false\" hidden inputmode=\"email\" title=\"Hey, you&#39re pretty cool\">Random text<div></div><a><div><abbr></abbr></div><address></address></a><div></div><button disabled></button><video autoplay preload=\"auto\" src=\"https://github.com/RandomHashTags/litleagues\" width=\"1cm\"></video></div></body></html>")
    }
}

// MARK: Dynamic test
extension HTMLKitTests {
    @Test func dynamic() {
        let charset:String = "utf-8", title:String = "Dynamic"
        var qualities:String = ""
        for quality in ["one", "two", "three", "four"] {
            qualities += #li("\(quality)")
        }
        let string:String = #html(
            #head(
                #meta(charset: "\(charset)"),
                #title("\(title)"),
                #meta(content: "\("description \(title)")", name: "description"),
                #meta(content: "\("keywords")", name: "keywords")
            ),
            #body(
                #h1("\("Heading")"),
                #div(attributes: [.id("desc")],
                    #p("\("bro")")
                ),
                #h2("\("Details")"),
                #h3("\("Qualities")"),
                #ul(attributes: [.id("user-qualities")], String(describing: qualities))
            )
        )
        #expect(string == "<!DOCTYPE html><html><head><meta charset=\"\(charset)\"><title>\(title)</title><meta content=\"description \(title)\" name=\"description\"><meta content=\"keywords\" name=\"keywords\"></head><body><h1>Heading</h1><div id=\"desc\"><p>bro</p></div><h2>Details</h2><h3>Qualities</h3><ul id=\"user-qualities\">\(qualities)</ul></body></html>")
    }
}

// MARK: Example2
extension HTMLKitTests {
    @Test func example2() {
        var test:TestStruct = TestStruct(name: "one", array: ["1", "2", "3"])
        #expect(test.html == "<p>one123</p>")
        
        test.name = "two"
        test.array = [4, 5, 6, 7, 8]
        #expect(test.html == "<p>two45678</p>")
    }
    struct TestStruct {
        var name:String
        var array:[CustomStringConvertible] {
            didSet {
                array_string = array.map({ "\($0)" }).joined()
            }
        }
        private var array_string:String
        
        init(name: String, array: [CustomStringConvertible]) {
            self.name = name
            self.array = array
            self.array_string = array.map({ "\($0)" }).joined()
        }

        var html : String { #p("\(name)", "\(array_string)") }
    }
}