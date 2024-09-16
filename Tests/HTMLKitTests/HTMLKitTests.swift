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
        print("test=" + test)
    }
}
