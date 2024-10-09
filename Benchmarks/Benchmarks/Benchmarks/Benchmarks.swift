//
//  main.swift
//
//
//  Created by Evan Anderson on 10/5/24.
//

import Benchmark
import Utilities

import TestElementary
import TestPlot
import TestSwiftHTMLBB
import TestSwiftHTMLKit
import TestSwiftHTMLPF
import TestSwim
import TestToucan
import TestVaporHTMLKit
import TestVaux

let benchmarks = {
    Benchmark.defaultConfiguration = .init(metrics: .all)

    let libraries:[String:HTMLGenerator] = [
        "BinaryBirds" : SwiftHTMLBBTests(),
        "Elementary" : ElementaryTests(),
        "Plot" : PlotTests(),
        "Pointfreeco" : SwiftHTMLPFTests(),
        "SwiftHTMLKit" : SwiftHTMLKitTests(),
        "Swim" : SwimTests(),
        "VaporHTMLKit" : VaporHTMLKitTests()
    ]

    /*for (key, value) in libraries {
        Benchmark(key) {
            for _ in $0.scaledIterations {
                blackHole(value.staticHTML())
            }
        }
    }*/

    let context:HTMLContext = HTMLContext()
    for (key, value) in libraries {
        Benchmark(key) {
            for _ in $0.scaledIterations {
                blackHole(value.dynamicHTML(context))
            }
        }
    }
}