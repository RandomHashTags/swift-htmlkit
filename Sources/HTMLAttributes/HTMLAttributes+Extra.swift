
#if canImport(HTMLAttributeTypes)
import HTMLAttributeTypes
#endif

#if canImport(HTMLKitUtilities)
import HTMLKitUtilities
#endif

#if canImport(SwiftSyntax)
import SwiftSyntax
#endif

// MARK: HTMLAttribute.Extra
extension HTMLAttribute {
    public enum Extra {
        public static func memoryLayout(for key: String) -> (alignment: Int, size: Int, stride: Int)? {
            func get<T>(_ dude: T.Type) -> (Int, Int, Int) {
                return (MemoryLayout<T>.alignment, MemoryLayout<T>.size, MemoryLayout<T>.stride)
            }
            switch key {
            case "as": return get(`As`.self)
            case "autocapitalize": return get(Autocapitalize.self)
            case "autocomplete": return get(Autocomplete.self)
            case "autocorrect": return get(Autocorrect.self)
            case "blocking": return get(Blocking.self)
            case "buttontype": return get(ButtonType.self)
            case "capture": return get(Capture.self)
            //case "command": return get(Command.self)
            case "contenteditable": return get(Contenteditable.self)
            case "controlslist": return get(ControlsList.self)
            case "crossorigin": return get(Crossorigin.self)
            //case "decoding": return get(Decoding.self)
            case "dir": return get(Dir.self)
            case "dirname": return get(Dirname.self)
            case "draggable": return get(Draggable.self)
            case "download": return get(Download.self)
            case "enterkeyhint": return get(Enterkeyhint.self)
            case "event": return get(HTMLEvent.self)
            case "fetchpriority": return get(FetchPriority.self)
            case "formenctype": return get(FormEncType.self)
            case "formmethod": return get(FormMethod.self)
            case "formtarget": return get(FormTarget.self)
            case "hidden": return get(Hidden.self)
            case "httpequiv": return get(HttpEquiv.self)
            case "inputmode": return get(Inputmode.self)
            //case "inputtype": return get(InputType.self)
            case "kind": return get(Kind.self)
            case "loading": return get(Loading.self)
            //case "numberingtype": return get(NumberingType.self)
            case "popover": return get(Popover.self)
            case "popovertargetaction": return get(PopoverTargetAction.self)
            case "preload": return get(Preload.self)
            case "referrerpolicy": return get(ReferrerPolicy.self)
            case "rel": return get(Rel.self)
            //case "sandbox": return get(Sandbox.self)
            case "scripttype": return get(ScriptType.self)
            case "scope": return get(Scope.self)
            case "shadowrootmode": return get(ShadowRootMode.self)
            case "shadowrootclonable": return get(ShadowRootClonable.self)
            //case "shape": return get(Shape.self)
            case "spellcheck": return get(Spellcheck.self)
            case "target": return get(Target.self)
            case "translate": return get(Translate.self)
            case "virtualkeyboardpolicy": return get(Virtualkeyboardpolicy.self)
            //case "wrap": return get(Wrap.self)
            case "writingsuggestions": return get(Writingsuggestions.self)

            case "width": return get(Width.self)
            case "height": return get(Height.self)
            default: return nil
            }
        }
    }
}

