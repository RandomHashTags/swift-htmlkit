//
//  HTMLKit.swift
//
//
//  Created by Evan Anderson on 9/14/24.
//

import HTMLKitUtilities

/*public extension StaticString {
    var string : String { withUTF8Buffer { String(decoding: $0, as: UTF8.self) } }
}*/

// MARK: Elements
@freestanding(expression)
public macro html(xmlns: String? = nil, _ innerHTML: [String]) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: A
@freestanding(expression)
public macro a(
    attributes: [HTMLElementAttribute] = [],
    
    attributionsrc: [String]? = nil,
    download: HTMLElementAttribute.Extra.download? = nil,
    href: String? = nil,
    hreflang: String? = nil,
    ping: [String] = [],
    referrerpolicy: HTMLElementAttribute.Extra.referrerpolicy? = nil,
    rel: String? = nil,
    target: HTMLElementAttribute.Extra.target? = nil,
    type: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro abbr(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro address(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro area(
    attributes: [HTMLElementAttribute] = [],
    
    alt: String? = nil,
    coords: [Int] = [],
    download: HTMLElementAttribute.Extra.download? = nil,
    href: String? = nil,
    ping: [String] = [],
    referrerpolicy: HTMLElementAttribute.Extra.referrerpolicy? = nil,
    rel: String? = nil,
    target: HTMLElementAttribute.Extra.formtarget? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro article(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro aside(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro audio(
    attributes: [HTMLElementAttribute] = [],
    
    autoplay: Bool = false,
    controls: Bool = true,
    controlslist: HTMLElementAttribute.Extra.controlslist? = nil,
    crossorigin: HTMLElementAttribute.Extra.crossorigin? = nil,
    disableremoteplayback: Bool = false,
    loop: Bool = false,
    muted: Bool = false,
    preload: HTMLElementAttribute.Extra.preload? = nil,
    src: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: B
@freestanding(expression)
public macro b(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro base(
    attributes: [HTMLElementAttribute] = [],
    
    href: String? = nil,
    target: HTMLElementAttribute.Extra.formtarget? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro bdi(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro bdo(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro blockquote(
    attributes: [HTMLElementAttribute] = [],
    
    cite: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro body(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro br(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro button(
    attributes: [HTMLElementAttribute] = [],
    
    disabled: Bool = false,
    form: String? = nil,
    formaction: String? = nil,
    formenctype: HTMLElementAttribute.Extra.formenctype? = nil,
    formmethod: HTMLElementAttribute.Extra.formmethod? = nil,
    formnovalidate: Bool = false,
    formtarget: HTMLElementAttribute.Extra.formtarget? = nil,
    name: String? = nil,
    popovertarget: String? = nil,
    popovertargetaction: HTMLElementAttribute.Extra.popovertargetaction? = nil,
    type: HTMLElementAttribute.Extra.buttontype? = nil,
    value: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: C
@freestanding(expression)
public macro canvas(
    attributes: [HTMLElementAttribute] = [],
    
    height: HTMLElementAttribute.CSSUnit? = nil,
    width: HTMLElementAttribute.CSSUnit? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro caption(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro cite(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro code(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro col(
    attributes: [HTMLElementAttribute] = [],
    
    span: Int? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro colgroup(
    attributes: [HTMLElementAttribute] = [],
    
    span: Int? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: D
@freestanding(expression)
public macro data(
    attributes: [HTMLElementAttribute] = [],
    
    value: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro datalist(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dd(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro del(
    attributes: [HTMLElementAttribute] = [],
    
    cite: String? = nil,
    datetime: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro details(
    attributes: [HTMLElementAttribute] = [],
    
    open: Bool = false,
    name: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dfn(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dialog(
    attributes: [HTMLElementAttribute] = [],
    
    open: Bool = false,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro div(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dl(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dt(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: E
@freestanding(expression)
public macro em(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro embed(
    attributes: [HTMLElementAttribute] = [],
    
    height: HTMLElementAttribute.CSSUnit? = nil,
    src: String? = nil,
    type: String? = nil,
    width: HTMLElementAttribute.CSSUnit? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: F
@freestanding(expression)
public macro fencedframe(
    attributes: [HTMLElementAttribute] = [],
    
    allow: String? = nil,
    height: Int? = nil,
    width: Int? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro fieldset(
    attributes: [HTMLElementAttribute] = [],
    
    disabled: Bool = false,
    form: String? = nil,
    name: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro figcaption(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro figure(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro footer(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro form(
    attributes: [HTMLElementAttribute] = [],
    
    acceptCharset: [String] = [],
    autocomplete: HTMLElementAttribute.Extra.autocomplete? = nil,
    name: String? = nil,
    rel: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: H
@freestanding(expression)
public macro h1(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h2(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h3(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h4(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h5(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h6(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro head(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro header(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro hgroup(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro hr(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: I
@freestanding(expression)
public macro i(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro iframe(
    attributes: [HTMLElementAttribute] = [],
    
    allow: String? = nil,
    browsingtopics: Bool = false,
    credentialless: Bool = false,
    csp: String? = nil,
    height: HTMLElementAttribute.CSSUnit? = nil,
    loading: HTMLElementAttribute.Extra.loading? = nil,
    name: String? = nil,
    referrerpolicy: HTMLElementAttribute.Extra.referrerpolicy? = nil,
    sandbox: [HTMLElementAttribute.Extra.sandbox] = [],
    src: String? = nil,
    srcdoc: String? = nil,
    width: HTMLElementAttribute.CSSUnit? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro img(
    attributes: [HTMLElementAttribute] = [],
    
    alt: String? = nil,
    attributionsrc: [String]? = nil,
    crossorigin: HTMLElementAttribute.Extra.crossorigin? = nil,
    decoding: HTMLElementAttribute.Extra.decoding? = nil,
    elementtiming: String? = nil,
    fetchpriority: HTMLElementAttribute.Extra.fetchpriority? = nil,
    height: HTMLElementAttribute.CSSUnit? = nil,
    ismap: Bool = false,
    loading: HTMLElementAttribute.Extra.loading? = nil,
    referrerpolicy: HTMLElementAttribute.Extra.referrerpolicy? = nil,
    sizes: [String] = [],
    src: String? = nil,
    srcset: [String] = [],
    width: HTMLElementAttribute.CSSUnit? = nil,
    usemap: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro input(
    attributes: [HTMLElementAttribute] = [],
    
    accept: [String] = [],
    alt: String? = nil,
    autocomplete: [String] = [],
    capture: HTMLElementAttribute.Extra.capture? = nil,
    checked: Bool = false,
    dirname: HTMLElementAttribute.Extra.dirname? = nil,
    disabled: Bool = false,
    form: String? = nil,
    formaction: String? = nil,
    formenctype: HTMLElementAttribute.Extra.formenctype? = nil,
    formmethod: HTMLElementAttribute.Extra.formmethod? = nil,
    formnovalidate: Bool = false,
    formtarget: HTMLElementAttribute.Extra.formtarget? = nil,
    height: HTMLElementAttribute.CSSUnit? = nil,
    list: String? = nil,
    max: Int? = nil,
    maxlength: Int? = nil,
    min: Int? = nil,
    minlength: Int? = nil,
    multiple: Bool = false,
    name: String? = nil,
    pattern: String? = nil,
    placeholder: String? = nil,
    popovertarget: String? = nil,
    popovertargetaction: HTMLElementAttribute.Extra.popovertargetaction? = nil,
    readonly: Bool = false,
    required: Bool = false,
    size: String? = nil,
    src: String? = nil,
    step: Float? = nil,
    type: HTMLElementAttribute.Extra.inputtype? = nil,
    value: String? = nil,
    width: HTMLElementAttribute.CSSUnit? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro ins(
    attributes: [HTMLElementAttribute] = [],
    
    cite: String? = nil,
    datetime: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: K
@freestanding(expression)
public macro kbd(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: L
@freestanding(expression)
public macro label(
    attributes: [HTMLElementAttribute] = [],
    
    for: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro legend(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro li(
    attributes: [HTMLElementAttribute] = [],
    
    value: Int? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro link(
    attributes: [HTMLElementAttribute] = [],
    
    as: HTMLElementAttribute.Extra.`as`? = nil,
    blocking: Set<HTMLElementAttribute.Extra.blocking> = [],
    crossorigin: HTMLElementAttribute.Extra.crossorigin? = nil,
    disabled: Bool = false,
    fetchpriority: HTMLElementAttribute.Extra.fetchpriority? = nil,
    href: String? = nil,
    hreflang: String? = nil,
    imagesizes: [String] = [],
    imagesrcset: [String] = [],
    integrity: String? = nil,
    media: String? = nil,
    referrerpolicy: HTMLElementAttribute.Extra.referrerpolicy? = nil,
    rel: [String] = [],
    sizes: [String] = [],
    type: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: M
@freestanding(expression)
public macro main(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro map(
    attributes: [HTMLElementAttribute] = [],
    
    name: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro mark(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro menu(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro meta(
    attributes: [HTMLElementAttribute] = [],
    
    charset: String? = nil,
    content: String? = nil,
    httpEquiv: HTMLElementAttribute.Extra.httpequiv? = nil,
    name: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro meter(
    attributes: [HTMLElementAttribute] = [],
    
    value: Float? = nil,
    min: Float? = nil,
    max: Float? = nil,
    low: Float? = nil,
    high: Float? = nil,
    optimum: Float? = nil,
    form: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: N
@freestanding(expression)
public macro nav(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro noscript(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: O
@freestanding(expression)
public macro object(
    attributes: [HTMLElementAttribute] = [],
    
    form: String? = nil,
    height: HTMLElementAttribute.CSSUnit? = nil,
    name: String? = nil,
    type: String? = nil,
    width: HTMLElementAttribute.CSSUnit? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro ol(
    attributes: [HTMLElementAttribute] = [],
    
    reversed: Bool = false,
    start: Int? = nil,
    type: HTMLElementAttribute.Extra.numberingtype? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro optgroup(
    attributes: [HTMLElementAttribute] = [],
    
    disabled: Bool = false,
    label: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro option(
    attributes: [HTMLElementAttribute] = [],
    
    disabled: Bool = false,
    label: String? = nil,
    selected: Bool = false,
    value: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro output(
    attributes: [HTMLElementAttribute] = [],
    
    for: [String] = [],
    form: String? = nil,
    name: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: P
@freestanding(expression)
public macro p(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro picture(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro portal(
    attributes: [HTMLElementAttribute] = [],
    
    referrerpolicy: HTMLElementAttribute.Extra.referrerpolicy? = nil,
    src: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro pre(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro progress(
    attributes: [HTMLElementAttribute] = [],
    
    max: Float? = nil,
    value: Float? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: Q
@freestanding(expression)
public macro q(
    attributes: [HTMLElementAttribute] = [],
    
    cite: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: R
@freestanding(expression)
public macro rp(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro rt(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro ruby(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: S
@freestanding(expression)
public macro s(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro samp(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro script(
    attributes: [HTMLElementAttribute] = [],
    
    async: Bool = false,
    attributionsrc: [String]? = nil,
    blocking: HTMLElementAttribute.Extra.blocking? = nil,
    crossorigin: HTMLElementAttribute.Extra.crossorigin? = nil,
    defer: Bool = false,
    fetchpriority: HTMLElementAttribute.Extra.fetchpriority? = nil,
    integrity: String? = nil,
    nomodule: Bool = false,
    referrerpolicy: HTMLElementAttribute.Extra.referrerpolicy? = nil,
    src: String? = nil,
    type: HTMLElementAttribute.Extra.scripttype? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro search(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro section(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro select(
    attributes: [HTMLElementAttribute] = [],
    
    disabled: Bool = false,
    form: String? = nil,
    multiple: Bool = false,
    name: String? = nil,
    required: Bool = false,
    size: Int? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro slot(
    attributes: [HTMLElementAttribute] = [],
    
    name: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro small(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro source(
    attributes: [HTMLElementAttribute] = [],
    
    type: String? = nil,
    src: String? = nil,
    srcset: [String] = [],
    sizes: [String] = [],
    media: String? = nil,
    height: Int? = nil,
    width: Int? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro span(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro strong(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro style(
    attributes: [HTMLElementAttribute] = [],
    
    blocking: HTMLElementAttribute.Extra.blocking? = nil,
    media: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro sub(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro summary(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro sup(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: T
@freestanding(expression)
public macro table(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro tbody(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro td(
    attributes: [HTMLElementAttribute] = [],
    
    colspan: Int? = nil,
    headers: [String] = [],
    rowspan: Int? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro template(
    attributes: [HTMLElementAttribute] = [],
    
    shadowrootclonable: HTMLElementAttribute.Extra.shadowrootclonable? = nil,
    shadowrootdelegatesfocus: Bool = false,
    shadowrootmode: HTMLElementAttribute.Extra.shadowrootmode? = nil,
    shadowrootserializable: Bool = false,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro textarea(
    attributes: [HTMLElementAttribute] = [],
    
    autocomplete: [String]? = nil,
    autocorrect: String? = nil,
    cols: Int? = nil,
    dirname: HTMLElementAttribute.Extra.dirname? = nil,
    disabled: Bool = false,
    form: String? = nil,
    maxlength: Int? = nil,
    minlength: Int? = nil,
    name: String? = nil,
    placeholder: String? = nil,
    readonly: Bool = false,
    rows: Int? = nil,
    wrap: HTMLElementAttribute.Extra.wrap? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro tfoot(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro th(
    attributes: [HTMLElementAttribute] = [],
    
    abbr: String? = nil,
    colspan: Int? = nil,
    headers: [String] = [],
    rowspan: Int? = nil,
    scope: HTMLElementAttribute.Extra.scope? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro thead(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro time(
    attributes: [HTMLElementAttribute] = [],
    
    datetime: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro title(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro tr(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro track(
    attributes: [HTMLElementAttribute] = [],
    
    default: Bool = true,
    kind: HTMLElementAttribute.Extra.kind? = nil,
    label: String? = nil,
    src: String? = nil,
    srclang: String? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: U
@freestanding(expression)
public macro u(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro ul(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: V
@freestanding(expression)
public macro `var`(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro video(
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
    poster: String? = nil,
    preload: HTMLElementAttribute.Extra.preload? = nil,
    src: String? = nil,
    width: HTMLElementAttribute.CSSUnit? = nil,
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: W
@freestanding(expression)
public macro wbr(
    attributes: [HTMLElementAttribute] = [],
    _ innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")
