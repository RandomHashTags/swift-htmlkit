//
//  HTMLElementValueType.swift
//
//
//  Created by Evan Anderson on 11/21/24.
//

import HTMLKitUtilities

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
}