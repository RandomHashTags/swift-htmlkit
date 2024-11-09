//
//  ElementTests.swift
//
//
//  Created by Evan Anderson on 11/3/24.
//

import Testing
import HTMLKit

struct ElementTests {
    // MARK: Escape
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



// MARK: Elements




extension ElementTests {
    // MARK: html
    @Test func html() {
        var string:StaticString = #html()
        #expect(string == "<!DOCTYPE html><html></html>")

        string = #html(xmlns: "test")
        #expect(string == "<!DOCTYPE html><html xmlns=\"test\"></html>")
    }

    // MARK: a
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a
    @Test func a() {
        var string:String = #a("Test")
        #expect(string == "<a>Test</a>")

        string = #a(href: "test", "Test")
        #expect(string == "<a href=\"test\">Test</a>")

        string = #a(href: "", "Test")
        #expect(string == "<a href=\"\">Test</a>")
        
        string = #a(download: .empty)
        #expect(string == "<a download></a>")
        
        string = #a(download: .filename("yippie.json"))
        #expect(string == "<a download=\"yippie.json\"></a>")

        string = #a(ping: ["https://litleagues.com", "https://github.com/RandomHashTags"])
        #expect(string == "<a ping=\"https://litleagues.com https://github.com/RandomHashTags\"></a>")

        string = #a(referrerpolicy: .noReferrer)
        #expect(string == "<a referrerpolicy=\"no-referrer\"></a>")

        string = #a(target: ._blank)
        #expect(string == "<a target=\"_blank\"></a>")
    }

    // MARK: area
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/area
    @Test func area() {
        var string:StaticString = #area(coords: [1, 2, 3])
        #expect(string == "<area coords=\"1,2,3\">")

        string = #area(coords: [])
        #expect(string == "<area coords=\"\">")

        string = #area(href: "")
        #expect(string == "<area href=\"\">")

        string = #area(href: "https://github.com/RandomHashTags")
        #expect(string == "<area href=\"https://github.com/RandomHashTags\">")

        string = #area(shape: .poly)
        #expect(string == "<area shape=\"poly\">")

        string = #area(shape: .default)
        #expect(string == "<area shape=\"default\">")

        string = #area(target: ._self)
        #expect(string == "<area target=\"_self\">")
    }

    // MARK: audio
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/audio
    @Test func audio() {
        var string:StaticString = #audio(controlslist: [.nodownload])
        #expect(string == "<audio controlslist=\"nodownload\"></audio>")

        string = #audio(controlslist: [.nodownload, .nofullscreen, .noremoteplayback])
        #expect(string == "<audio controlslist=\"nodownload nofullscreen noremoteplayback\"></audio>")

        string = #audio(autoplay: true)
        #expect(string == "<audio autoplay></audio>")

        string = #audio(autoplay: false, controls: true)
        #expect(string == "<audio controls></audio>")

        string = #audio(crossorigin: .anonymous)
        #expect(string == "<audio crossorigin=\"anonymous\"></audio>")

        string = #audio(crossorigin: .useCredentials)
        #expect(string == "<audio crossorigin=\"use-credentials\"></audio>")

        string = #audio(disableremoteplayback: true)
        #expect(string == "<audio disableremoteplayback></audio>")

        string = #audio(preload: .auto)
        #expect(string == "<audio preload=\"auto\"></audio>")
    }

    // MARK: button
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button
    @Test func button() {
        var string:StaticString = #button(type: .submit)
        #expect(string == "<button type=\"submit\"></button>")

        string = #button(formenctype: .applicationXWWWFormURLEncoded, formmethod: .get, formtarget: ._blank, popovertargetaction: .hide)
        #expect(string == "<button formenctype=\"application/x-www-form-urlencoded\" formmethod=\"get\" formtarget=\"_blank\" popovertargetaction=\"hide\"></button>")

        string = #button(formenctype: .multipartFormData, formmethod: .post, popovertargetaction: .show)
        #expect(string == "<button formenctype=\"multipart/form-data\" formmethod=\"post\" popovertargetaction=\"show\"></button>")

        string = #button(formenctype: .textPlain, formmethod: .get, type: .reset)
        #expect(string == "<button formenctype=\"text/plain\" formmethod=\"get\" type=\"reset\"></button>")

        string = #button(command: .showModal)
        #expect(string == "<button command=\"show-modal\"></button>")

        string = #button(command: .showPopover)
        #expect(string == "<button command=\"show-popover\"></button>")

        string = #button(command: .hidePopover)
        #expect(string == "<button command=\"hide-popover\"></button>")

        string = #button(command: .togglePopover)
        #expect(string == "<button command=\"toggle-popover\"></button>")

        string = #button(command: .custom("bingbong"))
        #expect(string == "<button command=\"--bingbong\"></button>")
    }

    // MARK: canvas
    @Test func canvas() {
        let string:StaticString = #canvas(height: .percent(4), width: .em(2.69))
        #expect(string == "<canvas height=\"4%\" width=\"2.69em\"></canvas>")
    }

    // MARK: form
    @Test func form() {
        let string:StaticString = #form(acceptCharset: ["utf-8"], autocomplete: .on)
        #expect(string == "<form accept-charset=\"utf-8\" autocomplete=\"on\"></form>")
    }

