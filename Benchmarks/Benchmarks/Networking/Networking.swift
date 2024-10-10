//
//  Networking.swift
//
//
//  Created by Evan Anderson on 10/10/24.
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

import Hummingbird
import Vapor

let benchmarks = {
    Benchmark.defaultConfiguration = .init(metrics: .all)

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
    /*
    // hummingbird
    let router:Hummingbird.Router = Hummingbird.Router()
    for (library, value) in libraries {
        router.get(RouterPath(library)) { request, _ -> String in
            return value.staticHTML()
        }
        router.get(RouterPath("d" + library)) { request, _ -> String in
            return value.dynamicHTML(HTMLContext())
        }
    }
    let app:Hummingbird.Application = Hummingbird.Application(router: router, configuration: .init(address: .hostname("127.0.0.1", port: 8080)))
    Task {
        try! await Task.sleep(for: .seconds(5))
        for (key, value) in libraries {
            let request_s:Hummingbird.Request = Request(head: HTTPRequest(method: .get, scheme: nil, authority: nil, path: "http://127.0.0.1:8080/" + key), body: RequestBody(buffer: ByteBuffer()))
            let request_d:Hummingbird.Request = Request(head: HTTPRequest(method: .get, scheme: nil, authority: nil, path: "http://127.0.0.1:8080/d" + key), body: RequestBody(buffer: ByteBuffer()))
            Benchmark(key) {
                for _ in $0.scaledIterations {
                    //blackHole()
                }
            }
            Benchmark("d" + key) {
                for _ in $0.scaledIterations {
                    //blackHole()
                }
            }
        }
    }
    try await app.runService()*/
}