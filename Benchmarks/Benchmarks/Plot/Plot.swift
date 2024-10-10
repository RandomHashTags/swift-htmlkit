//
//  Plot.swift
//
//
//  Created by Evan Anderson on 10/5/24.
//

import Utilities
import Plot

package struct PlotTests : HTMLGenerator {
    package init() {}

    package func staticHTML() -> String {
        HTML(
            .head(
                .element(named: "title", text: "StaticView")
            ),
            .body(
                .h1("Swift HTML Benchmarks")
            )
        ).render()
    }
    package func dynamicHTML(_ context: Utilities.HTMLContext) -> String {
        let context:Context = Context(context)
        return HTML(
            .body(
                .component(context.heading),
                .component(context.desc),
                .component(context.details_heading),
                .component(context.qualities_heading),
                .component(context.qualities)
            )
        )
        .render()
    }
}

struct Context {    
    let heading:any Component
    let desc:any Component
    let details_heading:any Component
    let qualities_heading:any Component
    let qualities:any Component

    init(_ context: Utilities.HTMLContext) {
        heading = H1(context.heading)
        desc = Div(Paragraph(context.string).id(context.desc_id))
        details_heading = H2(context.user.details_heading)
        qualities_heading = H3(context.user.qualities_heading)
        qualities = List(context.user.qualities).id(context.user.qualities_id)
    }
}