
import HTMLKitUtilities
import SwiftDiagnostics
import SwiftSyntax

extension HTMLKitUtilities {
    public static func expandHTMLMacro(context: HTMLExpansionContext) throws -> ExprSyntax {
        var context = context
        let (string, encoding) = expandMacro(context: &context)
        let encodingResult = encodingResult(context: context, node: context.expansion, string: string, for: encoding)
        let expandedResult = representationResult(encoding: encoding, encodedResult: encodingResult, resultType: context.resultType)
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
                context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "interpolationNotAllowedForDataType", message: "String Interpolation is not allowed for this data type. Runtime values get converted to raw text, which is not the intended result.")))
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
        resultType: HTMLExpansionResultTypeAST
    ) -> String {
        switch resultType {
        case .literal:
            if encoding == .string {
                return literal(encodedResult: encodedResult)
            }
        /*case .literalOptimized:
            if encoding == .string {
                return optimizedLiteral(encodedResult: encodedResult)
            } else {
                // TODO: show compiler diagnostic
            }*/
        case .chunks(let optimized, let chunkSize):
            return "[" + chunks(encoding: encoding, encodedResult: encodedResult, async: false, optimized: optimized, chunkSize: chunkSize).joined(separator: ", ") + "]"
        #if compiler(>=6.2)
        case .chunksInline(let optimized, let chunkSize):
            let typeAnnotation:String = "String" // TODO: fix
            let chunks = chunks(encoding: encoding, encodedResult: encodedResult, async: false, optimized: optimized, chunkSize: chunkSize).joined(separator: ", ")
            return "InlineArray<\(chunks.count), \(typeAnnotation)>([\(chunks)])"
        #endif
        case .stream(let optimized, let chunkSize):
            return streamed(
                encoding: encoding,
                encodedResult: encodedResult,
                async: false,
                optimized: optimized,
                chunkSize: chunkSize,
                yieldVariableName: nil,
                afterYield: nil
            )
        case .streamAsync(let optimized, let chunkSize, let yieldVariableName, let afterYield):
            return streamed(
                encoding: encoding,
                encodedResult: encodedResult,
                async: true,
                optimized: optimized,
                chunkSize: chunkSize,
                yieldVariableName: yieldVariableName,
                afterYield: afterYield
            )
        default:
            break
        }
        return encodedResult
    }
}

