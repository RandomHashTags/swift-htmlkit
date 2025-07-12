
import HTMLAttributes
import HTMLElements
import HTMLKitUtilities
import SwiftDiagnostics
import SwiftSyntax

#if canImport(SwiftLexicalLookup)
import SwiftLexicalLookup
#endif

extension HTMLKitUtilities {
    // MARK: Escape HTML
    public static func escapeHTML(context: inout HTMLExpansionContext) -> String {
        context.escape = true
        context.escapeAttributes = true
        context.elementsRequireEscaping = true
        return html(context: context)
    }

    // MARK: Raw HTML
    public static func rawHTML(context: inout HTMLExpansionContext) -> String {
        context.escape = false
        context.escapeAttributes = false
        context.elementsRequireEscaping = false
        return html(context: context)
    }

    // MARK: HTML
    /// - Parameters:
    ///   - context: `HTMLExpansionContext`.
    ///   - escape: Whether or not the escape source-breaking HTML characters.
    ///   - escapeAttributes: Whether or not the escape source-breaking HTML attribute characters.
    ///   - elementsRequireEscaping: Whether or not HTMLKit HTML elements in the inner html should be escaped.
    public static func html(
        context: HTMLExpansionContext
    ) -> String {
        var context = context
        let children = context.arguments.children(viewMode: .all)
        var innerHTML = ""
        innerHTML.reserveCapacity(children.count)
        for e in children {
            if let child = e.labeled {
                if let key = child.label?.text {
                    switch key {
                    case "encoding": context.encoding = parseEncoding(expression: child.expression) ?? .string
                    case "representation": context.representation = parseRepresentation(expr: child.expression) ?? .literalOptimized
                    case "minify":   context.minify = child.expression.boolean(context) ?? false
                    default: break
                    }
                } else if var c = HTMLKitUtilities.parseInnerHTML(context: context, child: child) {
                    if var element = c as? HTMLElement {
                        element.escaped = context.elementsRequireEscaping
                        c = element
                    }
                    innerHTML += String(describing: c)
                }
            }
        }
        if context.minify {
            innerHTML = minify(html: innerHTML)
        }
        innerHTML.replace(HTMLKitUtilities.lineFeedPlaceholder, with: "\\n")
        return innerHTML
    }
    
    // MARK: Expand #html
    public static func expandHTMLMacro(context: HTMLExpansionContext) throws -> ExprSyntax {
        var context = context
        return try expandHTMLMacro(context: &context)
    }
    public static func expandHTMLMacro(context: inout HTMLExpansionContext) throws -> ExprSyntax {
        let (string, encoding) = expandMacro(context: &context)
        let encodingResult = encodingResult(context: context, node: context.expansion, string: string, for: encoding)
        let expandedResult = representationResult(encoding: encoding, encodedResult: encodingResult, representation: context.representation)
        return "\(raw: expandedResult)"
    }

    // MARK: Parse Arguments
    public static func parseArguments(
        context: HTMLExpansionContext,
        otherAttributes: [String:String] = [:]
    ) -> ElementData {
        var context = context
        return parseArguments(context: &context)
    }
    public static func parseArguments(
        context: inout HTMLExpansionContext,
        otherAttributes: [String:String] = [:]
    ) -> ElementData {
        var globalAttributes = [HTMLAttribute]()
        var attributes = [String:Sendable]()
        var innerHTML = [CustomStringConvertible & Sendable]()
        var trailingSlash = false
        for element in context.arguments.children(viewMode: .all) {
            if let child = element.labeled {
                context.key = ""
                if let key = child.label?.text {
                    context.key = key
                    switch key {
                    case "encoding":
                        context.encoding = parseEncoding(expression: child.expression) ?? .string
                    case "representation":
                        context.representation = parseRepresentation(expr: child.expression) ?? .literalOptimized
                    case "lookupFiles":
                        context.lookupFiles = Set(child.expression.array!.elements.compactMap({ $0.expression.stringLiteral?.string(encoding: context.encoding) }))
                    case "attributes":
                        (globalAttributes, trailingSlash) = parseGlobalAttributes(context: context, array: child.expression.array!.elements)
                    default:
                        context.key = otherAttributes[key] ?? key
                        if let test = HTMLAttribute.Extra.parse(context: context, expr: child.expression) {
                            attributes[key] = test
                        } else if let literal = parseLiteralValue(context: context, expression: child.expression) {
                            switch literal {
                            case .boolean(let b): attributes[key] = b
                            case .string, .interpolation: attributes[key] = literal.value(key: key, escape: context.escape, escapeAttributes: context.escapeAttributes)
                            case .int(let i): attributes[key] = i
                            case .float(let f): attributes[key] = f
                            case .array:
                                switch literal.escapeArray() {
                                case .array(let a): attributes[key] = a
                                default: break
                                }
                            }
                        }
                    }
                // inner html
                } else if let inner_html = parseInnerHTML(context: context, child: child) {
                    innerHTML.append(inner_html)
                }
            }
        }
        if let statements = context.trailingClosure?.statements {
            var c = context
            c.trailingClosure = nil
            for statement in statements {
                switch statement.item {
                case .expr(let expr):
                    if let inner_html = parseInnerHTML(context: c, expr: expr) {
                        innerHTML.append(inner_html)
                    }
                default:
                    break
                }
            }
        }
        return ElementData(context.encoding, globalAttributes, attributes, innerHTML, trailingSlash)
    }

