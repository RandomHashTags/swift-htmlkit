
import HTMLAttributes
import HTMLKitUtilities
import SwiftSyntax

// MARK: Parse
extension HTMLAttribute.Extra {
    public static func parse(context: HTMLExpansionContext, expr: ExprSyntax) -> (any HTMLInitializable)? {
        func get<T: HTMLParsable>(_ type: T.Type) -> T? {
            let innerKey:String
            let arguments:LabeledExprListSyntax
            if let function = expr.functionCall {
                if let ik = function.calledExpression.memberAccess?.declName.baseName.text {
                    innerKey = ik
                } else {
                    return nil
                }
                arguments = function.arguments
            } else if let member = expr.memberAccess {
                innerKey = member.declName.baseName.text
                arguments = LabeledExprListSyntax()
            } else {
                return nil
            }
            var c = context
            c.key = innerKey
            c.arguments = arguments
            return T(context: c)
        }
        switch context.key {
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

// MARK: command
extension HTMLAttribute.Extra.command: HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        switch context.key {
        case "showModal":     self = .showModal
        case "close":         self = .close
        case "showPopover":   self = .showPopover
        case "hidePopover":   self = .hidePopover
        case "togglePopover": self = .togglePopover
        case "custom":        self = .custom(context.expression!.stringLiteral!.string(encoding: context.encoding))
        default:              return nil
        }
    }
}

// MARK: download
extension HTMLAttribute.Extra.download: HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        switch context.key {
        case "empty":    self = .empty
        case "filename": self = .filename(context.expression!.stringLiteral!.string(encoding: context.encoding))
        default:         return nil
        }
    }
}

// MARK: COMMON

extension HTMLAttribute.Extra.ariaattribute.Autocomplete: HTMLParsable {}
extension HTMLAttribute.Extra.ariaattribute.Checked: HTMLParsable {}
extension HTMLAttribute.Extra.ariaattribute.Current: HTMLParsable {}
extension HTMLAttribute.Extra.ariaattribute.DropEffect: HTMLParsable {}
extension HTMLAttribute.Extra.ariaattribute.Expanded: HTMLParsable {}
extension HTMLAttribute.Extra.ariaattribute.Grabbed: HTMLParsable {}
extension HTMLAttribute.Extra.ariaattribute.HasPopup: HTMLParsable {}
extension HTMLAttribute.Extra.ariaattribute.Hidden: HTMLParsable {}
extension HTMLAttribute.Extra.ariaattribute.Invalid: HTMLParsable {}
extension HTMLAttribute.Extra.ariaattribute.Live: HTMLParsable {}
extension HTMLAttribute.Extra.ariaattribute.Orientation: HTMLParsable {}
extension HTMLAttribute.Extra.ariaattribute.Pressed: HTMLParsable {}
extension HTMLAttribute.Extra.ariaattribute.Relevant: HTMLParsable {}
extension HTMLAttribute.Extra.ariaattribute.Selected: HTMLParsable {}
extension HTMLAttribute.Extra.ariaattribute.Sort: HTMLParsable {}
extension HTMLAttribute.Extra.ariarole: HTMLParsable {}
extension HTMLAttribute.Extra.`as`: HTMLParsable {}
extension HTMLAttribute.Extra.autocapitalize: HTMLParsable {}
extension HTMLAttribute.Extra.autocomplete: HTMLParsable {}
extension HTMLAttribute.Extra.autocorrect: HTMLParsable {}
extension HTMLAttribute.Extra.blocking: HTMLParsable {}
extension HTMLAttribute.Extra.buttontype: HTMLParsable {}
extension HTMLAttribute.Extra.capture: HTMLParsable {}
extension HTMLAttribute.Extra.contenteditable: HTMLParsable {}
extension HTMLAttribute.Extra.controlslist: HTMLParsable {}
extension HTMLAttribute.Extra.crossorigin: HTMLParsable {}
extension HTMLAttribute.Extra.decoding: HTMLParsable {}
extension HTMLAttribute.Extra.dir: HTMLParsable {}
extension HTMLAttribute.Extra.dirname: HTMLParsable {}
extension HTMLAttribute.Extra.draggable: HTMLParsable {}
extension HTMLAttribute.Extra.enterkeyhint: HTMLParsable {}
extension HTMLAttribute.Extra.fetchpriority: HTMLParsable {}
extension HTMLAttribute.Extra.formenctype: HTMLParsable {}
extension HTMLAttribute.Extra.formmethod: HTMLParsable {}
extension HTMLAttribute.Extra.formtarget: HTMLParsable {}
extension HTMLAttribute.Extra.hidden: HTMLParsable {}
extension HTMLAttribute.Extra.httpequiv: HTMLParsable {}
extension HTMLAttribute.Extra.inputmode: HTMLParsable {}
extension HTMLAttribute.Extra.inputtype: HTMLParsable {}
extension HTMLAttribute.Extra.kind: HTMLParsable {}
extension HTMLAttribute.Extra.loading: HTMLParsable {}
extension HTMLAttribute.Extra.numberingtype: HTMLParsable {}
extension HTMLAttribute.Extra.popover: HTMLParsable {}
extension HTMLAttribute.Extra.popovertargetaction: HTMLParsable {}
extension HTMLAttribute.Extra.preload: HTMLParsable {}
extension HTMLAttribute.Extra.referrerpolicy: HTMLParsable {}
extension HTMLAttribute.Extra.rel: HTMLParsable {}
extension HTMLAttribute.Extra.sandbox: HTMLParsable {}
extension HTMLAttribute.Extra.scripttype: HTMLParsable {}
extension HTMLAttribute.Extra.scope: HTMLParsable {}
extension HTMLAttribute.Extra.shadowrootmode: HTMLParsable {}
extension HTMLAttribute.Extra.shadowrootclonable: HTMLParsable {}
extension HTMLAttribute.Extra.shape: HTMLParsable {}
extension HTMLAttribute.Extra.spellcheck: HTMLParsable {}
extension HTMLAttribute.Extra.target: HTMLParsable {}
extension HTMLAttribute.Extra.translate: HTMLParsable {}
extension HTMLAttribute.Extra.virtualkeyboardpolicy: HTMLParsable {}
extension HTMLAttribute.Extra.wrap: HTMLParsable {}
extension HTMLAttribute.Extra.writingsuggestions: HTMLParsable {}
