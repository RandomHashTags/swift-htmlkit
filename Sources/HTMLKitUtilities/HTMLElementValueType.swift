//
//  HTMLElementValueType.swift
//
//
//  Created by Evan Anderson on 11/21/24.
//

import SwiftSyntax
import SwiftSyntaxMacros

package indirect enum HTMLElementValueType {
    case string
    case int
    case float
    case bool
    case booleanDefaultValue(Bool)
    case attribute
    case otherAttribute(String)
    case cssUnit
    case array(of: HTMLElementValueType)

    package static func parse_element(context: some MacroExpansionContext, encoding: HTMLEncoding, _ function: FunctionCallExprSyntax) -> HTMLElement? {
        let called_expression:ExprSyntax = function.calledExpression
        let key:String
        if let member:MemberAccessExprSyntax = called_expression.memberAccess, member.base?.declRef?.baseName.text == "HTMLKit" {
            key = member.declName.baseName.text
        } else if let ref:DeclReferenceExprSyntax = called_expression.declRef {
            key = ref.baseName.text
        } else {
            return nil
        }
        let children:SyntaxChildren = function.arguments.children(viewMode: .all)
        switch key {
        case "a": return a(context, encoding, children)
        case "abbr": return abbr(context, encoding, children)
        case "address": return address(context, encoding, children)
        case "area": return area(context, encoding, children)
        case "article": return article(context, encoding, children)
        case "aside": return aside(context, encoding, children)
        case "audio": return audio(context, encoding, children)
        case "b": return b(context, encoding, children)
        case "base": return base(context, encoding, children)
        case "bdi": return bdi(context, encoding, children)
        case "bdo": return bdo(context, encoding, children)
        case "blockquote": return blockquote(context, encoding, children)
        case "body": return body(context, encoding, children)
        case "br": return br(context, encoding, children)
        case "button": return button(context, encoding, children)
        case "canvas": return canvas(context, encoding, children)
        case "caption": return caption(context, encoding, children)
        case "cite": return cite(context, encoding, children)
        case "code": return code(context, encoding, children)
        case "col": return col(context, encoding, children)
        case "colgroup": return colgroup(context, encoding, children)
        case "data": return data(context, encoding, children)
        case "datalist": return datalist(context, encoding, children)
        case "dd": return dd(context, encoding, children)
        case "del": return del(context, encoding, children)
        case "details": return details(context, encoding, children)
        case "dfn": return dfn(context, encoding, children)
        case "dialog": return dialog(context, encoding, children)
        case "div": return div(context, encoding, children)
        case "dl": return dl(context, encoding, children)
        case "dt": return dt(context, encoding, children)
        case "em": return em(context, encoding, children)
        case "embed": return embed(context, encoding, children)
        case "fencedframe": return fencedframe(context, encoding, children)
        case "fieldset": return fieldset(context, encoding, children)
        case "figcaption": return figcaption(context, encoding, children)
        case "figure": return figure(context, encoding, children)
        case "footer": return footer(context, encoding, children)
        case "form": return form(context, encoding, children)
        case "h1": return h1(context, encoding, children)
        case "h2": return h2(context, encoding, children)
        case "h3": return h3(context, encoding, children)
        case "h4": return h4(context, encoding, children)
        case "h5": return h5(context, encoding, children)
        case "h6": return h6(context, encoding, children)
        case "head": return head(context, encoding, children)
        case "header": return header(context, encoding, children)
        case "hgroup": return hgroup(context, encoding, children)
        case "hr": return hr(context, encoding, children)
        case "html": return html(context, encoding, children)
        case "i": return i(context, encoding, children)
        case "iframe": return iframe(context, encoding, children)
        case "img": return img(context, encoding, children)
        case "input": return input(context, encoding, children)
        case "ins": return ins(context, encoding, children)
        case "kbd": return kbd(context, encoding, children)
        case "label": return label(context, encoding, children)
        case "legend": return legend(context, encoding, children)
        case "li": return li(context, encoding, children)
        case "link": return link(context, encoding, children)
        case "main": return main(context, encoding, children)
        case "map": return map(context, encoding, children)
        case "mark": return mark(context, encoding, children)
        case "menu": return menu(context, encoding, children)
        case "meta": return meta(context, encoding, children)
        case "meter": return meter(context, encoding, children)
        case "nav": return nav(context, encoding, children)
        case "noscript": return noscript(context, encoding, children)
        case "object": return object(context, encoding, children)
        case "ol": return ol(context, encoding, children)
        case "optgroup": return optgroup(context, encoding, children)
        case "option": return option(context, encoding, children)
        case "output": return output(context, encoding, children)
        case "p": return p(context, encoding, children)
        case "picture": return picture(context, encoding, children)
        case "portal": return portal(context, encoding, children)
        case "pre": return pre(context, encoding, children)
        case "progress": return progress(context, encoding, children)
        case "q": return q(context, encoding, children)
        case "rp": return rp(context, encoding, children)
        case "rt": return rt(context, encoding, children)
        case "ruby": return ruby(context, encoding, children)
        case "s": return s(context, encoding, children)
        case "samp": return samp(context, encoding, children)
        case "script": return script(context, encoding, children)
        case "search": return search(context, encoding, children)
        case "section": return section(context, encoding, children)
        case "select": return select(context, encoding, children)
        case "slot": return slot(context, encoding, children)
        case "small": return small(context, encoding, children)
        case "source": return source(context, encoding, children)
        case "span": return span(context, encoding, children)
        case "strong": return strong(context, encoding, children)
        case "style": return style(context, encoding, children)
        case "sub": return sub(context, encoding, children)
        case "summary": return summary(context, encoding, children)
        case "sup": return sup(context, encoding, children)
        case "table": return table(context, encoding, children)
        case "tbody": return tbody(context, encoding, children)
        case "td": return td(context, encoding, children)
        case "template": return template(context, encoding, children)
        case "textarea": return textarea(context, encoding, children)
        case "tfoot": return tfoot(context, encoding, children)
        case "th": return th(context, encoding, children)
        case "thead": return thead(context, encoding, children)
        case "time": return time(context, encoding, children)
        case "title": return title(context, encoding, children)
        case "tr": return tr(context, encoding, children)
        case "track": return track(context, encoding, children)
        case "u": return u(context, encoding, children)
        case "ul": return ul(context, encoding, children)
        case "variable": return variable(context, encoding, children)
        case "video": return video(context, encoding, children)
        case "wbr": return wbr(context, encoding, children)

        case "custom": return custom(context, encoding, children)
        default: return nil
        }
    }
}