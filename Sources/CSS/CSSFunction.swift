//
//  CSSFunction.swift
//
//
//  Created by Evan Anderson on 2/13/25.
//

public struct CSSFunction: Hashable {
    public var value:String
    public var type:CSSFunctionType

    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
    }
}