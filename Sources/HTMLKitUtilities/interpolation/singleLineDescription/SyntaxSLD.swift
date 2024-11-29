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
        } else if let s_case:SwitchCaseSyntax = self.as(SwitchCaseSyntax.self) {
            string = s_case.singleLineDescription
        } else if let s_case_label:SwitchCaseLabelSyntax = self.as(SwitchCaseLabelSyntax.self) {
            string = s_case_label.singleLineDescription
        } else if let s_default:SwitchDefaultLabelSyntax = self.as(SwitchDefaultLabelSyntax.self) {
            string = s_default.singleLineDescription
        } else if let s_case_item:SwitchCaseItemSyntax = self.as(SwitchCaseItemSyntax.self) {
            string = s_case_item.singleLineDescription
        } else if let type:TypeSyntaxProtocol = self.as(TypeSyntax.self) {
            string = type.singleLineDescription
        } else if let annotation:TypeAnnotationSyntax = self.as(TypeAnnotationSyntax.self) {
            string = annotation.singleLineDescription
        } else {
            string = "\(self)"
            //print("SyntaxSLD;singleLineDescription;self=" + self.debugDescription)
            return ""
        }
        string.stripLeadingAndTrailingWhitespace()
        return string
    }
}

// MARK: CodeBlockItemList
public extension CodeBlockItemListSyntax {
    var singleLineDescription : String {
        var string:String = ""
        for item in self {
            string += (string.isEmpty ? "" : "; ") + item.singleLineDescription
        }
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

// MARK: SwitchCase
public extension SwitchCaseSyntax {
    var singleLineDescription : String {
        return label.singleLineDescription + ": " + statements.singleLineDescription + "; "
    }
}

// MARK: SwitchCaseItemSyntax
public extension SwitchCaseItemSyntax {
    var singleLineDescription : String {
        return pattern.singleLineDescription
    }
}

// MARK: SwitchCaseLabelSyntax
public extension SwitchCaseLabelSyntax {
    var singleLineDescription : String {
        var string:String = ""
        for item in caseItems {
            string += (string.isEmpty ? "" : ", ") + item.singleLineDescription
        }
        return "case " + string
    }
}

// MARK: SwitchDefaultLabelSyntax
public extension SwitchDefaultLabelSyntax {
    var singleLineDescription : String {
        return "default"
    }
}