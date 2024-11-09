//
//  HTMLKit.swift
//
//
//  Created by Evan Anderson on 9/14/24.
//

import HTMLKitUtilities

#if canImport(Foundation)
import struct Foundation.Data
#endif

import struct NIOCore.ByteBuffer

// MARK: StaticString equality
public extension StaticString {
    static func == (left: Self, right: Self) -> Bool { left.description == right.description }
    static func != (left: Self, right: Self) -> Bool { left.description != right.description }
}
// MARK: StaticString and StringProtocol equality
public extension StringProtocol {
    static func == (left: Self, right: StaticString) -> Bool { left == right.description }
    static func == (left: StaticString, right: Self) -> Bool { left.description == right }
}

@freestanding(expression)
public macro escapeHTML<T: ExpressibleByStringLiteral>(_ innerHTML: T...) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: HTML Representation
@freestanding(expression)
public macro html<T: ExpressibleByStringLiteral>(lookupFiles: [StaticString] = [], attributes: [HTMLElementAttribute] = [], xmlns: T? = nil, _ innerHTML: T...) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro htmlUTF8Bytes<T: ExpressibleByStringLiteral>(lookupFiles: [StaticString] = [], attributes: [HTMLElementAttribute] = [], xmlns: T? = nil, _ innerHTML: T...) -> [UInt8] = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro htmlUTF16Bytes<T: ExpressibleByStringLiteral>(lookupFiles: [StaticString] = [], attributes: [HTMLElementAttribute] = [], xmlns: T? = nil, _ innerHTML: T...) -> [UInt16] = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro htmlUTF8CString<T: ExpressibleByStringLiteral>(lookupFiles: [StaticString] = [], attributes: [HTMLElementAttribute] = [], xmlns: T? = nil, _ innerHTML: T...) -> ContiguousArray<CChar> = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

#if canImport(Foundation)
@freestanding(expression)
public macro htmlData<T: ExpressibleByStringLiteral>(lookupFiles: [StaticString] = [], attributes: [HTMLElementAttribute] = [], xmlns: T? = nil, _ innerHTML: T...) -> Data = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")
#endif

@freestanding(expression)
public macro htmlByteBuffer<T: ExpressibleByStringLiteral>(lookupFiles: [StaticString] = [], attributes: [HTMLElementAttribute] = [], xmlns: T? = nil, _ innerHTML: T...) -> ByteBuffer = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: Elements

@freestanding(expression)
public macro custom<T: ExpressibleByStringLiteral>(tag: String, isVoid: Bool, attributes: [HTMLElementAttribute] = [], _ innerHTML: T...) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: A
@freestanding(expression)
public macro a<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    attributionSrc: [T]? = nil,
    download: HTMLElementAttribute.Extra.download? = nil,
    href: T? = nil,
    hreflang: T? = nil,
    ping: [T] = [],
    referrerpolicy: HTMLElementAttribute.Extra.referrerpolicy? = nil,
    rel: T? = nil,
    target: HTMLElementAttribute.Extra.target? = nil,
    type: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro abbr<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro address<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro area<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    alt: T? = nil,
    coords: [Int] = [],
    download: HTMLElementAttribute.Extra.download? = nil,
    href: T? = nil,
    shape: HTMLElementAttribute.Extra.shape? = nil,
    ping: [T] = [],
    referrerpolicy: HTMLElementAttribute.Extra.referrerpolicy? = nil,
    rel: T? = nil,
    target: HTMLElementAttribute.Extra.formtarget? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro article<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro aside<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro audio<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    autoplay: Bool = false,
    controls: Bool = true,
    controlslist: [HTMLElementAttribute.Extra.controlslist] = [],
    crossorigin: HTMLElementAttribute.Extra.crossorigin? = nil,
    disableremoteplayback: Bool = false,
    loop: Bool = false,
    muted: Bool = false,
    preload: HTMLElementAttribute.Extra.preload? = nil,
    src: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: B
@freestanding(expression)
public macro b<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro base<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    href: T? = nil,
    target: HTMLElementAttribute.Extra.formtarget? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro bdi<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro bdo<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro blockquote<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    cite: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro body<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro br<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro button<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    disabled: Bool = false,
    form: T? = nil,
    formaction: T? = nil,
    formenctype: HTMLElementAttribute.Extra.formenctype? = nil,
    formmethod: HTMLElementAttribute.Extra.formmethod? = nil,
    formnovalidate: Bool = false,
    formtarget: HTMLElementAttribute.Extra.formtarget? = nil,
    name: T? = nil,
    popovertarget: T? = nil,
    popovertargetaction: HTMLElementAttribute.Extra.popovertargetaction? = nil,
    type: HTMLElementAttribute.Extra.buttontype? = nil,
    value: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: C
@freestanding(expression)
public macro canvas<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    height: HTMLElementAttribute.CSSUnit? = nil,
    width: HTMLElementAttribute.CSSUnit? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro caption<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro cite<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro code<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro col<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    span: Int? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro colgroup<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    span: Int? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: D
