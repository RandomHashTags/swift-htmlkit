//
//  HTMLKitTests.swift
//
//
//  Created by Evan Anderson on 9/16/24.
//

import Testing
import HTMLKit

struct HTMLKitTests {
    @Test func measureElapsedTime() {
        measureElapsedTime(key: "htmlkit") {
            let _:StaticString = #html([
                #body([
                    #h1(["Swift HTML Benchmarks"])
                ])
            ])
        }
    }
    func measureElapsedTime(key: String, _ block: () -> Void) {
        let duration:ContinuousClock.Duration = ContinuousClock().measure(block)
        print("measureElapsedTime;" + key + " took=\(duration)")
    }
}

extension HTMLKitTests {
    @Test func element_html() {
        #expect(#html([]) == "<!DOCTYPE html><html></html>")
        #expect(#html(xmlns: "test", []) == "<!DOCTYPE html><html xmlns=\"test\"></html>")
    }
    @Test func element_area() {
        #expect(#area(coords: [1, 2, 3]) == "<area coords=\"1,2,3\">")
    }
    @Test func element_audio() {
        #expect(#audio(controlslist: .nodownload) == "<audio controlslist=\"nodownload\"></audio>")
    }
    @Test func element_button() {
        #expect(#button(type: .submit) == "<button type=\"submit\"></button>")
        #expect(#button(formenctype: .applicationXWWWFormURLEncoded, formmethod: .get, formtarget: ._blank, popovertargetaction: .hide) == "<button formenctype=\"application/x-www-form-urlencoded\" formmethod=\"get\" formtarget=\"_blank\" popovertargetaction=\"hide\"></button>")
        #expect(#button(formenctype: .multipartFormData, formmethod: .post, popovertargetaction: .show) == "<button formenctype=\"multipart/form-data\" formmethod=\"post\" popovertargetaction=\"show\"></button>")
        #expect(#button(formenctype: .textPlain, formmethod: .get, type: .reset) == "<button formenctype=\"text/plain\" formmethod=\"get\" type=\"reset\"></button>")
    }
    @Test func element_canvas() {
        #expect(#canvas(height: .percent(4), width: .em(2.69)) == "<canvas height=\"4%\" width=\"2.69em\"></canvas>")
    }
    @Test func element_form() {
        #expect(#form(acceptCharset: ["utf-8"], autocomplete: .on) == "<form accept-charset=\"utf-8\" autocomplete=\"on\"></form>")
    }
    @Test func element_iframe() {
        #expect(#iframe(sandbox: [.allowDownloads, .allowForms]) == "<iframe sandbox=\"allow-downloads allow-forms\"></iframe>")
    }
    @Test func element_input() {
        #expect(#input(autocomplete: ["email", "password"], type: .text) == "<input autocomplete=\"email password\" type=\"text\">")
        #expect(#input(type: .password) == "<input type=\"password\">")
        #expect(#input(type: .datetimeLocal) == "<input type=\"datetime-local\">")
    }
    @Test func element_img() {
        #expect(#img(sizes: ["(max-height: 500px) 1000px", "(min-height: 25rem)"], srcset: ["https://paradigm-app.com", "https://litleagues.com"]) == "<img sizes=\"(max-height: 500px) 1000px,(min-height: 25rem)\" srcset=\"https://paradigm-app.com,https://litleagues.com\">")
    }
    @Test func element_link() {
        #expect(#link(as: .document, imagesizes: ["lmno", "p"]) == "<link as=\"document\" imagesizes=\"lmno,p\">")
    }
    @Test func element_ol() {
        #expect(#ol() == "<ol></ol>")
        #expect(#ol(type: .a) == "<ol type=\"a\"></ol>")
        #expect(#ol(type: .A) == "<ol type=\"A\"></ol>")
        #expect(#ol(type: .i) == "<ol type=\"i\"></ol>")
        #expect(#ol(type: .I) == "<ol type=\"I\"></ol>")
        #expect(#ol(type: .one) == "<ol type=\"1\"></ol>")
    }
    @Test func element_script() {
        #expect(#script() == "<script></script>")
        #expect(#script(type: .importmap) == "<script type=\"importmap\"></script>")
        #expect(#script(type: .module) == "<script type=\"module\"></script>")
        #expect(#script(type: .speculationrules) == "<script type=\"speculationrules\"></script>")
    }
    @Test func element_style() {
        #expect(#style(blocking: .render) == "<style blocking=\"render\"></style>")
    }
    @Test func element_template() {
        #expect(#template(shadowrootclonable: .false, shadowrootdelegatesfocus: false, shadowrootmode: .closed, shadowrootserializable: true) == "<template shadowrootclonable=\"false\" shadowrootmode=\"closed\" shadowrootserializable></template>")
    }
    @Test func element_textarea() {
        #expect(#textarea(autocomplete: ["email", "password"], dirname: .ltr, rows: 5, wrap: .soft) == "<textarea autocomplete=\"email password\" dirname=\"ltr\" rows=\"5\" wrap=\"soft\"></textarea>")
    }
    @Test func element_th() {
        #expect(#th(rowspan: 2, scope: .colgroup) == "<th rowspan=\"2\" scope=\"colgroup\"></th>")
    }
    @Test func element_track() {
        #expect(#track(default: true, kind: .captions, label: "tesT") == "<track default kind=\"captions\" label=\"tesT\">")
    }
    @Test func element_video() {
        #expect(#video(controlslist: [.nodownload, .nofullscreen, .noremoteplayback]) == "<video controlslist=\"nodownload nofullscreen noremoteplayback\"></video>")
        #expect(#video(crossorigin: .anonymous) == "<video crossorigin=\"anonymous\"></video>")
        #expect(#video(crossorigin: .useCredentials) == "<video crossorigin=\"use-credentials\"></video>")
        #expect(#video(preload: .metadata) == "<video preload=\"metadata\"></video>")
    }

