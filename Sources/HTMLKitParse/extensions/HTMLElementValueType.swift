
#if canImport(HTMLElements) && canImport(HTMLKitUtilities) && canImport(SwiftSyntax)
import HTMLElements
import HTMLKitUtilities
import SwiftSyntax

extension HTMLElementValueType {
    package static func parseElement(
        context: HTMLExpansionContext,
        _ function: FunctionCallExprSyntax
    ) -> HTMLElement? {
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
    package static func get<T: HTMLElement>(_ context: HTMLExpansionContext, _ bruh: T.Type) -> T {
        return T(context.encoding, HTMLKitUtilities.parseArguments(context: context, otherAttributes: T.otherAttributes))
    }
    package static func parseElement(
        c: HTMLExpansionContext,
        key: String
    ) -> (any HTMLElement)? {
        switch key {
        case "a": get(c, a.self)
        case "abbr": get(c, abbr.self)
        case "address": get(c, address.self)
        case "area": get(c, area.self)
        case "article": get(c, article.self)
        case "aside": get(c, aside.self)
        case "audio": get(c, audio.self)
        case "b": get(c, b.self)
        case "base": get(c, base.self)
        case "bdi": get(c, bdi.self)
        case "bdo": get(c, bdo.self)
        case "blockquote": get(c, blockquote.self)
        case "body": get(c, body.self)
        case "br": get(c, br.self)
        case "button": get(c, button.self)
        case "canvas": get(c, canvas.self)
        case "caption": get(c, caption.self)
        case "cite": get(c, cite.self)
        case "code": get(c, code.self)
        case "col": get(c, col.self)
        case "colgroup": get(c, colgroup.self)
        case "data": get(c, data.self)
        case "datalist": get(c, datalist.self)
        case "dd": get(c, dd.self)
        case "del": get(c, del.self)
        case "details": get(c, details.self)
        case "dfn": get(c, dfn.self)
        case "dialog": get(c, dialog.self)
        case "div": get(c, div.self)
        case "dl": get(c, dl.self)
        case "dt": get(c, dt.self)
        case "em": get(c, em.self)
        case "embed": get(c, embed.self)
        case "fencedframe": get(c, fencedframe.self)
        case "fieldset": get(c, fieldset.self)
        case "figcaption": get(c, figcaption.self)
        case "figure": get(c, figure.self)
        case "footer": get(c, footer.self)
        case "form": get(c, form.self)
        case "h1": get(c, h1.self)
        case "h2": get(c, h2.self)
        case "h3": get(c, h3.self)
        case "h4": get(c, h4.self)
        case "h5": get(c, h5.self)
        case "h6": get(c, h6.self)
        case "head": get(c, head.self)
        case "header": get(c, header.self)
        case "hgroup": get(c, hgroup.self)
        case "hr": get(c, hr.self)
        case "html": get(c, html.self)
        case "i": get(c, i.self)
        case "iframe": get(c, iframe.self)
        case "img": get(c, img.self)
        case "input": get(c, input.self)
        case "ins": get(c, ins.self)
        case "kbd": get(c, kbd.self)
        case "label": get(c, label.self)
        case "legend": get(c, legend.self)
        case "li": get(c, li.self)
        case "link": get(c, link.self)
        case "main": get(c, main.self)
        case "map": get(c, map.self)
        case "mark": get(c, mark.self)
        case "menu": get(c, menu.self)
        case "meta": get(c, meta.self)
        case "meter": get(c, meter.self)
        case "nav": get(c, nav.self)
        case "noscript": get(c, noscript.self)
        case "object": get(c, object.self)
        case "ol": get(c, ol.self)
        case "optgroup": get(c, optgroup.self)
        case "option": get(c, option.self)
        case "output": get(c, output.self)
        case "p": get(c, p.self)
        case "picture": get(c, picture.self)
        case "portal": get(c, portal.self)
        case "pre": get(c, pre.self)
        case "progress": get(c, progress.self)
        case "q": get(c, q.self)
        case "rp": get(c, rp.self)
        case "rt": get(c, rt.self)
        case "ruby": get(c, ruby.self)
        case "s": get(c, s.self)
        case "samp": get(c, samp.self)
        case "script": get(c, script.self)
        case "search": get(c, search.self)
        case "section": get(c, section.self)
        case "select": get(c, select.self)
        case "slot": get(c, slot.self)
        case "small": get(c, small.self)
        case "source": get(c, source.self)
        case "span": get(c, span.self)
        case "strong": get(c, strong.self)
        case "style": get(c, style.self)
        case "sub": get(c, sub.self)
        case "summary": get(c, summary.self)
        case "sup": get(c, sup.self)
        case "table": get(c, table.self)
        case "tbody": get(c, tbody.self)
        case "td": get(c, td.self)
        case "template": get(c, template.self)
        case "textarea": get(c, textarea.self)
        case "tfoot": get(c, tfoot.self)
        case "th": get(c, th.self)
        case "thead": get(c, thead.self)
        case "time": get(c, time.self)
        case "title": get(c, title.self)
        case "tr": get(c, tr.self)
        case "track": get(c, track.self)
        case "u": get(c, u.self)
        case "ul": get(c, ul.self)
        case "variable": get(c, variable.self)
        case "video": get(c, video.self)
        case "wbr": get(c, wbr.self)

        case "custom": get(c, custom.self)
        //case "svg": get(c, svg.self)
        default: nil
        }
    }
}
#endif