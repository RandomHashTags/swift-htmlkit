//
//  TypeSLD.swift
//
//
//  Created by Evan Anderson on 11/29/24.
//

import SwiftSyntax

public extension TypeSyntaxProtocol {
    var singleLineDescription : String {
        var string:String
        if let identifier:IdentifierTypeSyntax = self.as(IdentifierTypeSyntax.self) {
            string = identifier.singleLineDescription
        } else {
            string = "\(self)"
            //print("TypeSLD;TypeSyntaxProtocol;singleLineDescription;self=" + self.debugDescription)
            return ""
        }
        string.stripLeadingAndTrailingWhitespace()
        return string
    }
}

// MARK: IdentifierType
public extension IdentifierTypeSyntax {
    var singleLineDescription : String {
        return name.text
    }
}

// MARK: TypeAnnotation
public extension TypeAnnotationSyntax {
    var singleLineDescription : String {
        return ":" + type.singleLineDescription
    }
}