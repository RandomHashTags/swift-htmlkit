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
    
    package func simpleHTML() -> String {
        html { body { h1 { "Swift HTML Benchmarks" }} }.render()
    }
    package func optimalHTML() -> String {
        simpleHTML()
    }
}