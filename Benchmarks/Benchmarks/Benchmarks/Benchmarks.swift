//
//  main.swift
//
//
//  Created by Evan Anderson on 10/5/24.
//

import Benchmark
import TestSwiftHTMLKit
import TestElementary
import TestSwiftHTMLPF

let benchmarks = {
    Benchmark.defaultConfiguration = .init(metrics: .all)

    let swifthtmlkit:SwiftHTMLKitTests = SwiftHTMLKitTests()
    Benchmark("SwiftHTMLKit simpleHTML()") {
        for _ in $0.scaledIterations {
            blackHole(swifthtmlkit.simpleHTML())
        }
    }

    let elementary:ElementaryTests = ElementaryTests()
    Benchmark("Elementary simpleHTML()") {
        for _ in $0.scaledIterations {
            blackHole(elementary.simpleHTML())
        }
    }

    /*let renderer:Renderer = Renderer.init()
    Benchmark("VaporHTMLKit create single html") {
        for _ in $0.scaledIterations {
            blackHole(renderer.render(view: VaporHTMLKitTests.SimpleHTML()))
        }
    }*/

    let swifthtml:SwiftHTMLPFTests = SwiftHTMLPFTests()
    Benchmark("SwiftHtml singleHTML()") {
        for _ in $0.scaledIterations {
            blackHole(swifthtml.simpleHTML())
        }
    }
}

/*struct VaporHTMLKitTests {
    struct SimpleHTML : some VaporHTMLKit.View {
        var body : Content {
            Html {
                Body {
                    Heading1 { "Swift HTML Benchmarks" }
                }
            }
        }
    }
}*/