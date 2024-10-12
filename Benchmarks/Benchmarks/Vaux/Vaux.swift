//
//  Vaux.swift
//
//
//  Created by Evan Anderson on 10/6/24.
//

import Utilities
import Vaux
import Foundation

// MARK: Custom rendering
extension HTML {
    func render(includeTag: Bool) -> (HTMLType, String) {
        if let node:HTMLNode = self as? HTMLNode {
            return (.node, node.rendered(includeTag: includeTag))
        } else if let node:MultiNode = self as? MultiNode {
            var string:String = ""
            for child in node.children {
                string += child.render(includeTag: true).1
            }
            return (.node, string)
        } else if let node:AttributedNode = self as? AttributedNode {
            return (.node, node.render)
        } else {
            return (.node, String(describing: self))
        }
    }
    func isVoid(_ tag: String) -> Bool {
        switch tag {
        case "area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "source", "track", "wbr": return true
        default: return false
        }
    }
}

enum HTMLType {
    case node, attribute
}

extension AttributedNode {
    var render : String {
        let tag:String = child.getTag()!
        let attribute_string:String = " " + attribute.key + (attribute.value != nil ? "=\"" + attribute.value! + "\"" : "")
        return "<" + tag + attribute_string + ">" + child.render(includeTag: false).1 + (isVoid(tag) ? "" : "</" + tag + ">")
    }
}

extension HTMLNode {
    func rendered(includeTag: Bool) -> String {
        guard let tag:String = getTag() else { return String(describing: self) }
        var attributes:String = "", children:String = ""
        if let child = self.child {
            let (type, value):(HTMLType, String) = child.render(includeTag: true)
            switch type {
                case .attribute:
                    attributes += " " + value
                    break
                case .node:
                    children += value
                    break
            }
        }
        return (tag == "html" ? "<!DOCTYPE html>" : "") + (includeTag ? "<" + tag + attributes + ">" : "") + children + (!isVoid(tag) && includeTag ? "</" + tag + ">" : "")
    }
}

// MARK: VauxTests
package struct VauxTests : HTMLGenerator {
    package init() {}

    package func staticHTML() -> String {
        html {
            head {
                title("StaticView")
            }
            body {
                heading(.h1) {
                    "Swift HTML Benchmarks"
                }
            }
        }.render(includeTag: true).1
    }

    package func dynamicHTML(_ context: HTMLContext) -> String {
        html {
            head {
                meta().attr("charset", context.charset)
                title(context.title)
                meta().attr("content", context.meta_description).attr("name", "description")
                meta().attr("content", context.keywords_string).attr("name", "keywords")
            }
            body {
                heading(.h1) { context.heading }
                div {
                    paragraph { context.string }
                }.id(context.desc_id)
                heading(.h2) { context.user.details_heading }
                heading(.h3) { context.user.qualities_heading }
                list {
                    forEach(context.user.qualities) {
                        listItem(label: $0)
                    }
                }.id(context.user.qualities_id)
            }
        }.render(includeTag: true).1
    }
}