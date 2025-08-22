
import CSS
import HTMLKitUtilities

extension CSSUnit: HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        func float() -> Float? {
            guard let expression = context.expression,
                    let s = expression.integerLiteral?.literal.text ?? expression.floatLiteral?.literal.text
            else {
                return nil
            }
            return Float(s)
        }
        switch context.key {
        case "centimeters": self = .centimeters(float())
        case "millimeters": self = .millimeters(float())
        case "inches": self = .inches(float())
        case "pixels": self = .pixels(float())
        case "points": self = .points(float())
        case "picas": self = .picas(float())

        case "em": self = .em(float())
        case "ex": self = .ex(float())
        case "ch": self = .ch(float())
        case "rem": self = .rem(float())
        case "viewportWidth": self = .viewportWidth(float())
        case "viewportHeight": self = .viewportHeight(float())
        case "viewportMin": self = .viewportMin(float())
        case "viewportMax": self = .viewportMax(float())
        case "percent": self = .percent(float())
        default: return nil
        }
    }
}