
import Utilities
import Vaux
import Foundation

// MARK: Custom rendering
extension HTML {
    @inlinable
    func render(includeTag: Bool) -> (HTMLType, String) {
        if let node = self as? HTMLNode {
            return (.node, node.rendered(includeTag: includeTag))
        } else if let node = self as? MultiNode {
            var string:String = ""
            for child in node.children {
                string += child.render(includeTag: true).1
            }
            return (.node, string)
        } else if let node = self as? AttributedNode {
            return (.node, node.render)
        } else {
            return (.node, String(describing: self))
        }
    }
    @inlinable
    func isVoid(_ tag: String) -> Bool {
        switch tag {
        case "area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "source", "track", "wbr": return true
        default: return false
        }
    }
}

public enum HTMLType {
    case node, attribute
}

extension AttributedNode {
    @inlinable
    var render: String {
        let tag = child.getTag()!
        let attribute_string = " " + attribute.key + (attribute.value != nil ? "=\"" + attribute.value! + "\"" : "")
        return "<" + tag + attribute_string + ">" + child.render(includeTag: false).1 + (isVoid(tag) ? "" : "</" + tag + ">")
    }
}

extension HTMLNode {
    @inlinable
    func rendered(includeTag: Bool) -> String {
        guard let tag = getTag() else { return String(describing: self) }
        var attributes = ""
        var children = ""
        if let child = self.child {
            let (type, value) = child.render(includeTag: true)
            switch type {
            case .attribute:
                attributes += " " + value
            case .node:
                children += value
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