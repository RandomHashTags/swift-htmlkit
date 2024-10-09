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
        render(.document(.html(.body(.h1("Swift HTML Benchmarks")))))
    }

    package func dynamicHTML(_ context: HTMLContext) -> String {
        render(
            .document(
                .html(
                    .body(
                        .h1(.raw(context.heading)),
                        .div(attributes: [.id("desc")], .p(.raw(context.string))),
                        .h2(.raw(context.user.details_heading)),
                        .h3(.raw(context.user.qualities_heading)),
                        .ul(attributes: [.id("user-qualities")], .fragment(context.user.qualities.map({ quality in .li(.raw(quality)) })))
                    )
                )
            )
        )
    }
}