//
//  InterpolationLookup.swift
//
//
//  Created by Evan Anderson on 11/2/24.
//

#if canImport(Foundation)
import Foundation
import SwiftDiagnostics
import SwiftSyntaxMacros
import SwiftParser
import SwiftSyntax

enum InterpolationLookup {
    private static var cached:[String:CodeBlockItemListSyntax] = [:]

    static func find(context: some MacroExpansionContext, _ node: some SyntaxProtocol, files: Set<String>) -> String? {
        guard !files.isEmpty, let item:Item = item(node) else { return nil }
        for file in files {
            if cached[file] == nil {
                if let string:String = try? String.init(contentsOfFile: file, encoding: .utf8) {
                    let parsed:CodeBlockItemListSyntax = Parser.parse(source: string).statements
                    cached[file] = parsed
                } else {
                    context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "fileNotFound", message: "Could not find file (\(file)) on disk, or was denied disk access (file access is always denied on macOS due to the macro being in a sandbox).", severity: .warning)))
                }
            }
        }
        //print("InterpolationLookup;find;item=\(item)")
        switch item {
        case .literal(let tokens):
            for (_, statements) in cached {
                if let flattened:String = flatten(tokens, statements: statements) {
                    return flattened
                }
            }
            return nil
        case .function(let tokens, let parameters):
            return nil
            //return target + "(" + parameters.map({ "\"" + $0 + "\"" }).joined(separator: ",") + ")"
        }
    }

    private static func item(_ node: some SyntaxProtocol) -> Item? {
        if let function:FunctionCallExprSyntax = node.functionCall {
            var array:[String] = []
            if let member:MemberAccessExprSyntax = function.calledExpression.memberAccess {
                array.append(contentsOf: test(member))
            }
            var parameters:[String] = []
            for argument in function.arguments {
                if let string:String = argument.expression.stringLiteral?.string {
                    parameters.append(string)
                }
            }
            return .function(tokens: array, parameters: parameters)
        } else if let member:MemberAccessExprSyntax = node.memberAccess {
            let path:[String] = test(member)
            return .literal(tokens: path)
        }
        return nil
    }
    
    private static func test(_ member: MemberAccessExprSyntax) -> [String] {
        var array:[String] = []
        if let base:MemberAccessExprSyntax = member.base?.memberAccess {
            array.append(contentsOf: test(base))
        } else if let decl:DeclReferenceExprSyntax = member.base?.declRef {
            array.append(decl.baseName.text)
        }
        array.append(member.declName.baseName.text)
        return array
    }

    private enum Item {
        case literal(tokens: [String])
        case function(tokens: [String], parameters: [String])
    }
}
// MARK: Flatten
private extension InterpolationLookup {
    static func flatten(_ tokens: [String], statements: CodeBlockItemListSyntax) -> String? {
        for statement in statements {
            var index:Int = 0
            let item = statement.item
            if let ext:ExtensionDeclSyntax = item.ext {
                if ext.extendedType.identifierType?.name.text == tokens[index] {
                    index += 1
                }
                for member in ext.memberBlock.members {
                    if let string:String = parse_function(syntax: member.decl, tokens: tokens, index: index)
                            ?? parse_enumeration(syntax: member.decl, tokens: tokens, index: index)
                            ?? parse_variable(syntax: member.decl, tokens: tokens, index: index) {
                        return string
                    }
                }
            } else if let structure:StructDeclSyntax = item.structure {
                for member in structure.memberBlock.members {
                    if let function:FunctionDeclSyntax = member.functionDecl, function.name.text == tokens[index], function.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.name.text == "StaticString" {
                        index += 1
                        if let body = function.body {
                        }
                        index -= 1
                    }
                }
            } else if let enumeration:String = parse_enumeration(syntax: item, tokens: tokens, index: index) {
                return enumeration
            } else if let variable:String = parse_variable(syntax: item, tokens: tokens, index: index) {
                return variable
            }
        }
        return nil
    }
    // MARK: Parse function
    static func parse_function(syntax: some SyntaxProtocol, tokens: [String], index: Int) -> String? {
        guard let function:FunctionDeclSyntax = syntax.functionDecl else { return nil }
        return nil
    }
    // MARK: Parse enumeration
    static func parse_enumeration(syntax: some SyntaxProtocol, tokens: [String], index: Int) -> String? {
        let allowed_inheritances:Set<String?> = ["String", "Int", "Double", "Float"]
        guard let enumeration:EnumDeclSyntax = syntax.enumeration,
            enumeration.name.text == tokens[index]
        else {
            return nil
        }
        //print("InterpolationLookup;parse_enumeration;enumeration=\(enumeration.debugDescription)")
        let value_type:String? = enumeration.inheritanceClause?.inheritedTypes.first(where: { allowed_inheritances.contains($0.type.identifierType?.name.text) })?.type.identifierType!.name.text
        var index:Int = index + 1
        for member in enumeration.memberBlock.members {
            if let decl:EnumCaseDeclSyntax = member.decl.enumCaseDecl {
                for element in decl.elements {
                    if let enum_case:EnumCaseElementSyntax = element.enumCaseElem, enum_case.name.text == tokens[index] {
                        index += 1
                        let case_name:String = enum_case.name.text
                        if index == tokens.count {
                            return case_name
                        }
                        switch value_type {
                        case "String":          return enum_case.rawValue?.value.stringLiteral!.string ?? case_name
                        case "Int":             return enum_case.rawValue?.value.integerLiteral!.literal.text ?? case_name
                        case "Double", "Float": return enum_case.rawValue?.value.floatLiteral!.literal.text ?? case_name
                        default:
                            // TODO: check body (can have nested enums)
                            break
                        }
                    }
                }
            }
        }
        return nil
    }
    // MARK: Parse variable
    static func parse_variable(syntax: some SyntaxProtocol, tokens: [String], index: Int) -> String? {
        guard let variable:VariableDeclSyntax = syntax.variableDecl else { return nil }
        for binding in variable.bindings {
            if binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text == tokens[index], let initializer:InitializerClauseSyntax = binding.initializer {
                return initializer.value.stringLiteral?.string
                        ?? initializer.value.integerLiteral?.literal.text
                        ?? initializer.value.floatLiteral?.literal.text
            }
        }
        return nil
    }
}
#endif

// MARK: Misc
// copy & paste `HTMLKitTests.swift` into https://swift-ast-explorer.com/ to get this working
extension TypeSyntax {
    var identifierType : IdentifierTypeSyntax? { self.as(IdentifierTypeSyntax.self) }
}

extension SyntaxProtocol {
    var enumCaseDecl : EnumCaseDeclSyntax? { self.as(EnumCaseDeclSyntax.self) }
    var enumCaseElem : EnumCaseElementSyntax? { self.as(EnumCaseElementSyntax.self) }
    var functionDecl : FunctionDeclSyntax? { self.as(FunctionDeclSyntax.self) }
    var variableDecl : VariableDeclSyntax? { self.as(VariableDeclSyntax.self) }

    var ext : ExtensionDeclSyntax? { self.as(ExtensionDeclSyntax.self) }
    var structure : StructDeclSyntax? { self.as(StructDeclSyntax.self) }
    var enumeration : EnumDeclSyntax? { self.as(EnumDeclSyntax.self) }
}