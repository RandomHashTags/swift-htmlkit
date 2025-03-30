//
//  RawHTMLTests.swift
//
//
//  Created by Evan Anderson on 3/29/25.
//

#if compiler(>=6.0)

import Testing
import HTMLKit

struct RawHTMLTests {
    @Test func rawHTML() {
        var expected = "<!DOCTYPE html><html>dude&dude</html>"
        var result:String = #rawHTML("<!DOCTYPE html><html>dude&dude</html>")
        #expect(expected == result)

        expected = "<!DOCTYPE html><html><p>test<></p>dude&dude bro&amp;bro</html>"
        result = #html(html(#anyRawHTML(p("test<>"), "dude&dude"), " bro&bro"))
        #expect(expected == result)
    }
}

#endif