    // MARK: iframe
    @Test func iframe() {
        let string:StaticString = #iframe(sandbox: [.allowDownloads, .allowForms])
        #expect(string == "<iframe sandbox=\"allow-downloads allow-forms\"></iframe>")
    }

    // MARK: input
    @Test func input() {
        var string:StaticString = #input(autocomplete: ["email", "password"], type: .text)
        #expect(string == "<input autocomplete=\"email password\" type=\"text\">")

        string = #input(type: .password)
        #expect(string == "<input type=\"password\">")

        string = #input(type: .datetimeLocal)
        #expect(string == "<input type=\"datetime-local\">")
    }

    // MARK: img
    @Test func img() {
        let string:StaticString = #img(sizes: ["(max-height: 500px) 1000px", "(min-height: 25rem)"], srcset: ["https://paradigm-app.com", "https://litleagues.com"])
        #expect(string == "<img sizes=\"(max-height: 500px) 1000px,(min-height: 25rem)\" srcset=\"https://paradigm-app.com,https://litleagues.com\">")
    }

    // MARK: link
    @Test func link() {
        let string:StaticString = #link(as: .document, imagesizes: ["lmno", "p"])
        #expect(string == "<link as=\"document\" imagesizes=\"lmno,p\">")
    }

    // MARK: ol
    @Test func ol() {
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

    // MARK: option
    @Test func option() {
        var string:StaticString = #option()
        #expect(string == "<option></option>")

        string = #option(value: "")
        #expect(string == "<option value=\"\"></option>")

        string = #option(value: "earth")
        #expect(string == "<option value=\"earth\"></option>")
    }

    // MARK: script
    @Test func script() {
        var string:StaticString = #script()
        #expect(string == "<script></script>")

        string = #script(type: .importmap)
        #expect(string == "<script type=\"importmap\"></script>")

        string = #script(type: .module)
        #expect(string == "<script type=\"module\"></script>")

        string = #script(type: .speculationrules)
        #expect(string == "<script type=\"speculationrules\"></script>")
    }

    // MARK: style
    @Test func style() {
        let string:StaticString = #style(blocking: .render)
        #expect(string == "<style blocking=\"render\"></style>")
    }

    // MARK: template
    @Test func template() {
        let string:StaticString = #template(shadowrootclonable: .false, shadowrootdelegatesfocus: false, shadowrootmode: .closed, shadowrootserializable: true)
        #expect(string == "<template shadowrootclonable=\"false\" shadowrootmode=\"closed\" shadowrootserializable></template>")
    }

    // MARK: textarea
    @Test func textarea() {
        let string:StaticString = #textarea(autocomplete: ["email", "password"], dirname: .ltr, rows: 5, wrap: .soft)
        #expect(string == "<textarea autocomplete=\"email password\" dirname=\"ltr\" rows=\"5\" wrap=\"soft\"></textarea>")
    }

    // MARK: th
    @Test func th() {
        let string:StaticString = #th(rowspan: 2, scope: .colgroup)
        #expect(string == "<th rowspan=\"2\" scope=\"colgroup\"></th>")
    }

    // MARK: track
    @Test func track() {
        let string:StaticString = #track(default: true, kind: .captions, label: "tesT")
        #expect(string == "<track default kind=\"captions\" label=\"tesT\">")
    }
    
    // MARK: video
    @Test func video() {
        var string:StaticString = #video(controlslist: [.nodownload, .nofullscreen, .noremoteplayback])
        #expect(string == "<video controlslist=\"nodownload nofullscreen noremoteplayback\"></video>")

        string = #video(crossorigin: .anonymous)
        #expect(string == "<video crossorigin=\"anonymous\"></video>")

        string = #video(crossorigin: .useCredentials)
        #expect(string == "<video crossorigin=\"use-credentials\"></video>")

        string = #video(preload: .metadata)
        #expect(string == "<video preload=\"metadata\"></video>")
    }

    // MARK: custom
    @Test func custom() {
        var bro:StaticString = #custom(tag: "bro", isVoid: false)
        #expect(bro == "<bro></bro>")

        bro = #custom(tag: "bro", isVoid: true)
        #expect(bro == "<bro>")
    }

    // MARK: Events
    @Test func events() {
        let third_thing:StaticString = "doAThirdThing()"
        let string:String = #div(attributes: [.event(.click, "doThing()"), .event(.change, "doAnotherThing()"), .event(.focus, "\(third_thing)")])
        #expect(string == "<div onclick=\"doThing()\" onchange=\"doAnotherThing()\" onfocus=\"doAThirdThing()\"></div>")
    }

    // MARK: Void elements
    @Test func elements_void() {
        let string:StaticString = #area(#base(), #br(), #col(), #embed(), #hr(), #img(), #input(), #link(), #meta(), #source(), #track(), #wbr())
        #expect(string == "<area><base><br><col><embed><hr><img><input><link><meta><source><track><wbr>")
    }
}

// MARK: Misc
extension ElementTests {
    @Test func recursive() {
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
        let _:String = #div(attributes: [.custom("potof gold1", "\(1)"), .custom("potof gold2", "2")])

        let _:StaticString = #div(attributes: [.trailingSlash])
        let _:StaticString = #custom(tag: "slash", isVoid: false, attributes: [.trailingSlash])
    }*/
}