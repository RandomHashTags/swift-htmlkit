//
//  InterpolationLookup.swift
//
//
//  Created by Evan Anderson on 11/2/24.
//

import Foundation
import SwiftParser
import SwiftSyntax

enum InterpolationLookup {
    private static var cached:[String:SourceFileSyntax] = [:]

    static func find(_ node: some SyntaxProtocol, files: Set<String>) -> String? {
        guard let item:Item = item(node) else { return nil }
        /*for file in files {
            if cached[file] == nil, let string:String = try? String.init(contentsOfFile: file, encoding: .utf8) {
                let parsed:SourceFileSyntax = Parser.parse(source: string)
                cached[file] = parsed
            }
        }*/
        switch item {
            case .literal(let target):
                return target
            case .function(let target, let parameters):
                return target + "(" + parameters.map({ "\"" + $0 + "\"" }).joined(separator: ",") + ")"
        }
    }

    static func item(_ node: some SyntaxProtocol) -> Item? {
        if let function:FunctionCallExprSyntax = node.functionCall {
            var path:String = ""
            if let member:MemberAccessExprSyntax = function.calledExpression.memberAccess {
                path += test(member)
            }
            var parameters:[String] = []
            for argument in function.arguments {
                if let string:String = argument.expression.stringLiteral?.string {
                    parameters.append(string)
                }
            }
            return .function(path, parameters)
        } else if let member:MemberAccessExprSyntax = node.memberAccess {
            let path:String = test(member)
            return .literal(path)
        }
        return nil
    }
    
    static func test(_ member: MemberAccessExprSyntax) -> String {
        var string:String = ""
        if let base:MemberAccessExprSyntax = member.base?.memberAccess {
            string += test(base) + "."
        } else if let decl:DeclReferenceExprSyntax = member.base?.declRef {
            string += decl.baseName.text + "."
        }
        string += member.declName.baseName.text
        return string
    }

    enum Item {
        case literal(String)
        case function(String, [String])
    }
}