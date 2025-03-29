//
//  AriaAttribute.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLAttributes
import HTMLKitUtilities

extension HTMLAttribute.Extra.ariaattribute : HTMLParsable {
    public init?(context: HTMLExpansionContext) {
        func arrayString() -> [String]? { context.arrayString() }
        func boolean() -> Bool? { context.boolean() }
        func enumeration<T: HTMLParsable>() -> T? { context.enumeration() }
        func float() -> Float? { context.float() }
        func int() -> Int? { context.int() }
        func string() -> String? { context.string() }
        switch context.key {
        case "activedescendant":       self = .activedescendant(string())
        case "atomic":                 self = .atomic(boolean())
        case "autocomplete":           self = .autocomplete(enumeration())
        case "braillelabel":           self = .braillelabel(string())
        case "brailleroledescription": self = .brailleroledescription(string())
        case "busy":                   self = .busy(boolean())
        case "checked":                self = .checked(enumeration())
        case "colcount":               self = .colcount(int())
        case "colindex":               self = .colindex(int())
        case "colindextext":           self = .colindextext(string())
        case "colspan":                self = .colspan(int())
        case "controls":               self = .controls(arrayString())
        case "current":                self = .current(enumeration())
        case "describedby":            self = .describedby(arrayString())
        case "description":            self = .description(string())
        case "details":                self = .details(arrayString())
        case "disabled":               self = .disabled(boolean())
        case "dropeffect":             self = .dropeffect(enumeration())
        case "errormessage":           self = .errormessage(string())
        case "expanded":               self = .expanded(enumeration())
        case "flowto":                 self = .flowto(arrayString())
        case "grabbed":                self = .grabbed(enumeration())
        case "haspopup":               self = .haspopup(enumeration())
        case "hidden":                 self = .hidden(enumeration())
        case "invalid":                self = .invalid(enumeration())
        case "keyshortcuts":           self = .keyshortcuts(string())
        case "label":                  self = .label(string())
        case "labelledby":             self = .labelledby(arrayString())
        case "level":                  self = .level(int())
        case "live":                   self = .live(enumeration())
        case "modal":                  self = .modal(boolean())
        case "multiline":              self = .multiline(boolean())
        case "multiselectable":        self = .multiselectable(boolean())
        case "orientation":            self = .orientation(enumeration())
        case "owns":                   self = .owns(arrayString())
        case "placeholder":            self = .placeholder(string())
        case "posinset":               self = .posinset(int())
        case "pressed":                self = .pressed(enumeration())
        case "readonly":               self = .readonly(boolean())
        case "relevant":               self = .relevant(enumeration())
        case "required":               self = .required(boolean())
        case "roledescription":        self = .roledescription(string())
        case "rowcount":               self = .rowcount(int())
        case "rowindex":               self = .rowindex(int())
        case "rowindextext":           self = .rowindextext(string())
        case "rowspan":                self = .rowspan(int())
        case "selected":               self = .selected(enumeration())
        case "setsize":                self = .setsize(int())
        case "sort":                   self = .sort(enumeration())
        case "valuemax":               self = .valuemax(float())
        case "valuemin":               self = .valuemin(float())
        case "valuenow":               self = .valuenow(float())
        case "valuetext":              self = .valuetext(string())
        default:                       return nil
        }
    }
}