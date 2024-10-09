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
import TestSwiftHTMLKit
import TestSwiftHTMLPF
import TestSwim
import TestToucan
import TestVaporHTMLKit
import TestVaux

let benchmarks = {
    Benchmark.defaultConfiguration = .init(metrics: .all)

    let libraries:[String:HTMLGenerator] = [
        "Elementary" : ElementaryTests(),
        "Plot" : PlotTests(),
        "SwiftHTMLKit" : SwiftHTMLKitTests(),
        "SwiftHTMLPF" : SwiftHTMLPFTests(),
        //"Swim" : SwimTests(),
        "VaporHTMLKit" : VaporHTMLKitTests()
    ]

    for (key, value) in libraries {
        Benchmark(key + " static") {
            for _ in $0.scaledIterations {
                blackHole(value.staticHTML())
            }
        }
    }

    /*let context:HTMLContext = HTMLContext()
    for (key, value) in libraries {
        Benchmark(key + " dynamic") {
            for _ in $0.scaledIterations {
                blackHole(value.dynamicHTML(context))
            }
        }
    }*/
}