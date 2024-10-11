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
        try! renderer.add(layout: StaticView())
        try! renderer.add(layout: DynamicView(context: Utilities.HTMLContext()))
    }

    package func staticHTML() -> String {
        return try! renderer.render(layout: StaticView.self)
    }
    package func dynamicHTML(_ context: Utilities.HTMLContext) -> String {
        return try! renderer.render(layout: DynamicView.self, with: context)
    }
}

struct StaticView : View {
    var body : AnyContent {
        Document(.html5)
        Html {
            Head {
                Title { "StaticView" }
            }
            Body {
                Heading1 { "Swift HTML Benchmarks" }
            }
        }
    }
}

struct DynamicView : View {
    let context:Utilities.HTMLContext

    var body : AnyContent {
        Document(.html5)
        Html {
            Head {
                Title { "DynamicView" }
            }
            Body {
                Heading1 { context.heading }
                Div {
                    P { context.string }
                }.id(context.desc_id)
                Heading2 { context.user.details_heading }
                Heading3 { context.user.qualities_heading }
                Ul {
                    context.user.qualities.map({ quality in Li { quality } })
                }.id(context.user.qualities_id)
            }
        }
    }
}