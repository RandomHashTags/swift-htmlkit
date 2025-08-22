
import CSS

extension CSSStyle.All: HTMLParsable {}
extension CSSStyle.Appearance: HTMLParsable {}
extension CSSStyle.BackfaceVisibility: HTMLParsable {}
extension CSSStyle.Box: HTMLParsable {}
extension CSSStyle.Break: HTMLParsable {}
extension CSSStyle.CaptionSide: HTMLParsable {}
extension CSSStyle.Clear: HTMLParsable {}
extension CSSStyle.ColorScheme: HTMLParsable {}
extension CSSStyle.ColumnCount: HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        return nil
    }
}
extension CSSStyle.Direction: HTMLParsable {}
extension CSSStyle.Display: HTMLParsable {}
extension CSSStyle.EmptyCells: HTMLParsable {}
extension CSSStyle.Float: HTMLParsable {}
extension CSSStyle.HyphenateCharacter: HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        return nil
    }
}
extension CSSStyle.Hyphens: HTMLParsable {}
extension CSSStyle.ImageRendering: HTMLParsable {}
extension CSSStyle.Isolation: HTMLParsable {}
extension CSSStyle.Visibility: HTMLParsable {}
extension CSSStyle.WhiteSpace: HTMLParsable {}
extension CSSStyle.WhiteSpaceCollapse: HTMLParsable {}
extension CSSStyle.WritingMode: HTMLParsable {}