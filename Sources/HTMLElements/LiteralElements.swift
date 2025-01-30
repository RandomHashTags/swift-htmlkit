//
//  Elements.swift
//
//
//  Created by Evan Anderson on 11/16/24.
//

import CSS
import HTMLAttributes
import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

@freestanding(
    declaration,
    names:
        named(a),
        named(abbr),
        named(address),
        named(area),
        named(article),
        named(aside),
        named(audio),
        named(b),
        named(base),
        named(bdi),
        named(bdo),
        named(blockquote),
        named(body),
        named(br),
        named(button),
        named(canvas),
        named(caption),
        named(cite),
        named(code),
        named(col),
        named(colgroup),
        named(data),
        named(datalist),
        named(dd),
        named(del),
        named(details),
        named(dfn),
        named(dialog),
        named(div),
        named(dl),
        named(dt),
        named(em),
        named(embed),
        named(fencedframe),
        named(fieldset),
        named(figcaption),
        named(figure),
        named(footer),
        named(form),
        named(frame),
        named(frameset),
        named(h1),
        named(h2),
        named(h3),
        named(h4),
        named(h5),
        named(h6),
        named(head),
        named(header),
        named(hgroup),
        named(hr),
        named(html),
        named(i),
        named(iframe),
        named(img),
        named(input),
        named(ins),
        named(kbd),
        named(label),
        named(legend),
        named(li),
        named(link),
        named(main),
        named(map),
        named(mark),
        named(menu),
        named(meta),
        named(meter),
        named(nav),
        named(noscript),
        named(object),
        named(ol),
        named(optgroup),
        named(option),
        named(output),
        named(p),
        named(picture),
        named(portal),
        named(pre),
        named(progress),
        named(q),
        named(rp),
        named(rt),
        named(ruby),
        named(s),
        named(samp),
        named(script),
        named(search),
        named(section),
        named(select),
        named(slot),
        named(small),
        named(source),
        named(span),
        named(strong),
        named(style),
        named(sub),
        named(summary),
        named(sup),
        named(table),
        named(tbody),
        named(td),
        named(template),
        named(textarea),
        named(tfoot),
        named(th),
        named(thead),
        named(time),
        named(title),
        named(tr),
        named(track),
        named(u),
        named(ul),
        named(variable),
        named(video),
        named(wbr)
)
macro HTMLElements(
    _ elements: [HTMLElementType:[(String, HTMLElementValueType)]]
) = #externalMacro(module: "HTMLKitUtilityMacros", type: "HTMLElements")

