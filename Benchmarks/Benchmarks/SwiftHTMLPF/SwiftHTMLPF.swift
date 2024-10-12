//
//  SwiftHTMLPF.swift
//
//
//  Created by Evan Anderson on 10/5/24.
//

import Utilities
import Html

package struct SwiftHTMLPFTests : HTMLGenerator {
    package init() {}

    package func staticHTML() -> String {
        render(
            .document(
                .html(
                    .head(
                        .title("StaticView")
                    ),
                    .body(.h1("Swift HTML Benchmarks"))
                )
            )
        )
    }

    package func dynamicHTML(_ context: HTMLContext) -> String {
        render(
            .document(
                .html(
                    .head(
                        .meta(attributes: [.charset(.utf8)]),
                        .title(context.title),
                        .meta(attributes: [.init("content", context.meta_description), .init("name", "description")]),
                        .meta(attributes: [.init("content", context.keywords_string), .init("name", "keywords")])
                    ),
                    .body(
                        .h1(.raw(context.heading)),
                        .div(attributes: [.id(context.desc_id)], .p(.raw(context.string))),
                        .h2(.raw(context.user.details_heading)),
                        .h3(.raw(context.user.qualities_heading)),
                        .ul(attributes: [.id(context.user.qualities_id)], .fragment(context.user.qualities.map({ quality in .li(.raw(quality)) })))
                    )
                )
            )
        )
    }
}