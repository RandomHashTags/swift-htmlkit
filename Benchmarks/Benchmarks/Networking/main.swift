
import HTTPTypes
import ServiceLifecycle

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

// hummingbird
import Hummingbird

struct HeaderMiddleware<Context: RequestContext> : RouterMiddleware {
    func handle(_ request: Request, context: Context, next: (Request, Context) async throws -> Response) async throws -> Response {
        var response = try await next(request, context)
        response.headers[HTTPField.Name.contentType] = "text/html"
        return response
    }
}

let router = Hummingbird.Router()
router.middlewares.add(HeaderMiddleware())
for (library, value) in libraries {
    router.get(RouterPath(library)) { request, _ -> String in
        return value.staticHTML()
    }
    router.get(RouterPath("d" + library)) { request, _ -> String in
        return value.dynamicHTML(HTMLContext())
    }
}
let app:Hummingbird.Application = Hummingbird.Application(router: router, configuration: .init(address: .hostname("127.0.0.1", port: 8080)))
try await app.runService()

/*
// vapor
import Vapor

*/