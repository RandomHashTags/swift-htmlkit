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
        html { body { h1 { "Swift HTML Benchmarks" }} }.render()
    }
    package func dynamicHTML(_ context: HTMLContext) -> String {
        html {
            body {
                h1 { context.heading }
                div(attributes: [.id("desc")]) {
                    p { context.string }
                }
                h2 { context.user.details_heading }
                h3 { context.user.qualities_heading }
                ul(attributes: [.id("user-qualities")]) {
                    for quality in context.user.qualities {
                        li { quality }
                    }
                }
            }
        }.render()
    }
}