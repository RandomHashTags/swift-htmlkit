//
//  HTMLGlobalAttributes.swift
//
//
//  Created by Evan Anderson on 2/3/25.
//

#if canImport(CSS)
import CSS
#endif

#if canImport(HTMLKitUtilities)
import HTMLKitUtilities
#endif

#if canImport(HTMX)
import HTMX
#endif

#if canImport(SwiftSyntax)
import SwiftSyntax
#endif

// MARK: HTMLGlobalAttributes
// TODO: finish
struct HTMLGlobalAttributes : CustomStringConvertible {
    public var accesskey:String?
    public var ariaattribute:HTMLAttribute.Extra.ariaattribute?
    public var role:HTMLAttribute.Extra.ariarole?

    public var id:String?

    public init() {
    }

    @inlinable
    public var description : String {
        ""
    }
}