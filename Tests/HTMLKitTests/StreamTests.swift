
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
        // TODO: fix infinite loop if `chunkSize` is `40`.
        let test:AsyncStream<String> = #html(representation: .streamedAsync(chunkSize: 50, suspendDuration: .milliseconds(5))) {
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
        let now = ContinuousClock.now
        for await test in test {
            receivedHTML += test
        }
        let took = ContinuousClock.now - now
        #expect(took < .milliseconds(25))
        #expect(receivedHTML == expected)
    }
}

#endif