//
//  Elements.swift
//
//
//  Created by Evan Anderson on 11/16/24.
//

@attached(member, names: arbitrary)
macro HTMLElements(
    _ elements: [HTMLElementType:HTMLElementData]
) = #externalMacro(module: "HTMLKitUtilityMacros", type: "HTMLElements")

// MARK: HTMLElementData
struct HTMLElementData {
    var attributes:[Attribute]

    init(_ attributes: [Attribute] = []) {
        self.attributes = attributes
    }
}
extension HTMLElementData {
    struct Attribute {
        let key:String
        let valueType:ValueType

        init(_ key: String, _ valueType: ValueType) {
            self.key = key
            self.valueType = valueType
        }

        indirect enum ValueType {
            case string
            case int
            case float
            case bool
            case booleanDefaultValue(Bool)
            case attribute
            case otherAttribute(String)
            case cssUnit
            case array(of: ValueType)
        }
    }
}

// MARK: HTML
/*
public struct HTML<T: ExpressibleByStringLiteral> {
    public let tag:String
    public let isVoid:Bool
    public let globalAttributes:[HTMLElementAttribute]
    public let attributes:[(String, String)]
    public let innerHTML:[HTML<T>]

    public var string : String {
        "<" + tag + ">" + innerHTML.map({ $0.string }).joined() + (isVoid ? "" : "</" + tag + ">")
    }
}*/

