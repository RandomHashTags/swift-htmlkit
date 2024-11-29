//
//  ExprSLD.swift
//
//
//  Created by Evan Anderson on 11/29/24.
//

import SwiftSyntax

public extension ExprSyntaxProtocol {
    var singleLineDescription : String {
        var string:String
        if let assignment:AssignmentExprSyntax = self.as(AssignmentExprSyntax.self) {
            string = assignment.singleLineDescription
        } else if let binary:BinaryOperatorExprSyntax = self.as(BinaryOperatorExprSyntax.self) {
            string = binary.singleLineDescription
        } else if let bool:BooleanLiteralExprSyntax = booleanLiteral {
            string = bool.singleLineDescription
        } else if let closure:ClosureExprSyntax = self.as(ClosureExprSyntax.self) {
            string = closure.singleLineDescription
        } else if let decl:DeclReferenceExprSyntax = declRef {
            string = decl.singleLineDescription
        } else if let float:FloatLiteralExprSyntax = floatLiteral {
            string = float.singleLineDescription
        } else if let force_unwrap:ForceUnwrapExprSyntax = self.as(ForceUnwrapExprSyntax.self) {
            string = force_unwrap.singleLineDescription
        } else if let function:FunctionCallExprSyntax = functionCall {
            string = function.singleLineDescription
        } else if let if_expr:IfExprSyntax = self.as(IfExprSyntax.self) {
            string = if_expr.singleLineDescription
        } else if let int:IntegerLiteralExprSyntax = integerLiteral {
            string = int.singleLineDescription
        } else if let infix_expr:InfixOperatorExprSyntax = self.as(InfixOperatorExprSyntax.self) {
            string = infix_expr.singleLineDescription
        } else if let member:MemberAccessExprSyntax = memberAccess {
            string = member.singleLineDescription
        } else if let string_expr:StringLiteralExprSyntax = stringLiteral {
            string = string_expr.singleLineDescription
        } else if let switch_expr:SwitchExprSyntax = self.as(SwitchExprSyntax.self) {
            string = switch_expr.singleLineDescription
        } else if let ternary:TernaryExprSyntax = self.as(TernaryExprSyntax.self) {
            string = ternary.singleLineDescription
        } else if let tuple:TupleExprSyntax = self.as(TupleExprSyntax.self) {
            string = tuple.singleLineDescription
        } else {
            string = "\(self)"
            //string = (self as SyntaxProtocol).singleLineDescription
            //print("ExprSLD;singleLineDescription;self=" + self.debugDescription)
            return ""
        }
        string.stripLeadingAndTrailingWhitespace()
        return string
    }
}

// MARK: AssignmentExpr
public extension AssignmentExprSyntax {
    var singleLineDescription : String {
        return "="
    }
}

// MARK: BinaryOperatorExpr
public extension BinaryOperatorExprSyntax {
    var singleLineDescription : String {
        return self.operator.text
    }
}

// MARK: BooleanLiteralExprSyntax
public extension BooleanLiteralExprSyntax {
    var singleLineDescription : String {
        return literal.text
    }
}

// MARK: ClosureExpr
public extension ClosureExprSyntax {
    var singleLineDescription : String {
        var body:String = "", is_first:Bool = true
        for statement in statements {
            if !is_first {
                body += "; "
            }
            switch statement.item {
                case .decl(let decl): body += decl.singleLineDescription
                case .expr(let expr): body += expr.singleLineDescription
                case .stmt(let stmt): body += stmt.singleLineDescription
            }
            is_first = false
        }
        return "{ " + (signature?.singleLineDescription ?? "") + body + " }"
    }
}

// MARK: ClosureSignature
public extension ClosureSignatureSyntax {
    var singleLineDescription : String {
        var string:String = ""
        switch parameterClause {
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

// MARK: DeclReferenceExpr
public extension DeclReferenceExprSyntax {
    var singleLineDescription : String {
        return baseName.text
    }
}

// MARK: FloatLiteralExpr
public extension FloatLiteralExprSyntax {
    var singleLineDescription : String {
        return literal.text
    }
}

// MARK: ForceUnwrapExpr
public extension ForceUnwrapExprSyntax {
    var singleLineDescription : String {
        return expression.singleLineDescription + "!"
    }
}

// MARK: FunctionCallExpr
public extension FunctionCallExprSyntax {
    var singleLineDescription : String {
        var args:String = "", is_first:Bool = true
        for argument in arguments {
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
            arg += argument.expression.singleLineDescription
            args += arg
            is_first = false
        }
        if let closure:ClosureExprSyntax = trailingClosure {
            args += closure.singleLineDescription
        }
        for e in additionalTrailingClosures {
            args += (is_first ? "" : ", ") + e.closure.singleLineDescription
            is_first = false
        }
        args = "(" + args + ")"
        return calledExpression.singleLineDescription + args
    }
}

// MARK: IfExpr
public extension IfExprSyntax {
    var singleLineDescription : String {
        var conditions:String = ""
        for condition in self.conditions {
            conditions += (conditions.isEmpty ? "" : " ") + condition.singleLineDescription
        }
        var body:String = ""
        for statement in self.body.statements {
            body += (body.isEmpty ? "" : "; ") + statement.singleLineDescription
        }
        if let else_body:ElseBody = elseBody {
            body += " } else { "
            switch else_body {
                case .ifExpr(let if_expr): body += if_expr.singleLineDescription
                case .codeBlock(let block): body += block.statements.singleLineDescription
            }
        }
        return "if " + conditions + " { " + body + " }"
    }
}

// MARK: InfixOperatorExpr
public extension InfixOperatorExprSyntax {
    var singleLineDescription : String {
        return leftOperand.singleLineDescription + " " + self.operator.singleLineDescription + " " + rightOperand.singleLineDescription
    }
}

// MARK: IntegerLiteralExpr
public extension IntegerLiteralExprSyntax {
    var singleLineDescription : String {
        return literal.text
    }
}

// MARK: LabeledExpr
public extension LabeledExprSyntax {
    var singleLineDescription : String {
        // TODO: check label
        return expression.singleLineDescription
    }
}

// MARK: MemberAccessExpr
public extension MemberAccessExprSyntax {
    var singleLineDescription : String {
        var string:String = "\(self)"
        string.removeAll { $0.isWhitespace }
        return string
    }
}

// MARK: StringLiteralExpr
public extension StringLiteralExprSyntax {
    var singleLineDescription : String {
        var string:String = ""
        for segment in segments {
            if let literal:StringSegmentSyntax = segment.as(StringSegmentSyntax.self) {
                string += (string.isEmpty ? "" : " ") + literal.content.text
            }
        }
        return "\"" + string + "\""
    }
}

// MARK: SwitchExpr
public extension SwitchExprSyntax {
    var singleLineDescription : String {
        var string:String = ""
        for c in cases {
            string += c.singleLineDescription
        }
        return "switch " + subject.singleLineDescription + " { " + string + " }"
    }
}

// MARK: TernaryExpr
public extension TernaryExprSyntax {
    var singleLineDescription : String {
        return condition.singleLineDescription + " ? " + thenExpression.singleLineDescription + " : " + elseExpression.singleLineDescription
    }
}

// MARK: TupleExpr
public extension TupleExprSyntax {
    var singleLineDescription : String {
        var string:String = "("
        for element in elements {
            string += element.singleLineDescription
        }
        return string + ")"
    }
}