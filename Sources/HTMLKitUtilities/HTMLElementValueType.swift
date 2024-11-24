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

    package static func parse_element(context: some MacroExpansionContext, _ function: FunctionCallExprSyntax) -> HTMLElement? {
        let called_expression:ExprSyntax = function.calledExpression
        let key:String
        if let member:MemberAccessExprSyntax = called_expression.memberAccess, member.base?.declRef?.baseName.text == "HTMLKit" {
            key = member.declName.baseName.text
        } else if let ref = called_expression.declRef {
            key = ref.baseName.text
        } else {
            return nil
        }
        let children:SyntaxChildren = function.arguments.children(viewMode: .all)
        switch key {
            case "a": return a(context: context, children)
            case "abbr": return abbr(context: context, children)
            case "address": return address(context: context, children)
            case "area": return area(context: context, children)
            case "article": return article(context: context, children)
            case "aside": return aside(context: context, children)
            case "audio": return audio(context: context, children)
            case "b": return b(context: context, children)
            case "base": return base(context: context, children)
            case "bdi": return bdi(context: context, children)
            case "bdo": return bdo(context: context, children)
            case "blockquote": return blockquote(context: context, children)
            case "body": return body(context: context, children)
            case "br": return br(context: context, children)
            case "button": return button(context: context, children)
            case "canvas": return canvas(context: context, children)
            case "caption": return caption(context: context, children)
            case "cite": return cite(context: context, children)
            case "code": return code(context: context, children)
            case "col": return col(context: context, children)
            case "colgroup": return colgroup(context: context, children)
            case "data": return data(context: context, children)
            case "datalist": return datalist(context: context, children)
            case "dd": return dd(context: context, children)
            case "del": return del(context: context, children)
            case "details": return details(context: context, children)
            case "dfn": return dfn(context: context, children)
            case "dialog": return dialog(context: context, children)
            case "div": return div(context: context, children)
            case "dl": return dl(context: context, children)
            case "dt": return dt(context: context, children)
            case "em": return em(context: context, children)
            case "embed": return embed(context: context, children)
            case "fencedframe": return fencedframe(context: context, children)
            case "fieldset": return fieldset(context: context, children)
            case "figcaption": return figcaption(context: context, children)
            case "figure": return figure(context: context, children)
            case "footer": return footer(context: context, children)
            case "form": return form(context: context, children)
            case "h1": return h1(context: context, children)
            case "h2": return h2(context: context, children)
            case "h3": return h3(context: context, children)
            case "h4": return h4(context: context, children)
            case "h5": return h5(context: context, children)
            case "h6": return h6(context: context, children)
            case "head": return head(context: context, children)
            case "header": return header(context: context, children)
            case "hgroup": return hgroup(context: context, children)
            case "hr": return hr(context: context, children)
            case "html": return html(context: context, children)
            case "i": return i(context: context, children)
            case "iframe": return iframe(context: context, children)
            case "img": return img(context: context, children)
            case "input": return input(context: context, children)
            case "ins": return ins(context: context, children)
            case "kbd": return kbd(context: context, children)
            case "label": return label(context: context, children)
            case "legend": return legend(context: context, children)
            case "li": return li(context: context, children)
            case "link": return link(context: context, children)
            case "main": return main(context: context, children)
            case "map": return map(context: context, children)
            case "mark": return mark(context: context, children)
            case "menu": return menu(context: context, children)
            case "meta": return meta(context: context, children)
            case "meter": return meter(context: context, children)
            case "nav": return nav(context: context, children)
            case "noscript": return noscript(context: context, children)
            case "object": return object(context: context, children)
            case "ol": return ol(context: context, children)
            case "optgroup": return optgroup(context: context, children)
            case "option": return option(context: context, children)
            case "output": return output(context: context, children)
            case "p": return p(context: context, children)
            case "picture": return picture(context: context, children)
            case "portal": return portal(context: context, children)
            case "pre": return pre(context: context, children)
            case "progress": return progress(context: context, children)
            case "q": return q(context: context, children)
            case "rp": return rp(context: context, children)
            case "rt": return rt(context: context, children)
            case "ruby": return ruby(context: context, children)
            case "s": return s(context: context, children)
            case "samp": return samp(context: context, children)
            case "script": return script(context: context, children)
            case "search": return search(context: context, children)
            case "section": return section(context: context, children)
            case "select": return select(context: context, children)
            case "slot": return slot(context: context, children)
            case "small": return small(context: context, children)
            case "source": return source(context: context, children)
            case "span": return span(context: context, children)
            case "strong": return strong(context: context, children)
            case "style": return style(context: context, children)
            case "sub": return sub(context: context, children)
            case "summary": return summary(context: context, children)
            case "sup": return sup(context: context, children)
            case "table": return table(context: context, children)
            case "tbody": return tbody(context: context, children)
            case "td": return td(context: context, children)
            case "template": return template(context: context, children)
            case "textarea": return textarea(context: context, children)
            case "tfoot": return tfoot(context: context, children)
            case "th": return th(context: context, children)
            case "thead": return thead(context: context, children)
            case "time": return time(context: context, children)
            case "title": return title(context: context, children)
            case "tr": return tr(context: context, children)
            case "track": return track(context: context, children)
            case "u": return u(context: context, children)
            case "ul": return ul(context: context, children)
            case "variable": return variable(context: context, children)
            case "video": return video(context: context, children)
            case "wbr": return wbr(context: context, children)

            case "custom": return custom(context: context, children)
            default: return nil
        }
    }
}