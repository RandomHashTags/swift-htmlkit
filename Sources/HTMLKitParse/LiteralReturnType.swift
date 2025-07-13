
// MARK: LiteralReturnType
public enum LiteralReturnType {
    case boolean(Bool)
    case string(String)
    case int(Int)
    case float(Float)
    case interpolation(String)
    case interpolationDescribed(String)
    indirect case arrayOfLiterals([LiteralReturnType])
    case array([Sendable])

    public var isInterpolation: Bool {
        switch self {
        case .interpolation, .interpolationDescribed:   
            return true
        case .arrayOfLiterals(let literals):
            return literals.first(where: { $0.isInterpolation }) == nil
        default:
            return false
        }
    }

    /// - Parameters:
    ///   - key: Attribute key associated with the value.
    ///   - escape: Whether or not to escape source-breaking HTML characters.
    ///   - escapeAttributes: Whether or not to escape source-breaking HTML attribute characters.
    public func value(
        key: String,
        escape: Bool = true,
        escapeAttributes: Bool = true
    ) -> String? {
        switch self {
        case .boolean(let b):
            return b ? key : nil
        case .string(var string):
            if string.isEmpty && key == "attributionsrc" {
                return ""
            }
            if escape {
                string.escapeHTML(escapeAttributes: escapeAttributes)
            }
            return string
        case .int(let int):
            return String(describing: int)
        case .float(let float):
            return String(describing: float)
        case .interpolation(let string):
            if string.hasPrefix("\\(") && string.last == ")" {
                return string
            }
            return "\\(\(string))"
        case .interpolationDescribed(let string):
            return "\" + String(describing: \(string)) + \""
        case .arrayOfLiterals(let literals):
            return literals.compactMap({ $0.value(key: key, escape: escape, escapeAttributes: escapeAttributes) }).joined()
        case .array:
            return nil
        }
    }

    public func escapeArray() -> LiteralReturnType {
        switch self {
        case .array(let a):
            if let arrayString = a as? [String] {
                return .array(arrayString.map({ $0.escapingHTML(escapeAttributes: true) }))
            }
            return .array(a)
        default:
            return self
        }
    }
}