    // MARK: Parse Encoding
    public static func parseEncoding(expression: ExprSyntax) -> HTMLEncoding? {
        switch expression.kind {
        case .memberAccessExpr:
            return HTMLEncoding(rawValue: expression.memberAccess!.declName.baseName.text)
        case .functionCallExpr:
            let function = expression.functionCall!
            switch function.calledExpression.memberAccess?.declName.baseName.text {
            case "custom":
                guard let logic = function.arguments.first?.expression.stringLiteral?.string(encoding: .string) else { return nil }
                if function.arguments.count == 1 {
                    return .custom(logic)
                } else if let delimiter = function.arguments.last!.expression.stringLiteral?.string(encoding: .string) {
                    return .custom(logic, stringDelimiter: delimiter)
                } else {
                    return nil
                }
            default:
                return nil
            }
        default:
            return nil
        }
    }

    // MARK: Parse Representation
    public static func parseRepresentation(expr: ExprSyntax) -> HTMLResultRepresentation? {
        switch expr.kind {
        case .memberAccessExpr:
            switch expr.memberAccess!.declName.baseName.text {
            case "literal": return .literal
            case "literalOptimized": return .literalOptimized
            case "chunked": return .chunked()
            #if compiler(>=6.2)
            case "chunkedInline": return .chunkedInline()
            #endif
            case "streamed": return .streamed()
            case "streamedAsync": return .streamedAsync()
            default: return nil
            }
        case .functionCallExpr:
            let function = expr.functionCall!
            var optimized = true
            var chunkSize = 1024
            var suspendDuration:Duration? = nil
            for arg in function.arguments {
                switch arg.label?.text {
                case "optimized":
                    optimized = arg.expression.booleanLiteral?.literal.text == "true"
                case "chunkSize":
                    if let s = arg.expression.integerLiteral?.literal.text, let size = Int(s) {
                        chunkSize = size
                    }
                case "suspendDuration":
                    // TODO: support
                    if let member = arg.expression.memberAccess?.declName.baseName.text {
                        switch member {
                        case "milliseconds":
                            break
                        case "microseconds":
                            break
                        case "nanoseconds":
                            break
                        case "seconds":
                            break
                        default:
                            break
                        }
                    }
                default:
                    break
                }
            }
            switch function.calledExpression.memberAccess?.declName.baseName.text {
            case "chunked":
                return .chunked(optimized: optimized, chunkSize: chunkSize)
            #if compiler(>=6.2)
            case "chunkedInline":
                return .chunkedInline(optimized: optimized, chunkSize: chunkSize)
            #endif
            case "streamed":
                return .streamed(optimized: optimized, chunkSize: chunkSize)
            case "streamedAsync":
                return .streamedAsync(optimized: optimized, chunkSize: chunkSize, suspendDuration: suspendDuration)
            default:
                return nil
            }
        default:
            return nil
        }
    }

