//
//  Vaux.swift
//
//
//  Created by Evan Anderson on 10/6/24.
//

import Utilities
import Vaux
import Foundation

/*
package struct VauxTests : HTMLGenerator {

    let vaux:Vaux
    package init() {
        vaux = Vaux()
    }

    package func staticHTML() -> String {
        var stream:HTMLOutputStream = HTMLOutputStream(FileHandle.standardOutput, nil)
        let content = html {
            body {
                heading(.h1) {
                    "Swift HTML Benchmarks"
                }
            }
        }
        stream.render(content)
        let textoutput:TextOutputStream = stream.output
        return ""
    }

    package func dynamicHTML(_ context: HTMLContext) -> String {
        staticHTML()
    }
}*/