@freestanding(expression)
public macro data<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    value: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro datalist<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dd<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro del<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    cite: T? = nil,
    datetime: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro details<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    open: Bool = false,
    name: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dfn<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dialog<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    open: Bool = false,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro div<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dl<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dt<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: E
@freestanding(expression)
public macro em<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro embed<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    height: HTMLElementAttribute.CSSUnit? = nil,
    src: T? = nil,
    type: T? = nil,
    width: HTMLElementAttribute.CSSUnit? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: F
@freestanding(expression)
public macro fencedframe<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    allow: T? = nil,
    height: Int? = nil,
    width: Int? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro fieldset<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    disabled: Bool = false,
    form: T? = nil,
    name: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro figcaption<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro figure<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro footer<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro form<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    acceptCharset: [T] = [],
    autocomplete: HTMLElementAttribute.Extra.autocomplete? = nil,
    name: T? = nil,
    rel: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: H
@freestanding(expression)
public macro h1<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h2<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h3<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h4<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h5<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h6<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro head<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro header<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro hgroup<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro hr<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: I
@freestanding(expression)
public macro i<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro iframe<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    allow: T? = nil,
    browsingtopics: Bool = false,
    credentialless: Bool = false,
    csp: T? = nil,
    height: HTMLElementAttribute.CSSUnit? = nil,
    loading: HTMLElementAttribute.Extra.loading? = nil,
    name: T? = nil,
    referrerpolicy: HTMLElementAttribute.Extra.referrerpolicy? = nil,
    sandbox: [HTMLElementAttribute.Extra.sandbox] = [],
    src: T? = nil,
    srcdoc: T? = nil,
    width: HTMLElementAttribute.CSSUnit? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro img<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    alt: T? = nil,
    attributionSrc: [T]? = nil,
    crossorigin: HTMLElementAttribute.Extra.crossorigin? = nil,
    decoding: HTMLElementAttribute.Extra.decoding? = nil,
    elementtiming: T? = nil,
    fetchpriority: HTMLElementAttribute.Extra.fetchpriority? = nil,
    height: HTMLElementAttribute.CSSUnit? = nil,
    ismap: Bool = false,
    loading: HTMLElementAttribute.Extra.loading? = nil,
    referrerpolicy: HTMLElementAttribute.Extra.referrerpolicy? = nil,
    sizes: [T] = [],
    src: T? = nil,
    srcset: [T] = [],
    width: HTMLElementAttribute.CSSUnit? = nil,
    usemap: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro input<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    accept: [T] = [],
    alt: T? = nil,
    autocomplete: [T] = [],
    capture: HTMLElementAttribute.Extra.capture? = nil,
    checked: Bool = false,
    dirname: HTMLElementAttribute.Extra.dirname? = nil,
    disabled: Bool = false,
    form: T? = nil,
    formaction: T? = nil,
    formenctype: HTMLElementAttribute.Extra.formenctype? = nil,
    formmethod: HTMLElementAttribute.Extra.formmethod? = nil,
    formnovalidate: Bool = false,
    formtarget: HTMLElementAttribute.Extra.formtarget? = nil,
    height: HTMLElementAttribute.CSSUnit? = nil,
    list: T? = nil,
    max: Int? = nil,
    maxlength: Int? = nil,
    min: Int? = nil,
    minlength: Int? = nil,
    multiple: Bool = false,
    name: T? = nil,
    pattern: T? = nil,
    placeholder: T? = nil,
    popovertarget: T? = nil,
    popovertargetaction: HTMLElementAttribute.Extra.popovertargetaction? = nil,
    readonly: Bool = false,
    required: Bool = false,
    size: T? = nil,
    src: T? = nil,
    step: Float? = nil,
    type: HTMLElementAttribute.Extra.inputtype? = nil,
    value: T? = nil,
    width: HTMLElementAttribute.CSSUnit? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro ins<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    cite: T? = nil,
    datetime: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: K
@freestanding(expression)
public macro kbd<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: L
@freestanding(expression)
public macro label<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    for: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro legend<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro li<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    value: Int? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro link<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    as: HTMLElementAttribute.Extra.`as`? = nil,
    blocking: Set<HTMLElementAttribute.Extra.blocking> = [],
    crossorigin: HTMLElementAttribute.Extra.crossorigin? = nil,
    disabled: Bool = false,
    fetchpriority: HTMLElementAttribute.Extra.fetchpriority? = nil,
    href: T? = nil,
    hreflang: T? = nil,
    imagesizes: [T] = [],
    imagesrcset: [T] = [],
    integrity: T? = nil,
    media: T? = nil,
    referrerpolicy: HTMLElementAttribute.Extra.referrerpolicy? = nil,
    rel: [T] = [],
    sizes: [T] = [],
    type: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: M
