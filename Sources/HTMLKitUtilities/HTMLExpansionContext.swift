
#if canImport(SwiftSyntax) && canImport(SwiftSyntaxMacros)
import SwiftSyntax
import SwiftSyntaxMacros
#endif

/// Data required to process an HTML expansion.
public struct HTMLExpansionContext: @unchecked Sendable {
    #if canImport(SwiftSyntax) && canImport(SwiftSyntaxMacros)
    public let context:MacroExpansionContext
    public var expansion:MacroExpansionExprSyntax
    public var trailingClosure:ClosureExprSyntax?
    public var arguments:LabeledExprListSyntax
    #endif
    
    /// `HTMLEncoding` of this expansion.
    public var encoding:HTMLEncoding

    /// `HTMLResultRepresentation` of this expansion.
    public var representation:HTMLResultRepresentation

    /// Associated attribute key responsible for the arguments.
    public var key:String

    /// Complete file paths used for looking up interpolation (when trying to promote to an equivalent `StaticString`).
    public var lookupFiles:Set<String>

    public var minify:Bool

    public var ignoresCompilerWarnings:Bool

    public var escape:Bool
    public var escapeAttributes:Bool
    public var elementsRequireEscaping:Bool

    public init(
        context: MacroExpansionContext,
        expansion: FreestandingMacroExpansionSyntax,
        ignoresCompilerWarnings: Bool,
        encoding: HTMLEncoding,
        representation: HTMLResultRepresentation,
        key: String,
        arguments: LabeledExprListSyntax,
        lookupFiles: Set<String> = [],
        minify: Bool = false,
        escape: Bool = true,
        escapeAttributes: Bool = true,
        elementsRequireEscaping: Bool = true
    ) {
        self.context = context
        self.expansion = expansion.as(ExprSyntax.self)!.macroExpansion!
        trailingClosure = expansion.trailingClosure
        self.ignoresCompilerWarnings = ignoresCompilerWarnings
        self.encoding = encoding
        self.representation = representation
        self.key = key
        self.arguments = arguments
        self.lookupFiles = lookupFiles
        self.minify = minify
        self.escape = escape
        self.escapeAttributes = escapeAttributes
        self.elementsRequireEscaping = elementsRequireEscaping
    }

    #if canImport(SwiftSyntax)
    /// First expression in the arguments.
    public var expression: ExprSyntax? {
        arguments.first?.expression
    }
    #endif
}