    @Test func element_custom() {
        var bro:String = #custom(tag: "bro", isVoid: false)
        #expect(bro == "<bro></bro>")

        bro = #custom(tag: "bro", isVoid: true)
        #expect(bro == "<bro>")
    }

    @Test func element_events() {
        #expect(#div(attributes: [.event(.click, "doThing()"), .event(.change, "doAnotherThing()")], []) == "<div onclick=\"doThing()\" onchange=\"doAnotherThing()\"></div>")
    }

    @Test func elements_void() {
        let string:StaticString = #area([#base(), #br(), #col(), #embed(), #hr(), #img(), #input(), #link(), #meta(), #source(), #track(), #wbr()])
        #expect(string == "<area><base><br><col><embed><hr><img><input><link><meta><source><track><wbr>")
    }
}

extension HTMLKitTests {
    @Test func recursive_elements() {
        let string:StaticString = #div([
            #div(),
            #div([#div(), #div(), #div()]),
            #div()
        ])
        #expect(string == "<div><div></div><div><div></div><div></div><div></div></div><div></div></div>")
    }

    @Test func no_value_type() {
        let test1 = #html([#body([#h1(["HTMLKitTests"])])])
        #expect(type(of: test1) == String.self)
        let test2 = #html([#body([#h1([StaticString("HTMLKitTests")])])])
        #expect(type(of: test2) == StaticString.self)
    }

    /*@Test func nil_values() {
        #expect(#a(["yippie", (true ? nil : "yiyo")]) == "<a>yippie</a>") // improper
        #expect(#a(["yippie", (false ? nil : "yiyo")]) == "<a>yippieyiyo</a>") // improper
        #expect(#a([nil, "sheesh", nil, nil, " capeesh"]) == "<a>sheesh capeesh</a>")

        let ss:StaticString = #a([(true ? "Oh yeah" : nil)]) // improper
        #expect(ss == "<a>Oh yeah</a>")
    }*/
    
    @Test func multiline_value_type() {
        /*#expect(#script(["""
        bro
        """
        ]) == "<script>bro</script>")*/
    }

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
        //let _:String = #div(attributes: [.custom("potof gold1", "\(1)"), .custom("potof gold2", "2")])
    }*/
}

extension HTMLKitTests {
    @Test func attribute_data() {
        #expect(#div(attributes: [.data("id", "5")]) == "<div data-id=\"5\"></div>")
    }
    @Test func attribute_hidden() {
        #expect(#div(attributes: [.hidden(.true)]) == "<div hidden></div>")
        #expect(#div(attributes: [.hidden(.untilFound)]) == "<div hidden=\"until-found\"></div>")
    }

    @Test func attribute_custom() {
        #expect(#div(attributes: [.custom("potofgold", "north")]) == "<div potofgold=\"north\"></div>")
        #expect(#div(attributes: [.custom("potofgold", "\(1)")]) == "<div potofgold=\"1\"></div>")
        #expect(#div(attributes: [.custom("potofgold1", "\(1)"), .custom("potofgold2", "2")]) == "<div potofgold1=\"1\" potofgold2=\"2\"></div>")
        
    }
}

extension HTMLKitTests {
    enum Shrek : String {
        case isLove, isLife
    }
    @Test func third_party_enum() {
        #expect(#a(attributes: [.title(Shrek.isLove.rawValue)]) == "<a title=\"isLove\"></a>")
        #expect(#a(attributes: [.title("\(Shrek.isLife)")]) == "<a title=\"isLife\"></a>")
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

        let static_string:StaticString = #div(attributes: [.title("Mr. Crabs")])
        #expect(static_string == "<div title=\"Mr. Crabs\"></div>")
    }
    @Test func third_party_func() {
        #expect(#div(attributes: [.title(HTMLKitTests.spongebobCharacter("patrick"))]) == "<div title=\"Patrick Star\"></div>")
    }
}

extension HTMLKitTests {
    @Test func example_1() {
        let test:StaticString = #html([
            #body([
                #div(
                    attributes: [
                        .class(["dark-mode", "row"]),
                        .draggable(.false),
                        .hidden(.true),
                        .inputmode(.email),
                        .title("Hey, you're pretty cool")
                    ],
                    [
                        "Random text",
                        #div(),
                        #a([
                            #div([
                                #abbr()
                            ]),
                            #address()
                        ]),
                        #div(),
                        #button(disabled: true),
                        #video(autoplay: true, controls: false, preload: .auto, src: "https://github.com/RandomHashTags/litleagues", width: .centimeters(1)),
                    ]
                )
            ])
        ])
        #expect(test == "<!DOCTYPE html><html><body><div class=\"dark-mode row\" draggable=\"false\" hidden inputmode=\"email\" title=\"Hey, you're pretty cool\">Random text<div></div><a><div><abbr></abbr></div><address></address></a><div></div><button disabled></button><video autoplay preload=\"auto\" src=\"https://github.com/RandomHashTags/litleagues\" width=\"1cm\"></video></div></body></html>")
    }
}

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
        var array:[CustomStringConvertible]

        var html : String { #p(["\(name)", "\(array.map({ "\($0)" }).joined())"]) }
    }
}
