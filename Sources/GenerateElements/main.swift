//
//  main.swift
//
//
//  Created by Evan Anderson on 12/22/24.
//

// generate the html element files using the following command:
/*
  swiftc main.swift ../HTMLKitUtilities/HTMLEncoding.swift \
  ../HTMLKitUtilities/attributes/HTMLElementAttribute.swift \
  ../HTMLKitUtilities/attributes/HTMLElementAttributeExtra.swift \
  ../HTMLKitUtilities/attributes/HTMX.swift \
  ../HTMLKitUtilities/attributes/HTMXAttributes.swift \
  -D GENERATE_ELEMENTS && ./main
*/

#if canImport(Foundation) && GENERATE_ELEMENTS

// Why do we do it this way?
// - The documentation doesn't link correctly if we generate from a macro

import Foundation

let suffix:String = "/swift-htmlkit/Sources/HTMLElements/", writeTo:String
#if os(Linux)
writeTo = "/home/paradigm/Desktop/GitProjects" + suffix
#elseif os(macOS)
writeTo = "/Users/randomhashtags/GitProjects" + suffix
#else
#error("no write path declared for platform")
#endif

let now:String = Date.now.formatted(date: .abbreviated, time: .complete)
let template:String = """
//
//  %elementName%.swift
//
//
//  Generated \(now).
//

import SwiftSyntax

/// The `%tagName%`%aliases% HTML element.%elementDocumentation%
public struct %elementName% : HTMLElement {%variables%
}

public extension %elementName% {
    enum AttributeKeys {%customAttributeCases%
    }
}
"""
let defaultVariables:[HTMLElementVariable] = [
    get(public: true, mutable: true, name: "trailingSlash", valueType: .bool, defaultValue: "false"),
    get(public: true, mutable: true, name: "escaped", valueType: .bool, defaultValue: "false"),
    get(public: false, mutable: true, name: "fromMacro", valueType: .bool, defaultValue: "false"),
    get(public: false, mutable: true, name: "encoding", valueType: .custom("HTMLEncoding"), defaultValue: ".string"),
    get(public: true, mutable: true, name: "innerHTML", valueType: .array(of: .custom("CustomStringConvertible"))),
    get(public: true, mutable: true, name: "attributes", valueType: .array(of: .custom("HTMLElementAttribute"))),
]

let indent1:String = "\n    "
let indent2:String = indent1 + "    "

for (elementType, customAttributes) in attributes().filter({ $0.key == .a }) {
    var variablesString:String = ""
    
    var variables:[HTMLElementVariable] = defaultVariables
    variables.append(get(public: true, mutable: false, name: "tag", valueType: .string, defaultValue: "\"%tagName%\""))
    variables.append(get(public: true, mutable: false, name: "isVoid", valueType: .bool, defaultValue: "\(elementType.isVoid)"))
    for attribute in customAttributes {
        variables.append(attribute)
    }

    for variable in variables.sorted(by: {
        guard $0.memoryLayoutAlignment == $1.memoryLayoutAlignment else { return $0.memoryLayoutAlignment > $1.memoryLayoutAlignment }
        guard $0.memoryLayoutSize == $1.memoryLayoutSize else { return $0.memoryLayoutSize > $1.memoryLayoutSize }
        guard $0.memoryLayoutStride == $1.memoryLayoutStride else { return $0.memoryLayoutStride > $1.memoryLayoutStride }
        return $0.name < $1.name
    }) {
        variablesString += indent1 + variable.description
    }
    
    variables = variables.sorted(by: { $0.name <= $1.name })
    var customAttributeCases:String = ""
    for variable in variables {
        customAttributeCases += indent2 + "case " + variable.name + "(" + variable.valueType.annotation(variableName: variable.name) + " = " + variable.valueType.defaultOptionalValue + ")"
    }
    
    var code:String = template
    code.replace("%variables%", with: variablesString)
    var elementDocumentation:[String] = elementType.documentation
    elementDocumentation.append(contentsOf: [" ", "[Read more](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/%tagName%)."])
    let elementDocumentationString:String = "\n/// \n" + elementDocumentation.map({ "/// " + $0 }).joined(separator: "\n")
    code.replace("%elementDocumentation%", with: elementDocumentationString)
    code.replace("%tagName%", with: elementType.tagName)

    let aliases:String = elementType.aliases.isEmpty ? "" : " (" + elementType.aliases.map({ "_" + $0 + "_" }).joined(separator: ", ") + ")"
    code.replace("%aliases%", with: aliases)
    code.replace("%elementName%", with: elementType.rawValue)
    code.replace("%customAttributeCases%", with: customAttributeCases)
    print(code)
    
    /*let fileName:String = elementType.rawValue + ".swift"
    let filePath:String = writeTo + fileName
    if FileManager.default.fileExists(atPath: filePath) {
        try FileManager.default.removeItem(atPath: filePath)
    }*/
}
extension Array where Element == HTMLElementVariable {
    func filterAndSort(_ predicate: (Element) -> Bool) -> [Element] {
        return filter(predicate).sorted(by: { $0.mutable == $1.mutable ? $0.public == $1.public ? $0.name < $1.name : !$0.public : !$0.mutable })
    }
}

