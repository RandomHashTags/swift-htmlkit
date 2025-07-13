

import Utilities
import DOM

package struct SwiftDOMTests: HTMLGenerator {
    package init() {}

    package func staticHTML() -> String {
        let document:HTML = .document {
            $0[.html] {
                $0[.head] { $0[.title] = "StaticView" }
                $0[.body] { $0[.h1] = "Swift HTML Benchmarks" }
            }
        }
        return "\(document)"
    }
    package func dynamicHTML(_ context: HTMLContext) -> String {
        let qualities:(inout HTML.ContentEncoder) throws -> () = {
            for quality in context.user.qualities {
                $0[.li] = quality
            }
        }
        let document:HTML = .document {
            $0[.html] {
                $0[.head] {
                    $0[.meta] { $0[name: .charset] = context.charset }
                    $0[.title] = context.title
                    $0[.meta] {
                        $0[name: .content] = context.meta_description
                        $0[name: .name] = "description"
                    }
                    $0[.meta] {
                        $0[name: .content] = context.keywords_string
                        $0[name: .name] = "keywords"
                    }
                }
                $0[.body] {
                    $0[.h1] = context.heading
                    $0[.div] {
                        $0.id = context.desc_id
                    } content: {
                        $0[.p] = context.string
                    }
                    $0[.h2] = context.user.details_heading
                    $0[.h3] = context.user.qualities_heading
                    $0[.ul] {
                        $0.id = context.user.qualities_id
                    } content: {
                        try! qualities(&$0)
                    }
                }
            }
        }
        return "\(document)"
    }
}

// required to compile
extension String: HTML.OutputStreamable {}
extension String: SVG.OutputStreamable {}