@freestanding(expression)
public macro main<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro map<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    name: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro mark<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro menu<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro meta<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    charset: T? = nil,
    content: T? = nil,
    httpEquiv: HTMLElementAttribute.Extra.httpequiv? = nil,
    name: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro meter<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    value: Float? = nil,
    min: Float? = nil,
    max: Float? = nil,
    low: Float? = nil,
    high: Float? = nil,
    optimum: Float? = nil,
    form: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: N
@freestanding(expression)
public macro nav<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro noscript<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: O
@freestanding(expression)
public macro object<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    form: T? = nil,
    height: HTMLElementAttribute.CSSUnit? = nil,
    name: T? = nil,
    type: T? = nil,
    width: HTMLElementAttribute.CSSUnit? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro ol<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    reversed: Bool = false,
    start: Int? = nil,
    type: HTMLElementAttribute.Extra.numberingtype? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro optgroup<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    disabled: Bool = false,
    label: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro option<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    disabled: Bool = false,
    label: T? = nil,
    selected: Bool = false,
    value: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro output<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    for: [T] = [],
    form: T? = nil,
    name: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: P
@freestanding(expression)
public macro p<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro picture<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro portal<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    referrerpolicy: HTMLElementAttribute.Extra.referrerpolicy? = nil,
    src: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro pre<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro progress<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    max: Float? = nil,
    value: Float? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: Q
@freestanding(expression)
public macro q<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    cite: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: R
@freestanding(expression)
public macro rp<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro rt<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro ruby<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: S
@freestanding(expression)
public macro s<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro samp<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro script<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    async: Bool = false,
    attributionSrc: [T]? = nil,
    blocking: HTMLElementAttribute.Extra.blocking? = nil,
    crossorigin: HTMLElementAttribute.Extra.crossorigin? = nil,
    defer: Bool = false,
    fetchpriority: HTMLElementAttribute.Extra.fetchpriority? = nil,
    integrity: T? = nil,
    nomodule: Bool = false,
    referrerpolicy: HTMLElementAttribute.Extra.referrerpolicy? = nil,
    src: T? = nil,
    type: HTMLElementAttribute.Extra.scripttype? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro search<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro section<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro select<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    disabled: Bool = false,
    form: T? = nil,
    multiple: Bool = false,
    name: T? = nil,
    required: Bool = false,
    size: Int? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro slot<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    name: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro small<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro source<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    type: T? = nil,
    src: T? = nil,
    srcset: [T] = [],
    sizes: [T] = [],
    media: T? = nil,
    height: Int? = nil,
    width: Int? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro span<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro strong<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro style<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    blocking: HTMLElementAttribute.Extra.blocking? = nil,
    media: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro sub<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro summary<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro sup<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: T
@freestanding(expression)
public macro table<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro tbody<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro td<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    colspan: Int? = nil,
    headers: [T] = [],
    rowspan: Int? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro template<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    shadowrootclonable: HTMLElementAttribute.Extra.shadowrootclonable? = nil,
    shadowrootdelegatesfocus: Bool = false,
    shadowrootmode: HTMLElementAttribute.Extra.shadowrootmode? = nil,
    shadowrootserializable: Bool = false,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro textarea<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    autocomplete: [T]? = nil,
    autocorrect: T? = nil,
    cols: Int? = nil,
    dirname: HTMLElementAttribute.Extra.dirname? = nil,
    disabled: Bool = false,
    form: T? = nil,
    maxlength: Int? = nil,
    minlength: Int? = nil,
    name: T? = nil,
    placeholder: T? = nil,
    readonly: Bool = false,
    rows: Int? = nil,
    wrap: HTMLElementAttribute.Extra.wrap? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro tfoot<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro th<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    abbr: T? = nil,
    colspan: Int? = nil,
    headers: [T] = [],
    rowspan: Int? = nil,
    scope: HTMLElementAttribute.Extra.scope? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro thead<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro time<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    datetime: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro title<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro tr<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro track<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    default: Bool = true,
    kind: HTMLElementAttribute.Extra.kind? = nil,
    label: T? = nil,
    src: T? = nil,
    srclang: T? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: U
@freestanding(expression)
public macro u<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro ul<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: V
@freestanding(expression)
public macro `var`<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro video<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    
    autoplay: Bool = false,
    controls: Bool = true,
    controlslist: [HTMLElementAttribute.Extra.controlslist] = [],
    crossorigin: HTMLElementAttribute.Extra.crossorigin? = nil,
    disablepictureinpicture: Bool = false,
    disableremoteplayback: Bool = false,
    height: HTMLElementAttribute.CSSUnit? = nil,
    loop: Bool = false,
    muted: Bool = false,
    playsinline: Bool = true,
    poster: T? = nil,
    preload: HTMLElementAttribute.Extra.preload? = nil,
    src: T? = nil,
    width: HTMLElementAttribute.CSSUnit? = nil,
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: W
@freestanding(expression)
public macro wbr<T: ExpressibleByStringLiteral>(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: T...
) -> T = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")
