//
//  Swim.swift
//
//
//  Created by Evan Anderson on 10/6/24.
//

import Utilities
import Swim

extension Node {
    var rendered: String {
        var result = ""
        write(to: &result)
        return result
    }
}

package struct SwimTests : HTMLGenerator {
    package init() {}

    package func staticHTML() -> String {
        html {
            body {
                h1 {
                    "Swift HTML Benchmarks"
                }
            }
        }.rendered
    }
    package func dynamicHTML(_ context: HTMLContext) -> String {
        html {
            body {
                h1 { context.heading }
                div(id: "desc") {
                    p { context.string }
                }
                h2 { context.user.details_heading }
                h3 { context.user.qualities_heading }
                ul(id: "user-qualities") {
                    context.user.qualities.map({ quality in li { quality} })
                }
            }
        }.rendered
    }
}