// MARK: HTMLElementVariable
struct HTMLElementVariable : Hashable {
    let name:String
    let documentation:[String]
    let defaultValue:String?
    let `public`:Bool
    let mutable:Bool
    let valueType:HTMLElementValueType
    let memoryLayoutAlignment:Int
    let memoryLayoutSize:Int
    let memoryLayoutStride:Int
    
    init(
        public: Bool,
        mutable: Bool,
        name: String,
        documentation: [String] = [],
        valueType: HTMLElementValueType,
        defaultValue: String? = nil,
        memoryLayout: (alignment: Int, size: Int, stride: Int)
    ) {
        switch name {
        case "for", "default", "defer", "as":
            self.name = "`" + name + "`"
        default:
            self.name = name
        }
        self.documentation = documentation
        self.defaultValue = defaultValue
        self.public = `public`
        self.mutable = mutable
        self.valueType = valueType
        (memoryLayoutAlignment, memoryLayoutSize, memoryLayoutStride) = (memoryLayout.alignment, memoryLayout.size, memoryLayout.stride)
    }
    
    var description : String {
        var string:String = ""
        for documentation in documentation {
            string += indent1 + "/// " + documentation
        }
        if !string.isEmpty {
            string += indent1
        }
        string += (`public` ? "public" : "private") + " " + (mutable ? "var" : "let") + " " + name + ":" + valueType.annotation(variableName: name) + (defaultValue != nil ? " = " + defaultValue! : "")
        return string
    }
}

// MARK: HTMLElementType
enum HTMLElementType : String, CaseIterable {
    case html
    
    case a
    case abbr
    case address
    case area
    case article
    case aside
    case audio

    case b
    case base
    case bdi
    case bdo
    case blockquote
    case body
    case br
    case button

    case canvas
    case caption
    case cite
    case code
    case col
    case colgroup

    case data
    case datalist
    case dd
    case del
    case details
    case dfn
    case dialog
    case div
    case dl
    case dt

    case em
    case embed

    case fencedframe
    case fieldset
    case figcaption
    case figure
    case footer
    case form

    case h1, h2, h3, h4, h5, h6
    case head
    case header
    case hgroup
    case hr
    
    case i
    case iframe
    case img
    case input
    case ins

    case kbd

    case label
    case legend
    case li
    case link

    case main
    case map
    case mark
    case menu
    case meta
    case meter

    case nav
    case noscript

    case object
    case ol
    case optgroup
    case option
    case output

    case p
    case picture
    case portal
    case pre
    case progress

    case q

    case rp
    case rt
    case ruby
    
    case s
    case samp
    case script
    case search
    case section
    case select
    case slot
    case small
    case source
    case span
    case strong
    case style
    case sub
    case summary
    case sup

    case table
    case tbody
    case td
    case template
    case textarea
    case tfoot
    case th
    case thead
    case time
    case title
    case tr
    case track

    case u
    case ul

    case variable // var
    case video

    case wbr

    var isVoid : Bool {
        switch self {
        case .area, .base, .br, .col, .embed, .hr, .img, .input, .link, .meta, .source, .track, .wbr:
            return true
        default:
            return false
        }
    }
    
    var tagName : String {
        switch self {
        case .variable: return "var"
        default: return rawValue
        }
    }

    var aliases : [String] {
        var aliases:Set<String>
        switch self {
            case .a: aliases = ["anchor"]
            default: aliases = []
        }
        return aliases.sorted(by: { $0 <= $1 })
    }
    