@HTMLElements([
    // MARK: A
    .a : .init([
        .init("attributionsrc", .array(of: .string)),
        .init("download", .attribute),
        .init("href", .string),
        .init("hreflang", .string),
        .init("ping", .array(of: .string)),
        .init("referrerpolicy", .attribute),
        .init("rel", .array(of: .attribute)),
        .init("target", .attribute),
        .init("type", .string)
    ]),
    .abbr : .init(),
    .address : .init(),
    .area : .init([
        .init("alt", .string),
        .init("coords", .array(of: .int)),
        .init("download", .attribute),
        .init("href", .string),
        .init("shape", .attribute),
        .init("ping", .array(of: .string)),
        .init("referrerpolicy", .attribute),
        .init("rel", .array(of: .attribute)),
        .init("target", .otherAttribute("formtarget"))
    ]),
    .article : .init(),
    .aside : .init(),
    .audio : .init([
        .init("autoplay", .bool),
        .init("controls", .booleanDefaultValue(true)),
        .init("controlslist", .array(of: .attribute)),
        .init("crossorigin", .attribute),
        .init("disableremoteplayback", .bool),
        .init("loop", .bool),
        .init("muted", .bool),
        .init("preload", .attribute),
        .init("src", .string)
    ]),

    // MARK: B
    .b : .init(),
    .base : .init([
        .init("href", .string),
        .init("target", .otherAttribute("formtarget"))
    ]),
    .bdi : .init(),
    .bdo : .init(),
    .blockquote : .init([
        .init("cite", .string)
    ]),
    .body : .init(),
    .br : .init(),
    .button : .init([
        .init("command", .attribute),
        .init("commandfor", .string),
        .init("disabled", .bool),
        .init("form", .string),
        .init("formaction", .string),
        .init("formenctype", .attribute),
        .init("formmethod", .attribute),
        .init("formnovalidate", .bool),
        .init("formtarget", .attribute),
        .init("name", .string),
        .init("popovertarget", .string),
        .init("popovertargetaction", .attribute),
        .init("type", .otherAttribute("buttontype")),
        .init("value", .string)
    ]),

    // MARK: C
    .canvas : .init([
        .init("height", .cssUnit),
        .init("width", .cssUnit)
    ]),
    .caption : .init(),
    .cite : .init(),
    .code : .init(),
    .col : .init([
        .init("span", .int)
    ]),
    .colgroup : .init([
        .init("span", .int)
    ]),

    // MARK: D
    .data : .init([
        .init("value", .string)
    ]),
    .datalist : .init(),
    .dd : .init(),
    .del : .init([
        .init("cite", .string),
        .init("datetime", .string)
    ]),
    .details : .init([
        .init("open", .bool),
        .init("name", .string)
    ]),
    .dfn : .init(),
    .dialog : .init([
        .init("open", .bool)
    ]),
    .div : .init(),
    .dl : .init(),
    .dt : .init(),

    // MARK: E
    .em : .init(),
    .embed : .init([
        .init("height", .cssUnit),
        .init("src", .string),
        .init("type", .string),
        .init("width", .cssUnit)
    ]),

    // MARK: F
    .fencedframe : .init([
        .init("allow", .string),
        .init("height", .int),
        .init("width", .int)
    ]),
    .fieldset : .init([
        .init("disabled", .bool),
        .init("form", .string),
        .init("name", .string)
    ]),
    .figcaption : .init(),
    .figure : .init(),
    .footer : .init(),
    .form : .init([
        .init("acceptCharset", .array(of: .string)),
        .init("action", .string),
        .init("autocomplete", .attribute),
        .init("enctype", .otherAttribute("formenctype")),
        .init("method", .string),
        .init("name", .string),
        .init("novalidate", .bool),
        .init("rel", .array(of: .attribute)),
        .init("target", .attribute)
    ]),

    // MARK: H
    .h1 : .init(),
    .h2 : .init(),
    .h3 : .init(),
    .h4 : .init(),
    .h5 : .init(),
    .h6 : .init(),
    .head : .init(),
    .header : .init(),
    .hgroup : .init(),
    .hr : .init(),

    // MARK: I
    .i : .init(),
    .iframe : .init([
        .init("allow", .array(of: .string)),
        .init("browsingtopics", .bool),
        .init("credentialless", .bool),
        .init("csp", .string),
        .init("height", .cssUnit),
        .init("loading", .attribute),
        .init("name", .string),
        .init("referrerpolicy", .attribute),
        .init("sandbox", .array(of: .attribute)),
        .init("src", .string),
        .init("srcdoc", .string),
        .init("width", .cssUnit)
    ]),
    .img : .init([
        .init("alt", .string),
        .init("attributionsrc", .array(of: .string)),
        .init("crossorigin", .attribute),
        .init("decoding", .attribute),
        .init("elementtiming", .string),
        .init("fetchpriority", .attribute),
        .init("height", .cssUnit),
        .init("ismap", .bool),
        .init("loading", .attribute),
        .init("referrerpolicy", .attribute),
        .init("sizes", .array(of: .string)),
        .init("src", .string),
        .init("srcset", .array(of: .string)),
        .init("width", .cssUnit),
        .init("usemap", .string)
    ]),
    .input : .init([
        .init("accept", .array(of: .string)),
        .init("alt", .string),
        .init("autocomplete", .array(of: .string)),
        .init("capture", .attribute),
        .init("checked", .bool),
        .init("dirname", .attribute),
        .init("disabled", .bool),
        .init("form", .string),
        .init("formaction", .string),
        .init("formenctype", .attribute),
        .init("formmethod", .attribute),
        .init("formnovalidate", .bool),
        .init("formtarget", .attribute),
        .init("height", .cssUnit),
        .init("list", .string),
        .init("max", .int),
        .init("maxlength", .int),
        .init("min", .int),
        .init("minlength", .int),
        .init("multiple", .bool),
        .init("name", .string),
        .init("pattern", .string),
        .init("placeholder", .string),
        .init("popovertarget", .string),
        .init("popovertargetaction", .attribute),
        .init("readonly", .bool),
        .init("required", .bool),
        .init("size", .string),
        .init("src", .string),
        .init("step", .float),
        .init("type", .otherAttribute("inputtype")),
        .init("value", .string),
        .init("width", .cssUnit)
    ]),
    .ins : .init([
        .init("cite", .string),
        .init("datetime", .string)
    ]),

    // MARK: K
    .kbd : .init(),
    
    // MARK: L
    .label : .init([
        .init("for", .string)
    ]),
    .legend : .init(),
    .li : .init([
        .init("value", .int)
    ]),
    .link : .init([
        .init("as", .otherAttribute("`as`")),
        .init("blocking", .array(of: .attribute)),
        .init("crossorigin", .attribute),
        .init("disabled", .bool),
        .init("fetchpriority", .attribute),
        .init("href", .string),
        .init("hreflang", .string),
        .init("imagesizes", .array(of: .string)),
        .init("imagesrcset", .array(of: .string)),
        .init("integrity", .string),
        .init("media", .string),
        .init("referrerpolicy", .attribute),
        .init("rel", .attribute),
        .init("size", .string),
        .init("type", .string)
    ]),

    // MARK: M
    .main : .init(),
    .map : .init([
        .init("name", .string)
    ]),
    .mark : .init(),
    .menu : .init(),
    .meta : .init([
        .init("charset", .string),
        .init("content", .string),
        .init("httpEquiv", .otherAttribute("httpequiv")),
        .init("name", .string)
    ]),
    .meter : .init([
        .init("value", .float),
        .init("min", .float),
        .init("max", .float),
        .init("low", .float),
        .init("high", .float),
        .init("optimum", .float),
        .init("form", .string)
    ]),

    // MARK: N
    .nav : .init(),
    .noscript : .init(),

    // MARK: O
    .object : .init([
        .init("archive", .array(of: .string)),
        .init("border", .int),
        .init("classid", .string),
        .init("codebase", .string),
        .init("codetype", .string),
        .init("data", .string),
        .init("declare", .bool),
        .init("form", .string),
        .init("height", .cssUnit),
        .init("name", .string),
        .init("standby", .string),
        .init("type", .string),
        .init("usemap", .string),
        .init("width", .cssUnit)
    ]),
    .ol : .init([
        .init("reversed", .bool),
        .init("start", .int),
        .init("type", .otherAttribute("numberingtype"))
    ]),
    .optgroup : .init([
        .init("disabled", .bool),
        .init("label", .string)
    ]),
    .option : .init([
        .init("disabled", .bool),
        .init("label", .string),
        .init("selected", .bool),
        .init("value", .string)
    ]),
    .output : .init([
        .init("for", .array(of: .string)),
        .init("form", .string),
        .init("name", .string)
    ]),

    // MARK: P
    .p : .init(),
    .picture : .init(),
    .portal : .init([
        .init("referrerpolicy", .attribute),
        .init("src", .string)
    ]),
    .pre : .init(),
    .progress : .init([
        .init("max", .float),
        .init("value", .float)
    ]),

    // MARK: Q
    .q : .init([
        .init("cite", .string)
    ]),

    // MARK: R
    .rp : .init(),
    .rt : .init(),
    .ruby : .init(),

    // MARK: S
    .s : .init(),
    .samp : .init(),
    .script : .init([
        .init("async", .bool),
        .init("attributionsrc", .array(of: .string)),
        .init("blocking", .attribute),
        .init("crossorigin", .attribute),
        .init("defer", .bool),
        .init("fetchpriority", .attribute),
        .init("integrity", .string),
        .init("nomodule", .bool),
        .init("referrerpolicy", .attribute),
        .init("src", .string),
        .init("type", .otherAttribute("scripttype"))
    ]),
    .search : .init(),
    .section : .init(),
    .select : .init([
        .init("disabled", .bool),
        .init("form", .string),
        .init("multiple", .bool),
        .init("name", .string),
        .init("required", .bool),
        .init("size", .int)
    ]),
    .slot : .init([
        .init("name", .string)
    ]),
    .small : .init(),
    .source : .init([
        .init("type", .string),
        .init("src", .string),
        .init("srcset", .array(of: .string)),
        .init("sizes", .array(of: .string)),
        .init("media", .string),
        .init("height", .int),
        .init("width", .int)
    ]),
    .span : .init(),
    .strong : .init(),
    .style : .init([
        .init("blocking", .attribute),
        .init("media", .string)
    ]),
    .sub : .init(),
    .summary : .init(),
    .sup : .init(),

    // MARK: T
    .table : .init(),
    .tbody : .init(),
    .td : .init([
        .init("colspan", .int),
        .init("headers", .array(of: .string)),
        .init("rowspan", .int)
    ]),
    .template : .init([
        .init("shadowrootclonable", .attribute),
        .init("shadowrootdelegatesfocus", .bool),
        .init("shadowrootmode", .attribute),
        .init("shadowrootserializable", .bool)
    ]),
    .textarea : .init([
        .init("autocomplete", .array(of: .string)),
        .init("autocorrect", .attribute),
        .init("cols", .int),
        .init("dirname", .attribute),
        .init("disabled", .bool),
        .init("form", .string),
        .init("maxlength", .int),
        .init("minlength", .int),
        .init("name", .string),
        .init("placeholder", .string),
        .init("readonly", .bool),
        .init("required", .bool),
        .init("rows", .int),
        .init("wrap", .attribute)
    ]),
    .tfoot : .init(),
    .th : .init([
        .init("abbr", .string),
        .init("colspan", .int),
        .init("headers", .array(of: .string)),
        .init("rowspan", .int),
        .init("scope", .attribute)
    ]),
    .thead : .init(),
    .time : .init([
        .init("datetime", .string)
    ]),
    .title : .init(),
    .tr : .init(),
    .track : .init([
        .init("default", .booleanDefaultValue(true)),
        .init("kind", .attribute),
        .init("label", .string),
        .init("src", .string),
        .init("srclang", .string)
    ]),

    // MARK: U
    .u : .init(),
    .ul : .init(),

    // MARK: V
    .var : .init(),
    .video : .init([
        .init("autoplay", .bool),
        .init("controls", .bool),
        .init("controlslist", .array(of: .attribute)),
        .init("crossorigin", .attribute),
        .init("disablepictureinpicture", .bool),
        .init("disableremoteplayback", .bool),
        .init("height", .cssUnit),
        .init("loop", .bool),
        .init("muted", .bool),
        .init("playsinline", .booleanDefaultValue(true)),
        .init("poster", .string),
        .init("preload", .attribute),
        .init("src", .string),
        .init("width", .cssUnit)
    ]),

    // MARK: W
    .wbr : .init()
])
public enum HTML {
    case custom
    
}