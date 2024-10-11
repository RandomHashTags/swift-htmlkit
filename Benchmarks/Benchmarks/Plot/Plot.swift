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
        return HTML(
            .head(
                .meta(.attribute(named: "charset", value: context.charset)),
                .element(named: "title", text: "DynamicView"),
                .meta(.content(context.meta_description), .name("description")),
                .meta(.content(context.keywords_string), .name("keywords"))
            ),
            .body(
                .component(H1(context.heading)),
                .component(Div(Paragraph(context.string)).id(context.desc_id)),
                .component(H2(context.user.details_heading)),
                .component(H3(context.user.qualities_heading)),
                .component(List(context.user.qualities).id(context.user.qualities_id))
            )
        )
        .render()
    }
}