    // MARK: Parse Global Attributes
    public static func parseGlobalAttributes(
        context: HTMLExpansionContext,
        array: ArrayElementListSyntax
    ) -> (attributes: [HTMLAttribute], trailingSlash: Bool) {
        var keys = Set<String>()
        var attributes = [HTMLAttribute]()
        var trailingSlash = false
        for element in array {
            if let function = element.expression.functionCall {
                if let firstExpression = function.arguments.first?.expression, var key = function.calledExpression.memberAccess?.declName.baseName.text {
                    var c = context
                    c.key = key
                    c.arguments = function.arguments
                    if key.contains(" ") {
                        context.context.diagnose(Diagnostic(node: firstExpression, message: DiagnosticMsg(id: "spacesNotAllowedInAttributeDeclaration", message: "Spaces are not allowed in attribute declaration.")))
                    } else if keys.contains(key) {
                        globalAttributeAlreadyDefined(context: context, attribute: key, node: firstExpression)
                    } else if let attr = HTMLAttribute.init(context: c) {
                        attributes.append(attr)
                        key = attr.key
                        keys.insert(key)
                    }
                }
            } else if let member = element.expression.memberAccess?.declName.baseName.text, member == "trailingSlash" {
                if keys.contains(member) {
                    globalAttributeAlreadyDefined(context: context, attribute: member, node: element.expression)
                } else {
                    trailingSlash = true
                    keys.insert(member)
                }
            }
        }
        return (attributes, trailingSlash)
    }

    // MARK: Parse Inner HTML
    public static func parseInnerHTML(
        context: HTMLExpansionContext,
        child: LabeledExprSyntax
    ) -> (CustomStringConvertible & Sendable)? {
        return parseInnerHTML(context: context, expr: child.expression)
    }
    public static func parseInnerHTML(
        context: HTMLExpansionContext,
        expr: ExprSyntax
    ) -> (CustomStringConvertible & Sendable)? {
        if let expansion = expr.macroExpansion {
            var c = context
            c.expansion = expansion
            c.trailingClosure = expansion.trailingClosure
            c.arguments = expansion.arguments
            switch expansion.macroName.text {
            case "html", "anyHTML", "uncheckedHTML":
                c.ignoresCompilerWarnings = expansion.macroName.text == "uncheckedHTML"
                return html(context: c)
            case "escapeHTML":
                return escapeHTML(context: &c)
            case "rawHTML", "anyRawHTML":
                return rawHTML(context: &c)
            default:
                return "" // TODO: fix?
            }
        } else if let element = parse_element(context: context, expr: expr) {
            return element
        } else if let string = parseLiteralValue(context: context, expression: expr)?.value(key: "", escape: context.escape, escapeAttributes: context.escapeAttributes) {
            return string
        } else {
            unallowedExpression(context: context, node: expr)
            return nil
        }
    }

    // MARK: Parse element
    public static func parse_element(context: HTMLExpansionContext, expr: ExprSyntax) -> HTMLElement? {
        guard let function = expr.functionCall else { return nil }
        return HTMLElementValueType.parseElement(context: context, function)
    }
}

// MARK: Encoding result
extension HTMLKitUtilities {
    static func encodingResult(
        context: HTMLExpansionContext,
        node: MacroExpansionExprSyntax,
        string: String,
        for encoding: HTMLEncoding
    ) -> String {
        switch encoding {
        case .utf8Bytes:
            guard hasNoInterpolation(context, node, string) else { return "" }
            return bytes([UInt8](string.utf8))
        case .utf16Bytes:
            guard hasNoInterpolation(context, node, string) else { return "" }
            return bytes([UInt16](string.utf16))
        case .utf8CString:
            guard hasNoInterpolation(context, node, string) else { return "" }
            return "\(string.utf8CString)"

        case .foundationData:
            guard hasNoInterpolation(context, node, string) else { return "" }
            return "Data(\(bytes([UInt8](string.utf8))))"

        case .byteBuffer:
            guard hasNoInterpolation(context, node, string) else { return "" }
            return "ByteBuffer(bytes: \(bytes([UInt8](string.utf8))))"

        case .string:
            return "\"\(string)\""
        case .custom(let encoded, _):
            return encoded.replacingOccurrences(of: "$0", with: string)
        }
    }
    private static func bytes<T: FixedWidthInteger>(_ bytes: [T]) -> String {
        var string = "["
        for b in bytes {
            string += "\(b),"
        }
        string.removeLast()
        return string.isEmpty ? "[]" : string + "]"
    }
    private static func hasNoInterpolation(_ context: HTMLExpansionContext, _ node: MacroExpansionExprSyntax, _ string: String) -> Bool {
        guard string.firstRange(of: try! Regex("\\((.*)\\)")) == nil else {
            if !context.ignoresCompilerWarnings {
                context.context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "interpolationNotAllowedForDataType", message: "String Interpolation is not allowed for this data type. Runtime values get converted to raw text, which is not the intended result.")))
            }
            return false
        }
        return true
    }
}

