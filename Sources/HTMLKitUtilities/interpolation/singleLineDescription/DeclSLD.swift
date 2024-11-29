//
//  DeclSLD.swift
//
//
//  Created by Evan Anderson on 11/29/24.
//

import SwiftSyntax

public extension DeclSyntaxProtocol {
    var singleLineDescription : String {
        var string:String
        if let variable:VariableDeclSyntax = self.as(VariableDeclSyntax.self) {
            string = variable.singleLineDescription
        } else {
            string = "\(self)"
            //print("DeclSLD;DeclSyntax;singleLineDescription;self=" + self.debugDescription)
            return ""
        }
        string.stripLeadingAndTrailingWhitespace()
        return string
    }
}

// MARK: VariableDecl
public extension VariableDeclSyntax {
    var singleLineDescription : String {
        var string:String = bindingSpecifier.text + " "
        for binding in bindings {
            string += binding.singleLineDescription
        }
        return string
    }
}