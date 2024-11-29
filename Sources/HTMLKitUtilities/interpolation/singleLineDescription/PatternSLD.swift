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
        if let expression:ExpressionPatternSyntax = self.as(ExpressionPatternSyntax.self) {
            string = expression.singleLineDescription
        } else if let identifier:IdentifierPatternSyntax = self.as(IdentifierPatternSyntax.self) {
            string = identifier.singleLineDescription
        } else {
            string = "\(self)"
            //print("PatternSLD;singleLineDescription;self=" + self.debugDescription)
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

// MARK: ExpressionPattern
public extension ExpressionPatternSyntax {
    var singleLineDescription : String {
        return expression.singleLineDescription
    }
}