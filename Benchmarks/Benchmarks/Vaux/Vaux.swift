//
//  Vaux.swift
//
//
//  Created by Evan Anderson on 10/6/24.
//

import Utilities
import Vaux
import Foundation

extension HTML {
    var rendered : String { String(describing: self) }
}

package struct VauxTests : HTMLGenerator {

    let vaux:Vaux
    package init() {
        vaux = Vaux()
    }

    package func staticHTML() -> String {
        html {
            body {
                heading(.h1) {
                    "Swift HTML Benchmarks"
                }
            }
        }.rendered
    }

    package func dynamicHTML(_ context: HTMLContext) -> String {
        html {
            body {
                heading(.h1) { context.heading }
                div {
                    paragraph { context.string }
                }.id("desc")
                heading(.h2) { context.user.details_heading }
                heading(.h3) { context.user.qualities_heading }
                list {
                    forEach(context.user.qualities) {
                        listItem(label: $0)
                    }
                }.id("user-qualities")
            }
        }.rendered
    }
}