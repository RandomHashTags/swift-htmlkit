//
//  SwiftHTMLKit.swift
//
//
//  Created by Evan Anderson on 10/5/24.
//

import Utilities
import SwiftHTMLKit
import NIOCore

package struct SwiftHTMLKitTests : HTMLGenerator {
    package init() {}

    package func staticHTML() -> String {
        #html(
            #head(
                #title("StaticView")
            ),
            #body(
                #h1("Swift HTML Benchmarks")
            )
        )
    }

    package func staticHTMLUTF8Bytes() -> [UInt8] {
        #htmlUTF8Bytes(
            #head(
                #title("StaticView")
            ),
            #body(
                #h1("Swift HTML Benchmarks")
            )
        )
    }

    package func staticHTMLUTF16Bytes() -> [UInt16] {
        #htmlUTF16Bytes(
            #head(
                #title("StaticView")
            ),
            #body(
                #h1("Swift HTML Benchmarks")
            )
        )
    }

    package func staticHTMLByteBuffer() -> ByteBuffer {
        #htmlByteBuffer(
            #head(
                #title("StaticView")
            ),
            #body(
                #h1("Swift HTML Benchmarks")
            )
        )
    }

    // performance notes
    // - maping makes unnecessary copies and hurts throughput
    // - interpolation hurts performance, a lot less than maping but still noticeable
    // - adding strings (concatenation) is faster than interpolation
    // - calculating the size of the result than assigning the contents in a String is significantly worse than interpolation and concatenation
    // - calculating the size of the result than assigning the contents in a Data is about the same performance, if not faster, as SwiftHTMLKit native solution with interpolation/concatenation
    package func dynamicHTML(_ context: HTMLContext) -> String {
        var qualities:String = ""
        for quality in context.user.qualities {
            qualities += #li("\(quality)")
        }
        return #html(
            #head(
                #meta(charset: "\(context.charset)"),
                #title("\(context.title)"),
                #meta(content: "\(context.meta_description)", name: "description"),
                #meta(content: "\(context.keywords_string)", name: "keywords")
            ),
            #body(
                #h1("\(context.heading)"),
                #div(attributes: [.id(context.desc_id)],
                    #p("\(context.string)")
                ),
                #h2("\(context.user.details_heading)"),
                #h3("\(context.user.qualities_heading)"),
                #ul(attributes: [.id(context.user.qualities_id)], "\(qualities)")
            )
        )
    }
}