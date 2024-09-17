//
//  HTMLKit.swift
//
//
//  Created by Evan Anderson on 9/14/24.
//

import HTMLKitMacros

// TODO: fix some `height` & `width` value types (they're CSS pixels, not only integers) | change some to `String` or allow overloads

// MARK: Elements
@freestanding(expression)
public macro html(xmlns: String? = nil, innerHTML: [String]) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: A
@freestanding(expression)
public macro a(
    attributes: Set<HTMLElementAttribute> = [],
    attributionsrc: [String] = [],
    download: HTMLElementAttribute.Download? = nil,
    href: String? = nil,
    hreflang: String? = nil,
    ping: [String] = [],
    referrerpolicy: HTMLElementAttribute.ReferrerPolicy? = nil,
    rel: String? = nil,
    target: HTMLElementAttribute.Target? = nil,
    type: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro abbr(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro address(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro area(
    attributes: Set<HTMLElementAttribute> = [],
    alt: String? = nil,
    coords: [Int] = [],
    download: HTMLElementAttribute.Download? = nil,
    href: String? = nil,
    ping: [String] = [],
    referrerpolicy: HTMLElementAttribute.ReferrerPolicy? = nil,
    rel: String? = nil,
    target: HTMLElementAttribute.FormTarget? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro article(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro aside(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro audio(
    attributes: Set<HTMLElementAttribute> = [],
    autoplay: Bool = false,
    controls: Bool = true,
    controlslist: HTMLElementAttribute.ControlsList? = nil,
    crossorigin: HTMLElementAttribute.CrossOrigin? = nil,
    disableremoteplayback: Bool = false,
    loop: Bool = false,
    muted: Bool = false,
    preload: HTMLElementAttribute.Preload? = nil,
    src: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: B
@freestanding(expression)
public macro b(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro base(
    attributes: Set<HTMLElementAttribute> = [],
    href: String? = nil,
    target: HTMLElementAttribute.FormTarget? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro bdi(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro bdo(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro blockquote(
    attributes: Set<HTMLElementAttribute> = [],
    cite: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro body(
    attributes: Set<HTMLElementAttribute> = [],
    onafterprint: String? = nil,
    onbeforeprint: String? = nil,
    onbeforeunload: String? = nil,
    onblur: String? = nil,
    onerror: String? = nil,
    onfocus: String? = nil,
    onhashchange: String? = nil,
    onlanguagechange: String? = nil,
    onload: String? = nil,
    onmessage: String? = nil,
    onoffline: String? = nil,
    ononline: String? = nil,
    onpopstate: String? = nil,
    onresize: String? = nil,
    onstorage: String? = nil,
    onunload: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro br(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro button(
    attributes: Set<HTMLElementAttribute> = [],
    disabled: Bool = false,
    form: String? = nil,
    formaction: String? = nil,
    formenctype: HTMLElementAttribute.FormEncType? = nil,
    formmethod: HTMLElementAttribute.FormMethod? = nil,
    formnovalidate: Bool = false,
    formtarget: HTMLElementAttribute.FormTarget? = nil,
    name: String? = nil,
    popovertarget: String? = nil,
    popovertargetaction: HTMLElementAttribute.PopoverTargetAction? = nil,
    type: HTMLElementAttribute.ButtonType? = nil,
    value: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: C
@freestanding(expression)
public macro canvas(
    attributes: Set<HTMLElementAttribute> = [],
    height: Int? = nil,
    width: Int? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro caption(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro cite(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro code(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro col(
    attributes: Set<HTMLElementAttribute> = [],
    span: Int? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro colgroup(
    attributes: Set<HTMLElementAttribute> = [],
    span: Int? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: D
@freestanding(expression)
public macro data(
    attributes: Set<HTMLElementAttribute> = [],
    value: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro datalist(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dd(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro del(
    attributes: Set<HTMLElementAttribute> = [],
    cite: String? = nil,
    datetime: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro details(
    attributes: Set<HTMLElementAttribute> = [],
    open: Bool = false,
    name: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dfn(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dialog(
    attributes: Set<HTMLElementAttribute> = [],
    open: Bool = false,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro div(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dl(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro dt(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: E
@freestanding(expression)
public macro em(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro embed(
    attributes: Set<HTMLElementAttribute> = [],
    height: Int? = nil,
    src: String? = nil,
    type: String? = nil,
    width: Int? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: F
@freestanding(expression)
public macro fencedframe(
    attributes: Set<HTMLElementAttribute> = [],
    allow: String? = nil,
    height: Int? = nil,
    width: Int? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro fieldset(
    attributes: Set<HTMLElementAttribute> = [],
    disabled: Bool = false,
    form: String? = nil,
    name: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro figcaption(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro figure(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro footer(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro form(
    attributes: Set<HTMLElementAttribute> = [],
    acceptCharset: [String] = [],
    //autocapitalize: HTMLElementAttribute.AutoCapitalize? = nil,
    autocomplete: [String] = [],
    name: String? = nil,
    rel: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: H
@freestanding(expression)
public macro h1(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h2(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h3(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h4(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h5(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro h6(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro head(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro header(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro hgroup(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro hr(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: I
@freestanding(expression)
public macro i(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro iframe(
    attributes: Set<HTMLElementAttribute> = [],
    allow: String? = nil,
    browsingtopics: Bool = false,
    credentialless: Bool = false,
    csp: String? = nil,
    height: Int? = nil,
    loading: HTMLElementAttribute.Loading? = nil,
    name: String? = nil,
    referrerpolicy: HTMLElementAttribute.ReferrerPolicy? = nil,
    sandbox: [HTMLElementAttribute.Iframe.Sandbox] = [],
    src: String? = nil,
    srcdoc: String? = nil,
    width: Int? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro img(
    attributes: Set<HTMLElementAttribute> = [],
    alt: String? = nil,
    attributionsrc: [String]? = nil,
    crossorigin: HTMLElementAttribute.CrossOrigin? = nil,
    decoding: HTMLElementAttribute.Decoding? = nil,
    elementtiming: String? = nil,
    fetchpriority: HTMLElementAttribute.FetchPriority? = nil,
    height: Int? = nil,
    ismap: Bool = false,
    loading: HTMLElementAttribute.Loading? = nil,
    referrerpolicy: HTMLElementAttribute.ReferrerPolicy? = nil,
    sizes: [String] = [],
    src: String? = nil,
    srcset: [String] = [],
    width: Int? = nil,
    usemap: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro input(
    attributes: Set<HTMLElementAttribute> = [],
    accept: [String] = [],
    alt: String? = nil,
    //autocomplete: [String] = [],
    capture: HTMLElementAttribute.Capture? = nil,
    checked: Bool = false,
    dirname: HTMLElementAttribute.DirName? = nil,
    disabled: Bool = false,
    form: String? = nil,
    formaction: String? = nil,
    formenctype: HTMLElementAttribute.FormEncType? = nil,
    formmethod: HTMLElementAttribute.FormMethod? = nil,
    formnovalidate: Bool = false,
    formtarget: HTMLElementAttribute.FormTarget? = nil,
    height: Int? = nil,
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
    popovertargetaction: HTMLElementAttribute.PopoverTargetAction? = nil,
    readonly: Bool = false,
    required: Bool = false,
    size: String? = nil,
    src: String? = nil,
    step: Float? = nil,
    type: HTMLElementAttribute.InputMode? = nil,
    value: String? = nil,
    width: Int? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro ins(
    attributes: Set<HTMLElementAttribute> = [],
    cite: String? = nil,
    datetime: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: K
@freestanding(expression)
public macro kbd(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: L
@freestanding(expression)
public macro label(
    attributes: Set<HTMLElementAttribute> = [],
    for: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro legend(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro li(
    attributes: Set<HTMLElementAttribute> = [],
    value: Int? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro link(
    attributes: Set<HTMLElementAttribute> = [],
    as: HTMLElementAttribute.As? = nil,
    blocking: Set<HTMLElementAttribute.Blocking> = [],
    crossorigin: HTMLElementAttribute.CrossOrigin? = nil,
    disabled: Bool = false,
    fetchpriority: HTMLElementAttribute.FetchPriority? = nil,
    href: String? = nil,
    hreflang: String? = nil,
    imagesizes: [String] = [],
    integrity: String? = nil,
    media: String? = nil,
    referrerpolicy: HTMLElementAttribute.ReferrerPolicy? = nil,
    rel: [String] = [],
    sizes: [String] = [],
    type: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: M
@freestanding(expression)
public macro main(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro map(
    attributes: Set<HTMLElementAttribute> = [],
    name: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro mark(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro menu(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro meta(
    attributes: Set<HTMLElementAttribute> = [],
    charset: String? = nil,
    content: String? = nil,
    httpEquiv: HTMLElementAttribute.HttpEquiv? = nil,
    name: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro meter(
    attributes: Set<HTMLElementAttribute> = [],
    value: Float? = nil,
    min: Float? = nil,
    max: Float? = nil,
    low: Float? = nil,
    high: Float? = nil,
    optimum: Float? = nil,
    form: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: N
@freestanding(expression)
public macro nav(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro noscript(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: O
@freestanding(expression)
public macro object(
    attributes: Set<HTMLElementAttribute> = [],
    form: String? = nil,
    height: Int? = nil,
    name: String? = nil,
    type: String? = nil,
    width: Int? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro ol(
    attributes: Set<HTMLElementAttribute> = [],
    reversed: Bool = false,
    start: Int? = nil,
    type: HTMLElementAttribute.NumberingType? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro optgroup(
    attributes: Set<HTMLElementAttribute> = [],
    disabled: Bool = false,
    label: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro option(
    attributes: Set<HTMLElementAttribute> = [],
    disabled: Bool = false,
    label: String? = nil,
    selected: Bool = false,
    value: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro output(
    attributes: Set<HTMLElementAttribute> = [],
    for: [String] = [],
    form: String? = nil,
    name: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: P
@freestanding(expression)
public macro p(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro picture(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro portal(
    attributes: Set<HTMLElementAttribute> = [],
    referrerpolicy: HTMLElementAttribute.ReferrerPolicy? = nil,
    src: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro pre(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro progress(
    attributes: Set<HTMLElementAttribute> = [],
    max: Float? = nil,
    value: Float? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: Q
@freestanding(expression)
public macro q(
    attributes: Set<HTMLElementAttribute> = [],
    cite: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: R
@freestanding(expression)
public macro rp(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro rt(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro ruby(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: S
@freestanding(expression)
public macro s(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro samp(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro script(
    attributes: Set<HTMLElementAttribute> = [],
    async: Bool = false,
    attributionsrc: [String] = [],
    blocking: HTMLElementAttribute.Blocking? = nil,
    crossorigin: HTMLElementAttribute.CrossOrigin? = nil,
    defer: Bool = false,
    fetchpriority: HTMLElementAttribute.FetchPriority? = nil,
    integrity: String? = nil,
    nomodule: Bool = false,
    nonce: String? = nil,
    referrerpolicy: HTMLElementAttribute.ReferrerPolicy? = nil,
    src: String? = nil,
    type: HTMLElementAttribute.ScriptType? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro search(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro section(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro select(
    attributes: Set<HTMLElementAttribute> = [],
    disabled: Bool = false,
    form: String? = nil,
    multiple: Bool = false,
    name: String? = nil,
    required: Bool = false,
    size: Int? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro slot(
    attributes: Set<HTMLElementAttribute> = [],
    name: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro small(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro source(
    attributes: Set<HTMLElementAttribute> = [],
    type: String? = nil,
    src: String? = nil,
    srcset: [String] = [],
    sizes: [String] = [],
    media: String? = nil,
    height: Int? = nil,
    width: Int? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro span(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro strong(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro style(
    attributes: Set<HTMLElementAttribute> = [],
    blocking: HTMLElementAttribute.Blocking? = nil,
    media: String? = nil,
    nonce: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro sub(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro summary(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro sup(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: T
@freestanding(expression)
public macro table(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro tbody(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro td(
    attributes: Set<HTMLElementAttribute> = [],
    colspan: Int? = nil,
    headers: [String] = [],
    rowspan: Int? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro template(
    attributes: Set<HTMLElementAttribute> = [],
    shadowrootclonable: HTMLElementAttribute.Template.ShadowRootClonable? = nil,
    shadowrootdelegatesfocus: Bool = false,
    shadowrootmode: HTMLElementAttribute.Template.ShadowRootMode? = nil,
    shadowrootserializable: Bool = false,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro textarea(
    attributes: Set<HTMLElementAttribute> = [],
    //autocomplete: HTMLElementAttribute.AutoComplete,
    autocorrect: String? = nil,
    cols: Int? = nil,
    dirname: HTMLElementAttribute.DirName? = nil,
    disabled: Bool = false,
    form: String? = nil,
    maxlength: Int? = nil,
    minlength: Int? = nil,
    name: String? = nil,
    placeholder: String? = nil,
    readonly: Bool = false,
    rows: Int? = nil,
    wrap: HTMLElementAttribute.Wrap? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro tfoot(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro th(
    attributes: Set<HTMLElementAttribute> = [],
    abbr: String? = nil,
    colspan: Int? = nil,
    headers: [String] = [],
    rowspan: Int? = nil,
    scope: HTMLElementAttribute.Scope? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro thead(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro time(
    attributes: Set<HTMLElementAttribute> = [],
    datetime: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro title(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro tr(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro track(
    attributes: Set<HTMLElementAttribute> = [],
    default: Bool = true,
    kind: HTMLElementAttribute.Track.Kind? = nil,
    label: String? = nil,
    src: String? = nil,
    srclang: String? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: U
@freestanding(expression)
public macro u(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro ul(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: V
@freestanding(expression)
public macro `var`(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

@freestanding(expression)
public macro video(
    attributes: Set<HTMLElementAttribute> = [],
    autoplay: Bool = false,
    controls: Bool = true,
    controlslist: [HTMLElementAttribute.ControlsList] = [],
    crossorigin: HTMLElementAttribute.CrossOrigin? = nil,
    disablepictureinpicture: Bool = false,
    disableremoteplayback: Bool = false,
    height: Int? = nil,
    loop: Bool = false,
    muted: Bool = false,
    playsinline: Bool = true,
    poster: String? = nil,
    preload: HTMLElementAttribute.Preload? = nil,
    src: String? = nil,
    width: Int? = nil,
    innerHTML: [String] = []
) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")

// MARK: W
@freestanding(expression)
public macro wbr(attributes: Set<HTMLElementAttribute> = [], innerHTML: [String] = []) -> String = #externalMacro(module: "HTMLKitMacros", type: "HTMLElement")


// MARK: HTMLElementAttribute
public struct HTMLElementAttribute : Hashable {
    public let id:String

    init(_ id: String) {
        self.id = id
    }
}

// MARK: Global Attributes
public extension HTMLElementAttribute {
    static func accesskey(_ value: String) -> Self                            { Self("accesskey") }
    static func autoCapitalize(_ value: AutoCapitalize) -> Self               { Self("autocapitalize") }
    static let autofocus:Self = Self("autofocus")
    static func `class`(_ value: [String]) -> Self                            { Self("class") }
    static func contentEditable(_ value: ContentEditable) -> Self             { Self("contenteditable") }
    static func data(id: String, _ value: String) -> Self                     { Self("data-" + id) }
    static func dir(_ value: Dir) -> Self                                     { Self("dir") }
    static func draggable(_ value: Draggable) -> Self                         { Self("draggable") }
    static func enterKeyHint(_ value: EnterKeyHint) -> Self                   { Self("enterkeyhint") }
    static func exportParts(_ value: [String]) -> Self                        { Self("exportparts") }
    static func hidden(_ value: Hidden) -> Self                               { Self("hidden") }
    static func id(_ value: String) -> Self                                   { Self("id") }
    static let inert:Self = Self("inert")
    static func inputMode(_ value: InputMode) -> Self                         { Self("inputmode") }
    static func `is`(_ value: String) -> Self                                 { Self("is") }
    static func itemId(_ value: String) -> Self                               { Self("itemid") }
    static func itemProp(_ value: String) -> Self                             { Self("itemprop") }
    static func itemRef(_ value: String) -> Self                              { Self("itemref") }
    static func itemScope() -> Self                                           { Self("itemscope") }
    static func itemType(_ value: String) -> Self                             { Self("itemtype") }
    static func lang(_ value: String) -> Self                                 { Self("lang") }
    static func nonce(_ value: String) -> Self                                { Self("nonce") }
    static func part(_ value: [String]) -> Self                               { Self("part") }
    static func popover(_ value: Popover) -> Self                             { Self("popover") }
    static func role(_ value: String) -> Self                                 { Self("role") }
    static func slot(_ value: String) -> Self                                 { Self("slot") }
    static func spellcheck(_ value: Spellcheck) -> Self                       { Self("spellcheck") }
    static func style(_ value: String) -> Self                                { Self("style") }
    static func tabIndex(_ value: Int) -> Self                                { Self("tabindex") }
    static func title(_ value: String) -> Self                                { Self("title") }
    static func translate(_ value: Translate) -> Self                         { Self("translate") }
    static func virtualKeyboardPolicy(_ value: VirtualKeyboardPolicy) -> Self { Self("virtualkeyboardpolicy") }
    static func writingSuggestions(_ value: WritingSuggestions) -> Self       { Self("translate") }
}

public extension HTMLElementAttribute {
    enum As : String {
        case audio, document, embed, fetch, font, image, object, script, style, track, video, worker
    }

    enum AutoCapitalize : String {
        case on, off
        case none
        case sentences, words, characters
    }

    /*enum AutoComplete {
        package enum Value : String {
            case off, on, tokenList([String])

            var rawValue: RawValue {
                return ""
            }
        }
    }*/

    enum Blocking : String {
        case render
    }

    enum ButtonType : String {
        case submit, reset, button
    }

    enum Capture : String {
        case user, environment
    }

    enum ContentEditable : String {
        case `true`, `false`
        case plaintextOnly = "plaintext-only"
    }

    enum ControlsList : String {
        case nodownload, nofullscreen, noremoteplayback
    }

    enum CrossOrigin : String {
        case anonymous
        case useCredentials = "use-credentials"
    }

    enum Decoding : String {
        case sync, async, auto
    }

    enum Dir : String {
        case auto, ltr, rtl
    }

    enum DirName : String {
        case ltr, rtl
    }

    enum Draggable : String {
        case `true`, `false`
    }

    enum Download : String {
        case browserSuggested = ""
        case filename
    }

    enum EnterKeyHint : String {
        case enter, done, go, next, previous, search, send
    }

    enum FetchPriority : String {
        case high, low, auto
    }

    enum FormEncType : String {
        case applicationXWWWFormURLEncoded = "application/x-www-form-urlencoded"
        case multipartFormData = "multipart/form-data"
        case textPlain = "text/plain"
    }

    enum FormMethod : String {
        case get, post, dialog
    }

    enum FormTarget : String {
        case _self, _blank, _parent, _top
    }

    enum Hidden : String {
        case `true` = ""
        case hidden
        case untilFound = "until-found"
    }

    enum HttpEquiv : String {
        case contentSecurityPolicy = "content-security-policy"
        case contentType = "content-type"
        case defaultStyle = "default-style"
        case xUACompatible = "x-ua-compatible"
        case refresh
    }

    enum Iframe {
        public enum Sandbox : String {
            case allowDownloads = "allow-downloads"
            case allowForms = "allow-forms"
            case allowModals = "allow-modals"
            case allowOrientationLock = "allow-orientation-lock"
            case allowPointerLock = "allow-pointer-lock"
            case allowPopups = "allow-popups"
            case allowPopupsToEscapeSandbox = "allow-popups-to-escape-sandbox"
            case allowPresentation = "allow-presentation"
            case allowSameOrigin = "allow-same-origin"
            case allowScripts = "allow-scripts"
            case allowStorageAccessByUserActiviation = "allow-storage-access-by-user-activation"
            case allowTopNavigation = "allow-top-navigation"
            case allowTopNavigationByUserActivation = "allow-top-navigation-by-user-activation"
            case allowTopNavigationToCustomProtocols = "allow-top-navigation-to-custom-protocols"
        }
    }

    enum InputMode {
        case none, text, decimal, numeric, tel, search, email, url
    }

    enum Loading : String {
        case eager, lazy
    }

    enum NumberingType : String {
        case a, A, i, I, one = "1"
    }

    enum Popover : String {
        case auto, manual
    }
    enum PopoverTargetAction : String {
        case hide, show, toggle
    }

    enum Preload : String {
        case none, metadata, auto
    }

    enum ReferrerPolicy : String {
        case noReferrer = "no-referrer"
        case noReferrerWhenDowngrade = "no-referrer-when-downgrade"
        case origin
        case originWhenCrossOrigin = "origin-when-cross-origin"
        case sameOrigin
        case strictOrigin = "strict-origin"
        case strictOriginWhenCrossOrigin = "strict-origin-when-cross-origin"
        case unsafeURL = "unsafe-url"
    }

    enum Role {
        public enum Value : String {
            case alert
            case alertdialog
            case application
            case article

            case banner
            case button

            case cell
            case checkbox
            case columnheader
            case combobox
            case command
            case comment
            case complementary
            case composite
            case contentinfo

            case definition
            case dialog
            case directory
            //case document(Document)

            case feed
            case figure
            case form

            case generic
            case grid
            case gridcell
            case group

            case heading

            case img
            case input

            case landmark
            case link
            case list
            case listbox
            case listitem
            case log

            case main
            case mark
            case marquee
            case math
            case menu
            case menubar
            case menuitem
            case menuitemcheckbox
            case menuitemradio
            case meter

            case navigation
            case none
            case note

            case option
            
            case presentation
            case progressbar

            case radio
            case radiogroup
            case range
            case region
            case roletype
            case row
            case rowgroup
            case rowheader

            case scrollbar
            case search
            case searchbox
            case section
            case sectionhead
            case select
            case separator
            case slider
            case spinbutton
            case status
            case structure
            case suggestion
            case `switch`

            case tab
            case table
            case tablist
            case tabpanel
            case term
            case textbox
            case timer
            case toolbar
            case tooltip
            case tree
            case treegrid
            case treeitem

            case widget
            case window

            /*package var rawValue : RawValue {
                switch self {
                    case .document(let bro):
                        return bro.rawValue
                    default:
                        return "\(self)"
                }
            }*/

            public enum Document : String {
                case associationlist
                case associationlistitemkey
                case associationlistitemvalue
                case blockquote
                case caption
                case code
                case deletion
                case emphasis
                case figure
                case heading
                case img
                case insertion
                case list
                case listitem
                case mark
                case meter
                case paragraph
                case strong
                case `subscript`
                case superscript
                case term
                case time
            }
        }
    }

    enum ScriptType : String {
        case classic = ""
        case importmap, module, speculationrules
    }

    enum Scope : String {
        case row, col, rowgroup, colgroup
    }

    enum Shape : String {
        case rect, circle, poly, `default`
    }

    enum Spellcheck : String {
        case `true`, `false`
    }

    enum Target : String {
        case _self, _blank, _parent, _top, _unfencedTop
    }

    enum Template {
        public enum ShadowRootMode : String {
            case open, closed
        }
        public enum ShadowRootClonable : String {
            case `true`, `false`
        }
    }

    enum Track {
        public enum Kind : String {
            case subtitles, captions, chapters, metadata
        }
    }

    enum Translate : String {
        case yes, no
    }

    enum VirtualKeyboardPolicy : String {
        case auto, manual
    }

    enum Wrap : String {
        case hard, soft
    }

    enum WritingSuggestions : String {
        case `true`, `false`
    }
}
