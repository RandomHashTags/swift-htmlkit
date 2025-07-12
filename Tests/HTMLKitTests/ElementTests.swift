
#if compiler(>=6.0)

import Testing
import HTMLKit

struct ElementTests {
    // MARK: html
    @Test func elementHTML() {
        var expected:String = "<!DOCTYPE html><html></html>"
        var string:String = #html(html())
        #expect(string == expected)

        expected = "<!DOCTYPE html><html xmlns=\"test\"></html>"
        string = #html(html(xmlns: "test"))
        #expect(string == expected)

        string = #html {
            html(xmlns: "test")
        }
        #expect(string == expected)
    }

    // MARK: HTMLKit.<element>
    @Test func elementWithLibraryDecl() {
        let string:StaticString = #html(html(HTMLKit.body()))
        #expect(string == "<!DOCTYPE html><html><body></body></html>")
    }
}



// MARK: Elements




extension ElementTests {
    // MARK: a
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a
    @Test func elementA() {
        var string:String = #html(a("Test"))
        #expect(string == "<a>Test</a>")

        var stream:AsyncStream<String> = #html(representation: .streamed()) {
            a("Test")
        }

        string = #html(a(href: "test", "Test"))
        #expect(string == "<a href=\"test\">Test</a>")

        string = #html(a(href: "test") {
            "Test"
        })
        #expect(string == "<a href=\"test\">Test</a>")

        string = #html(a(href: "", "Test"))
        #expect(string == "<a href=\"\">Test</a>")
        
        string = #html(a(download: .empty))
        #expect(string == "<a download></a>")
        
        string = #html(a(download: .filename("yippie.json")))
        #expect(string == "<a download=\"yippie.json\"></a>")

        string = #html(a(ping: ["https://litleagues.com", "https://github.com/RandomHashTags"]))
        #expect(string == "<a ping=\"https://litleagues.com https://github.com/RandomHashTags\"></a>")

        string = #html(a(referrerpolicy: .noReferrer))
        #expect(string == "<a referrerpolicy=\"no-referrer\"></a>")

        string = #html(a(target: ._blank))
        #expect(string == "<a target=\"_blank\"></a>")

        string = #html(a(rel: [.stylesheet, .alternate, .privacyPolicy, .termsOfService, .dnsPrefetch]))
        #expect(string == "<a rel=\"stylesheet alternate privacy-policy terms-of-service dns-prefetch\"></a>")
    }

    // MARK: area
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/area
    @Test func elementArea() {
        var string:StaticString = #html(area(coords: [1, 2, 3]))
        #expect(string == "<area coords=\"1,2,3\">")

        string = #html(area(coords: []))
        #expect(string == "<area coords>")

        string = #html(area(href: ""))
        #expect(string == "<area href=\"\">")

        string = #html(area(href: "https://github.com/RandomHashTags"))
        #expect(string == "<area href=\"https://github.com/RandomHashTags\">")

        string = #html(area(shape: .poly))
        #expect(string == "<area shape=\"poly\">")

        string = #html(area(shape: .default))
        #expect(string == "<area shape=\"default\">")

        string = #html(area(target: ._self))
        #expect(string == "<area target=\"_self\">")
    }

    // MARK: audio
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/audio
    @Test func elementAudio() {
        var string:StaticString = #html(audio(controlslist: [.nodownload]))
        #expect(string == "<audio controlslist=\"nodownload\"></audio>")

        string = #html(audio(controlslist: [.nodownload, .nofullscreen, .noremoteplayback]))
        #expect(string == "<audio controlslist=\"nodownload nofullscreen noremoteplayback\"></audio>")

        string = #html(audio(autoplay: true))
        #expect(string == "<audio autoplay></audio>")

        string = #html(audio(autoplay: false, controls: true))
        #expect(string == "<audio controls></audio>")

        string = #html(audio(crossorigin: .anonymous))
        #expect(string == "<audio crossorigin=\"anonymous\"></audio>")

        string = #html(audio(crossorigin: .useCredentials))
        #expect(string == "<audio crossorigin=\"use-credentials\"></audio>")

        string = #html(audio(disableremoteplayback: true))
        #expect(string == "<audio disableremoteplayback></audio>")

        string = #html(audio(preload: .auto))
        #expect(string == "<audio preload=\"auto\"></audio>")
    }

    // MARK: button
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button
    @Test func elementButton() {
        var string:StaticString = #html(button(type: .submit))
        #expect(string == "<button type=\"submit\"></button>")

        string = #html(button(formenctype: .applicationXWWWFormURLEncoded, formmethod: .get, formtarget: ._blank, popovertargetaction: .hide))
        #expect(string == "<button formenctype=\"application/x-www-form-urlencoded\" formmethod=\"get\" formtarget=\"_blank\" popovertargetaction=\"hide\"></button>")

        string = #html(button(formenctype: .multipartFormData, formmethod: .post, popovertargetaction: .show))
        #expect(string == "<button formenctype=\"multipart/form-data\" formmethod=\"post\" popovertargetaction=\"show\"></button>")

        string = #html(button(formenctype: .textPlain, formmethod: .get, type: .reset))
        #expect(string == "<button formenctype=\"text/plain\" formmethod=\"get\" type=\"reset\"></button>")

        string = #html(button(command: .showModal))
        #expect(string == "<button command=\"show-modal\"></button>")

        string = #html(button(command: .showPopover))
        #expect(string == "<button command=\"show-popover\"></button>")

        string = #html(button(command: .hidePopover))
        #expect(string == "<button command=\"hide-popover\"></button>")

        string = #html(button(command: .togglePopover))
        #expect(string == "<button command=\"toggle-popover\"></button>")

        string = #html(button(command: .custom("bingbong")))
        #expect(string == "<button command=\"--bingbong\"></button>")
    }

    // MARK: canvas
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/canvas
    @Test func elementCanvas() {
        let string:StaticString = #html(canvas(height: .percent(4), width: .em(2.69)))
        #expect(string == "<canvas height=\"4%\" width=\"2.69em\"></canvas>")
    }

    // MARK: col
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/col
    @Test func elementCol() {
        let string:StaticString = #html(col(span: 4))
        #expect(string == "<col span=\"4\">")
    }

    // MARK: colgroup
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/colgroup
    @Test func elementColgroup() {
        let string:StaticString = #html(colgroup(span: 3))
        #expect(string == "<colgroup span=\"3\"></colgroup>")
    }

    // MARK: form
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form
    @Test func elementForm() {
        var string:StaticString = #html(form(acceptCharset: ["utf-8"], autocomplete: .on))
        #expect(string == "<form accept-charset=\"utf-8\" autocomplete=\"on\"></form>")

        string = #html(form(acceptCharset: ["utf-8", "utf-16"]))
        #expect(string == "<form accept-charset=\"utf-8 utf-16\"></form>")

        string = #html(form(enctype: .textPlain))
        #expect(string == "<form enctype=\"text/plain\"></form>")

        string = #html(form(method: "post"))
        #expect(string == "<form method=\"post\"></form>")

        string = #html(form(novalidate: true))
        #expect(string == "<form novalidate></form>")
    }

    // MARK: iframe
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe
    @Test func elementIframe() {
        var string:StaticString = #html(iframe(sandbox: [.allowDownloads, .allowForms]))
        #expect(string == "<iframe sandbox=\"allow-downloads allow-forms\"></iframe>")

        string = #html(iframe(allow: ["geolocation", "test"]))
        #expect(string == "<iframe allow=\"geolocation;test\"></iframe>")
    }

    // MARK: img
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/img
    @Test func elementImg() {
        let string:StaticString = #html(img(sizes: ["(max-height: 500px) 1000px", "(min-height: 25rem)"], srcset: ["https://paradigm-app.com", "https://litleagues.com"]))
        #expect(string == "<img sizes=\"(max-height: 500px) 1000px,(min-height: 25rem)\" srcset=\"https://paradigm-app.com,https://litleagues.com\">")
    }

    // MARK: input
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
    @Test func elementInput() {
        var string:StaticString = #html(input(autocomplete: ["email", "password"], type: .text))
        #expect(string == "<input autocomplete=\"email password\" type=\"text\">")

        string = #html(input(type: .password))
        #expect(string == "<input type=\"password\">")

        string = #html(input(type: .datetimeLocal))
        #expect(string == "<input type=\"datetime-local\">")

        string = #html(input(accept: [".docx", ".json"]))
        #expect(string == "<input accept=\".docx,.json\">")
    }

    // MARK: label
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/label
    @Test func elementLabel() {
        let string:StaticString = #html(label(for: "what_the", "skrrt"))
        #expect(string == "<label for=\"what_the\">skrrt</label>")
    }

    // MARK: link
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/link
    @Test func elementLink() {
        var string:StaticString = #html(link(as: .document, imagesizes: ["lmno", "p"]))
        #expect(string == "<link as=\"document\" imagesizes=\"lmno,p\">")

        string = #html(link(imagesrcset: ["blah", "bling"]))
        #expect(string == "<link imagesrcset=\"blah,bling\">")
    }

    // MARK: meta
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/meta
    @Test func elementMeta() {
        let string:StaticString = #html(meta(charset: "utf-8", httpEquiv: .contentType))
        #expect(string == "<meta charset=\"utf-8\" http-equiv=\"content-type\">")
    }

    // MARK: object
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/object
    @Test func elementObject() {
        let string:StaticString = #html(object(archive: ["https://github.com/RandomHashTags/destiny", "https://youtube.com"], border: 5))
        #expect(string == "<object archive=\"https://github.com/RandomHashTags/destiny https://youtube.com\" border=\"5\"></object>")
    }

    // MARK: ol
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ol
    @Test func elementOl() {
        var string:StaticString = #html(ol())
        #expect(string == "<ol></ol>")

        string = #html(ol(type: .a))
        #expect(string == "<ol type=\"a\"></ol>")

        string = #html(ol(type: .A))
        #expect(string == "<ol type=\"A\"></ol>")

        string = #html(ol(type: .i))
        #expect(string == "<ol type=\"i\"></ol>")

        string = #html(ol(type: .I))
        #expect(string == "<ol type=\"I\"></ol>")

        string = #html(ol(type: .one))
        #expect(string == "<ol type=\"1\"></ol>")
    }

    // MARK: option
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/option
    @Test func elementOption() {
        var string:StaticString = #html(option())
        #expect(string == "<option></option>")

        string = #html(option(value: ""))
        #expect(string == "<option value=\"\"></option>")

        string = #html(option(value: "earth"))
        #expect(string == "<option value=\"earth\"></option>")
    }

    // MARK: output
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/output
    @Test func elementOutput() {
        let string:StaticString = #html(output(for: ["whats", "it", "tuya"]))
        #expect(string == "<output for=\"whats it tuya\"></output>")
    }

    // MARK: script
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script
    @Test func elementScript() {
        var string:StaticString = #html(script())
        #expect(string == "<script></script>")

        string = #html(script(type: .importmap))
        #expect(string == "<script type=\"importmap\"></script>")

        string = #html(script(type: .module))
        #expect(string == "<script type=\"module\"></script>")

        string = #html(script(type: .speculationrules))
        #expect(string == "<script type=\"speculationrules\"></script>")
    }

    // MARK: style
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/style
    @Test func elementStyle() {
        let string:StaticString = #html(style(blocking: .render))
        #expect(string == "<style blocking=\"render\"></style>")
    }

    // MARK: td
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/td
    @Test func elementTd() {
        let string:StaticString = #html(td(headers: ["puss", "in", "boots"]))
        #expect(string == "<td headers=\"puss in boots\"></td>")
    }

    // MARK: template
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/template
    @Test func elementTemplate() {
        let string:StaticString = #html(template(shadowrootclonable: .false, shadowrootdelegatesfocus: false, shadowrootmode: .closed, shadowrootserializable: true))
        #expect(string == "<template shadowrootclonable=\"false\" shadowrootmode=\"closed\" shadowrootserializable></template>")
    }

    // MARK: textarea
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea
    @Test func elementTextarea() {
        let string:StaticString = #html(textarea(autocomplete: ["email", "password"], dirname: .ltr, rows: 5, wrap: .soft))
        #expect(string == "<textarea autocomplete=\"email password\" dirname=\"ltr\" rows=\"5\" wrap=\"soft\"></textarea>")
    }

    // MARK: th
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/th
    @Test func elementTh() {
        let string:StaticString = #html(th(rowspan: 2, scope: .colgroup))
        #expect(string == "<th rowspan=\"2\" scope=\"colgroup\"></th>")
    }

    // MARK: track
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/track
    @Test func elementTrack() {
        let string:StaticString = #html(track(default: true, kind: .captions, label: "tesT"))
        #expect(string == "<track default kind=\"captions\" label=\"tesT\">")
    }

    // MARK: variable
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/var
    @Test func elementVar() {
        let string:StaticString = #html(variable("macros don't like `var` bro"))
        #expect(string == "<var>macros don&#39t like `var` bro</var>")
    }
    
    // MARK: video
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/video
    @Test func elementVideo() {
        var string:StaticString = #html(video(controlslist: [.nodownload, .nofullscreen, .noremoteplayback]))
        #expect(string == "<video controlslist=\"nodownload nofullscreen noremoteplayback\"></video>")

        string = #html(video(crossorigin: .anonymous))
        #expect(string == "<video crossorigin=\"anonymous\"></video>")

        string = #html(video(crossorigin: .useCredentials))
        #expect(string == "<video crossorigin=\"use-credentials\"></video>")

        string = #html(video(preload: .metadata))
        #expect(string == "<video preload=\"metadata\"></video>")
    }

    // MARK: custom
    @Test func elementCustom() {
        var bro:StaticString = #html(custom(tag: "bro", isVoid: false))
        #expect(bro == "<bro></bro>")

        bro = #html(custom(tag: "bro", isVoid: true))
        #expect(bro == "<bro>")
    }

    // MARK: Events
    @Test func attributeEvents() {
        let third_thing:StaticString = "doAThirdThing()"
        let string:String = #html(div(attributes: [.event(.click, "doThing()"), .event(.change, "doAnotherThing()"), .event(.focus, "\(third_thing)")]))
        #expect(string == "<div onclick=\"doThing()\" onchange=\"doAnotherThing()\" onfocus=\"doAThirdThing()\"></div>")
    }

    // MARK: Void elements
    @Test func voidElements() {
        let string:StaticString = #html(area(base(), br(), col(), embed(), hr(), img(), input(), link(), meta(), source(), track(), wbr()))
        #expect(string == "<area><base><br><col><embed><hr><img><input><link><meta><source><track><wbr>")
    }
}

