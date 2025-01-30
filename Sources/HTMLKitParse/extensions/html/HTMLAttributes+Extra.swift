//
//  HTMLAttributes+Extra.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLAttributes
import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

extension HTMLAttribute.Extra { // TODO: move back
    public static func parse(context: some MacroExpansionContext, isUnchecked: Bool, key: String, expr: ExprSyntax) -> (any HTMLInitializable)? {
        func get<T : HTMLParsable>(_ type: T.Type) -> T? {
            let inner_key:String, arguments:LabeledExprListSyntax
            if let function:FunctionCallExprSyntax = expr.functionCall {
                inner_key = function.calledExpression.memberAccess!.declName.baseName.text
                arguments = function.arguments
            } else if let member:MemberAccessExprSyntax = expr.memberAccess {
                inner_key = member.declName.baseName.text
                arguments = LabeledExprListSyntax()
            } else {
                return nil
            }
            return T(context: context, isUnchecked: isUnchecked, key: inner_key, arguments: arguments)
        }
        switch key {
        case "as": return get(`as`.self)
        case "autocapitalize": return get(autocapitalize.self)
        case "autocomplete": return get(autocomplete.self)
        case "autocorrect": return get(autocorrect.self)
        case "blocking": return get(blocking.self)
        case "buttontype": return get(buttontype.self)
        case "capture": return get(capture.self)
        case "command": return get(command.self)
        case "contenteditable": return get(contenteditable.self)
        case "controlslist": return get(controlslist.self)
        case "crossorigin": return get(crossorigin.self)
        case "decoding": return get(decoding.self)
        case "dir": return get(dir.self)
        case "dirname": return get(dirname.self)
        case "draggable": return get(draggable.self)
        case "download": return get(download.self)
        case "enterkeyhint": return get(enterkeyhint.self)
        case "event": return get(HTMLEvent.self)
        case "fetchpriority": return get(fetchpriority.self)
        case "formenctype": return get(formenctype.self)
        case "formmethod": return get(formmethod.self)
        case "formtarget": return get(formtarget.self)
        case "hidden": return get(hidden.self)
        case "httpequiv": return get(httpequiv.self)
        case "inputmode": return get(inputmode.self)
        case "inputtype": return get(inputtype.self)
        case "kind": return get(kind.self)
        case "loading": return get(loading.self)
        case "numberingtype": return get(numberingtype.self)
        case "popover": return get(popover.self)
        case "popovertargetaction": return get(popovertargetaction.self)
        case "preload": return get(preload.self)
        case "referrerpolicy": return get(referrerpolicy.self)
        case "rel": return get(rel.self)
        case "sandbox": return get(sandbox.self)
        case "scripttype": return get(scripttype.self)
        case "scope": return get(scope.self)
        case "shadowrootmode": return get(shadowrootmode.self)
        case "shadowrootclonable": return get(shadowrootclonable.self)
        case "shape": return get(shape.self)
        case "spellcheck": return get(spellcheck.self)
        case "target": return get(target.self)
        case "translate": return get(translate.self)
        case "virtualkeyboardpolicy": return get(virtualkeyboardpolicy.self)
        case "wrap": return get(wrap.self)
        case "writingsuggestions": return get(writingsuggestions.self)

        case "width": return get(width.self)
        case "height": return get(height.self)
        default: return nil
        }
    }
}