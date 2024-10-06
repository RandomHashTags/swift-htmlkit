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

    package func simpleHTML() -> String {
        #html([
            #body([
                #h1(["Swift HTML Benchmarks"])
            ])
        ])
    }
    package func optimalHTML() -> String { simpleHTML() }
}