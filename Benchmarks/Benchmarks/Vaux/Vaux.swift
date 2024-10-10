//
//  Vaux.swift
//
//
//  Created by Evan Anderson on 10/6/24.
//

import Utilities
@testable import Vaux
import Foundation

extension HTML {
    var render : String {
        if let node:HTMLNode = self as? HTMLNode {
            return node.rendered
        } else if let node:MultiNode = self as? MultiNode {
            return node.children.map({ $0.render }).joined()
        } else {
            return String(describing: self)
        }
    }
}

extension HTMLNode {
    var rendered : String {
        guard let tag:String = getTag() else { return String(describing: self) }
        var string:String
        if tag == "html" {
            string = "<!DOCTYPE html>"
        } else {
            string = ""
        }
        string += "<" + tag + ">"
        if let child = self.child {
            string += child.render
        }
        return string + "</" + tag + ">" // Vaux doesn't take into account void elements
    }
}

package struct VauxTests : HTMLGenerator {

    let vaux:Vaux
    package init() {
        vaux = Vaux()
    }

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
        }.render
    }

    package func dynamicHTML(_ context: HTMLContext) -> String {
        html {
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
        }.render
    }
}