//
//  Elementary.swift
//
//
//  Created by Evan Anderson on 10/5/24.
//

import Utilities
import Elementary

package struct ElementaryTests : HTMLGenerator {
    package init() {}
    
    package func staticHTML() -> String {
        StaticView().render()
    }
    package func dynamicHTML(_ context: HTMLContext) -> String {
        html {
            body {
                h1 { context.heading }
                div(attributes: [.id(context.desc_id)]) {
                    p { context.string }
                }
                h2 { context.user.details_heading }
                h3 { context.user.qualities_heading }
                ul(attributes: [.id(context.user.qualities_id)]) {
                    for quality in context.user.qualities {
                        li { quality }
                    }
                }
            }
        }.render()
    }
}

struct StaticView : HTMLDocument {
    var title:String = "StaticView"

    var head : some HTML {
        ""
    }
    var body : some HTML {
        h1 { "Swift HTML Benchmarks" }
    }
}