//
//  SwiftHTMLKit.swift
//
//
//  Created by Evan Anderson on 10/5/24.
//

import Utilities
import SwiftHTMLKit

package struct SwiftHTMLKitTests : HTMLGenerator {
    package init() {}

    package func staticHTML() -> String {
        #html([
            #head([
                #title(["StaticView"])
            ]),
            #body([
                #h1(["Swift HTML Benchmarks"])
            ])
        ])
    }
    // performance notes
    // - maping makes unneccessary copies and hurts throughput
    // - interpolation hurts performance, a lot less than maping but still noticeable
    // - adding strings (concatenation) is faster than interpolation
    // - calculating the size of the result than assigning the contents in a String is significantly worse than interpolation and concatenation
    // - calculating the size of the result than assigning the contents in a Data is about the same performance, if not faster, as SwiftHTMLKit native solution with interpolation/concatenation
    package func dynamicHTML(_ context: HTMLContext) -> String {
        var qualities:String = ""
        for quality in context.user.qualities {
            qualities += #li(["\(quality)"])
            //qualities += "<li>" + quality + "</li>"
        }
        //return "<!DOCTYPE html><html><body><h1>" + context.heading + "</h1><div id=\"" + context.desc_id + "\"><p>" + context.string + "</p></div><h2>" + context.user.details_heading + "</h2><h3>" + context.user.qualities_heading + "</h3><ul id=\"" + context.user.qualities_id + "\">" + qualities + "</ul></body></html>"
        return #html([
            #head([
                #title(["DynamicView"])
            ]),
            #body([
                #h1(["\(context.heading)"]),
                #div(attributes: [.id(context.desc_id)], [
                    #p(["\(context.string)"])
                ]),
                #h2(["\(context.user.details_heading)"]),
                #h3(["\(context.user.qualities_heading)"]),
                #ul(attributes: [.id(context.user.qualities_id)], ["\(qualities)"])
            ])
        ])
    }
}