
#if canImport(HTMLElements) && canImport(HTMLKitUtilities) && canImport(SwiftSyntax)
import HTMLElements
import HTMLKitUtilities
import SwiftSyntax

extension HTMLElementValueType {
    package static func get<T: HTMLElement>(_ context: inout HTMLExpansionContext, _ bruh: T.Type) -> T {
        return T(context.encoding, HTMLKitUtilities.parseArguments(context: &context, otherAttributes: T.otherAttributes))
    }
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
        switch key {
        case "a": return get(&c, a.self)
        case "abbr": return get(&c, abbr.self)
        case "address": return get(&c, address.self)
        case "area": return get(&c, area.self)
        case "article": return get(&c, article.self)
        case "aside": return get(&c, aside.self)
        case "audio": return get(&c, audio.self)
        case "b": return get(&c, b.self)
        case "base": return get(&c, base.self)
        case "bdi": return get(&c, bdi.self)
        case "bdo": return get(&c, bdo.self)
        case "blockquote": return get(&c, blockquote.self)
        case "body": return get(&c, body.self)
        case "br": return get(&c, br.self)
        case "button": return get(&c, button.self)
        case "canvas": return get(&c, canvas.self)
        case "caption": return get(&c, caption.self)
        case "cite": return get(&c, cite.self)
        case "code": return get(&c, code.self)
        case "col": return get(&c, col.self)
        case "colgroup": return get(&c, colgroup.self)
        case "data": return get(&c, data.self)
        case "datalist": return get(&c, datalist.self)
        case "dd": return get(&c, dd.self)
        case "del": return get(&c, del.self)
        case "details": return get(&c, details.self)
        case "dfn": return get(&c, dfn.self)
        case "dialog": return get(&c, dialog.self)
        case "div": return get(&c, div.self)
        case "dl": return get(&c, dl.self)
        case "dt": return get(&c, dt.self)
        case "em": return get(&c, em.self)
        case "embed": return get(&c, embed.self)
        case "fencedframe": return get(&c, fencedframe.self)
        case "fieldset": return get(&c, fieldset.self)
        case "figcaption": return get(&c, figcaption.self)
        case "figure": return get(&c, figure.self)
        case "footer": return get(&c, footer.self)
        case "form": return get(&c, form.self)
        case "h1": return get(&c, h1.self)
        case "h2": return get(&c, h2.self)
        case "h3": return get(&c, h3.self)
        case "h4": return get(&c, h4.self)
        case "h5": return get(&c, h5.self)
        case "h6": return get(&c, h6.self)
        case "head": return get(&c, head.self)
        case "header": return get(&c, header.self)
        case "hgroup": return get(&c, hgroup.self)
        case "hr": return get(&c, hr.self)
        case "html": return get(&c, html.self)
        case "i": return get(&c, i.self)
        case "iframe": return get(&c, iframe.self)
        case "img": return get(&c, img.self)
        case "input": return get(&c, input.self)
        case "ins": return get(&c, ins.self)
        case "kbd": return get(&c, kbd.self)
        case "label": return get(&c, label.self)
        case "legend": return get(&c, legend.self)
        case "li": return get(&c, li.self)
        case "link": return get(&c, link.self)
        case "main": return get(&c, main.self)
        case "map": return get(&c, map.self)
        case "mark": return get(&c, mark.self)
        case "menu": return get(&c, menu.self)
        case "meta": return get(&c, meta.self)
        case "meter": return get(&c, meter.self)
        case "nav": return get(&c, nav.self)
        case "noscript": return get(&c, noscript.self)
        case "object": return get(&c, object.self)
        case "ol": return get(&c, ol.self)
        case "optgroup": return get(&c, optgroup.self)
        case "option": return get(&c, option.self)
        case "output": return get(&c, output.self)
        case "p": return get(&c, p.self)
        case "picture": return get(&c, picture.self)
        case "portal": return get(&c, portal.self)
        case "pre": return get(&c, pre.self)
        case "progress": return get(&c, progress.self)
        case "q": return get(&c, q.self)
        case "rp": return get(&c, rp.self)
        case "rt": return get(&c, rt.self)
        case "ruby": return get(&c, ruby.self)
        case "s": return get(&c, s.self)
        case "samp": return get(&c, samp.self)
        case "script": return get(&c, script.self)
        case "search": return get(&c, search.self)
        case "section": return get(&c, section.self)
        case "select": return get(&c, select.self)
        case "slot": return get(&c, slot.self)
        case "small": return get(&c, small.self)
        case "source": return get(&c, source.self)
        case "span": return get(&c, span.self)
        case "strong": return get(&c, strong.self)
        case "style": return get(&c, style.self)
        case "sub": return get(&c, sub.self)
        case "summary": return get(&c, summary.self)
        case "sup": return get(&c, sup.self)
        case "table": return get(&c, table.self)
        case "tbody": return get(&c, tbody.self)
        case "td": return get(&c, td.self)
        case "template": return get(&c, template.self)
        case "textarea": return get(&c, textarea.self)
        case "tfoot": return get(&c, tfoot.self)
        case "th": return get(&c, th.self)
        case "thead": return get(&c, thead.self)
        case "time": return get(&c, time.self)
        case "title": return get(&c, title.self)
        case "tr": return get(&c, tr.self)
        case "track": return get(&c, track.self)
        case "u": return get(&c, u.self)
        case "ul": return get(&c, ul.self)
        case "variable": return get(&c, variable.self)
        case "video": return get(&c, video.self)
        case "wbr": return get(&c, wbr.self)

        case "custom": return get(&c, custom.self)
        //case "svg": return get(&c, svg.self)
        default: return nil
        }
    }
}
#endif