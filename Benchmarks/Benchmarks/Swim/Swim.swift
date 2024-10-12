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
            var attributes_string:String = ""
            for (key, value) in attributes {
                attributes_string += " " + key + "=\"" + value + "\""
            }
            return (name == "html" ? "<!DOCTYPE html>" : "") + "<" + name + attributes_string + ">" + (child?.rendered ?? "") + (isVoid(name) ? "" : "</" + name + ">")
        case .text(let string): return string
        case .raw(let string): return string
        case .comment(_): return ""
        case .documentType(let string): return string
        case .fragment(let children):
            var string:String = ""
            for child in children {
                string += child.rendered
            }
            return string
        case .trim: return ""
        }
    }
    func isVoid(_ tag: String) -> Bool {
        switch tag {
        case "area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "source", "track", "wbr": return true
        default: return false
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
        var test:[Node] = []
        for quality in context.user.qualities {
            test.append(li { quality } )
        }
        return html {
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
        }.rendered
    }
}