#HTMLElements([
    // MARK: A
    .a : [
        ("attributionsrc", .array(of: .string)),
        ("download", .attribute),
        ("href", .string),
        ("hreflang", .string),
        ("ping", .array(of: .string)),
        ("referrerpolicy", .attribute),
        ("rel", .array(of: .attribute)),
        ("target", .attribute),
        ("type", .string)
    ],
    .abbr : [],
    .address : [],
    .area : [
        ("alt", .string),
        ("coords", .array(of: .int)),
        ("download", .attribute),
        ("href", .string),
        ("shape", .attribute),
        ("ping", .array(of: .string)),
        ("referrerpolicy", .attribute),
        ("rel", .array(of: .attribute)),
        ("target", .otherAttribute("formtarget"))
    ],
    .article : [],
    .aside : [],
    .audio : [
        ("autoplay", .bool),
        ("controls", .booleanDefaultValue(true)),
        ("controlslist", .array(of: .attribute)),
        ("crossorigin", .attribute),
        ("disableremoteplayback", .bool),
        ("loop", .bool),
        ("muted", .bool),
        ("preload", .attribute),
        ("src", .string)
    ],

    // MARK: B
    .b : [],
    .base : [
        ("href", .string),
        ("target", .otherAttribute("formtarget"))
    ],
    .bdi : [],
    .bdo : [],
    .blockquote : [
        ("cite", .string)
    ],
    .body : [],
    .br : [],
    .button : [
        ("command", .attribute),
        ("commandfor", .string),
        ("disabled", .bool),
        ("form", .string),
        ("formaction", .string),
        ("formenctype", .attribute),
        ("formmethod", .attribute),
        ("formnovalidate", .bool),
        ("formtarget", .attribute),
        ("name", .string),
        ("popovertarget", .string),
        ("popovertargetaction", .attribute),
        ("type", .otherAttribute("buttontype")),
        ("value", .string)
    ],

    // MARK: C
    .canvas : [
        ("height", .cssUnit),
        ("width", .cssUnit)
    ],
    .caption : [],
    .cite : [],
    .code : [],
    .col : [
        ("span", .int)
    ],
    .colgroup : [
        ("span", .int)
    ],

    // MARK: D
    .data : [
        ("value", .string)
    ],
    .datalist : [],
    .dd : [],
    .del : [
        ("cite", .string),
        ("datetime", .string)
    ],
    .details : [
        ("open", .bool),
        ("name", .string)
    ],
    .dfn : [],
    .dialog : [
        ("open", .bool)
    ],
    .div : [],
    .dl : [],
    .dt : [],

    // MARK: E
    .em : [],
    .embed : [
        ("height", .cssUnit),
        ("src", .string),
        ("type", .string),
        ("width", .cssUnit)
    ],

    // MARK: F
    .fencedframe : [
        ("allow", .string),
        ("height", .int),
        ("width", .int)
    ],
    .fieldset : [
        ("disabled", .bool),
        ("form", .string),
        ("name", .string)
    ],
    .figcaption : [],
    .figure : [],
    .footer : [],
    .form : [
        ("acceptCharset", .array(of: .string)),
        ("action", .string),
        ("autocomplete", .attribute),
        ("enctype", .otherAttribute("formenctype")),
        ("method", .string),
        ("name", .string),
        ("novalidate", .bool),
        ("rel", .array(of: .attribute)),
        ("target", .attribute)
    ],

    // MARK: H
    .h1 : [],
    .h2 : [],
    .h3 : [],
    .h4 : [],
    .h5 : [],
    .h6 : [],
    .head : [],
    .header : [],
    .hgroup : [],
    .hr : [],
    .html : [
        ("lookupFiles", .array(of: .string)),
        ("xmlns", .string)
    ],

    // MARK: I
    .i : [],
    .iframe : [
        ("allow", .array(of: .string)),
        ("browsingtopics", .bool),
        ("credentialless", .bool),
        ("csp", .string),
        ("height", .cssUnit),
        ("loading", .attribute),
        ("name", .string),
        ("referrerpolicy", .attribute),
        ("sandbox", .array(of: .attribute)),
        ("src", .string),
        ("srcdoc", .string),
        ("width", .cssUnit)
    ],
    .img : [
        ("alt", .string),
        ("attributionsrc", .array(of: .string)),
        ("crossorigin", .attribute),
        ("decoding", .attribute),
        ("elementtiming", .string),
        ("fetchpriority", .attribute),
        ("height", .cssUnit),
        ("ismap", .bool),
        ("loading", .attribute),
        ("referrerpolicy", .attribute),
        ("sizes", .array(of: .string)),
        ("src", .string),
        ("srcset", .array(of: .string)),
        ("width", .cssUnit),
        ("usemap", .string)
    ],
    .input : [
        ("accept", .array(of: .string)),
        ("alt", .string),
        ("autocomplete", .array(of: .string)),
        ("capture", .attribute),
        ("checked", .bool),
        ("dirname", .attribute),
        ("disabled", .bool),
        ("form", .string),
        ("formaction", .string),
        ("formenctype", .attribute),
        ("formmethod", .attribute),
        ("formnovalidate", .bool),
        ("formtarget", .attribute),
        ("height", .cssUnit),
        ("list", .string),
        ("max", .int),
        ("maxlength", .int),
        ("min", .int),
        ("minlength", .int),
        ("multiple", .bool),
        ("name", .string),
        ("pattern", .string),
        ("placeholder", .string),
        ("popovertarget", .string),
        ("popovertargetaction", .attribute),
        ("readonly", .bool),
        ("required", .bool),
        ("size", .string),
        ("src", .string),
        ("step", .float),
        ("type", .otherAttribute("inputtype")),
        ("value", .string),
        ("width", .cssUnit)
    ],
    .ins : [
        ("cite", .string),
        ("datetime", .string)
    ],

    // MARK: K
    .kbd : [],
    
    // MARK: L
    .label : [
        ("for", .string)
    ],
    .legend : [],
    .li : [
        ("value", .int)
    ],
    .link : [
        ("as", .otherAttribute("`as`")),
        ("blocking", .array(of: .attribute)),
        ("crossorigin", .attribute),
        ("disabled", .bool),
        ("fetchpriority", .attribute),
        ("href", .string),
        ("hreflang", .string),
        ("imagesizes", .array(of: .string)),
        ("imagesrcset", .array(of: .string)),
        ("integrity", .string),
        ("media", .string),
        ("referrerpolicy", .attribute),
        ("rel", .attribute),
        ("size", .string),
        ("type", .string)
    ],

    // MARK: M
    .main : [],
    .map : [
        ("name", .string)
    ],
    .mark : [],
    .menu : [],
    .meta : [
        ("charset", .string),
        ("content", .string),
        ("httpEquiv", .otherAttribute("httpequiv")),
        ("name", .string)
    ],
    .meter : [
        ("value", .float),
        ("min", .float),
        ("max", .float),
        ("low", .float),
        ("high", .float),
        ("optimum", .float),
        ("form", .string)
    ],

    // MARK: N
    .nav : [],
    .noscript : [],

    // MARK: O
    .object : [
        ("archive", .array(of: .string)),
        ("border", .int),
        ("classid", .string),
        ("codebase", .string),
        ("codetype", .string),
        ("data", .string),
        ("declare", .bool),
        ("form", .string),
        ("height", .cssUnit),
        ("name", .string),
        ("standby", .string),
        ("type", .string),
        ("usemap", .string),
        ("width", .cssUnit)
    ],
    .ol : [
        ("reversed", .bool),
        ("start", .int),
        ("type", .otherAttribute("numberingtype"))
    ],
    .optgroup : [
        ("disabled", .bool),
        ("label", .string)
    ],
    .option : [
        ("disabled", .bool),
        ("label", .string),
        ("selected", .bool),
        ("value", .string)
    ],
    .output : [
        ("for", .array(of: .string)),
        ("form", .string),
        ("name", .string)
    ],

    // MARK: P
    .p : [],
    .picture : [],
    .portal : [
        ("referrerpolicy", .attribute),
        ("src", .string)
    ],
    .pre : [],
    .progress : [
        ("max", .float),
        ("value", .float)
    ],

    // MARK: Q
    .q : [
        ("cite", .string)
    ],

    // MARK: R
    .rp : [],
    .rt : [],
    .ruby : [],

    // MARK: S
    .s : [],
    .samp : [],
    .script : [
        ("async", .bool),
        ("attributionsrc", .array(of: .string)),
        ("blocking", .attribute),
        ("crossorigin", .attribute),
        ("defer", .bool),
        ("fetchpriority", .attribute),
        ("integrity", .string),
        ("nomodule", .bool),
        ("referrerpolicy", .attribute),
        ("src", .string),
        ("type", .otherAttribute("scripttype"))
    ],
    .search : [],
    .section : [],
    .select : [
        ("disabled", .bool),
        ("form", .string),
        ("multiple", .bool),
        ("name", .string),
        ("required", .bool),
        ("size", .int)
    ],
    .slot : [
        ("name", .string)
    ],
    .small : [],
    .source : [
        ("type", .string),
        ("src", .string),
        ("srcset", .array(of: .string)),
        ("sizes", .array(of: .string)),
        ("media", .string),
        ("height", .int),
        ("width", .int)
    ],
    .span : [],
    .strong : [],
    .style : [
        ("blocking", .attribute),
        ("media", .string)
    ],
    .sub : [],
    .summary : [],
    .sup : [],

    // MARK: T
    .table : [],
    .tbody : [],
    .td : [
        ("colspan", .int),
        ("headers", .array(of: .string)),
        ("rowspan", .int)
    ],
    .template : [
        ("shadowrootclonable", .attribute),
        ("shadowrootdelegatesfocus", .bool),
        ("shadowrootmode", .attribute),
        ("shadowrootserializable", .bool)
    ],
    .textarea : [
        ("autocomplete", .array(of: .string)),
        ("autocorrect", .attribute),
        ("cols", .int),
        ("dirname", .attribute),
        ("disabled", .bool),
        ("form", .string),
        ("maxlength", .int),
        ("minlength", .int),
        ("name", .string),
        ("placeholder", .string),
        ("readonly", .bool),
        ("required", .bool),
        ("rows", .int),
        ("wrap", .attribute)
    ],
    .tfoot : [],
    .th : [
        ("abbr", .string),
        ("colspan", .int),
        ("headers", .array(of: .string)),
        ("rowspan", .int),
        ("scope", .attribute)
    ],
    .thead : [],
    .time : [
        ("datetime", .string)
    ],
    .title : [],
    .tr : [],
    .track : [
        ("default", .booleanDefaultValue(true)),
        ("kind", .attribute),
        ("label", .string),
        ("src", .string),
        ("srclang", .string)
    ],

    // MARK: U
    .u : [],
    .ul : [],

    // MARK: V
    .variable : [],
    .video : [
        ("autoplay", .bool),
        ("controls", .bool),
        ("controlslist", .array(of: .attribute)),
        ("crossorigin", .attribute),
        ("disablepictureinpicture", .bool),
        ("disableremoteplayback", .bool),
        ("height", .cssUnit),
        ("loop", .bool),
        ("muted", .bool),
        ("playsinline", .booleanDefaultValue(true)),
        ("poster", .string),
        ("preload", .attribute),
        ("src", .string),
        ("width", .cssUnit)
    ],

    // MARK: W
    .wbr : []
])