//
//  SyntaxSLD.swift
//
//
//  Created by Evan Anderson on 11/29/24.
//

import SwiftSyntax

extension String {
    mutating func stripLeadingAndTrailingWhitespace() {
        while first?.isWhitespace ?? false {
            removeFirst()
        }
        while last?.isWhitespace ?? false {
            removeLast()
        }
    }
}

public extension SyntaxProtocol {
    var singleLineDescription : String {
        var string:String
        if let code_bi:CodeBlockItemSyntax = self.as(CodeBlockItemSyntax.self) {
            string = code_bi.singleLineDescription
        } else if let condition:ConditionElementSyntax = self.as(ConditionElementSyntax.self) {
            string = condition.singleLineDescription
        } else if let decl:DeclSyntax = self.as(DeclSyntax.self) {
            string = decl.singleLineDescription
        } else if let expression:ExprSyntax = self.as(ExprSyntax.self) {
            string = expression.singleLineDescription
        } else if let initializer:InitializerClauseSyntax = self.as(InitializerClauseSyntax.self) {
            string = initializer.singleLineDescription
        } else if let labeled:LabeledExprSyntax = self.as(LabeledExprSyntax.self) {
            string = labeled.singleLineDescription
        } else if let pattern:PatternSyntaxProtocol = self.as(PatternSyntax.self) {
            string = pattern.singleLineDescription
        } else if let binding:PatternBindingSyntax = self.as(PatternBindingSyntax.self) {
            string = binding.singleLineDescription
        } else if let stmt:StmtSyntax = self.as(StmtSyntax.self) {
            string = stmt.singleLineDescription
        } else if let type:TypeSyntaxProtocol = self.as(TypeSyntax.self) {
            string = type.singleLineDescription
        } else if let annotation:TypeAnnotationSyntax = self.as(TypeAnnotationSyntax.self) {
            string = annotation.singleLineDescription
        } else {
            string = "\(self)"
            //print("SyntaxSLD;SyntaxProtocol;singleLineDescription;self=" + self.debugDescription)
            return ""
        }
        string.stripLeadingAndTrailingWhitespace()
        return string
    }
}

// MARK: CodeBlockItem
public extension CodeBlockItemSyntax {
    var singleLineDescription : String {
        switch item {
            case .decl(let decl): return decl.singleLineDescription
            case .expr(let expr): return expr.singleLineDescription
            case .stmt(let stmt): return stmt.singleLineDescription
        }
    }
}

// MARK: ConditionElement
public extension ConditionElementSyntax {
    var singleLineDescription : String {
        return condition.singleLineDescription
    }
}

// MARK: InitializerClause
public extension InitializerClauseSyntax {
    var singleLineDescription : String {
        return "= " + value.singleLineDescription
    }
}