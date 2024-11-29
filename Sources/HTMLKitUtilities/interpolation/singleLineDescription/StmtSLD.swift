//
//  StmtSLD.swift
//
//
//  Created by Evan Anderson on 11/29/24.
//

import SwiftSyntax

public extension StmtSyntaxProtocol {
    var singleLineDescription : String {
        var string:String
        if let expression:ExpressionStmtSyntax = self.as(ExpressionStmtSyntax.self) {
            string = expression.singleLineDescription
        } else if let return_stmt:ReturnStmtSyntax = self.as(ReturnStmtSyntax.self) {
            string = return_stmt.singleLineDescription
        } else {
            string = "\(self)"
            //print("StmtSLD;StmtSyntax;singleLineDescription;self=" + self.debugDescription)
            return ""
        }
        string.stripLeadingAndTrailingWhitespace()
        return string
    }
}

// MARK: ExpressionStmt
public extension ExpressionStmtSyntax {
    var singleLineDescription : String {
        return expression.singleLineDescription
    }
}

// MARK: ReturnStmt
public extension ReturnStmtSyntax {
    var singleLineDescription : String {
        return "return " + (expression?.singleLineDescription ?? "")
    }
}