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
    @Test func test_element_html() {
        #expect(#html([]) == "<!DOCTYPE html><html></html>")
        #expect(#html(xmlns: "test", []) == "<!DOCTYPE html><html xmlns=\"test\"></html>")
    }
    @Test func test_element_area() {
        #expect(#area(coords: [1, 2, 3]) == "<area coords=\"1,2,3\">")
    }
    @Test func test_element_audio() {
        #expect(#audio(controlslist: .nodownload) == "<audio controlslist=\"nodownload\"></audio>")
    }
    @Test func test_element_button() {
        #expect(#button(type: .submit) == "<button type=\"submit\"></button>")
    }
    @Test func test_element_canvas() {
        #expect(#canvas(height: .percent(4), width: .em(2.69)) == "<canvas height=\"4%\" width=\"2.69em\"></canvas>")
    }
    @Test func test_element_form() {
        #expect(#form(acceptCharset: ["utf-8"], autocomplete: .on) == "<form accept-charset=\"utf-8\" autocomplete=\"on\"></form>")
    }
    @Test func test_element_iframe() {
        #expect(#iframe(sandbox: [.allowDownloads, .allowForms]) == "<iframe sandbox=\"allow-downloads allow-forms\"></iframe>")
    }
    @Test func test_element_input() {
        #expect(#input(autocomplete: ["email", "password"], type: .text) == "<input autocomplete=\"email password\" type=\"text\">")
        #expect(#input(type: .password) == "<input type=\"password\">")
        #expect(#input(type: .datetimeLocal) == "<input type=\"datetime-local\">")
    }
    @Test func test_element_img() {
        #expect(#img(sizes: ["(max-height: 500px) 1000px", "(min-height: 25rem)"], srcset: ["https://paradigm-app.com", "https://litleagues.com"]) == "<img sizes=\"(max-height: 500px) 1000px,(min-height: 25rem)\" srcset=\"https://paradigm-app.com,https://litleagues.com\">")
    }
    @Test func test_link() {
        #expect(#link(as: .document, imagesizes: ["lmno", "p"]) == "<link as=\"document\" imagesizes=\"lmno,p\">")
    }
    @Test func test_element_ol() {
        #expect(#ol() == "<ol></ol>")
        #expect(#ol(type: .a) == "<ol type=\"a\"></ol>")
        #expect(#ol(type: .A) == "<ol type=\"A\"></ol>")
        #expect(#ol(type: .i) == "<ol type=\"i\"></ol>")
        #expect(#ol(type: .I) == "<ol type=\"I\"></ol>")
        #expect(#ol(type: .one) == "<ol type=\"1\"></ol>")
    }
    @Test func test_element_script() {
        #expect(#script() == "<script></script>")
        #expect(#script(type: .importmap) == "<script type=\"importmap\"></script>")
        #expect(#script(type: .module) == "<script type=\"module\"></script>")
        #expect(#script(type: .speculationrules) == "<script type=\"speculationrules\"></script>")
    }
    @Test func test_element_text_area() {
        #expect(#textarea(autocomplete: ["email", "password"], rows: 5) == "<textarea autocomplete=\"email password\" rows=\"5\"></textarea>")
    }
    @Test func test_element_video() {
        #expect(#video(controlslist: [.nodownload, .nofullscreen, .noremoteplayback]) == "<video controlslist=\"nodownload nofullscreen noremoteplayback\"></video>")
    }
}

extension HTMLKitTests {
    @Test func test_recursive() {
        let string:String = #div([
            #div(),
            #div([#div(), #div(), #div()]),
            #div()
        ])
        #expect(string == "<div><div></div><div><div></div><div></div><div></div></div><div></div></div>")
    }
    /*@Test func test_same_attribute_multiple_times() {
        let string:StaticString = #div(attributes: [.id("1"), .id("2"), .id("3"), .id("4")])
        #expect(string == "<div id=\"1\"></div>")
    }*/
    @Test func test_attribute_hidden() {
        #expect(#div(attributes: [.hidden(.true)]) == "<div hidden></div>")
        #expect(#div(attributes: [.hidden(.untilFound)]) == "<div hidden=\"until-found\"></div>")
    }

    @Test func test_void() {
        let string:StaticString = #area([#base(), #br(), #col(), #embed(), #hr(), #img(), #input(), #link(), #meta(), #source(), #track(), #wbr()])
        #expect(string == "<area><base><br><col><embed><hr><img><input><link><meta><source><track><wbr>")
    }
    @Test func test_multiline() {
        /*#expect(#script(["""
        bro
        """
        ]) == "<script>bro</script>")*/
    }
    @Test func test_events() {
        #expect(#div(attributes: [.event(.click, "doThing()"), .event(.change, "doAnotherThing()")], []) == "<div onclick=\"doThing()\" onchange=\"doAnotherThing()\"></div>")
    }
}

extension HTMLKitTests {
    @Test func test_attribute_data() {
        #expect(#div(attributes: [.data("id", "5")]) == "<div data-id=\"5\"></div>")
    }
}

extension HTMLKitTests {
    enum Shrek : String {
        case isLove, isLife
    }
    @Test func test_third_party_enum() {
        #expect(#div(attributes: [.title(Shrek.isLove.rawValue)]) == "<div title=\"isLove\"></div>")
        #expect(#div(attributes: [.title("\(Shrek.isLife)")]) == "<div title=\"isLife\"></div>")
    }
}

extension HTMLKitTests {
    static let spongebob:String = "Spongebob"
    static func spongebobCharacter(_ string: StaticString) -> StaticString {
        if string == "patrick" {
            return "Patrick Star"
        }
        return "Plankton"
    }
    
    @Test func test_third_party_literal() {
        #expect(#div(attributes: [.title(HTMLKitTests.spongebob)]) == "<div title=\"Spongebob\"></div>")
    }
    @Test func test_third_party_func() {
        #expect(#div(attributes: [.title(HTMLKitTests.spongebobCharacter("patrick"))]) == "<div title=\"Patrick Star\"></div>")
    }
}

extension HTMLKitTests {
    @Test func test_example_1() {
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
    @Test func testExample2() {
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
