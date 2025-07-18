
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
            resultType: .streamAsync(chunkSize: 50, { _ in
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
        #expect(took >= .milliseconds(20) && took < .milliseconds(25))
        #expect(receivedHTML == expected)

        test = #html(
            resultType: .streamAsync(
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
        #expect(took >= .milliseconds(50) && took < .milliseconds(55))
        #expect(receivedHTML == expected)
    }
}

// MARK: Interpolation
extension StreamTests {
    @Test
    func streamInterpolation() async {
        let rawHTMLInterpolationTest = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let expected:String = #html(
            html {
                body {
                    div()
                    div()
                    div()
                    div()
                    div()
                    rawHTMLInterpolationTest
                    div()
                    div()
                    div()
                    div()
                    div()
                }
            }
        )

        var test:AsyncStream<String> = #html(
            resultType: .streamAsync(chunkSize: 50, { _ in
                try await Task.sleep(for: .milliseconds(5))
            })) {
            html {
                body {
                    div()
                    div()
                    div()
                    div()
                    div()
                    rawHTMLInterpolationTest
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
        #expect(took >= .milliseconds(20) && took < .milliseconds(25))
        #expect(receivedHTML == expected)

        test = #html(
            resultType: .streamAsync(chunkSize: 200, { _ in
                try await Task.sleep(for: .milliseconds(5))
            })) {
            html {
                body {
                    div()
                    div()
                    div()
                    div()
                    div()
                    rawHTMLInterpolationTest
                    div()
                    div()
                    div()
                    div()
                    div()
                }
            }
        }
        receivedHTML = ""
        now = ContinuousClock.now
        for await test in test {
            receivedHTML += test
        }
        took = ContinuousClock.now - now
        #expect(took >= .milliseconds(10) && took < .milliseconds(15))
        #expect(receivedHTML == expected)
    }
}

#endif