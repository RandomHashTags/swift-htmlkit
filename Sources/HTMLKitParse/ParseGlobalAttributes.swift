
import HTMLAttributes
import HTMLKitUtilities
import SwiftDiagnostics
import SwiftSyntax

extension HTMLKitUtilities {
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
}