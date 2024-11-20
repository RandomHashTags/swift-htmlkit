//
//  HTMLKitUtilities.swift
//
//
//  Created by Evan Anderson on 9/19/24.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

// MARK: Escape HTML
public extension String {
    /// Escapes all occurrences of source-breaking HTML characters
    /// - Parameters:
    ///   - escapeAttributes: Whether or not to escape source-breaking HTML attribute characters
    /// - Returns: A new `String` escaping source-breaking HTML
    func escapingHTML(escapeAttributes: Bool) -> String {
        var string:String = self
        string.escapeHTML(escapeAttributes: escapeAttributes)
        return string
    }
    /// Escapes all occurrences of source-breaking HTML characters
    /// - Parameters:
    ///   - escapeAttributes: Whether or not to escape source-breaking HTML attribute characters
    mutating func escapeHTML(escapeAttributes: Bool) {
        self.replace("&", with: "&amp;")
        self.replace("<", with: "&lt;")
        self.replace(">", with: "&gt;")
        if escapeAttributes {
            self.escapeHTMLAttributes()
        }
    }
    /// Escapes all occurrences of source-breaking HTML attribute characters
    /// - Returns: A new `String` escaping source-breaking HTML attribute characters
    func escapingHTMLAttributes() -> String {
        var string:String = self
        string.escapeHTMLAttributes()
        return string
    }
    /// Escapes all occurrences of source-breaking HTML attribute characters
    mutating func escapeHTMLAttributes() {
        self.replace("\"", with: "&quot;")
        self.replace("'", with: "&#39")
    }
}

// MARK: CSSUnit
public extension HTMLElementAttribute {
    struct CSSUnit {
        public let htmlValue:String?

        private init(_ value: Float) {
            htmlValue = value.description
        }
    }
}
public extension HTMLElementAttribute.CSSUnit { // https://www.w3schools.com/cssref/css_units.php
    // absolute
    static func centimeters(_ value: Float) -> Self { Self(value) }
    static func millimeters(_ value: Float) -> Self { Self(value) }
    /// 1 inch = 96px = 2.54cm
    static func inches(_ value: Float) -> Self      { Self(value) }
    /// 1 pixel = 1/96th of 1inch
    static func pixels(_ value: Float) -> Self      { Self(value) }
    /// 1 point = 1/72 of 1inch
    static func points(_ value: Float) -> Self      { Self(value) }
    /// 1 pica = 12 points
    static func picas(_ value: Float) -> Self       { Self(value) }
    
    // relative
    /// Relative to the font-size of the element (2em means 2 times the size of the current font)
    static func em(_ value: Float) -> Self             { Self(value) }
    /// Relative to the x-height of the current font (rarely used)
    static func ex(_ value: Float) -> Self             { Self(value) }
    /// Relative to the width of the "0" (zero)
    static func ch(_ value: Float) -> Self             { Self(value) }
    /// Relative to font-size of the root element
    static func rem(_ value: Float) -> Self            { Self(value) }
    /// Relative to 1% of the width of the viewport
    static func viewportWidth(_ value: Float) -> Self  { Self(value) }
    /// Relative to 1% of the height of the viewport
    static func viewportHeight(_ value: Float) -> Self { Self(value) }
    /// Relative to 1% of viewport's smaller dimension
    static func viewportMin(_ value: Float) -> Self    { Self(value) }
    /// Relative to 1% of viewport's larger dimension
    static func viewportMax(_ value: Float) -> Self    { Self(value) }
    /// Relative to the parent element
    static func percent(_ value: Float) -> Self        { Self(value) }
}


