
#if canImport(Foundation)
import Foundation
import HTMLKitUtilities
import SwiftDiagnostics
import SwiftParser
import SwiftSyntax

enum InterpolationLookup {
    @MainActor private static var cached:[String:CodeBlockItemListSyntax] = [:]

    @MainActor
    static func find(context: HTMLExpansionContext, _ node: some ExprSyntaxProtocol, files: Set<String>) -> String? {
        guard !files.isEmpty, let item = item(context: context, node) else { return nil }
        for file in files {
            if cached[file] == nil {
                if let string = try? String.init(contentsOfFile: file, encoding: .utf8) {
                    let parsed = Parser.parse(source: string).statements
                    cached[file] = parsed
                } else {
                    context.diagnose(Diagnostic(node: node, message: DiagnosticMsg(id: "fileNotFound", message: "Could not find file (\(file)) on disk, or was denied disk access (file access is always denied on macOS due to the macro being in a sandbox).", severity: .warning)))
                }
            }
        }
        //print("InterpolationLookup;find;item=\(item)")
        switch item {
        case .literal(let tokens):
            for statements in cached.values {
                if let flattened = flatten(context: context, tokens: tokens, statements: statements) {
                    return flattened
                }
            }
            return nil
        case .function(let tokens, let parameters):
            return nil
            //return target + "(" + parameters.map({ "\"" + $0 + "\"" }).joined(separator: ",") + ")"
        }
    }

    private static func item(context: HTMLExpansionContext, _ node: some ExprSyntaxProtocol) -> Item? {
        if let function = node.functionCall {
            var array = [String]()
            if let member = function.calledExpression.memberAccess {
                array.append(contentsOf: test(member))
            }
            var parameters = [String]()
            for argument in function.arguments {
                if let string = argument.expression.stringLiteral?.string(encoding: context.encoding) {
                    parameters.append(string)
                }
            }
            return .function(tokens: array, parameters: parameters)
        } else if let member = node.memberAccess {
            let path = test(member)
            return .literal(tokens: path)
        }
        return nil
    }
    
    private static func test(_ member: MemberAccessExprSyntax) -> [String] {
        var array = [String]()
        if let base = member.base?.memberAccess {
            array.append(contentsOf: test(base))
        } else if let decl = member.base?.declRef {
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
    static func flatten(context: HTMLExpansionContext, tokens: [String], statements: CodeBlockItemListSyntax) -> String? {
        for statement in statements {
            var index = 0
            let item = statement.item
            if let ext = item.ext {
                if ext.extendedType.identifierType?.name.text == tokens[index] {
                    index += 1
                }
                for member in ext.memberBlock.members {
                    if let string = parseFunction(syntax: member.decl, tokens: tokens, index: index)
                            ?? parseEnumeration(context: context, syntax: member.decl, tokens: tokens, index: index)
                            ?? parseVariable(context: context, syntax: member.decl, tokens: tokens, index: index) {
                        return string
                    }
                }
            } else if let structure = item.structure {
                for member in structure.memberBlock.members {
                    if let function = member.functionDecl, function.name.text == tokens[index], function.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.name.text == "StaticString" {
                        index += 1
                        if let body = function.body {
                        }
                        index -= 1
                    }
                }
            } else if let enumeration = parseEnumeration(context: context, syntax: item, tokens: tokens, index: index) {
                return enumeration
            } else if let variable = parseVariable(context: context, syntax: item, tokens: tokens, index: index) {
                return variable
            }
        }
        return nil
    }
    // MARK: Parse function
    static func parseFunction(syntax: some SyntaxProtocol, tokens: [String], index: Int) -> String? {
        guard let function = syntax.functionDecl else { return nil }
        return nil
    }
    // MARK: Parse enumeration
    static func parseEnumeration(context: HTMLExpansionContext, syntax: some SyntaxProtocol, tokens: [String], index: Int) -> String? {
        let allowedInheritances:Set<String?> = ["String", "Int", "Double", "Float"]
        guard let enumeration = syntax.enumeration,
            enumeration.name.text == tokens[index]
        else {
            return nil
        }
        //print("InterpolationLookup;parse_enumeration;enumeration=\(enumeration.debugDescription)")
        let valueType:String? = enumeration.inheritanceClause?.inheritedTypes.first(where: {
            allowedInheritances.contains($0.type.identifierType?.name.text)
        })?.type.identifierType?.name.text
        var index = index + 1
        for member in enumeration.memberBlock.members {
            if let decl = member.decl.enumCaseDecl {
                for element in decl.elements {
                    if let enumCase = element.enumCaseElem, enumCase.name.text == tokens[index] {
                        index += 1
                        let caseName = enumCase.name.text
                        if index == tokens.count {
                            return caseName
                        }
                        switch valueType {
                        case "String":          return enumCase.rawValue?.value.stringLiteral!.string(encoding: context.encoding) ?? caseName
                        case "Int":             return enumCase.rawValue?.value.integerLiteral!.literal.text ?? caseName
                        case "Double", "Float": return enumCase.rawValue?.value.floatLiteral!.literal.text ?? caseName
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
    static func parseVariable(context: HTMLExpansionContext, syntax: some SyntaxProtocol, tokens: [String], index: Int) -> String? {
        guard let variable = syntax.variableDecl else { return nil }
        for binding in variable.bindings {
            if binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text == tokens[index], let initializer = binding.initializer {
                return initializer.value.stringLiteral?.string(encoding: context.encoding)
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
    var identifierType: IdentifierTypeSyntax? { self.as(IdentifierTypeSyntax.self) }
}

extension SyntaxProtocol {
    var enumCaseDecl: EnumCaseDeclSyntax? { self.as(EnumCaseDeclSyntax.self) }
    var enumCaseElem: EnumCaseElementSyntax? { self.as(EnumCaseElementSyntax.self) }
    var functionDecl: FunctionDeclSyntax? { self.as(FunctionDeclSyntax.self) }
    var variableDecl: VariableDeclSyntax? { self.as(VariableDeclSyntax.self) }

    var ext: ExtensionDeclSyntax? { self.as(ExtensionDeclSyntax.self) }
    var structure: StructDeclSyntax? { self.as(StructDeclSyntax.self) }
    var enumeration: EnumDeclSyntax? { self.as(EnumDeclSyntax.self) }
}