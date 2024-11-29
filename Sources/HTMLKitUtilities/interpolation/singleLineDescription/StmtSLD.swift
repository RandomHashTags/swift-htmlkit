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
        if let brk:BreakStmtSyntax = self.as(BreakStmtSyntax.self) {
            string = brk.singleLineDescription
        } else if let expression:ExpressionStmtSyntax = self.as(ExpressionStmtSyntax.self) {
            string = expression.singleLineDescription
        } else if let ft:FallThroughStmtSyntax = self.as(FallThroughStmtSyntax.self) {
            string = ft.singleLineDescription
        } else if let return_stmt:ReturnStmtSyntax = self.as(ReturnStmtSyntax.self) {
            string = return_stmt.singleLineDescription
        } else {
            string = "\(self)"
            //print("StmtSLD;singleLineDescription;self=" + self.debugDescription)
            return ""
        }
        string.stripLeadingAndTrailingWhitespace()
        return string
    }
}

// MARK: BreakStmt
public extension BreakStmtSyntax {
    var singleLineDescription : String {
        return "break"
    }
}

// MARK: ExpressionStmt
public extension ExpressionStmtSyntax {
    var singleLineDescription : String {
        return expression.singleLineDescription
    }
}

// MARK: FallthroughStmt
public extension FallThroughStmtSyntax {
    var singleLineDescription : String {
        return "fallthrough"
    }
}

// MARK: ReturnStmt
public extension ReturnStmtSyntax {
    var singleLineDescription : String {
        return "return " + (expression?.singleLineDescription ?? "")
    }
}