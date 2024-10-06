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

    package func simpleHTML() -> String {
        HTML(
            .body(
                .h1("Swift HTML Benchmarks")
            )
        ).render()
    }
    package func optimalHTML() -> String {
        simpleHTML()
    }
}