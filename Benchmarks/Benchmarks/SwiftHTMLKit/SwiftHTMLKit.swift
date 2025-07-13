
import Utilities
import SwiftHTMLKit
import NIOCore

package struct SwiftHTMLKitTests : HTMLGenerator {
    package init() {}

    package func staticHTML() -> String {
        #html(
            html(
                head(
                    title("StaticView")
                ),
                body(
                    h1("Swift HTML Benchmarks")
                )
            )
        )
    }

    package func staticHTMLUTF8Bytes() -> [UInt8] {
        #html(encoding: .utf8Bytes,
            html(
                head(
                    title("StaticView")
                ),
                body(
                    h1("Swift HTML Benchmarks")
                )
            )
        )
    }

    package func staticHTMLUTF16Bytes() -> [UInt16] {
        #html(encoding: .utf16Bytes,
            html(
                head(
                    title("StaticView")
                ),
                body(
                    h1("Swift HTML Benchmarks")
                )
            )
        )
    }

    package func staticHTMLByteBuffer() -> ByteBuffer {
        #html(encoding: .byteBuffer,
            html(
                head(
                    title("StaticView")
                ),
                body(
                    h1("Swift HTML Benchmarks")
                )
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
            qualities += #html(li(quality))
        }
        return #html {
            html {
                head {
                    meta(charset: context.charset)
                    title(context.title)
                    meta(content: context.meta_description, name: "description")
                    meta(content: context.keywords_string, name: "keywords")
                }
                body {
                    h1(context.heading)
                    div(attributes: [.id(context.desc_id)]) {
                        p(context.string)
                    }
                    h2(context.user.details_heading)
                    h3(context.user.qualities_heading)
                    ul(attributes: [.id(context.user.qualities_id)], qualities)
                }
            }
        }
    }
}