// MARK: HTMLElementType
package enum HTMLElementType : String, CaseIterable {
    case escapeHTML

    case html, htmlUTF8Bytes, htmlUTF16Bytes, htmlUTF8CString
    
    #if canImport(Foundation)
    case htmlData
    #endif

    case htmlByteBuffer
    
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

    case `var`
    case video

    case wbr

    package var isVoid : Bool {
        switch self {
        case .area, .base, .br, .col, .embed, .hr, .img, .input, .link, .meta, .source, .track, .wbr:
            return true
        default:
            return false
        }
    }
}
// MARK: HTMLElementValueType
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

    // MARK: Parse element
    package static func parse_element(context: some MacroExpansionContext, _ function: FunctionCallExprSyntax) -> HTMLElement? {
        guard let key:String = function.calledExpression.declRef?.baseName.text else { return nil }
        switch key {
            case "a": return a(context: context, function)
            case "abbr": return abbr(context: context, function)
            case "address": return address(context: context, function)
            case "area": return area(context: context, function)
            case "article": return article(context: context, function)
            case "aside": return aside(context: context, function)
            case "audio": return audio(context: context, function)
            case "b": return b(context: context, function)
            case "base": return base(context: context, function)
            case "bdi": return bdi(context: context, function)
            case "bdo": return bdo(context: context, function)
            case "blockquote": return blockquote(context: context, function)
            case "body": return body(context: context, function)
            case "br": return br(context: context, function)
            case "button": return button(context: context, function)
            case "canvas": return canvas(context: context, function)
            case "caption": return caption(context: context, function)
            case "cite": return cite(context: context, function)
            case "code": return code(context: context, function)
            case "col": return col(context: context, function)
            case "colgroup": return colgroup(context: context, function)
            case "data": return data(context: context, function)
            case "datalist": return datalist(context: context, function)
            case "dd": return dd(context: context, function)
            case "del": return del(context: context, function)
            case "details": return details(context: context, function)
            case "dfn": return dfn(context: context, function)
            case "dialog": return dialog(context: context, function)
            case "div": return div(context: context, function)
            case "dl": return dl(context: context, function)
            case "dt": return dt(context: context, function)
            case "em": return em(context: context, function)
            case "embed": return embed(context: context, function)
            case "fencedframe": return fencedframe(context: context, function)
            case "fieldset": return fieldset(context: context, function)
            case "figcaption": return figcaption(context: context, function)
            case "figure": return figure(context: context, function)
            case "footer": return footer(context: context, function)
            case "form": return form(context: context, function)
            case "h1": return h1(context: context, function)
            case "h2": return h2(context: context, function)
            case "h3": return h3(context: context, function)
            case "h4": return h4(context: context, function)
            case "h5": return h5(context: context, function)
            case "h6": return h6(context: context, function)
            case "head": return head(context: context, function)
            case "header": return header(context: context, function)
            case "hgroup": return hgroup(context: context, function)
            case "hr": return hr(context: context, function)
            case "html": return html(context: context, function)
            case "i": return i(context: context, function)
            case "iframe": return iframe(context: context, function)
            case "img": return img(context: context, function)
            case "input": return input(context: context, function)
            case "ins": return ins(context: context, function)
            case "kbd": return kbd(context: context, function)
            case "label": return label(context: context, function)
            case "legend": return legend(context: context, function)
            case "li": return li(context: context, function)
            case "link": return link(context: context, function)
            case "main": return main(context: context, function)
            case "map": return map(context: context, function)
            case "mark": return mark(context: context, function)
            case "menu": return menu(context: context, function)
            case "meta": return meta(context: context, function)
            case "meter": return meter(context: context, function)
            case "nav": return nav(context: context, function)
            case "noscript": return noscript(context: context, function)
            case "object": return object(context: context, function)
            case "ol": return ol(context: context, function)
            case "optgroup": return optgroup(context: context, function)
            case "option": return option(context: context, function)
            case "output": return output(context: context, function)
            case "p": return p(context: context, function)
            case "picture": return picture(context: context, function)
            case "portal": return portal(context: context, function)
            case "pre": return pre(context: context, function)
            case "progress": return progress(context: context, function)
            case "q": return q(context: context, function)
            case "rp": return rp(context: context, function)
            case "rt": return rt(context: context, function)
            case "ruby": return ruby(context: context, function)
            case "s": return s(context: context, function)
            case "samp": return samp(context: context, function)
            case "script": return script(context: context, function)
            case "search": return search(context: context, function)
            case "section": return section(context: context, function)
            case "select": return select(context: context, function)
            case "slot": return slot(context: context, function)
            case "small": return small(context: context, function)
            case "source": return source(context: context, function)
            case "span": return span(context: context, function)
            case "strong": return strong(context: context, function)
            case "style": return style(context: context, function)
            case "sub": return sub(context: context, function)
            case "summary": return summary(context: context, function)
            case "sup": return sup(context: context, function)
            case "table": return table(context: context, function)
            case "tbody": return tbody(context: context, function)
            case "td": return td(context: context, function)
            case "template": return template(context: context, function)
            case "textarea": return textarea(context: context, function)
            case "tfoot": return tfoot(context: context, function)
            case "th": return th(context: context, function)
            case "thead": return thead(context: context, function)
            case "time": return time(context: context, function)
            case "title": return title(context: context, function)
            case "tr": return tr(context: context, function)
            case "track": return track(context: context, function)
            case "u": return u(context: context, function)
            case "ul": return ul(context: context, function)
            //case "var": return `var`(context: context, function)
            case "video": return video(context: context, function)
            case "wbr": return wbr(context: context, function)

            case "custom": return custom(context: context, function)
            default:        return nil
        }
    }
}

