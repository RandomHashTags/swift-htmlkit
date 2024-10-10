//
//  Swim.swift
//
//
//  Created by Evan Anderson on 10/6/24.
//

import Utilities
import Swim

extension Node {
    var rendered : String {
        switch self {
        case .element(let name, let attributes, let child):
            let attributes_string:String = attributes.isEmpty ? "" : " " + attributes.map({ $0 + "=\"" + $1 + "\"" }).joined(separator: " ")
            return (name == "html" ? "<!DOCTYPE html>" : "") + "<" + name + attributes_string + ">" + (child?.rendered ?? "") + "</" + name + ">"
        case .text(let string): return string
        case .raw(let string): return string
        case .comment(let _): return ""
        case .documentType(let string): return string
        case .fragment(let children): return children.map({ $0.rendered }).joined()
        case .trim: return ""
        }
    }
}

package struct SwimTests : HTMLGenerator {
    package init() {}

    package func staticHTML() -> String {
        html {
            head {
                title { "StaticView" }
            }
            body {
                h1 {
                    "Swift HTML Benchmarks"
                }
            }
        }.rendered
    }
    package func dynamicHTML(_ context: HTMLContext) -> String {
        html {
            body {
                h1 { context.heading }
                div(id: context.desc_id) {
                    p { context.string }
                }
                h2 { context.user.details_heading }
                h3 { context.user.qualities_heading }
                ul(id: context.user.qualities_id) {
                    context.user.qualities.map({ quality in li { quality} })
                }
            }
        }.rendered
    }
}