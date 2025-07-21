
#if canImport(HTMLElements) && canImport(HTMLKitUtilities) && canImport(SwiftSyntax)
import HTMLElements
import HTMLKitUtilities
import SwiftSyntax

extension HTMLElementValueType {
    package static func parseElement(
        context: HTMLExpansionContext,
        _ function: FunctionCallExprSyntax
    ) -> HTMLKitElement? {
        let calledExpression = function.calledExpression
        let key:String
        switch calledExpression.kind {
        case .memberAccessExpr:
            guard let member = calledExpression.memberAccess, member.base?.declRef?.baseName.text == "HTMLKit" else { return nil }
            key = member.declName.baseName.text
        case .declReferenceExpr:
            key = calledExpression.declRef!.baseName.text
        default:
            return nil
        }
        var c = context
        c.trailingClosure = function.trailingClosure
        c.arguments = function.arguments
        return parseElement(c: c, key: key)
    }
    package static func get<T: HTMLElement>(_ context: HTMLExpansionContext, _ bruh: T.Type) -> HTMLKitElement {
        return .init(context.encoding, HTMLKitUtilities.parseArguments(context: context, otherAttributes: [:]))
    }
    package static func parseElement(
        c: HTMLExpansionContext,
        key: String
    ) -> HTMLKitElement? {
        switch key {
        case "a": get(c, Anchor.self)
        case "abbr": get(c, Abbreviation.self)
        case "address": get(c, Address.self)
        case "area": get(c, Area.self)
        case "article": get(c, Article.self)
        case "aside": get(c, Aside.self)
        case "audio": get(c, Audio.self)
        case "b": get(c, B.self)
        case "base": get(c, Base.self)
        case "bdi": get(c, BidirectionalIsolate.self)
        case "bdo": get(c, BidirectionalTextOverride.self)
        case "blockquote": get(c, BlockQuote.self)
        case "body": get(c, Body.self)
        case "br": get(c, BR.self)
        case "button": get(c, Button.self)
        case "canvas": get(c, Canvas.self)
        case "caption": get(c, Caption.self)
        case "cite": get(c, HTMLElementTypes.Cite.self)
        case "code": get(c, Code.self)
        case "col": get(c, TableColumn.self)
        case "colgroup": get(c, TableColumnGroup.self)
        case "data": get(c, Data.self)
        case "datalist": get(c, DataList.self)
        case "dd": get(c, DescriptionDetails.self)
        case "del": get(c, Del.self)
        case "details": get(c, Details.self)
        case "dfn": get(c, Definition.self)
        case "dialog": get(c, Dialog.self)
        case "div": get(c, ContentDivision.self)
        case "dl": get(c, DescriptionList.self)
        case "dt": get(c, DescriptionTerm.self)
        case "em": get(c, Emphasis.self)
        case "embed": get(c, Embed.self)
        case "fencedframe": get(c, FencedFrame.self)
        case "fieldset": get(c, FieldSet.self)
        case "figcaption": get(c, FigureCaption.self)
        case "figure": get(c, Figure.self)
        case "footer": get(c, Footer.self)
        case "form": get(c, Form.self)
        case "h1": get(c, H1.self)
        case "h2": get(c, H2.self)
        case "h3": get(c, H3.self)
        case "h4": get(c, H4.self)
        case "h5": get(c, H5.self)
        case "h6": get(c, H6.self)
        case "head": get(c, Head.self)
        case "header": get(c, Header.self)
        case "hgroup": get(c, HeadingGroup.self)
        case "hr": get(c, ThematicBreak.self)
        case "html": get(c, HtmlRoot.self)
        case "i": get(c, IdiomaticText.self)
        case "iframe": get(c, InlineFrame.self)
        case "img": get(c, Image.self)
        case "input": get(c, Input.self)
        case "ins": get(c, InsertedText.self)
        case "kbd": get(c, KeyboardInput.self)
        case "label": get(c, HTMLElementTypes.Label.self)
        case "legend": get(c, Legend.self)
        case "li": get(c, ListItem.self)
        case "link": get(c, Link.self)
        case "main": get(c, Main.self)
        case "map": get(c, Map.self)
        case "mark": get(c, Mark.self)
        case "menu": get(c, Menu.self)
        case "meta": get(c, Meta.self)
        case "meter": get(c, Meter.self)
        case "nav": get(c, NavigationSection.self)
        case "noscript": get(c, Noscript.self)
        case "object": get(c, ExternalObject.self)
        case "ol": get(c, OrderedList.self)
        case "optgroup": get(c, OptionGroup.self)
        case "option": get(c, Option.self)
        case "output": get(c, Output.self)
        case "p": get(c, Paragraph.self)
        case "picture": get(c, Picture.self)
        //case "portal": get(c, Portal.self)
        case "pre": get(c, PreformattedText.self)
        case "progress": get(c, ProgressIndicator.self)
        case "q": get(c, InlineQuotation.self)
        case "rp": get(c, RubyParenthesis.self)
        case "rt": get(c, RubyText.self)
        case "ruby": get(c, Ruby.self)
        case "s": get(c, Strikethrough.self)
        case "samp": get(c, Samp.self)
        case "script": get(c, Script.self)
        case "search": get(c, Search.self)
        case "section": get(c, Section.self)
        case "select": get(c, Select.self)
        case "slot": get(c, HTMLElementTypes.WebComponentSlot.self)
        case "small": get(c, Small.self)
        case "source": get(c, Source.self)
        case "span": get(c, HTMLElementTypes.ContentSpan.self)
        case "strong": get(c, StrongImportance.self)
        case "style": get(c, HTMLElementTypes.Style.self)
        case "sub": get(c, Subscript.self)
        case "summary": get(c, DisclosureSummary.self)
        case "sup": get(c, Superscript.self)
        case "table": get(c, Table.self)
        case "tbody": get(c, TableBody.self)
        case "td": get(c, TableDataCell.self)
        case "template": get(c, ContentTemplate.self)
        case "textarea": get(c, Textarea.self)
        case "tfoot": get(c, TableFoot.self)
        case "th": get(c, TableHeader.self)
        case "thead": get(c, TableHead.self)
        case "time": get(c, Time.self)
        case "title": get(c, HTMLElementTypes.Title.self)
        case "tr": get(c, TableRow.self)
        case "track": get(c, Track.self)
        case "u": get(c, UnarticulatedAnnotation.self)
        case "ul": get(c, UnorderedList.self)
        case "variable": get(c, Variable.self)
        case "video": get(c, Video.self)
        case "wbr": get(c, LineBreakOpportunity.self)

        //case "custom": get(c, custom.self)
        //case "svg": get(c, svg.self)
        default: nil
        }
    }
}
#endif

public struct HTMLKitElement {

    var encoding: HTMLEncoding

    public init(_ encoding: HTMLEncoding, _ data: HTMLKitUtilities.ElementData) {
        self.encoding = encoding
        // TODO: finish
    }
}

extension HTMLElement {
    public static var attributes: Set<String> { [] }
}

extension Anchor {
    public static var attributes: Set<String> {
        [
            "attributionsrc",
            "download",
            "href",
            "hreflang",
            "ping",
            "referrerpolicy",
            "rel",
            "target"
        ]
    }
}