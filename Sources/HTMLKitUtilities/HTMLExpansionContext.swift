//
//  HTMLExpansionContext.swift
//
//
//  Created by Evan Anderson on 1/31/25.
//

import SwiftSyntax
import SwiftSyntaxMacros

/// Data required to process an HTML expansion.
public struct HTMLExpansionContext {
    public let context:MacroExpansionContext
    
    /// `HTMLEncoding` of this expansion.
    public var encoding:HTMLEncoding

    /// Associated attribute key responsible for the arguments.
    public var key:String
    public var arguments:LabeledExprListSyntax

    /// Complete file paths used for looking up interpolation (when trying to promote to an equivalent `StaticString`).
    public var lookupFiles:Set<String>

    public init(
        context: MacroExpansionContext,
        encoding: HTMLEncoding,
        key: String,
        arguments: LabeledExprListSyntax,
        lookupFiles: Set<String> = []
    ) {
        self.context = context
        self.encoding = encoding
        self.key = key
        self.arguments = arguments
        self.lookupFiles = lookupFiles
    }

    /// First expression in the arguments.
    public var expression : ExprSyntax? {
        arguments.first?.expression
    }

    /// Whether the encoding is unchecked.
    public var isUnchecked : Bool {
        encoding.isUnchecked
    }
}