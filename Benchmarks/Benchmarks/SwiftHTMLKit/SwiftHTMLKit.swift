//
//  SwiftHTMLKit.swift
//
//
//  Created by Evan Anderson on 10/5/24.
//

import Utilities
import SwiftHTMLKit

package struct SwiftHTMLKitTests : HTMLGenerator {
    package init() {}

    package func staticHTML() -> String {
        #html(
            #head(
                #title("StaticView")
            ),
            #body(
                #h1("Swift HTML Benchmarks")
            )
        )
    }
    package func dynamicHTML(_ context: HTMLContext) -> String {
        var qualities:String = ""
        for quality in context.user.qualities {
            qualities += #li("\(quality)")
        }
        return #html(
            #body(
                #h1("\(context.heading)"),
                #div(attributes: [.id(context.desc_id)],
                    #p("\(context.string)")
                ),
                #h2("\(context.user.details_heading)"),
                #h3("\(context.user.qualities_heading)"),
                #ul(attributes: [.id(context.user.qualities_id)], "\(qualities)")
            )
        )
    }
}