//
//  SwiftHTMLBB.swift
//
//
//  Created by Evan Anderson on 10/5/24.
//

import Utilities
import SwiftHtml

package struct SwiftHTMLBBTests : HTMLGenerator {
    let renderer:DocumentRenderer
    package init() {
        renderer = DocumentRenderer(minify: true, indent: 0)
    }

    package func staticHTML() -> String {
        renderer.render(Document(.html) {
            Html {
                Head {
                    Title("StaticView")
                }
                Body {
                    H1("Swift HTML Benchmarks")
                }
            }
        })
    }

    package func dynamicHTML(_ context: HTMLContext) -> String {
        renderer.render(Document(.html) {
            Html {
                Body {
                    H1(context.heading)
                    Div {
                        P(context.string)
                    }.id(context.desc_id)
                    H2(context.user.details_heading)
                    H3(context.user.qualities_heading)
                    Ul {
                        context.user.qualities.map({ Li($0) })
                    }.id(context.user.qualities_id)
                }
            }
        })
    }
}