    var documentation : [String] {
        switch self {
        case .a:
            return [
                "[Its `href` attribute](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a#href) creates a hyperlink to web pages, files, email addresses, locations in the same page, or anything else a URL can address.",
                " ",
                "Content within each `<a>` _should_ indicate the link's destination. If the `href` attribute is present, pressing the enter key while focused on the `<a>` element will activate it."
            ]
        default: return []
        }
    }
}

// MARK: HTMLElementValueType
enum HTMLElementValueType : Hashable {
    case string
    case int
    case float
    case bool
    case booleanDefaultValue(Bool)
    case attribute
    case otherAttribute(String)
    case cssUnit
    indirect case array(of: HTMLElementValueType)
    case custom(String)
    indirect case optional(HTMLElementValueType)
    
    func annotation(variableName: String) -> String {
        switch self {
        case .string: return "String"
        case .int: return "Int"
        case .float: return "Float"
        case .bool: return "Bool"
        case .booleanDefaultValue(_): return "Bool"
        case .attribute: return "HTMLElementAttribute.Extra.\(variableName.lowercased())"
        case .otherAttribute(let item): return "HTMLElementAttribute.Extra.\(item)"
        case .cssUnit: return "HTMLElementAttribute.CSSUnit"
        case .array(let item): return "[" + item.annotation(variableName: variableName.lowercased()) + "]"
        case .custom(let s): return s
        case .optional(let item): return item.annotation(variableName: variableName.lowercased()) + (item.isArray ? "" : "?")
        }
    }
    
    var isBool : Bool {
        switch self {
        case .bool: return true
        case .booleanDefaultValue(_): return true
        case .optional(let item): return item.isBool
        default: return false
        }
    }
    
    var isArray : Bool {
        switch self {
        case .array(_): return true
        case .optional(let item): return item.isArray
        default: return false
        }
    }
    
    var isAttribute : Bool {
        switch self {
        case .attribute, .otherAttribute(_): return true
        case .optional(let item): return item.isAttribute
        default: return false
        }
    }
    
    var defaultOptionalValue : String {
        isArray ? "[]" : isBool ? "false" : "nil"
    }
}

// MARK: Get
func get(
    _ variableName: String,
    _ valueType: HTMLElementValueType,
    _ documentation: HTMLElementVariableDocumentation? = nil
) -> HTMLElementVariable {
    return get(public: true, mutable: true, name: variableName, documentation: documentation?.value ?? [], valueType: .optional(valueType))
}
func get(
    public: Bool,
    mutable: Bool,
    name: String,
    documentation: [String] = [],
    valueType: HTMLElementValueType,
    defaultValue: String? = nil
) -> HTMLElementVariable {
    func get<T>(_ dude: T.Type) -> (Int, Int, Int) {
        return (MemoryLayout<T>.alignment, MemoryLayout<T>.size, MemoryLayout<T>.stride)
    }
    var (alignment, size, stride):(Int, Int, Int) = (-1, -1, -1)
    func layout(vt: HTMLElementValueType) -> (Int, Int, Int) {
        switch vt {
            case .bool, .booleanDefaultValue(_): return get(Bool.self)
            case .string: return get(String.self)
            case .int: return get(Int.self)
            case .float: return get(Float.self)
            case .cssUnit: return get(HTMLElementAttribute.CSSUnit.self)
            case .attribute: return HTMLElementAttribute.Extra.memoryLayout(for: name.lowercased()) ?? (-1, -1, -1)
            case .otherAttribute(let item): return HTMLElementAttribute.Extra.memoryLayout(for: item.lowercased()) ?? (-1, -1, -1)
            case .custom(let s):
                switch s {
                    case "HTMLEncoding": return get(HTMLEncoding.self)
                    default: break
                }
                
            default: break
        }
        return (-1, -1, -1)
    }
    switch valueType {
        case .bool, .string, .int, .float, .cssUnit, .attribute, .custom(_): (alignment, size, stride) = layout(vt: valueType)
        case .optional(let innerVT):
            switch innerVT {
                case .bool, .booleanDefaultValue(_): (alignment, size, stride) = get(Bool.self)
                case .string: (alignment, size, stride) = get(String?.self)
                case .int: (alignment, size, stride) = get(Int?.self)
                case .float: (alignment, size, stride) = get(Float?.self)
                case .cssUnit: (alignment, size, stride) = get(HTMLElementAttribute.CSSUnit?.self)
                case .attribute: (alignment, size, stride) = HTMLElementAttribute.Extra.memoryLayout(for: name.lowercased()) ?? (-1, -1, -1)
                case .otherAttribute(let item): (alignment, size, stride) = HTMLElementAttribute.Extra.memoryLayout(for: item.lowercased()) ?? (-1, -1, -1)
                case .array(_): (alignment, size, stride) = (8, 8, 8)
                default: break
            }
        case .array(_): (alignment, size, stride) = (8, 8, 8)
        default: break
    }
    //var documentation:[String] = documentation
    //documentation.append(contentsOf: ["- Memory Layout:", "  - Alignment: \(alignment)", "  - Size: \(size)", "  - Stride: \(stride)"])
    return HTMLElementVariable(
        public: `public`,
        mutable: mutable,
        name: name,
        documentation: documentation,
        valueType: valueType,
        defaultValue: defaultValue ?? valueType.defaultOptionalValue,
        memoryLayout: (alignment, size, stride)
    )
}

