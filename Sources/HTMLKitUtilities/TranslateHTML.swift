//
//  TranslateHTML.swift
//
//
//  Created by Evan Anderson on 11/27/24.
//

#if canImport(Foundation)
import Foundation

private enum TranslateHTML { // TODO: finish
    public static func translate(string: String) -> String {
        var result:String = ""
        result.reserveCapacity(string.count)
        let end_index:String.Index = string.endIndex
        var index:String.Index = string.startIndex
        while index < end_index {
            if string[index].isWhitespace { // skip
                index = string.index(after: index)
            } else if string[index] == "<" {
                var i:Int = 0, depth:Int = 1
                loop: while true {
                    i += 1
                    let char:Character = string[string.index(index, offsetBy: i)]
                    switch char {
                    case "<": depth += 1
                    case ">":
                        depth -= 1
                        if depth == 0 {
                            break loop
                        }
                    default:
                        break
                    }
                }

                let end_index:String.Index = string.firstIndex(of: ">")!
                let input:String = String(string[index...])
                if let element:String = parse_element(input: input) {
                    result += element
                    index = string.index(index, offsetBy: element.count)
                }
            }
        }
        return "#html(\n" + result + "\n)"
    }
}

extension TranslateHTML {
    /// input: "<[HTML ELEMENT TAG NAME] [attributes]>[innerHTML]"
    static func parse_element(input: String) -> String? {
        let tag_name_ends:String.Index = input.firstIndex(of: " ") ?? input.firstIndex(of: ">")!
        let tag_name:String = String(input[input.index(after: input.startIndex)..<tag_name_ends])
        if let type:HTMLElementType = HTMLElementType(rawValue: tag_name) {
            return type.rawValue + "(\n)"
        } else {
            let is_void:Bool = input.range(of: "</" + tag_name + ">") == nil
            return "custom(tag: \"\(tag_name)\", isVoid: \(is_void))"
        }
    }
}

#endif