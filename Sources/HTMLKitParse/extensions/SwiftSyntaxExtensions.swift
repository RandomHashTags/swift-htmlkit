
import HTMLKitUtilities
import SwiftSyntax

// MARK: Misc
extension ExprSyntax {
    package func string(_ context: HTMLExpansionContext) -> String? {
        return HTMLKitUtilities.parseLiteral(context: context, expr: self)?.value(key: context.key)
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
        guard let s = HTMLKitUtilities.parseLiteral(context: context, expr: self)?.value(key: context.key) else { return nil }
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
        guard let s = HTMLKitUtilities.parseLiteral(context: context, expr: self)?.value(key: context.key) else { return nil }
        return Float(s)
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

// MARK: Other
extension ExprSyntaxProtocol {
    package var booleanLiteral: BooleanLiteralExprSyntax? { self.as(BooleanLiteralExprSyntax.self) }
    package var stringLiteral: StringLiteralExprSyntax? { self.as(StringLiteralExprSyntax.self) }
    package var integerLiteral: IntegerLiteralExprSyntax? { self.as(IntegerLiteralExprSyntax.self) }
    package var floatLiteral: FloatLiteralExprSyntax? { self.as(FloatLiteralExprSyntax.self) }
    package var array: ArrayExprSyntax? { self.as(ArrayExprSyntax.self) }
    package var dictionary: DictionaryExprSyntax? { self.as(DictionaryExprSyntax.self) }
    package var memberAccess: MemberAccessExprSyntax? { self.as(MemberAccessExprSyntax.self) }
    package var macroExpansion: MacroExpansionExprSyntax? { self.as(MacroExpansionExprSyntax.self) }
    package var functionCall: FunctionCallExprSyntax? { self.as(FunctionCallExprSyntax.self) }
    package var declRef: DeclReferenceExprSyntax? { self.as(DeclReferenceExprSyntax.self) }
}

extension ExprSyntaxProtocol {
    package var booleanIsTrue: Bool {
        booleanLiteral?.literal.text == "true"
    }
}

extension SyntaxChildren.Element {
    package var labeled: LabeledExprSyntax? {
        self.as(LabeledExprSyntax.self)
    }
}

extension StringLiteralExprSyntax {
    package func string(encoding: HTMLEncoding) -> String {
        if openingQuote.debugDescription.hasPrefix("multilineStringQuote") {
            var value = ""
            for segment in segments {
                value += segment.as(StringSegmentSyntax.self)?.content.text ?? ""
            }
            switch encoding {
            case .string:
                value.replace("\n", with: HTMLKitUtilities.lineFeedPlaceholder)
                value.replace("\"", with: "\\\"")
            default:
                break
            }
            return value
        }
        /*if segments.count > 1 {
            var value = segments.compactMap({
                guard let s = $0.as(StringSegmentSyntax.self)?.content.text, !s.isEmpty else { return nil }
                return s
            }).joined()
            switch encoding {
            case .string:
                value.replace("\n", with: "\\n")
            default:
                break
            }
            return value
        }*/
        return "\(segments)"
    }
}

extension LabeledExprListSyntax {
    package func get(_ index: Int) -> Element? {
        return self.get(self.index(at: index))
    }
    package func getPositive(_ index: Int) -> Element? {
        return self.getPositive(self.index(at: index))
    }
}