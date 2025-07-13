
import Utilities
import Swim
import HTML

package struct SwimTests: HTMLGenerator {
    package init() {}

    package func staticHTML() -> String {
        var string = ""
        html {
            head {
                title { "StaticView" }
            }
            body {
                h1 {
                    "Swift HTML Benchmarks"
                }
            }
        }.write(to: &string)
        return string
    }

    package func dynamicHTML(_ context: HTMLContext) -> String {
        var string = ""
        var test = [Node]()
        test.reserveCapacity(context.user.qualities.count)
        for quality in context.user.qualities {
            test.append(li { quality } )
        }
        html {
            head {
                meta(charset: context.charset)
                title { context.title }
                meta(customAttributes: ["content":context.meta_description, "name":"description"])
                meta(customAttributes: ["content":context.keywords_string, "name":"keywords"])
            }
            body {
                h1 { context.heading }
                div(id: context.desc_id) {
                    p { context.string }
                }
                h2 { context.user.details_heading }
                h3 { context.user.qualities_heading }
                ul(id: context.user.qualities_id) { test }
            }
        }.write(to: &string)
        return string
    }
}