// MARK: Misc
extension ElementTests {
    @Test func recursiveElements() {
        let string:StaticString = #html(
            div(
                div(),
                div(div(), div(), div()),
                div()
            )
        )
        #expect(string == "<div><div></div><div><div></div><div></div><div></div></div><div></div></div>")
    }

    /*@Test func nil_values() {
        #expect(#a("yippie", (true ? nil : "yiyo")) == "<a>yippie</a>") // improper
        #expect(#a("yippie", (false ? nil : "yiyo")) == "<a>yippieyiyo</a>") // improper
        #expect(#a(nil, "sheesh", nil, nil, " capeesh") == "<a>sheesh capeesh</a>")

        let ss:StaticString = #a((true ? "Oh yeah" : nil)) // improper
        #expect(ss == "<a>Oh yeah</a>")
    }*/
    
    @Test func multilineInnerHTMLValue() {
        let string:StaticString = #html(
            p {
                """
                bro
                    dude
                hermano
                """
            }
        ) 
        #expect(string == "<p>bro\n    dude\nhermano</p>")
    }

    /*@Test func not_allowed() {
        let _:StaticString = #html(div(attributes: [.id("1"), .id("2"), .id("3"), .id("4")]))
        let _:StaticString = #html(
            a(
                attributes: [
                    .class(["lets go"])
                ],
                attributionsrc: ["lets go"],
                ping: ["lets go"]
            )
        )
        let _:StaticString = #html(
            input(
                accept: ["lets,go"],
                autocomplete: ["lets go"]
            )
        )
        let _:StaticString = #html(
            link(
                imagesizes: ["lets,go"],
                imagesrcset: ["lets,go"],
                rel: .stylesheet,
                size: "lets,go"
            )
        )
    }*/
}

#endif