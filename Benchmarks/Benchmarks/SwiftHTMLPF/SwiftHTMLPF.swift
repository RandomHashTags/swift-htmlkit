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

    package func simpleHTML() -> String {
        render(.document(.html(.body(.h1("Swift HTML Benchmarks")))))
    }
    package func optimalHTML() -> String {
        simpleHTML()
    }
}