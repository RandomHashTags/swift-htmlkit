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

        result = #rawHTML(minify: true, """
        <!DOCTYPE html>
        <html>
            dude&dude
        </html>
        """)
        #expect(expected == result)

        expected = "<!DOCTYPE html><html><p>test<></p>dude&dude bro&amp;bro</html>"
        result = #html(html(#anyRawHTML(p("test<>"), "dude&dude"), " bro&bro"))
        #expect(expected == result)

        expected = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" class=\"lucide lucide-eye-icon\">\n    <path d=\"M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0\"></path>\n    <circle cx=\"12\" cy=\"12\" r=\"3\"></circle></svg><!--]--></a><a href=\"about:blank#\" class=\"hover:underline tooltip\" title=\"Delete\"><svg xmlns=\"http://www.w3.org/2000/svg\" width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\" class=\"lucide lucide-trash-icon\">\n    <path d=\"M3 6h18\"></path>\n    <path d=\"M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6\"></path>\n    <path d=\"M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2\"></path></svg>"
        result = #rawHTML(#"""
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-eye-icon">
            <path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"></path>
            <circle cx="12" cy="12" r="3"></circle></svg><!--]--></a><a href="about:blank#" class="hover:underline tooltip" title="Delete"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-trash-icon">
            <path d="M3 6h18"></path>
            <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"></path>
            <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"></path></svg>
        """#
        )
        #expect(expected == result)
    }
}

#endif