// MARK: Literal
extension HTMLKitUtilities {
    static var interpolationRegex: Regex<AnyRegexOutput> {
        try! Regex.init(#"( \+ String\(describing: [\x00-\x2A\x2C-\xFF]+\) \+ )"#)
    }
    static func literal(encodedResult: String) -> String {
        var interpolation = encodedResult.matches(of: interpolationRegex)
        guard !interpolation.isEmpty else {
            return encodedResult
        }
        var index = encodedResult.startIndex
        var values = [String]()
        while !interpolation.isEmpty {
            let interp = interpolation.removeFirst()
            var left = encodedResult[index..<interp.range.lowerBound]
            if index != encodedResult.startIndex && left.first == "\"" {
                left.removeFirst()
            }
            if left.last == "\"" {
                left.removeLast()
            }
            values.append(String(left))

            var interpolationValue = encodedResult[interp.range]
            interpolationValue.removeFirst(22)
            interpolationValue.removeLast(3)
            interpolationValue.removeAll(where: { $0.isNewline })
            values.append(String("\\(" + interpolationValue))
            index = interp.range.upperBound
        }
        if index < encodedResult.endIndex {
            var slice = encodedResult[index...]
            if slice.first == "\"" {
                slice.removeFirst()
            }
            values.append(String(slice))
        }
        return values.joined()
    }
}

// MARK: Optimized literal
extension HTMLKitUtilities {
    static func optimizedLiteral(encodedResult: String) -> String {
        var interpolation = encodedResult.matches(of: interpolationRegex)
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
            values.append(normalizeInterpolation(encodedResult[interp.range], withQuotationMarks: true))
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
    static func normalizeInterpolation(_ value: Substring, withQuotationMarks: Bool) -> String {
        var value = value
        value.removeFirst(22) // ` + String(describing: `.count
        value.removeLast(3) // ` + `.count
        value.removeAll(where: { $0.isNewline })
        if withQuotationMarks {
            value.insert("\"", at: value.startIndex)
            value.append("\"")
        }
        return String("\\(" + value)
    }
}

// MARK: Chunks
extension HTMLKitUtilities {
    static func chunks(
        encoding: HTMLEncoding,
        encodedResult: String,
        async: Bool,
        optimized: Bool,
        chunkSize: Int,
    ) -> [String] {
        var interpolationMatches = encodedResult.matches(of: interpolationRegex)
        var chunks = [String]()
        let delimiter:(Character) -> String? = encoding == .string ? { $0 != "\"" ? "\"" : nil } : { _ in nil }
        let count = encodedResult.count
        var i = 0
        while i < count {
            var endingIndex = i + chunkSize
            var offset = 0
            if i == 0 && encoding == .string {
                endingIndex += 1
                offset = 1
            }
            var endIndex = encodedResult.index(encodedResult.startIndex, offsetBy: endingIndex, limitedBy: encodedResult.endIndex) ?? encodedResult.endIndex
            let range = encodedResult.index(encodedResult.startIndex, offsetBy: i)..<endIndex
            var slice = encodedResult[range]
            var interpolation:String? = nil
            if let interp = interpolationMatches.first, range.contains(interp.range.lowerBound) { // chunk contains interpolation
                var normalized = normalizeInterpolation(encodedResult[interp.range], withQuotationMarks: false)
                if !range.contains(interp.range.upperBound) {
                    endIndex = encodedResult.index(before: interp.range.lowerBound)
                    if slice.startIndex < endIndex {
                        slice = slice[slice.startIndex..<endIndex]
                    } else {
                        slice = ""
                        normalized = "\"\(normalized)\""
                    }
                    interpolation = normalized
                    i += encodedResult.distance(from: range.upperBound, to: interp.range.upperBound)
                } else {
                    interpolation = nil
                    slice.remove(at: interp.range.upperBound) // "
                    slice.replaceSubrange(interp.range, with: normalized)
                    slice.remove(at: slice.index(before: interp.range.lowerBound)) // "
                }
                interpolationMatches.removeFirst()
            } else {
                interpolation = nil
            }
            i += chunkSize + offset
            if slice.isEmpty && interpolation == nil || encoding == .string && slice.count == 1 && slice[slice.startIndex] == "\"" {
                continue
            }
            var string = ""
            if let f = slice.first, let d = delimiter(f) {
                string += d
            }
            if let interpolation {
                string += slice
                string += interpolation
            } else {
                string += slice
            }
            if let l = slice.last, let d = delimiter(l) {
                string += d
            }
            chunks.append(string)
        }
        return chunks
    }
}

// MARK: Streamed
extension HTMLKitUtilities {
    static func streamed(
        encoding: HTMLEncoding,
        encodedResult: String,
        async: Bool,
        optimized: Bool,
        chunkSize: Int,
        yieldVariableName: String?,
        afterYield: String?
    ) -> String {
        var string = "AsyncStream { continuation in\n"
        if async {
            string += "Task {\n"
        }
        var yieldVariableName:String? = yieldVariableName
        if yieldVariableName == "_" {
            yieldVariableName = nil
        }
        var afterYieldLogic:String?
        if let afterYield {
            if let yieldVariableName {
                string += "var \(yieldVariableName) = 0\n"
            }
            afterYieldLogic = afterYield
        } else {
            afterYieldLogic = nil
        }
        let chunks = chunks(encoding: encoding, encodedResult: encodedResult, async: async, optimized: optimized, chunkSize: chunkSize)
        for chunk in chunks {
            string += "continuation.yield(" + chunk + ")\n"
            if let afterYieldLogic {
                string += "\(afterYieldLogic)\n"
            }
            if let yieldVariableName {
                string += "\(yieldVariableName) += 1\n"
            }
        }
        string += "continuation.finish()\n}"
        if async {
            string += "\n}"
        }
        return string
    }
}