// MARK: Representation results
extension HTMLKitUtilities {
    static func representationResult(
        encoding: HTMLEncoding,
        encodedResult: String,
        representation: HTMLResultRepresentation
    ) -> String {
        switch representation {
        case .literal:
            break
        case .literalOptimized:
            if encoding == .string {
                // TODO: implement
            } else {
                // TODO: show compiler diagnostic
            }
        case .streamed(let optimized, let chunkSize):
            return streamedRepresentation(encoding: encoding, encodedResult: encodedResult, async: false, optimized: optimized, chunkSize: chunkSize, suspendDuration: nil)
        case .streamedAsync(let optimized, let chunkSize, let suspendDuration):
            return streamedRepresentation(encoding: encoding, encodedResult: encodedResult, async: true, optimized: optimized, chunkSize: chunkSize, suspendDuration: suspendDuration)
        default:
            break
        }
        return encodedResult
    }
    static func streamedRepresentation(
        encoding: HTMLEncoding,
        encodedResult: String,
        async: Bool,
        optimized: Bool,
        chunkSize: Int,
        suspendDuration: Duration?
    ) -> String {
        let typeAnnotation:String
        if optimized {
            typeAnnotation = encoding.typeAnnotation // TODO: implement
        } else {
            typeAnnotation = encoding.typeAnnotation
        }
        var string = "AsyncStream<\(typeAnnotation)> { continuation in\n"
        if async {
            string += "Task {\n"
        }

        let delimiter:(Character) -> String? = encoding == .string ? { $0 != "\"" ? "\"" : nil } : { _ in nil }
        let count = encodedResult.count
        var i = 0
        while i < count {
            var endingIndex = i + chunkSize
            if i == 0 && encoding == .string {
                endingIndex += 1
            }
            let endIndex = encodedResult.index(encodedResult.startIndex, offsetBy: endingIndex, limitedBy: encodedResult.endIndex) ?? encodedResult.endIndex
            let slice = encodedResult[encodedResult.index(encodedResult.startIndex, offsetBy: i)..<endIndex]
            i += chunkSize + (i == 0 && encoding == .string ? 1 : 0)
            if slice.isEmpty || encoding == .string && slice.count == 1 && slice.first == "\"" {
                continue
            }
            string += "continuation.yield("
            if let f = slice.first, let d = delimiter(f) {
                string += d
            }
            string += slice
            if let l = slice.last, let d = delimiter(l) {
                string += d
            }
            string += ")\n"
            if let suspendDuration {
                string += "try await Task.sleep(for: \(suspendDuration))\n"
            }
        }
        string += "continuation.finish()\n}"
        if async {
            string += "\n}"
        }
        return string
    }
}