// MARK: HTMLKitUtilities
public enum HTMLKitUtilities {
    public struct ElementData {
        public let globalAttributes:[HTMLElementAttribute]
        public let attributes:[String:Any]
        public let innerHTML:[CustomStringConvertible]
        public let trailingSlash:Bool

        init(
            _ globalAttributes: [HTMLElementAttribute],
            _ attributes: [String:Any],
            _ innerHTML: [CustomStringConvertible],
            _ trailingSlash: Bool
        ) {
            self.globalAttributes = globalAttributes
            self.attributes = attributes
            self.innerHTML = innerHTML
            self.trailingSlash = trailingSlash
        }
    }
}
public extension HTMLKitUtilities {
    // MARK: Parse Arguments
    static func parse_arguments(
        context: some MacroExpansionContext,
        children: SyntaxChildren
    ) -> ElementData {
        var global_attributes:[HTMLElementAttribute] = []
        var attributes:[String:Any] = [:]
        var innerHTML:[CustomStringConvertible] = []
        var trailingSlash:Bool = false
        var lookupFiles:Set<String> = []
        for element in children {
            if let child:LabeledExprSyntax = element.labeled {
                if var key:String = child.label?.text {
                    if key == "lookupFiles" {
                        lookupFiles = Set(child.expression.array!.elements.compactMap({ $0.expression.stringLiteral?.string }))
                    } else if key == "attributes" {
                        (global_attributes, trailingSlash) = parse_global_attributes(context: context, array: child.expression.array!.elements, lookupFiles: lookupFiles)
                    } else {
                        if key == "acceptCharset" {
                            key = "accept-charset"
                        } else if key == "httpEquiv" {
                            key = "http-equiv"
                        }
                        if let string:String = parse_attribute(context: context, key: key, expression: child.expression, lookupFiles: lookupFiles) {
                            attributes[key] = string
                        }
                    }
                // inner html
                } else if let inner_html:CustomStringConvertible = parse_inner_html(context: context, child: child, lookupFiles: lookupFiles) {
                    innerHTML.append(inner_html)
                }
            }
        }
        return ElementData(global_attributes, attributes, innerHTML, trailingSlash)
    }
    // MARK: Parse Global Attributes
    static func parse_global_attributes(
        context: some MacroExpansionContext,
        array: ArrayElementListSyntax,
        lookupFiles: Set<String>
    ) -> (attributes: [HTMLElementAttribute], trailingSlash: Bool) {
        var keys:Set<String> = []
        var attributes:[HTMLElementAttribute] = []
        var trailingSlash:Bool = false
        for element in array {
            if let function:FunctionCallExprSyntax = element.expression.functionCall {
                if let attr:HTMLElementAttribute = HTMLElementAttribute(rawValue: "\(function)") {
                    let first_expression:ExprSyntax = function.arguments.first!.expression
                    let key:String = function.calledExpression.memberAccess!.declName.baseName.text
                    if key.contains(" ") {
                        context.diagnose(Diagnostic(node: first_expression, message: DiagnosticMsg(id: "spacesNotAllowedInAttributeDeclaration", message: "Spaces are not allowed in attribute declaration.")))
                    } else if keys.contains(key) {
                        global_attribute_already_defined(context: context, attribute: key, node: first_expression)
                    } else {
                        attributes.append(attr)
                        keys.insert(key)
                    }
                }
            } else if let member:String = element.expression.memberAccess?.declName.baseName.text, member == "trailingSlash" {
                if keys.contains(member) {
                    global_attribute_already_defined(context: context, attribute: member, node: element.expression)
                } else {
                    trailingSlash = true
                    keys.insert(member)
                }
            }
        }
        return (attributes, trailingSlash)
    }
    static func global_attribute_already_defined(context: some MacroExpansionContext, attribute: String, node: some SyntaxProtocol) {
        context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "globalAttributeAlreadyDefined", message: "Global attribute \"" + attribute + "\" is already defined.")))
    }
    // MARK: Parse innerHTML
    static func parse_inner_html(
        context: some MacroExpansionContext,
        child: LabeledExprSyntax,
        lookupFiles: Set<String>
    ) -> CustomStringConvertible? {
        if let string:HTMLElement = parse_element(context: context, expr: child.expression) {
            return string
        } else if var string:String = parse_literal_value(context: context, key: "", expression: child.expression, lookupFiles: lookupFiles)?.value {
            string.escapeHTML(escapeAttributes: false)
            return string
        } else {
            unallowed_expression(context: context, node: child)
            return nil
        }
    }
    static func unallowed_expression(context: some MacroExpansionContext, node: LabeledExprSyntax) {
        context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unallowedExpression", message: "String Interpolation is required when encoding runtime values."), fixIts: [
            FixIt(message: DiagnosticMsg(id: "useStringInterpolation", message: "Use String Interpolation."), changes: [
                FixIt.Change.replace(
                    oldNode: Syntax(node),
                    newNode: Syntax(StringLiteralExprSyntax(content: "\\(\(node))"))
                )
            ])
        ]))
    }
    
    // MARK: Parse Attribute
    static func parse_attribute(
        context: some MacroExpansionContext,
        key: String,
        expression: ExprSyntax,
        lookupFiles: Set<String>
    ) -> String? {
        if var (string, returnType):(String, LiteralReturnType) = parse_literal_value(context: context, key: key, expression: expression, lookupFiles: lookupFiles) {
            switch returnType {
            case .boolean: return string.elementsEqual("true") ? key : nil
            case .string, .enumCase:
                if returnType == .enumCase && string.isEmpty
                    || returnType == .string && key == "attributionsrc" && string.isEmpty {
                    return key
                }
                string.escapeHTML(escapeAttributes: true)
                return key + "=\\\"" + string + "\\\""
            case .interpolation:
                return key + "=\\\"" + string + "\\\""
            }
        }
        return nil
    }
    // MARK: Parse element
    static func parse_element(context: some MacroExpansionContext, expr: ExprSyntax) -> HTMLElement? {
        guard let function:FunctionCallExprSyntax = expr.functionCall else { return nil }
        return HTMLElementValueType.parse_element(context: context, function)
    }
    // MARK: Parse Literal Value
    static func parse_literal_value(
        context: some MacroExpansionContext,
        key: String,
        expression: ExprSyntax,
        lookupFiles: Set<String>
    ) -> (value: String, returnType: LiteralReturnType)? {
        if let boolean:String = expression.booleanLiteral?.literal.text {
            return (boolean, .boolean)
        }
        if let string:String = expression.integerLiteral?.literal.text ?? expression.floatLiteral?.literal.text {
            return (string, .string)
        }
        guard var (string, returnType):(String, LiteralReturnType) = extract_string_or_interpolation(context: context, key: key, expression: expression, lookupFiles: lookupFiles) else {
            //context.diagnose(Diagnostic(node: expression, message: DiagnosticMsg(id: "somethingWentWrong", message: "Something went wrong. (" + expression.debugDescription + ")", severity: .warning)))
            return nil
        }
        var remaining_interpolation:Int = returnType == .interpolation ? 1 : 0, interpolation:[ExpressionSegmentSyntax] = []
        if let stringLiteral:StringLiteralExprSyntax = expression.stringLiteral {
            remaining_interpolation = stringLiteral.segments.count(where: { $0.is(ExpressionSegmentSyntax.self) })
            interpolation = stringLiteral.segments.compactMap({ $0.as(ExpressionSegmentSyntax.self) })
        }
        for expr in interpolation {
            string.replace("\(expr)", with: flatten_interpolation(context: context, remaining_interpolation: &remaining_interpolation, expr: expr, lookupFiles: lookupFiles))
        }
        if remaining_interpolation > 0 {
            warn_interpolation(context: context, node: expression, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
            if remaining_interpolation > 0 && !string.contains("\\(") {
                string = "\\(" + string + ")"
            }
        }
        if remaining_interpolation > 0 {
            returnType = .interpolation
        }
        return (string, returnType)
    }
    // MARK: Extract string/interpolation
    static func extract_string_or_interpolation(
        context: some MacroExpansionContext,
        key: String,
        expression: ExprSyntax,
        lookupFiles: Set<String>
    ) -> (String, LiteralReturnType)? {
        if let stringLiteral:StringLiteralExprSyntax = expression.stringLiteral {
            let return_type:LiteralReturnType = stringLiteral.segments.count(where: { $0.is(ExpressionSegmentSyntax.self) }) == 0 ? .string : .interpolation
            return (stringLiteral.string, return_type)
        }
        if let function:FunctionCallExprSyntax = expression.functionCall {
            let enums:Set<String> = ["command", "download", "height", "width"]
            if enums.contains(key) || key.hasPrefix("aria-") {
                return ("", .enumCase)
            } else {
                if let decl:String = function.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                    switch decl {
                        case "StaticString":
                            var string:String = function.arguments.first!.expression.stringLiteral!.string
                            return (string, .string)
                        default:
                            if let element:HTMLElement = HTMLElementValueType.parse_element(context: context, function) {
                                let string:String = element.description
                                return (string, string.contains("\\(") ? .interpolation : .string)
                            }
                            break
                    }
                }
                return ("\(function)", .interpolation)
            }
        }
        if let member:MemberAccessExprSyntax = expression.memberAccess {
            return ("\(member)", .interpolation)
        }
        if let array:ArrayExprSyntax = expression.array {
            let separator:Character, separator_string:String
            switch key {
                case "accept", "coords", "exportparts", "imagesizes", "imagesrcset", "sizes", "srcset":
                    separator = ","
                    break
                case "allow":
                    separator = ";"
                    break
                default:
                    separator = " "
                    break
            }
            separator_string = String(separator)
            var result:String = ""
            for element in array.elements {
                if let string:String = element.expression.stringLiteral?.string {
                    if string.contains(separator) {
                        context.diagnose(Diagnostic(node: element.expression, message: DiagnosticMsg(id: "characterNotAllowedInDeclaration", message: "Character \"\(separator)\" is not allowed when declaring values for \"" + key + "\".")))
                        return nil
                    }
                    result += string + separator_string
                }
                if let string:String = element.expression.integerLiteral?.literal.text ?? element.expression.floatLiteral?.literal.text {
                    result += string + separator_string
                }
            }
            if !result.isEmpty {
                result.removeLast()
            }
            return (result, .string)
        }
        if let _:DeclReferenceExprSyntax = expression.as(DeclReferenceExprSyntax.self) {
            var string:String = "\(expression)", remaining_interpolation:Int = 1
            warn_interpolation(context: context, node: expression, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
            if remaining_interpolation > 0 {
                return ("\\(" + string + ")", .interpolation)
            } else {
                return (string, .string)
            }
        }
        return nil
    }
    // MARK: Flatten Interpolation
    static func flatten_interpolation(
        context: some MacroExpansionContext,
        remaining_interpolation: inout Int,
        expr: ExpressionSegmentSyntax,
        lookupFiles: Set<String>
    ) -> String {
        let expression:ExprSyntax = expr.expressions.first!.expression
        var string:String = "\(expr)"
        if let stringLiteral:StringLiteralExprSyntax = expression.stringLiteral {
            let segments:StringLiteralSegmentListSyntax = stringLiteral.segments
            if segments.count(where: { $0.is(StringSegmentSyntax.self) }) == segments.count {
                remaining_interpolation = 0
                string = segments.map({ $0.as(StringSegmentSyntax.self)!.content.text }).joined()
            } else {
                string = ""
                for segment in segments {
                    if let literal:String = segment.as(StringSegmentSyntax.self)?.content.text {
                        string += literal
                    } else if let interpolation:ExpressionSegmentSyntax = segment.as(ExpressionSegmentSyntax.self) {
                        let flattened:String = flatten_interpolation(context: context, remaining_interpolation: &remaining_interpolation, expr: interpolation, lookupFiles: lookupFiles)
                        if "\(interpolation)" == flattened {
                            //string += "\\(\"\(flattened)\".escapingHTML(escapeAttributes: true))"
                            string += "\(flattened)"
                            warn_interpolation(context: context, node: interpolation, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
                        } else {
                            string += flattened
                        }
                    } else {
                        //string += "\\(\"\(segment)\".escapingHTML(escapeAttributes: true))"
                        warn_interpolation(context: context, node: segment, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
                        string += "\(segment)"
                    }
                }
            }
        } else if let fix:String = expression.integerLiteral?.literal.text ?? expression.floatLiteral?.literal.text {
            let target:String = "\(expr)"
            remaining_interpolation -= string.ranges(of: target).count
            string.replace(target, with: fix)
        } else {
            //string = "\\(\"\(string)\".escapingHTML(escapeAttributes: true))"
            warn_interpolation(context: context, node: expr, string: &string, remaining_interpolation: &remaining_interpolation, lookupFiles: lookupFiles)
        }
        return string
    }
    static func warn_interpolation(
        context: some MacroExpansionContext,
        node: some SyntaxProtocol,
        string: inout String,
        remaining_interpolation: inout Int,
        lookupFiles: Set<String>
    ) {
        if let fix:String = InterpolationLookup.find(context: context, node, files: lookupFiles) {
            let expression:String = "\(node)"
            let ranges:[Range<String.Index>] = string.ranges(of: expression)
            string.replace(expression, with: fix)
            remaining_interpolation -= ranges.count
        } else {
            context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "unsafeInterpolation", message: "Interpolation may introduce raw HTML.", severity: .warning)))
        }
    }
}

