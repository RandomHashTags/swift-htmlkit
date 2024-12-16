//
//  UnitTests.swift
//
//
//  Created by Evan Anderson on 10/6/24.
//

#if compiler(>=6.0)

import Testing
import Utilities
import SwiftHTMLKit

import TestElementary
import TestPlot
import TestSwiftDOM
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
        "SwiftDOM" : SwiftDOMTests(),
        "SwiftHTMLKit" : SwiftHTMLKitTests(),
        "Swim" : SwimTests(),
        "VaporHTMLKit" : VaporHTMLKitTests(),
        "Vaux (custom renderer)" : VauxTests()
    ]
    // Some tests fail due to:
    // - Plot closes void tags
    // - Swim doesn't minify (keeps new line characters and some whitespace); uses a dictionary for meta values; closes void tags
    // - Vaux is doodoo

    @Test func staticHTML() {
        let expected_value:String = libraries["SwiftHTMLKit"]!.staticHTML()
        for (key, value) in libraries {
            var string:String = value.staticHTML()
            if key == "Swim" {
                string.replace("\n", with: "")
            } else if key == "SwiftDOM" {
                string.replace("'", with: "\"")
            }
            #expect(string == expected_value, Comment(rawValue: key))
        }
    }
    @Test func dynamicHTML() {
        let context:HTMLContext = HTMLContext()
        let expected_value:String = libraries["SwiftHTMLKit"]!.dynamicHTML(context)
        for (key, value) in libraries {
            var string:String = value.dynamicHTML(context)
            if key == "Swim" {
                string.replace("\n", with: "")
            } else if key == "SwiftDOM" {
                string.replace("'", with: "\"")
            }
            #expect(string == expected_value, Comment(rawValue: key))
        }
    }
}

#endif