
#if compiler(>=6.0)

import HTMLKit
import Testing

@Suite
struct ResultTypeTests {
    let yeah = "yeah"
    let expected = "<div>oh yeah</div>"
}

// MARK: Literal
extension ResultTypeTests {
    @Test
    func resultTypeLiteral() {
        var literal:String = #html(resultType: .literal) {
            div("oh yeah")
        }
        #expect(literal == expected)

        literal = #html(resultType: .literal) {
            div("oh \(yeah)")
        }
        #expect(literal == expected)

        literal = #html(resultType: .literal) {
            div("oh \(yeah)", yeah)
        }
        #expect(literal == "<div>oh yeahyeah</div>")
    }
}

// MARK: Literal optimized
extension ResultTypeTests {
    @Test
    func resultTypeLiteralOptimized() {
        /*let _:String = #html(resultType: .literalOptimized) {
            div("oh yeah")
        }
        let _:String = #html(resultType: .literalOptimized) {
            div("oh \(yeah)")
        }*/
    }
}

// MARK: Chunks
extension ResultTypeTests {
    @Test
    func resultTypeChunks() {
        let _:[StaticString] = #html(resultType: .chunks()) {
            div("oh yeah")
        }

        let expected = "<div>oh yeah</div>"
        var chunks:[String] = #html(resultType: .chunks()) {
            div("oh yeah")
        }
        #expect(chunks == [expected])//

        chunks = #html(resultType: .chunks(chunkSize: 3)) {
            div("oh \(yeah)")
        }
        #expect(chunks.joined() == expected)

        chunks = #html(resultType: .chunks(chunkSize: 3)) {
            div("oh \(yeah)", yeah)
        }
        #expect(chunks.joined() == "<div>oh yeahyeah</div>")

        chunks = #html(resultType: .chunks(chunkSize: 3)) {
            div("oh ", yeah, yeah)
        }
        #expect(chunks.joined() == "<div>oh yeahyeah</div>")

        chunks = #html(resultType: .chunks(chunkSize: 3)) {
            div("oh ", yeah)
        }
        #expect(chunks == ["<di", "v>o", "h ", yeah, "</d", "iv>"])
    }
}

// MARK: Stream
extension ResultTypeTests {
    @Test
    func resultTypeStream() {
        let _:AsyncStream<String> = #html(resultType: .stream()) {
            div("oh yeah")
        }
        let _:AsyncStream<StaticString> = #html(resultType: .stream()) {
            div("oh yeah")
        }
        let _:AsyncStream<String> = #html(resultType: .stream(chunkSize: 3)) {
            div("oh yeah")
        }
        let _:AsyncStream<StaticString> = #html(resultType: .stream(chunkSize: 3)) {
            div("oh yeah")
        }
        let _:AsyncStream<String> = #html(resultType: .stream(chunkSize: 3)) {
            div("oh \(yeah)")
        }
        let _:AsyncStream<String> = #html(resultType: .stream(chunkSize: 3)) {
            div("oh \(yeah)", yeah)
        }
    }
}

// MARK: Stream async
extension ResultTypeTests {
    @Test
    func resultTypeStreamAsync() {
        let _:AsyncStream<String> = #html(resultType: .streamAsync()) {
            div("oh yeah")
        }
        let _:AsyncStream<String> = #html(resultType: .streamAsync(chunkSize: 3)) {
            div("oh yeah")
        }
        let _:AsyncStream<String> = #html(resultType: .streamAsync(chunkSize: 3)) {
            div("oh \(yeah)")
        }
        let _:AsyncStream<String> = #html(resultType: .streamAsync(chunkSize: 3)) {
            div("oh \(yeah)", yeah)
        }
        let _:AsyncStream<String> = #html(resultType: .streamAsync({ _ in
            try await Task.sleep(for: .milliseconds(50))
        })) {
            div("oh yeah")
        }
        let _:AsyncStream<String> = #html(resultType: .streamAsync(chunkSize: 3, { _ in
            try await Task.sleep(for: .milliseconds(50))
        })) {
            div("oh yeah")
        }
    }
}

#endif