//
//  VaporHTMLKit.swift
//
//
//  Created by Evan Anderson on 10/5/24.
//

import Utilities
import VaporHTMLKit

package struct VaporHTMLKitTests : HTMLGenerator {

    let renderer:Renderer
    package init() {
        renderer = Renderer()
        try! renderer.add(layout: SimpleView())
    }

    package func simpleHTML() -> String {
        return try! renderer.render(layout: SimpleView.self)
    }
    package func optimalHTML() -> String {
        simpleHTML()
    }
}

struct SimpleView : View {
    var body : AnyContent {
        Document(.html5)
        Html {
            Body {
                Heading1 { "Swift HTML Benchmarks" }
            }
        }
    }
}