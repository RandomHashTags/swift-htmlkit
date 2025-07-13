
import Utilities
import Elementary

package struct ElementaryTests: HTMLGenerator {
    package init() {}
    
    package func staticHTML() -> String {
        StaticView().render()
    }

    package func dynamicHTML(_ context: HTMLContext) -> String {
        DynamicView(context: context).render()
    }
}

struct StaticView: HTML {
    var content: some HTML {
        HTMLRaw("<!DOCTYPE html>")
        html {
            head {
                title { "StaticView" }
            }
            body {
                h1 { "Swift HTML Benchmarks" }
            }
        }
    }
}

struct DynamicView: HTML { 
    let context:HTMLContext
    
    var content: some HTML {
        HTMLRaw("<!DOCTYPE html>")
        html {
            head {
                meta(.custom(name: "charset", value: context.charset))
                title { context.title }
                meta(.content(context.meta_description), .name("description"))
                meta(.content(context.keywords_string), .name("keywords"))
            }
            body {
                h1 { context.heading }
                div(.id(context.desc_id)) {
                    p { context.string }
                }
                h2 { context.user.details_heading }
                h3 { context.user.qualities_heading }
                ul(.id(context.user.qualities_id)) {
                    for quality in context.user.qualities {
                        li { quality }
                    }
                }
            }
        }
    }
}