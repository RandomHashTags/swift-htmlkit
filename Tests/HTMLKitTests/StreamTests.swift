
#if compiler(>=6.0)

import HTMLKit
import Testing

struct StreamTests {
    @Test(.timeLimit(.minutes(1)))
    func streamTest() async {
        let expected:String = #html(
            html {
                body {
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                }
            }
        )
        var test:AsyncStream<String> = #html(
            representation: .streamedAsync(chunkSize: 50, { _ in
                try await Task.sleep(for: .milliseconds(5))
            })) {
            html {
                body {
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                }
            }
        }
        var receivedHTML = ""
        var now = ContinuousClock.now
        for await test in test {
            receivedHTML += test
        }
        var took = ContinuousClock.now - now
        #expect(took < .milliseconds(25))
        #expect(receivedHTML == expected)

        test = #html(
            representation: .streamedAsync(
                chunkSize: 40, { yieldIndex in
                    try await Task.sleep(for: .milliseconds((yieldIndex+1) * 5))
                }
            )) {
            html {
                body {
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                    div()
                }
            }
        }
        receivedHTML = ""
        now = .now
        for await test in test {
            receivedHTML += test
        }
        took = ContinuousClock.now - now
        #expect(took < .milliseconds(55))
        #expect(receivedHTML == expected)
    }
}

#endif