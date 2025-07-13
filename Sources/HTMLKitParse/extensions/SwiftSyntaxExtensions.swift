
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