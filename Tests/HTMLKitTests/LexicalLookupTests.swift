//
//  LexicalLookupTests.swift
//
//
//  Created by Evan Anderson on 3/30/25.
//

#if compiler(>=6.0)

import Testing
import HTMLKit

struct LexicalLookupTests {
    @Test
    func lexicalLookup() {
        let placeholder:String = #html(p("gottem"))
        let value:String = #html(html(placeholder))
    }
}

#endif