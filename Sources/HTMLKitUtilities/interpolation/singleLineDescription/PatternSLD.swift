//
//  PatternSLD.swift
//
//
//  Created by Evan Anderson on 11/29/24.
//

import SwiftSyntax

public extension PatternSyntaxProtocol {
    var singleLineDescription : String {
        var string:String
        if let identifier:IdentifierPatternSyntax = self.as(IdentifierPatternSyntax.self) {
            string = identifier.singleLineDescription
        } else {
            string = "\(self)"
            //print("PatternSLD;PatternSyntaxProtocol;singleLineDescription;self=" + self.debugDescription)
            return ""
        }
        string.stripLeadingAndTrailingWhitespace()
        return string
    }
}

// MARK: IdentifierPattern
public extension IdentifierPatternSyntax {
    var singleLineDescription : String {
        return identifier.text
    }
}

// MARK: PatternBinding
public extension PatternBindingSyntax {
    var singleLineDescription : String {
        var string:String = pattern.singleLineDescription
        if let annotation:TypeAnnotationSyntax = typeAnnotation {
            string += annotation.singleLineDescription
        }
        if let initializer:InitializerClauseSyntax = initializer {
            string += " " + initializer.singleLineDescription
        }
        return string
    }
}