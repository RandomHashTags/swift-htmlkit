//
//  HTMLElementValueType.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

#if canImport(HTMLElements) && canImport(HTMLKitUtilities) && canImport(SwiftSyntax)
import HTMLElements
import HTMLKitUtilities
import SwiftSyntax

extension HTMLElementValueType {
    package static func parse_element(context: HTMLExpansionContext, _ function: FunctionCallExprSyntax) -> HTMLElement? {
        var context:HTMLExpansionContext = context
        let called_expression:ExprSyntax = function.calledExpression
        let key:String
        if let member:MemberAccessExprSyntax = called_expression.memberAccess, member.base?.declRef?.baseName.text == "HTMLKit" {
            key = member.declName.baseName.text
        } else if let ref:DeclReferenceExprSyntax = called_expression.declRef {
            key = ref.baseName.text
        } else {
            return nil
        }
        context.arguments = function.arguments
        func get<T: HTMLElement>(_ bruh: T.Type) -> T {
            let data:HTMLKitUtilities.ElementData = HTMLKitUtilities.parseArguments(context: context, otherAttributes: T.otherAttributes)
            return T(context.encoding, data)
        }
        switch key {
        case "a": return get(a.self)
        case "abbr": return get(abbr.self)
        case "address": return get(address.self)
        case "area": return get(area.self)
        case "article": return get(article.self)
        case "aside": return get(aside.self)
        case "audio": return get(audio.self)
        case "b": return get(b.self)
        case "base": return get(base.self)
        case "bdi": return get(bdi.self)
        case "bdo": return get(bdo.self)
        case "blockquote": return get(blockquote.self)
        case "body": return get(body.self)
        case "br": return get(br.self)
        case "button": return get(button.self)
        case "canvas": return get(canvas.self)
        case "caption": return get(caption.self)
        case "cite": return get(cite.self)
        case "code": return get(code.self)
        case "col": return get(col.self)
        case "colgroup": return get(colgroup.self)
        case "data": return get(data.self)
        case "datalist": return get(datalist.self)
        case "dd": return get(dd.self)
        case "del": return get(del.self)
        case "details": return get(details.self)
        case "dfn": return get(dfn.self)
        case "dialog": return get(dialog.self)
        case "div": return get(div.self)
        case "dl": return get(dl.self)
        case "dt": return get(dt.self)
        case "em": return get(em.self)
        case "embed": return get(embed.self)
        case "fencedframe": return get(fencedframe.self)
        case "fieldset": return get(fieldset.self)
        case "figcaption": return get(figcaption.self)
        case "figure": return get(figure.self)
        case "footer": return get(footer.self)
        case "form": return get(form.self)
        case "h1": return get(h1.self)
        case "h2": return get(h2.self)
        case "h3": return get(h3.self)
        case "h4": return get(h4.self)
        case "h5": return get(h5.self)
        case "h6": return get(h6.self)
        case "head": return get(head.self)
        case "header": return get(header.self)
        case "hgroup": return get(hgroup.self)
        case "hr": return get(hr.self)
        case "html": return get(html.self)
        case "i": return get(i.self)
        case "iframe": return get(iframe.self)
        case "img": return get(img.self)
        case "input": return get(input.self)
        case "ins": return get(ins.self)
        case "kbd": return get(kbd.self)
        case "label": return get(label.self)
        case "legend": return get(legend.self)
        case "li": return get(li.self)
        case "link": return get(link.self)
        case "main": return get(main.self)
        case "map": return get(map.self)
        case "mark": return get(mark.self)
        case "menu": return get(menu.self)
        case "meta": return get(meta.self)
        case "meter": return get(meter.self)
        case "nav": return get(nav.self)
        case "noscript": return get(noscript.self)
        case "object": return get(object.self)
        case "ol": return get(ol.self)
        case "optgroup": return get(optgroup.self)
        case "option": return get(option.self)
        case "output": return get(output.self)
        case "p": return get(p.self)
        case "picture": return get(picture.self)
        case "portal": return get(portal.self)
        case "pre": return get(pre.self)
        case "progress": return get(progress.self)
        case "q": return get(q.self)
        case "rp": return get(rp.self)
        case "rt": return get(rt.self)
        case "ruby": return get(ruby.self)
        case "s": return get(s.self)
        case "samp": return get(samp.self)
        case "script": return get(script.self)
        case "search": return get(search.self)
        case "section": return get(section.self)
        case "select": return get(select.self)
        case "slot": return get(slot.self)
        case "small": return get(small.self)
        case "source": return get(source.self)
        case "span": return get(span.self)
        case "strong": return get(strong.self)
        case "style": return get(style.self)
        case "sub": return get(sub.self)
        case "summary": return get(summary.self)
        case "sup": return get(sup.self)
        case "table": return get(table.self)
        case "tbody": return get(tbody.self)
        case "td": return get(td.self)
        case "template": return get(template.self)
        case "textarea": return get(textarea.self)
        case "tfoot": return get(tfoot.self)
        case "th": return get(th.self)
        case "thead": return get(thead.self)
        case "time": return get(time.self)
        case "title": return get(title.self)
        case "tr": return get(tr.self)
        case "track": return get(track.self)
        case "u": return get(u.self)
        case "ul": return get(ul.self)
        case "variable": return get(variable.self)
        case "video": return get(video.self)
        case "wbr": return get(wbr.self)

        case "custom": return get(custom.self)
        //case "svg": return get(svg.self)
        default: return nil
        }
    }
}
#endif