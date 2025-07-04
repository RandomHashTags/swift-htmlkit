
#if compiler(>=6.0)

import Testing
import HTMLKit

struct CSSTests {

    @Test func cssAttribute() {
        let expected:String = "<div style=\"white-space:normal\"></div>"
        //let result:String = #html(div(attributes: [.style([.whiteSpace(.normal)])]))
        let result:String = #html(div(attributes: [.style("white-space:normal")]))
        #expect(expected == result)
    }

    @Test func cssDefaultAttribute() {
        let expected:String = "unset"
        let result:String? = CSSStyle.Order.unset.htmlValue(encoding: .string, forMacro: false)
        #expect(expected == result)
        #expect("\(CSSStyle.Order.unset)" == expected)
    }
}


#endif