extension HTMLKitUtilities {
    // MARK: GA Already Defined
    static func globalAttributeAlreadyDefined(context: HTMLExpansionContext, attribute: String, node: some SyntaxProtocol) {
        context.context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "globalAttributeAlreadyDefined", message: "Global attribute \"" + attribute + "\" is already defined.")))
    }

    // MARK: Unallowed Expression
    static func unallowedExpression(context: HTMLExpansionContext, node: ExprSyntax) {
        context.context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unallowedExpression", message: "String Interpolation is required when encoding runtime values."), fixIts: [
            FixIt(message: DiagnosticMsg(id: "useStringInterpolation", message: "Use String Interpolation."), changes: [
                FixIt.Change.replace(
                    oldNode: Syntax(node),
                    newNode: Syntax(StringLiteralExprSyntax(content: "\\(\(node))"))
                )
            ])
        ]))
    }

    // MARK: Warn Interpolation
    static func warnInterpolation(
        context: HTMLExpansionContext,
        node: some SyntaxProtocol
    ) {
        /*#if canImport(SwiftLexicalLookup)
        for t in node.tokens(viewMode: .fixedUp) {
            let results = node.lookup(t.identifier)
            for result in results {
                switch result {
                case .lookForMembers(let test):
                    print("lookForMembers=" + test.debugDescription)
                case .lookForImplicitClosureParameters(let test):
                    print("lookForImplicitClosureParameters=" + test.debugDescription)
                default:
                    print(result.debugDescription)
                }
            }
        }
        #endif*/
        /*if let fix:String = InterpolationLookup.find(context: context, node) {
            let expression:String = "\(node)"
            let ranges:[Range<String.Index>] = string.ranges(of: expression)
            string.replace(expression, with: fix)
            remaining_interpolation -= ranges.count
        } else {*/
            guard !context.ignoresCompilerWarnings else { return }
            context.context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unsafeInterpolation", message: "Interpolation may introduce raw HTML.", severity: .warning)))
        //}
    }

    // MARK: Expand Macro
    static func expandMacro(context: inout HTMLExpansionContext) -> (String, HTMLEncoding) {
        let data = HTMLKitUtilities.parseArguments(context: &context)
        var string = ""
        for v in data.innerHTML {
            string += String(describing: v)
        }
        string.replace(HTMLKitUtilities.lineFeedPlaceholder, with: "\\n")
        return (string, data.encoding)
    }
}

// MARK: Misc
extension ExprSyntax {
    package func string(_ context: HTMLExpansionContext) -> String? {
        return HTMLKitUtilities.parseLiteralValue(context: context, expression: self)?.value(key: context.key)
    }
    package func boolean(_ context: HTMLExpansionContext) -> Bool? {
        booleanLiteral?.literal.text == "true"
    }
    package func enumeration<T: HTMLParsable>(_ context: HTMLExpansionContext) -> T? {
        if let functionCall, let member = functionCall.calledExpression.memberAccess {
            var c = context
            c.key = member.declName.baseName.text
            c.arguments = functionCall.arguments
            return T(context: c)
        }
        if let memberAccess {
            var c = context
            c.key = memberAccess.declName.baseName.text
            return T(context: c)
        }
        return nil
    }
    package func int(_ context: HTMLExpansionContext) -> Int? {
        guard let s = HTMLKitUtilities.parseLiteralValue(context: context, expression: self)?.value(key: context.key) else { return nil }
        return Int(s)
    }
    package func arrayString(_ context: HTMLExpansionContext) -> [String]? {
        array?.elements.compactMap({ $0.expression.string(context) })
    }
    package func arrayEnumeration<T: HTMLParsable>(_ context: HTMLExpansionContext) -> [T]? {
        array?.elements.compactMap({ $0.expression.enumeration(context) })
    }
    package func dictionaryStringString(_ context: HTMLExpansionContext) -> [String:String] {
        var d:[String:String] = [:]
        if let elements = dictionary?.content.as(DictionaryElementListSyntax.self) {
            for element in elements {
                if let key = element.key.string(context), let value = element.value.string(context) {
                    d[key] = value
                }
            }
        }
        return d
    }
    package func float(_ context: HTMLExpansionContext) -> Float? {
        guard let s = HTMLKitUtilities.parseLiteralValue(context: context, expression: self)?.value(key: context.key) else { return nil }
        return Float(s)
    }
}

// MARK: DiagnosticMsg
package struct DiagnosticMsg: DiagnosticMessage, FixItMessage {
    package let message:String
    package let diagnosticID:MessageID
    package let severity:DiagnosticSeverity
    package var fixItID: MessageID { diagnosticID }

    package init(id: String, message: String, severity: DiagnosticSeverity = .error) {
        self.message = message
        self.diagnosticID = MessageID(domain: "HTMLKitMacros", id: id)
        self.severity = severity
    }
}

// MARK: HTMLExpansionContext
extension HTMLExpansionContext {
    func string() -> String? { expression?.string(self) }
    func boolean() -> Bool?  { expression?.boolean(self) }
    func enumeration<T: HTMLParsable>() -> T? { expression?.enumeration(self) }
    func int() -> Int? { expression?.int(self) }
    func float() -> Float? { expression?.float(self) }
    func arrayString() -> [String]? { expression?.arrayString(self) }
    func arrayEnumeration<T: HTMLParsable>() -> [T]? { expression?.arrayEnumeration(self) }
}