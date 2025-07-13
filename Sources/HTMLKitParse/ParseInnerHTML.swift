
import HTMLElements
import HTMLKitUtilities
import SwiftSyntax

extension HTMLKitUtilities {
    public static func parseInnerHTML(
        context: HTMLExpansionContext,
        child: LabeledExprSyntax
    ) -> (any Sendable)? {
        return parseInnerHTML(context: context, expr: child.expression)
    }

    public static func parseInnerHTML(
        context: HTMLExpansionContext,
        expr: ExprSyntax
    ) -> (any Sendable)? {
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
        } else if let literal = parseLiteralValue(context: context, expr: expr) {
            return literal.value(key: "", escape: context.escape, escapeAttributes: context.escapeAttributes)
        } else {
            unallowedExpression(context: context, node: expr)
            return nil
        }
    }
}

// MARK: Parse element
extension HTMLKitUtilities {
    public static func parse_element(context: HTMLExpansionContext, expr: ExprSyntax) -> (any HTMLElement)? {
        guard let function = expr.functionCall else { return nil }
        return HTMLElementValueType.parseElement(context: context, function)
    }
}