public enum LiteralReturnType {
    case boolean, string, enumCase, interpolation
}

// MARK: Misc
package extension SyntaxProtocol {
    var booleanLiteral : BooleanLiteralExprSyntax? { self.as(BooleanLiteralExprSyntax.self) }
    var stringLiteral : StringLiteralExprSyntax? { self.as(StringLiteralExprSyntax.self) }
    var integerLiteral : IntegerLiteralExprSyntax? { self.as(IntegerLiteralExprSyntax.self) }
    var floatLiteral : FloatLiteralExprSyntax? { self.as(FloatLiteralExprSyntax.self) }
    var array : ArrayExprSyntax? { self.as(ArrayExprSyntax.self) }
    var memberAccess : MemberAccessExprSyntax? { self.as(MemberAccessExprSyntax.self) }
    var macroExpansion : MacroExpansionExprSyntax? { self.as(MacroExpansionExprSyntax.self) }
    var functionCall : FunctionCallExprSyntax? { self.as(FunctionCallExprSyntax.self) }
    var declRef : DeclReferenceExprSyntax? { self.as(DeclReferenceExprSyntax.self) }
}
package extension SyntaxChildren.Element {
    var labeled : LabeledExprSyntax? { self.as(LabeledExprSyntax.self) }
}
package extension StringLiteralExprSyntax {
    var string : String { "\(segments)" }
}

// MARK: DiagnosticMsg
package struct DiagnosticMsg : DiagnosticMessage, FixItMessage {
    package let message:String
    package let diagnosticID:MessageID
    package let severity:DiagnosticSeverity
    package var fixItID : MessageID { diagnosticID }

    package init(id: String, message: String, severity: DiagnosticSeverity = .error) {
        self.message = message
        self.diagnosticID = MessageID(domain: "HTMLKitMacros", id: id)
        self.severity = severity
    }
}