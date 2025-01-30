//
//  HTMLElement.swift
//
//
//  Created by Evan Anderson on 11/16/24.
//

/// An HTML element.
public protocol HTMLElement : CustomStringConvertible, Sendable {
    /// Whether or not this element is a void element.
    var isVoid : Bool { get }

    /// Whether or not this element should include a forward slash in the tag name.
    var trailingSlash : Bool { get }

    /// Whether or not to HTML escape the `<` and `>` characters directly adjacent of the opening and closing tag names when rendering.
    var escaped : Bool { get set }

    /// This element's tag name.
    var tag : String { get }

    /// The global attributes of this element.
    var attributes : [HTMLElementAttribute] { get }

    /// The inner HTML content of this element.
    var innerHTML : [CustomStringConvertible & Sendable] { get }
}