// MARK: Attribute Documentation
enum HTMLElementVariableDocumentation {
    case download
    
    var value : [String] {
        switch self {
        case .download:
            return [
                "Causes the browser to treat the linked URL as a download. Can be used with or without a `filename` value.",
                "",
                "Without a value, the browser will suggest a filename/extension, generated from various sources:",
                "- The [`Content-Disposition`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Disposition) HTTP header",
                "- The final segment in the URL [path](https://developer.mozilla.org/en-US/docs/Web/API/URL/pathname)",
                "- The [media type](https://developer.mozilla.org/en-US/docs/Glossary/MIME_type) (from the [`Content-Type`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type) header, the start of a [`data:` URL](https://developer.mozilla.org/en-US/docs/Web/URI/Schemes/data), or [`Blob.type`](https://developer.mozilla.org/en-US/docs/Web/API/Blob/type) for a [`blob:` URL](https://developer.mozilla.org/en-US/docs/Web/API/URL/createObjectURL_static))"
            ]
        }
    }
}

// MARK: Attributes
func attributes() ->  [HTMLElementType:[HTMLElementVariable]] {
    return [
        // MARK: A
        .a : [
            get("attributionsrc", .array(of: .string)),
            get("download", .attribute, .download),
            get("href", .string),
            get("hrefLang", .string),
            get("ping", .array(of: .string)),
            get("referrerPolicy", .attribute),
            get("rel", .array(of: .attribute)),
            get("target", .attribute),
            get("type", .string)
        ],
        .abbr : [],
        .address : [],
        .area : [
            get("alt", .string),
            get("coords", .array(of: .int)),
            get("download", .attribute, .download),
            get("href", .string),
            get("shape", .attribute),
            get("ping", .array(of: .string)),
            get("referrerPolicy", .attribute),
            get("rel", .array(of: .attribute)),
            get("target", .otherAttribute("formtarget"))
        ],
        .article : [],
        .aside : [],
        .audio : [
            get("autoplay", .bool),
            get("controls", .booleanDefaultValue(true)),
            get("controlsList", .array(of: .attribute)),
            get("crossorigin", .attribute),
            get("disableRemotePlayback", .bool),
            get("loop", .bool),
            get("muted", .bool),
            get("preload", .attribute),
            get("src", .string)
        ],

        // MARK: B
        .b : [],
        .base : [
            get("href", .string),
            get("target", .otherAttribute("formtarget"))
        ],
        .bdi : [],
        .bdo : [],
        .blockquote : [
            get("cite", .string)
        ],
        .body : [],
        .br : [],
        .button : [
            get("command", .attribute),
            get("commandFor", .string),
            get("disabled", .bool),
            get("form", .string),
            get("formAction", .string),
            get("formEncType", .attribute),
            get("formMethod", .attribute),
            get("formNoValidate", .bool),
            get("formTarget", .attribute),
            get("name", .string),
            get("popoverTarget", .string),
            get("popoverTargetAction", .attribute),
            get("type", .otherAttribute("buttontype")),
            get("value", .string)
        ],

        // MARK: C
        .canvas : [
            get("height", .cssUnit),
            get("width", .cssUnit)
        ],
        .caption : [],
        .cite : [],
        .code : [],
        .col : [
            get("span", .int)
        ],
        .colgroup : [
            get("span", .int)
        ],

        // MARK: D
        .data : [
            get("value", .string)
        ],
        .datalist : [],
        .dd : [],
        .del : [
            get("cite", .string),
            get("datetime", .string)
        ],
        .details : [
            get("open", .bool),
            get("name", .string)
        ],
        .dfn : [],
        .dialog : [
            get("open", .bool)
        ],
        .div : [],
        .dl : [],
        .dt : [],

        // MARK: E
        .em : [],
        .embed : [
            get("height", .cssUnit),
            get("src", .string),
            get("type", .string),
            get("width", .cssUnit)
        ],

        // MARK: F
        .fencedframe : [
            get("allow", .string),
            get("height", .int),
            get("width", .int)
        ],
        .fieldset : [
            get("disabled", .bool),
            get("form", .string),
            get("name", .string)
        ],
        .figcaption : [],
        .figure : [],
        .footer : [],
        .form : [
            get("acceptCharset", .array(of: .string)),
            get("action", .string),
            get("autocomplete", .attribute),
            get("enctype", .otherAttribute("formenctype")),
            get("method", .string),
            get("name", .string),
            get("novalidate", .bool),
            get("rel", .array(of: .attribute)),
            get("target", .attribute)
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
            get("lookupFiles", .array(of: .string)),
            get("xmlns", .string)
        ],

        // MARK: I
        .i : [],
        .iframe : [
            get("allow", .array(of: .string)),
            get("browsingtopics", .bool),
            get("credentialless", .bool),
            get("csp", .string),
            get("height", .cssUnit),
            get("loading", .attribute),
            get("name", .string),
            get("referrerPolicy", .attribute),
            get("sandbox", .array(of: .attribute)),
            get("src", .string),
            get("srcdoc", .string),
            get("width", .cssUnit)
        ],
        .img : [
            get("alt", .string),
            get("attributionsrc", .array(of: .string)),
            get("crossorigin", .attribute),
            get("decoding", .attribute),
            get("elementTiming", .string),
            get("fetchPriority", .attribute),
            get("height", .cssUnit),
            get("isMap", .bool),
            get("loading", .attribute),
            get("referrerPolicy", .attribute),
            get("sizes", .array(of: .string)),
            get("src", .string),
            get("srcSet", .array(of: .string)),
            get("width", .cssUnit),
            get("usemap", .string)
        ],
        .input : [
            get("accept", .array(of: .string)),
            get("alt", .string),
            get("autocomplete", .array(of: .string)),
            get("capture", .attribute),
            get("checked", .bool),
            get("dirName", .attribute),
            get("disabled", .bool),
            get("form", .string),
            get("formAction", .string),
            get("formEncType", .attribute),
            get("formMethod", .attribute),
            get("formNoValidate", .bool),
            get("formTarget", .attribute),
            get("height", .cssUnit),
            get("list", .string),
            get("max", .int),
            get("maxLength", .int),
            get("min", .int),
            get("minLength", .int),
            get("multiple", .bool),
            get("name", .string),
            get("pattern", .string),
            get("placeholder", .string),
            get("popoverTarget", .string),
            get("popoverTargetAction", .attribute),
            get("readOnly", .bool),
            get("required", .bool),
            get("size", .string),
            get("src", .string),
            get("step", .float),
            get("type", .otherAttribute("inputtype")),
            get("value", .string),
            get("width", .cssUnit)
        ],
        .ins : [
            get("cite", .string),
            get("datetime", .string)
        ],

        // MARK: K
        .kbd : [],
        
        // MARK: L
        .label : [
            get("for", .string)
        ],
        .legend : [],
        .li : [
            get("value", .int)
        ],
        .link : [
            get("as", .otherAttribute("`as`")),
            get("blocking", .array(of: .attribute)),
            get("crossorigin", .attribute),
            get("disabled", .bool),
            get("fetchPriority", .attribute),
            get("href", .string),
            get("hrefLang", .string),
            get("imageSizes", .array(of: .string)),
            get("imagesrcset", .array(of: .string)),
            get("integrity", .string),
            get("media", .string),
            get("referrerPolicy", .attribute),
            get("rel", .attribute),
            get("size", .string),
            get("type", .string)
        ],

        // MARK: M
        .main : [],
        .map : [
            get("name", .string)
        ],
        .mark : [],
        .menu : [],
        .meta : [
            get("charset", .string),
            get("content", .string),
            get("httpEquiv", .otherAttribute("httpequiv")),
            get("name", .string)
        ],
        .meter : [
            get("value", .float),
            get("min", .float),
            get("max", .float),
            get("low", .float),
            get("high", .float),
            get("optimum", .float),
            get("form", .string)
        ],

        // MARK: N
        .nav : [],
        .noscript : [],

        // MARK: O
        .object : [
            get("archive", .array(of: .string)),
            get("border", .int),
            get("classID", .string),
            get("codebase", .string),
            get("codetype", .string),
            get("data", .string),
            get("declare", .bool),
            get("form", .string),
            get("height", .cssUnit),
            get("name", .string),
            get("standby", .string),
            get("type", .string),
            get("usemap", .string),
            get("width", .cssUnit)
        ],
        .ol : [
            get("reversed", .bool),
            get("start", .int),
            get("type", .otherAttribute("numberingtype"))
        ],
        .optgroup : [
            get("disabled", .bool),
            get("label", .string)
        ],
        .option : [
            get("disabled", .bool),
            get("label", .string),
            get("selected", .bool),
            get("value", .string)
        ],
        .output : [
            get("for", .array(of: .string)),
            get("form", .string),
            get("name", .string)
        ],

        // MARK: P
        .p : [],
        .picture : [],
        .portal : [
            get("referrerPolicy", .attribute),
            get("src", .string)
        ],
        .pre : [],
        .progress : [
            get("max", .float),
            get("value", .float)
        ],

        // MARK: Q
        .q : [
            get("cite", .string)
        ],

        // MARK: R
        .rp : [],
        .rt : [],
        .ruby : [],

        // MARK: S
        .s : [],
        .samp : [],
        .script : [
            get("async", .bool),
            get("attributionsrc", .array(of: .string)),
            get("blocking", .attribute),
            get("crossorigin", .attribute),
            get("defer", .bool),
            get("fetchPriority", .attribute),
            get("integrity", .string),
            get("noModule", .bool),
            get("referrerPolicy", .attribute),
            get("src", .string),
            get("type", .otherAttribute("scripttype"))
        ],
        .search : [],
        .section : [],
        .select : [
            get("disabled", .bool),
            get("form", .string),
            get("multiple", .bool),
            get("name", .string),
            get("required", .bool),
            get("size", .int)
        ],
        .slot : [
            get("name", .string)
        ],
        .small : [],
        .source : [
            get("type", .string),
            get("src", .string),
            get("srcSet", .array(of: .string)),
            get("sizes", .array(of: .string)),
            get("media", .string),
            get("height", .int),
            get("width", .int)
        ],
        .span : [],
        .strong : [],
        .style : [
            get("blocking", .attribute),
            get("media", .string)
        ],
        .sub : [],
        .summary : [],
        .sup : [],

        // MARK: T
        .table : [],
        .tbody : [],
        .td : [
            get("colspan", .int),
            get("headers", .array(of: .string)),
            get("rowspan", .int)
        ],
        .template : [
            get("shadowRootClonable", .attribute),
            get("shadowRootDelegatesFocus", .bool),
            get("shadowRootMode", .attribute),
            get("shadowRootSerializable", .bool)
        ],
        .textarea : [
            get("autocomplete", .array(of: .string)),
            get("autocorrect", .attribute),
            get("cols", .int),
            get("dirName", .attribute),
            get("disabled", .bool),
            get("form", .string),
            get("maxLength", .int),
            get("minLength", .int),
            get("name", .string),
            get("placeholder", .string),
            get("readOnly", .bool),
            get("required", .bool),
            get("rows", .int),
            get("wrap", .attribute)
        ],
        .tfoot : [],
        .th : [
            get("abbr", .string),
            get("colspan", .int),
            get("headers", .array(of: .string)),
            get("rowspan", .int),
            get("scope", .attribute)
        ],
        .thead : [],
        .time : [
            get("datetime", .string)
        ],
        .title : [],
        .tr : [],
        .track : [
            get("default", .booleanDefaultValue(true)),
            get("kind", .attribute),
            get("label", .string),
            get("src", .string),
            get("srcLang", .string)
        ],

        // MARK: U
        .u : [],
        .ul : [],

        // MARK: V
        .variable : [],
        .video : [
            get("autoplay", .bool),
            get("controls", .bool),
            get("controlsList", .array(of: .attribute)),
            get("crossorigin", .attribute),
            get("disablePictureInPicture", .bool),
            get("disableRemotePlayback", .bool),
            get("height", .cssUnit),
            get("loop", .bool),
            get("muted", .bool),
            get("playsInline", .booleanDefaultValue(true)),
            get("poster", .string),
            get("preload", .attribute),
            get("src", .string),
            get("width", .cssUnit)
        ],

        // MARK: W
        .wbr : []
    ]
}

#endif
