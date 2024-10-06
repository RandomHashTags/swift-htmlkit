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
        Benchmark(key + " simpleHTML()") {
            for _ in $0.scaledIterations {
                blackHole(value.simpleHTML())
            }
        }
    }
}