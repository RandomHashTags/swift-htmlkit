//
//  HTMLExpansionContext.swift
//
//
//  Created by Evan Anderson on 1/31/25.
//

#if canImport(SwiftSyntax) && canImport(SwiftSyntaxMacros)
import SwiftSyntax
import SwiftSyntaxMacros
#endif

/// Data required to process an HTML expansion.
public struct HTMLExpansionContext : @unchecked Sendable {
    #if canImport(SwiftSyntax) && canImport(SwiftSyntaxMacros)
    public let context:MacroExpansionContext
    public let expansion:MacroExpansionExprSyntax
    public var arguments:LabeledExprListSyntax
    #endif
    
    /// `HTMLEncoding` of this expansion.
    public var encoding:HTMLEncoding

    /// Associated attribute key responsible for the arguments.
    public var key:String

    /// Complete file paths used for looking up interpolation (when trying to promote to an equivalent `StaticString`).
    public var lookupFiles:Set<String>

    public package(set) var ignoresCompilerWarnings:Bool

    public package(set) var escape:Bool
    public package(set) var escapeAttributes:Bool
    public package(set) var elementsRequireEscaping:Bool

    public init(
        context: MacroExpansionContext,
        expansion: MacroExpansionExprSyntax,
        ignoresCompilerWarnings: Bool,
        encoding: HTMLEncoding,
        key: String,
        arguments: LabeledExprListSyntax,
        lookupFiles: Set<String> = [],
        escape: Bool = true,
        escapeAttributes: Bool = true,
        elementsRequireEscaping: Bool = true
    ) {
        self.context = context
        self.expansion = expansion
        self.ignoresCompilerWarnings = ignoresCompilerWarnings
        self.encoding = encoding
        self.key = key
        self.arguments = arguments
        self.lookupFiles = lookupFiles
        self.escape = escape
        self.escapeAttributes = escapeAttributes
        self.elementsRequireEscaping = elementsRequireEscaping
    }

    #if canImport(SwiftSyntax)
    /// First expression in the arguments.
    public var expression : ExprSyntax? {
        arguments.first?.expression
    }
    #endif
}