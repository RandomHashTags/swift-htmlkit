
import Benchmark
import Utilities

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

let benchmarks = {
    Benchmark.defaultConfiguration = .init(metrics: .all)

    let libraries:[String:HTMLGenerator] = [
        "BinaryBirds" : SwiftHTMLBBTests(),
        "Elementary" : ElementaryTests(),
        "Plot" : PlotTests(),
        "Pointfreeco" : SwiftHTMLPFTests(),
        "SwiftHTMLKit" : SwiftHTMLKitTests(),
        "SwiftDOM" : SwiftDOMTests(),
        "Swim" : SwimTests(),
        "VaporHTMLKit" : VaporHTMLKitTests(),
        "Vaux (custom renderer)" : VauxTests()
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

    /*let test:SwiftHTMLKitTests = SwiftHTMLKitTests()
    Benchmark("SwiftHTMLKit static (StaticString)") {
        for _ in $0.scaledIterations {
            blackHole(test.staticHTML())
        }
    }
    Benchmark("SwiftHTMLKit static ([UInt8])") {
        for _ in $0.scaledIterations {
            blackHole(test.staticHTMLUTF8Bytes())
        }
    }
    Benchmark("SwiftHTMLKit static ([UInt16])") {
        for _ in $0.scaledIterations {
            blackHole(test.staticHTMLUTF16Bytes())
        }
    }
    Benchmark("SwiftHTMLKit static (ByteBuffer)") {
        for _ in $0.scaledIterations {
            blackHole(test.staticHTMLByteBuffer())
        }
    }*/
}