#if canImport(SwiftSyntax)
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
        case "as": return get(`As`.self)
        case "autocapitalize": return get(Autocapitalize.self)
        case "autocomplete": return get(Autocomplete.self)
        case "autocorrect": return get(Autocorrect.self)
        case "blocking": return get(Blocking.self)
        case "buttontype": return get(ButtonType.self)
        case "capture": return get(Capture.self)
        //case "command": return get(Command.self)
        case "contenteditable": return get(Contenteditable.self)
        case "controlslist": return get(ControlsList.self)
        case "crossorigin": return get(Crossorigin.self)
        //case "decoding": return get(Decoding.self)
        case "dir": return get(Dir.self)
        case "dirname": return get(Dirname.self)
        case "draggable": return get(Draggable.self)
        //case "download": return get(Download.self)
        case "enterkeyhint": return get(Enterkeyhint.self)
        case "event": return get(HTMLEvent.self)
        case "fetchpriority": return get(FetchPriority.self)
        case "formenctype": return get(FormEncType.self)
        case "formmethod": return get(FormMethod.self)
        case "formtarget": return get(FormTarget.self)
        case "hidden": return get(Hidden.self)
        case "httpequiv": return get(HttpEquiv.self)
        case "inputmode": return get(Inputmode.self)
        //case "inputtype": return get(InputType.self)
        case "kind": return get(Kind.self)
        case "loading": return get(Loading.self)
        //case "numberingtype": return get(NumberingType.self)
        case "popover": return get(Popover.self)
        case "popovertargetaction": return get(PopoverTargetAction.self)
        case "preload": return get(Preload.self)
        case "referrerpolicy": return get(ReferrerPolicy.self)
        case "rel": return get(Rel.self)
        //case "sandbox": return get(Sandbox.self)
        case "scripttype": return get(ScriptType.self)
        case "scope": return get(Scope.self)
        case "shadowrootmode": return get(ShadowRootMode.self)
        //case "shadowrootclonable": return get(ShadowRootClonable.self)
        //case "shape": return get(Shape.self)
        case "spellcheck": return get(Spellcheck.self)
        case "target": return get(Target.self)
        case "translate": return get(Translate.self)
        case "virtualkeyboardpolicy": return get(Virtualkeyboardpolicy.self)
        //case "wrap": return get(Wrap.self)
        case "writingsuggestions": return get(Writingsuggestions.self)

        case "width": return get(Width.self)
        case "height": return get(Height.self)
        default: return nil
        }
    }
}
#endif

extension As: HTMLParsable {}
extension Autocapitalize: HTMLParsable {}
extension Autocomplete: HTMLParsable {}
extension Autocorrect: HTMLParsable {}
extension Blocking: HTMLParsable {}
extension ButtonType: HTMLParsable {}
extension Capture: HTMLParsable {}
//extension Command: HTMLParsable {}
extension Contenteditable: HTMLParsable {}
extension ControlsList: HTMLParsable {}
extension Crossorigin: HTMLParsable {}
//extension Decoding: HTMLParsable {}
extension Dir: HTMLParsable {}
extension Dirname: HTMLParsable {}
extension Draggable: HTMLParsable {}
//extension Download: HTMLParsable {}
extension Enterkeyhint: HTMLParsable {}
extension FetchPriority: HTMLParsable {}
extension FormEncType: HTMLParsable {}
extension FormMethod: HTMLParsable {}
extension FormTarget: HTMLParsable {}
extension Hidden: HTMLParsable {}
extension HttpEquiv: HTMLParsable {}
extension Inputmode: HTMLParsable {}
//extension InputType: HTMLParsable {}
extension Kind: HTMLParsable {}
extension Loading: HTMLParsable {}
//extension NumberingType: HTMLParsable {}
extension Popover: HTMLParsable {}
extension PopoverTargetAction: HTMLParsable {}
extension Preload: HTMLParsable {}
extension ReferrerPolicy: HTMLParsable {}
extension Rel: HTMLParsable {}
//extension Sandbox: HTMLParsable {}
extension ScriptType: HTMLParsable {}
extension Scope: HTMLParsable {}
extension ShadowRootMode: HTMLParsable {}
//extension ShadowRootClonable: HTMLParsable {}
//extension Shape: HTMLParsable {}
extension Spellcheck: HTMLParsable {
    public var key: String { "spellcheck" }
    public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
        rawValue ? "true" : nil
    }
}
extension Target: HTMLParsable {}
extension Translate: HTMLParsable {}
extension Virtualkeyboardpolicy: HTMLParsable {}
//extension Wrap: HTMLParsable {}
extension Writingsuggestions: HTMLParsable {}
extension Width: HTMLParsable {}
extension Height: HTMLParsable {}