
import HTMLAttributes
import HTMLKitUtilities

extension HTMLAttribute: HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        func arrayString() -> [String]? { context.arrayString() }
        func boolean() -> Bool? { context.boolean() }
        func enumeration<T: HTMLParsable>() -> T? { context.enumeration() }
        func string() -> String? { context.string() }
        switch context.key {
        case "accesskey":             self = .accesskey(string())
        case "ariaattribute":         self = .ariaattribute(enumeration())
        case "role":                  self = .role(enumeration())
        case "autocapitalize":        self = .autocapitalize(enumeration())
        case "autofocus":             self = .autofocus(boolean())
        case "class":                 self = .class(arrayString())
        case "contenteditable":       self = .contenteditable(enumeration())
        case "data", "custom":
            guard let id = string(), let value = context.arguments.last?.expression.string(context) else {
                return nil
            }
            if context.key == "data" {
                self = .data(id, value)
            } else {
                self = .custom(id, value)
            }
        case "dir":                   self = .dir(enumeration())
        case "draggable":             self = .draggable(enumeration())
        case "enterkeyhint":          self = .enterkeyhint(enumeration())
        case "exportparts":           self = .exportparts(arrayString())
        case "hidden":                self = .hidden(enumeration())
        case "id":                    self = .id(string())
        case "inert":                 self = .inert(boolean())
        case "inputmode":             self = .inputmode(enumeration())
        case "is":                    self = .is(string())
        case "itemid":                self = .itemid(string())
        case "itemprop":              self = .itemprop(string())
        case "itemref":               self = .itemref(string())
        case "itemscope":             self = .itemscope(boolean())
        case "itemtype":              self = .itemtype(string())
        case "lang":                  self = .lang(string())
        case "nonce":                 self = .nonce(string())
        case "part":                  self = .part(arrayString())
        case "popover":               self = .popover(enumeration())
        case "slot":                  self = .slot(string())
        case "spellcheck":            self = .spellcheck(enumeration())

        /*#if canImport(CSS)
        case "style":                 self = .style(context.arrayEnumeration())
        #else*/
        case "style":                 self = .style(context.string())
        //#endif

        case "tabindex":              self = .tabindex(context.int())
        case "title":                 self = .title(string())
        case "translate":             self = .translate(enumeration())
        case "virtualkeyboardpolicy": self = .virtualkeyboardpolicy(enumeration())
        case "writingsuggestions":    self = .writingsuggestions(enumeration())
        case "trailingSlash":         self = .trailingSlash
        case "htmx":                  self = .htmx(enumeration())
        case "event":
            guard let event:HTMLEvent = enumeration(), let value = context.arguments.last?.expression.string(context) else {
                return nil
            }
            self = .event(event, value)
        default: return nil
        }
    }
}
