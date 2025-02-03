//
//  CSSTests.swift
//
//
//  Created by Evan Anderson on 2/3/25.
//

#if compiler(>=6.0)

import Testing
import HTMLKit

struct CSSTests {

    @Test func cssAttribute() {
        let expected:String = "<div style=\"white-space:normal\"></div>"
        let result:String = #html(div(attributes: [.style([.whiteSpace(.normal)])]))
        #expect(expected == result)
    }
}


#endif