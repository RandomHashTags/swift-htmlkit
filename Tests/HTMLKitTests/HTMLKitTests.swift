//
//  HTMLKitTests.swift
//
//
//  Created by Evan Anderson on 9/16/24.
//

import XCTest
@testable import HTMLKit

final class HTMLKitTests : XCTestCase {
    func testExample() throws {
    }
}

extension HTMLKitTests {
    func test_macro_html() {
        XCTAssertEqual(#html(innerHTML: []), "<!DOCTYPE html><html></html>")
        XCTAssertEqual(#html(xmlns: "test", innerHTML: []), "<!DOCTYPE html><html xmlns=\"test\"></html>")
    }
}

extension HTMLKitTests {
    func test_recursive() {
        let string:String = #div(innerHTML: [
            #div(),
            #div(innerHTML: [#div(), #div(), #div()]),
            #div()
        ])
        XCTAssertEqual(string, "<div><div></div><div><div></div><div></div><div></div></div><div></div></div>")
    }
}

extension HTMLKitTests {
    func test_attribute_data() {
        let bro:Int = 0
        let string:String = #div(attributes: [.data(id: "id", "\(bro)")])
        XCTAssertEqual(string, "<div data-id=\"\(bro)\"></div>")
    }
}

extension HTMLKitTests {
    func testExample1() {
        let test:String = #html(innerHTML: [
            #body(innerHTML: [
                #div(
                    attributes: [
                        .class(["bing", "bong"]),
                        .title("just seeing what blow's"),
                        .draggable(.false),
                        .inputMode(.email),
                        .hidden(.hidden)
                    ],
                    innerHTML: [
                        "poggies",
                        #div(),
                        #a(innerHTML: [#div(innerHTML: [#abbr()]), #address()]),
                        #div(),
                        #button(disabled: true),
                        #video(autoplay: true, controls: false, height: nil, preload: .auto, src: "ezclap", width: 5),
                    ]
                )
            ])
        ])
        XCTAssertEqual(test, "<!DOCTYPE html><html><body><div class=\"bing bong\" title=\"just seeing what blow's\" draggable=\"false\" inputmode=\"email\" hidden=\"hidden\">poggies<div></div><a><div><abbr></abbr></div><address></address></a><div></div><button disabled></button><video autoplay preload=\"auto\" src=\"ezclap\" width=\"5\"></video></div></body></html>")
    }
}
