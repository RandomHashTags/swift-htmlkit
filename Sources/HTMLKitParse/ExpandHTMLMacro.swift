
import HTMLKitUtilities
import SwiftDiagnostics
import SwiftSyntax

extension HTMLKitUtilities {
    public static func expandHTMLMacro(context: HTMLExpansionContext) throws -> ExprSyntax {
        var context = context
        let (string, encoding) = expandMacro(context: &context)
        let encodingResult = encodingResult(context: context, node: context.expansion, string: string, for: encoding)
        let expandedResult = representationResult(encoding: encoding, encodedResult: encodingResult, representation: context.representation)
        return "\(raw: expandedResult)"
    }

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
                return optimizedLiteral(encodedResult: encodedResult)
            } else {
                // TODO: show compiler diagnostic
            }
        case .chunked(let optimized, let chunkSize):
            return "[" + chunks(encoding: encoding, encodedResult: encodedResult, async: false, optimized: optimized, chunkSize: chunkSize).joined(separator: ", ") + "]"
        #if compiler(>=6.2)
        case .chunkedInline(let optimized, let chunkSize):
            let typeAnnotation:String = "String" // TODO: fix
            let chunks = chunks(encoding: encoding, encodedResult: encodedResult, async: false, optimized: optimized, chunkSize: chunkSize).joined(separator: ", ")
            return "InlineArray<\(chunks.count), \(typeAnnotation)>([\(chunks)])"
        #endif
        case .streamed(let optimized, let chunkSize):
            return streamedRepresentation(encoding: encoding, encodedResult: encodedResult, async: false, optimized: optimized, chunkSize: chunkSize, suspendDuration: nil)
        case .streamedAsync(let optimized, let chunkSize, let suspendDuration):
            return streamedRepresentation(encoding: encoding, encodedResult: encodedResult, async: true, optimized: optimized, chunkSize: chunkSize, suspendDuration: suspendDuration)
        default:
            break
        }
        return encodedResult
    }

    static func optimizedLiteral(encodedResult: String) -> String {
        let regex = try! Regex.init("( \\+ String\\(describing: [\\.\\w\\s\\(\\)\\[\\]]+\\) \\+ )")
        var interpolation = encodedResult.matches(of: regex)
        guard !interpolation.isEmpty else {
            return encodedResult
        }
        var index = encodedResult.startIndex
        var reserveCapacity = 0
        var values = [String]()
        while !interpolation.isEmpty {
            let interp = interpolation.removeFirst()
            let left = encodedResult[index..<interp.range.lowerBound]
            values.append("StaticString(\(left))")

            var interpolationValue = encodedResult[interp.range]
            interpolationValue.removeFirst(3)
            interpolationValue.removeLast(3)
            values.append(String(interpolationValue))
            index = interp.range.upperBound

            reserveCapacity += left.count + 32
        }
        if index < encodedResult.endIndex {
            let slice = encodedResult[index...]
            reserveCapacity += slice.count
            values.append("StaticString(\(slice))")
        }
        return "HTMLOptimizedLiteral(reserveCapacity: \(reserveCapacity)).render((\n\(values.joined(separator: ",\n"))\n))"
    }

    static func chunks(
        encoding: HTMLEncoding,
        encodedResult: String,
        async: Bool,
        optimized: Bool,
        chunkSize: Int,
    ) -> [String] {
        var chunks = [String]()
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
            var string = ""
            if let f = slice.first, let d = delimiter(f) {
                string += d
            }
            string += slice
            if let l = slice.last, let d = delimiter(l) {
                string += d
            }
            chunks.append(string)
        }
        return chunks
    }

    static func streamedRepresentation(
        encoding: HTMLEncoding,
        encodedResult: String,
        async: Bool,
        optimized: Bool,
        chunkSize: Int,
        suspendDuration: Duration?
    ) -> String {
        var string = "AsyncStream { continuation in\n"
        if async {
            string += "Task {\n"
        }
        let chunks = chunks(encoding: encoding, encodedResult: encodedResult, async: async, optimized: optimized, chunkSize: chunkSize)
        for chunk in chunks {
            string += "continuation.yield(" + chunk + ")\n"
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