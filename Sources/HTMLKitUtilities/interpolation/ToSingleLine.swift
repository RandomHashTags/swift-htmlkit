//
//  ToSingleLine.swift
//
//
//  Created by Evan Anderson on 11/29/24.
//

import SwiftSyntax

// MARK: To Single Line
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
extension HTMLKitUtilities {
    static func to_single_line(_ syntax: SyntaxProtocol) -> String {
        var string:String = "\(syntax)"
        if let decl:DeclSyntax = syntax.as(DeclSyntax.self) {
            string = to_single_line(decl)
        } else if let expression:ExprSyntax = syntax.as(ExprSyntax.self) {
            if let function:FunctionCallExprSyntax = expression.functionCall {
                string = to_single_line(function)
            } else if let member:MemberAccessExprSyntax = expression.memberAccess {
                string = to_single_line(member)
            } else if let force_unwrap:ForceUnwrapExprSyntax = expression.as(ForceUnwrapExprSyntax.self) {
                string = to_single_line(force_unwrap)
            } else if let closure:ClosureExprSyntax = expression.as(ClosureExprSyntax.self) {
                string = to_single_line(closure)
            }
        } else if let stmt:StmtSyntax = syntax.as(StmtSyntax.self) {
            string = to_single_line(stmt)
        }
        string.stripLeadingAndTrailingWhitespace()
        return string
    }
}

// MARK: Decl to single line
extension HTMLKitUtilities {
    static func to_single_line(_ decl: DeclSyntax) -> String {
        var string:String = "\(decl)" // TODO: fix?
        string.stripLeadingAndTrailingWhitespace()
        return string
    }
}

// MARK: Expr to single line
extension HTMLKitUtilities {
    static func to_single_line(_ force_unwrap: ForceUnwrapExprSyntax) -> String {
        return to_single_line(force_unwrap.expression) + "!"
    }
    static func to_single_line(_ member: MemberAccessExprSyntax) -> String {
        var string:String = "\(member)"
        string.removeAll { $0.isWhitespace }
        return string
    }
    static func to_single_line(_ function: FunctionCallExprSyntax) -> String {
        var args:String = "", is_first:Bool = true
        for argument in function.arguments {
            var arg:String
            if let label:TokenSyntax = argument.label {
                arg = label.text
                if !is_first {
                    arg.insert(",", at: arg.startIndex)
                }
                arg += ": "
            } else {
                arg = ""
            }
            arg += to_single_line(argument.expression)
            args += arg
            is_first = false
        }
        if let closure:ClosureExprSyntax = function.trailingClosure {
            args += to_single_line(closure)
        }
        for e in function.additionalTrailingClosures {
            args += (is_first ? "" : ", ") + to_single_line(e.closure)
            is_first = false
        }
        args = "(" + args + ")"
        return to_single_line(function.calledExpression) + args
    }
    static func to_single_line(_ closure: ClosureExprSyntax) -> String {
        var signature:String = ""
        if let sig:ClosureSignatureSyntax = closure.signature {
            signature = to_single_line(sig)
        }
        var body:String = "", is_first:Bool = true
        for statement in closure.statements {
            if !is_first {
                body += "; "
            }
            switch statement.item {
                case .decl(let decl): body += to_single_line(decl)
                case .expr(let expr): body += to_single_line(expr)
                case .stmt(let stmt): body += to_single_line(stmt)
            }
            is_first = false
        }
        return "{ " + signature + body + " }"
    }
    static func to_single_line(_ signature: ClosureSignatureSyntax) -> String {
        var string:String = ""
        switch signature.parameterClause {
            case nil:
                break
            case .simpleInput(let list):
                for i in list {
                    string += i.name.text
                }
            case .parameterClause(let clause):
                string += "("
                for i in clause.parameters {
                    string += "\(i)"
                }
                string += ")"
        }
        return string + " in "
    }
}

// MARK: Stmt to single line
extension HTMLKitUtilities {
    static func to_single_line(_ statement: StmtSyntax) -> String {
        var string:String = "\(statement)" // TODO: fix?
        if let expression:ExpressionStmtSyntax = statement.as(ExpressionStmtSyntax.self) {
        } else if let labeled:LabeledStmtSyntax = statement.as(LabeledStmtSyntax.self) {
        }
        string.stripLeadingAndTrailingWhitespace()
        return string
    }
}