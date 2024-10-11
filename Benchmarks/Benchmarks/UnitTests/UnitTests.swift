//
//  UnitTests.swift
//
//
//  Created by Evan Anderson on 10/6/24.
//

import Testing
import Utilities
import SwiftHTMLKit

import TestElementary
import TestPlot
import TestSwiftHTMLBB
import TestSwiftHTMLKit
import TestSwiftHTMLPF
import TestSwim
import TestToucan
import TestVaporHTMLKit
import TestVaux

struct UnitTests {
    let libraries:[String:HTMLGenerator] = [
        "BinaryBirds" : SwiftHTMLBBTests(),
        "Elementary" : ElementaryTests(),
        "Plot" : PlotTests(),
        "Pointfreeco" : SwiftHTMLPFTests(),
        "SwiftHTMLKit" : SwiftHTMLKitTests(),
        "Swim" : SwimTests(),
        "VaporHTMLKit" : VaporHTMLKitTests(),
        "Vaux" : VauxTests()
    ]
    @Test func staticHTML() {
        let expected_value:String = #html([
            #head([
                #title(["StaticView"])
            ]),
            #body([
                #h1(["Swift HTML Benchmarks"])
            ])
        ])
        for (key, value) in libraries {
            var string:String = value.staticHTML()
            if key == "Swim" {
                string = string.replacingOccurrences(of: "\n", with: "")
            }
            #expect(string == expected_value, Comment(rawValue: key))
        }
    }
    @Test func dynamicHTML() {
        let context:HTMLContext = HTMLContext()
        let expected_value:String = libraries["SwiftHTMLKit"]!.dynamicHTML(context)
        // Plot closes void tags | Swim uses a dictionary for meta values | Vaux is doodoo
        for (key, value) in libraries {
            #expect(value.dynamicHTML(context) == expected_value, Comment(rawValue: key))
        }
    }
}