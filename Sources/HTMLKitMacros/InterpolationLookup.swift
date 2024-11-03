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
                for (_, source_file) in cached {
                    if let flattened:String = flatten(target, file: source_file) {
                        return flattened
                    }
                }
                return nil
            case .function(let target, let parameters):
                return target + "(" + parameters.map({ "\"" + $0 + "\"" }).joined(separator: ",") + ")"
        }
    }

    private static func item(_ node: some SyntaxProtocol) -> Item? {
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
    
    private static func test(_ member: MemberAccessExprSyntax) -> String {
        var string:String = ""
        if let base:MemberAccessExprSyntax = member.base?.memberAccess {
            string += test(base) + "."
        } else if let decl:DeclReferenceExprSyntax = member.base?.declRef {
            string += decl.baseName.text + "."
        }
        string += member.declName.baseName.text
        return string
    }

    private enum Item {
        case literal(String)
        case function(String, [String])
    }
}
private extension InterpolationLookup {
    static func flatten(_ target: String, file: SourceFileSyntax) -> String? {
        for statement in file.statements {
            if let ext:ExtensionDeclSyntax = statement.item.as(ExtensionDeclSyntax.self) {
                if ext.extendedType.as(IdentifierTypeSyntax.self)?.name.text == "HTMLKitTests" {
                }
                for member in ext.memberBlock.members {
                    if let function:FunctionDeclSyntax = member.decl.as(FunctionDeclSyntax.self) {
                    }
                }
            }
        }
        return nil
    }
}

// the below is the last statement in the parsed source file of `HTMLKitTests.swift`
// ...to be read and understood in order to lookup the stuff we want, and check whether or not we can replace it with a compile time equivalent
/*


CodeBlockItemSyntax
╰─item: ExtensionDeclSyntax
  ├─attributes: AttributeListSyntax
  ├─modifiers: DeclModifierListSyntax
  ├─extensionKeyword: keyword(SwiftSyntax.Keyword.extension)
  ├─extendedType: IdentifierTypeSyntax
  │ ╰─name: identifier("HTMLKitTests")
  ╰─memberBlock: MemberBlockSyntax
    ├─leftBrace: leftBrace
    ├─members: MemberBlockItemListSyntax
    │ ├─[0]: MemberBlockItemSyntax
    │ │ ╰─decl: FunctionDeclSyntax
    │ │   ├─attributes: AttributeListSyntax
    │ │   │ ╰─[0]: AttributeSyntax
    │ │   │   ├─atSign: atSign
    │ │   │   ╰─attributeName: IdentifierTypeSyntax
    │ │   │     ╰─name: identifier("Test")
    │ │   ├─modifiers: DeclModifierListSyntax
    │ │   ├─funcKeyword: keyword(SwiftSyntax.Keyword.func)
    │ │   ├─name: identifier("example2")
    │ │   ├─signature: FunctionSignatureSyntax
    │ │   │ ╰─parameterClause: FunctionParameterClauseSyntax
    │ │   │   ├─leftParen: leftParen
    │ │   │   ├─parameters: FunctionParameterListSyntax
    │ │   │   ╰─rightParen: rightParen
    │ │   ╰─body: CodeBlockSyntax
    │ │     ├─leftBrace: leftBrace
    │ │     ├─statements: CodeBlockItemListSyntax
    │ │     │ ├─[0]: CodeBlockItemSyntax
    │ │     │ │ ╰─item: VariableDeclSyntax
    │ │     │ │   ├─attributes: AttributeListSyntax
    │ │     │ │   ├─modifiers: DeclModifierListSyntax
    │ │     │ │   ├─bindingSpecifier: keyword(SwiftSyntax.Keyword.var)
    │ │     │ │   ╰─bindings: PatternBindingListSyntax
    │ │     │ │     ╰─[0]: PatternBindingSyntax
    │ │     │ │       ├─pattern: IdentifierPatternSyntax
    │ │     │ │       │ ╰─identifier: identifier("test")
    │ │     │ │       ├─typeAnnotation: TypeAnnotationSyntax
    │ │     │ │       │ ├─colon: colon
    │ │     │ │       │ ╰─type: IdentifierTypeSyntax
    │ │     │ │       │   ╰─name: identifier("TestStruct")
    │ │     │ │       ╰─initializer: InitializerClauseSyntax
    │ │     │ │         ├─equal: equal
    │ │     │ │         ╰─value: FunctionCallExprSyntax
    │ │     │ │           ├─calledExpression: DeclReferenceExprSyntax
    │ │     │ │           │ ╰─baseName: identifier("TestStruct")
    │ │     │ │           ├─leftParen: leftParen
    │ │     │ │           ├─arguments: LabeledExprListSyntax
    │ │     │ │           │ ├─[0]: LabeledExprSyntax
    │ │     │ │           │ │ ├─label: identifier("name")
    │ │     │ │           │ │ ├─colon: colon
    │ │     │ │           │ │ ├─expression: StringLiteralExprSyntax
    │ │     │ │           │ │ │ ├─openingQuote: stringQuote
    │ │     │ │           │ │ │ ├─segments: StringLiteralSegmentListSyntax
    │ │     │ │           │ │ │ │ ╰─[0]: StringSegmentSyntax
    │ │     │ │           │ │ │ │   ╰─content: stringSegment("one")
    │ │     │ │           │ │ │ ╰─closingQuote: stringQuote
    │ │     │ │           │ │ ╰─trailingComma: comma
    │ │     │ │           │ ╰─[1]: LabeledExprSyntax
    │ │     │ │           │   ├─label: identifier("array")
    │ │     │ │           │   ├─colon: colon
    │ │     │ │           │   ╰─expression: ArrayExprSyntax
    │ │     │ │           │     ├─leftSquare: leftSquare
    │ │     │ │           │     ├─elements: ArrayElementListSyntax
    │ │     │ │           │     │ ├─[0]: ArrayElementSyntax
    │ │     │ │           │     │ │ ├─expression: StringLiteralExprSyntax
    │ │     │ │           │     │ │ │ ├─openingQuote: stringQuote
    │ │     │ │           │     │ │ │ ├─segments: StringLiteralSegmentListSyntax
    │ │     │ │           │     │ │ │ │ ╰─[0]: StringSegmentSyntax
    │ │     │ │           │     │ │ │ │   ╰─content: stringSegment("1")
    │ │     │ │           │     │ │ │ ╰─closingQuote: stringQuote
    │ │     │ │           │     │ │ ╰─trailingComma: comma
    │ │     │ │           │     │ ├─[1]: ArrayElementSyntax
    │ │     │ │           │     │ │ ├─expression: StringLiteralExprSyntax
    │ │     │ │           │     │ │ │ ├─openingQuote: stringQuote
    │ │     │ │           │     │ │ │ ├─segments: StringLiteralSegmentListSyntax
    │ │     │ │           │     │ │ │ │ ╰─[0]: StringSegmentSyntax
    │ │     │ │           │     │ │ │ │   ╰─content: stringSegment("2")
    │ │     │ │           │     │ │ │ ╰─closingQuote: stringQuote
    │ │     │ │           │     │ │ ╰─trailingComma: comma
    │ │     │ │           │     │ ╰─[2]: ArrayElementSyntax
    │ │     │ │           │     │   ╰─expression: StringLiteralExprSyntax
    │ │     │ │           │     │     ├─openingQuote: stringQuote
    │ │     │ │           │     │     ├─segments: StringLiteralSegmentListSyntax
    │ │     │ │           │     │     │ ╰─[0]: StringSegmentSyntax
    │ │     │ │           │     │     │   ╰─content: stringSegment("3")
    │ │     │ │           │     │     ╰─closingQuote: stringQuote
    │ │     │ │           │     ╰─rightSquare: rightSquare
    │ │     │ │           ├─rightParen: rightParen
    │ │     │ │           ╰─additionalTrailingClosures: MultipleTrailingClosureElementListSyntax
    │ │     │ ├─[1]: CodeBlockItemSyntax
    │ │     │ │ ╰─item: MacroExpansionExprSyntax
    │ │     │ │   ├─pound: pound
    │ │     │ │   ├─macroName: identifier("expect")
    │ │     │ │   ├─leftParen: leftParen
    │ │     │ │   ├─arguments: LabeledExprListSyntax
    │ │     │ │   │ ╰─[0]: LabeledExprSyntax
    │ │     │ │   │   ╰─expression: SequenceExprSyntax
    │ │     │ │   │     ╰─elements: ExprListSyntax
    │ │     │ │   │       ├─[0]: MemberAccessExprSyntax
    │ │     │ │   │       │ ├─base: DeclReferenceExprSyntax
    │ │     │ │   │       │ │ ╰─baseName: identifier("test")
    │ │     │ │   │       │ ├─period: period
    │ │     │ │   │       │ ╰─declName: DeclReferenceExprSyntax
    │ │     │ │   │       │   ╰─baseName: identifier("html")
    │ │     │ │   │       ├─[1]: BinaryOperatorExprSyntax
    │ │     │ │   │       │ ╰─operator: binaryOperator("==")
    │ │     │ │   │       ╰─[2]: StringLiteralExprSyntax
    │ │     │ │   │         ├─openingQuote: stringQuote
    │ │     │ │   │         ├─segments: StringLiteralSegmentListSyntax
    │ │     │ │   │         │ ╰─[0]: StringSegmentSyntax
    │ │     │ │   │         │   ╰─content: stringSegment("<p>one123</p>")
    │ │     │ │   │         ╰─closingQuote: stringQuote
    │ │     │ │   ├─rightParen: rightParen
    │ │     │ │   ╰─additionalTrailingClosures: MultipleTrailingClosureElementListSyntax
    │ │     │ ├─[2]: CodeBlockItemSyntax
    │ │     │ │ ╰─item: SequenceExprSyntax
    │ │     │ │   ╰─elements: ExprListSyntax
    │ │     │ │     ├─[0]: MemberAccessExprSyntax
    │ │     │ │     │ ├─base: DeclReferenceExprSyntax
    │ │     │ │     │ │ ╰─baseName: identifier("test")
    │ │     │ │     │ ├─period: period
    │ │     │ │     │ ╰─declName: DeclReferenceExprSyntax
    │ │     │ │     │   ╰─baseName: identifier("name")
    │ │     │ │     ├─[1]: AssignmentExprSyntax
    │ │     │ │     │ ╰─equal: equal
    │ │     │ │     ╰─[2]: StringLiteralExprSyntax
    │ │     │ │       ├─openingQuote: stringQuote
    │ │     │ │       ├─segments: StringLiteralSegmentListSyntax
    │ │     │ │       │ ╰─[0]: StringSegmentSyntax
    │ │     │ │       │   ╰─content: stringSegment("two")
    │ │     │ │       ╰─closingQuote: stringQuote
    │ │     │ ├─[3]: CodeBlockItemSyntax
    │ │     │ │ ╰─item: SequenceExprSyntax
    │ │     │ │   ╰─elements: ExprListSyntax
    │ │     │ │     ├─[0]: MemberAccessExprSyntax
    │ │     │ │     │ ├─base: DeclReferenceExprSyntax
    │ │     │ │     │ │ ╰─baseName: identifier("test")
    │ │     │ │     │ ├─period: period
    │ │     │ │     │ ╰─declName: DeclReferenceExprSyntax
    │ │     │ │     │   ╰─baseName: identifier("array")
    │ │     │ │     ├─[1]: AssignmentExprSyntax
    │ │     │ │     │ ╰─equal: equal
    │ │     │ │     ╰─[2]: ArrayExprSyntax
    │ │     │ │       ├─leftSquare: leftSquare
    │ │     │ │       ├─elements: ArrayElementListSyntax
    │ │     │ │       │ ├─[0]: ArrayElementSyntax
    │ │     │ │       │ │ ├─expression: IntegerLiteralExprSyntax
    │ │     │ │       │ │ │ ╰─literal: integerLiteral("4")
    │ │     │ │       │ │ ╰─trailingComma: comma
    │ │     │ │       │ ├─[1]: ArrayElementSyntax
    │ │     │ │       │ │ ├─expression: IntegerLiteralExprSyntax
    │ │     │ │       │ │ │ ╰─literal: integerLiteral("5")
    │ │     │ │       │ │ ╰─trailingComma: comma
    │ │     │ │       │ ├─[2]: ArrayElementSyntax
    │ │     │ │       │ │ ├─expression: IntegerLiteralExprSyntax
    │ │     │ │       │ │ │ ╰─literal: integerLiteral("6")
    │ │     │ │       │ │ ╰─trailingComma: comma
    │ │     │ │       │ ├─[3]: ArrayElementSyntax
    │ │     │ │       │ │ ├─expression: IntegerLiteralExprSyntax
    │ │     │ │       │ │ │ ╰─literal: integerLiteral("7")
    │ │     │ │       │ │ ╰─trailingComma: comma
    │ │     │ │       │ ╰─[4]: ArrayElementSyntax
    │ │     │ │       │   ╰─expression: IntegerLiteralExprSyntax
    │ │     │ │       │     ╰─literal: integerLiteral("8")
    │ │     │ │       ╰─rightSquare: rightSquare
    │ │     │ ╰─[4]: CodeBlockItemSyntax
    │ │     │   ╰─item: MacroExpansionExprSyntax
    │ │     │     ├─pound: pound
    │ │     │     ├─macroName: identifier("expect")
    │ │     │     ├─leftParen: leftParen
    │ │     │     ├─arguments: LabeledExprListSyntax
    │ │     │     │ ╰─[0]: LabeledExprSyntax
    │ │     │     │   ╰─expression: SequenceExprSyntax
    │ │     │     │     ╰─elements: ExprListSyntax
    │ │     │     │       ├─[0]: MemberAccessExprSyntax
    │ │     │     │       │ ├─base: DeclReferenceExprSyntax
    │ │     │     │       │ │ ╰─baseName: identifier("test")
    │ │     │     │       │ ├─period: period
    │ │     │     │       │ ╰─declName: DeclReferenceExprSyntax
    │ │     │     │       │   ╰─baseName: identifier("html")
    │ │     │     │       ├─[1]: BinaryOperatorExprSyntax
    │ │     │     │       │ ╰─operator: binaryOperator("==")
    │ │     │     │       ╰─[2]: StringLiteralExprSyntax
    │ │     │     │         ├─openingQuote: stringQuote
    │ │     │     │         ├─segments: StringLiteralSegmentListSyntax
    │ │     │     │         │ ╰─[0]: StringSegmentSyntax
    │ │     │     │         │   ╰─content: stringSegment("<p>two45678</p>")
    │ │     │     │         ╰─closingQuote: stringQuote
    │ │     │     ├─rightParen: rightParen
    │ │     │     ╰─additionalTrailingClosures: MultipleTrailingClosureElementListSyntax
    │ │     ╰─rightBrace: rightBrace
    │ ╰─[1]: MemberBlockItemSyntax
    │   ╰─decl: StructDeclSyntax
    │     ├─attributes: AttributeListSyntax
    │     ├─modifiers: DeclModifierListSyntax
    │     ├─structKeyword: keyword(SwiftSyntax.Keyword.struct)
    │     ├─name: identifier("TestStruct")
    │     ╰─memberBlock: MemberBlockSyntax
    │       ├─leftBrace: leftBrace
    │       ├─members: MemberBlockItemListSyntax
    │       │ ├─[0]: MemberBlockItemSyntax
    │       │ │ ╰─decl: VariableDeclSyntax
    │       │ │   ├─attributes: AttributeListSyntax
    │       │ │   ├─modifiers: DeclModifierListSyntax
    │       │ │   ├─bindingSpecifier: keyword(SwiftSyntax.Keyword.var)
    │       │ │   ╰─bindings: PatternBindingListSyntax
    │       │ │     ╰─[0]: PatternBindingSyntax
    │       │ │       ├─pattern: IdentifierPatternSyntax
    │       │ │       │ ╰─identifier: identifier("name")
    │       │ │       ╰─typeAnnotation: TypeAnnotationSyntax
    │       │ │         ├─colon: colon
    │       │ │         ╰─type: IdentifierTypeSyntax
    │       │ │           ╰─name: identifier("String")
    │       │ ├─[1]: MemberBlockItemSyntax
    │       │ │ ╰─decl: VariableDeclSyntax
    │       │ │   ├─attributes: AttributeListSyntax
    │       │ │   ├─modifiers: DeclModifierListSyntax
    │       │ │   ├─bindingSpecifier: keyword(SwiftSyntax.Keyword.var)
    │       │ │   ╰─bindings: PatternBindingListSyntax
    │       │ │     ╰─[0]: PatternBindingSyntax
    │       │ │       ├─pattern: IdentifierPatternSyntax
    │       │ │       │ ╰─identifier: identifier("array")
    │       │ │       ├─typeAnnotation: TypeAnnotationSyntax
    │       │ │       │ ├─colon: colon
    │       │ │       │ ╰─type: ArrayTypeSyntax
    │       │ │       │   ├─leftSquare: leftSquare
    │       │ │       │   ├─element: IdentifierTypeSyntax
    │       │ │       │   │ ╰─name: identifier("CustomStringConvertible")
    │       │ │       │   ╰─rightSquare: rightSquare
    │       │ │       ╰─accessorBlock: AccessorBlockSyntax
    │       │ │         ├─leftBrace: leftBrace
    │       │ │         ├─accessors: AccessorDeclListSyntax
    │       │ │         │ ╰─[0]: AccessorDeclSyntax
    │       │ │         │   ├─attributes: AttributeListSyntax
    │       │ │         │   ├─accessorSpecifier: keyword(SwiftSyntax.Keyword.didSet)
    │       │ │         │   ╰─body: CodeBlockSyntax
    │       │ │         │     ├─leftBrace: leftBrace
    │       │ │         │     ├─statements: CodeBlockItemListSyntax
    │       │ │         │     │ ╰─[0]: CodeBlockItemSyntax
    │       │ │         │     │   ╰─item: SequenceExprSyntax
    │       │ │         │     │     ╰─elements: ExprListSyntax
    │       │ │         │     │       ├─[0]: DeclReferenceExprSyntax
    │       │ │         │     │       │ ╰─baseName: identifier("array_string")
    │       │ │         │     │       ├─[1]: AssignmentExprSyntax
    │       │ │         │     │       │ ╰─equal: equal
    │       │ │         │     │       ╰─[2]: FunctionCallExprSyntax
    │       │ │         │     │         ├─calledExpression: MemberAccessExprSyntax
    │       │ │         │     │         │ ├─base: FunctionCallExprSyntax
    │       │ │         │     │         │ │ ├─calledExpression: MemberAccessExprSyntax
    │       │ │         │     │         │ │ │ ├─base: DeclReferenceExprSyntax
    │       │ │         │     │         │ │ │ │ ╰─baseName: identifier("array")
    │       │ │         │     │         │ │ │ ├─period: period
    │       │ │         │     │         │ │ │ ╰─declName: DeclReferenceExprSyntax
    │       │ │         │     │         │ │ │   ╰─baseName: identifier("map")
    │       │ │         │     │         │ │ ├─leftParen: leftParen
    │       │ │         │     │         │ │ ├─arguments: LabeledExprListSyntax
    │       │ │         │     │         │ │ │ ╰─[0]: LabeledExprSyntax
    │       │ │         │     │         │ │ │   ╰─expression: ClosureExprSyntax
    │       │ │         │     │         │ │ │     ├─leftBrace: leftBrace
    │       │ │         │     │         │ │ │     ├─statements: CodeBlockItemListSyntax
    │       │ │         │     │         │ │ │     │ ╰─[0]: CodeBlockItemSyntax
    │       │ │         │     │         │ │ │     │   ╰─item: StringLiteralExprSyntax
    │       │ │         │     │         │ │ │     │     ├─openingQuote: stringQuote
    │       │ │         │     │         │ │ │     │     ├─segments: StringLiteralSegmentListSyntax
    │       │ │         │     │         │ │ │     │     │ ├─[0]: StringSegmentSyntax
    │       │ │         │     │         │ │ │     │     │ │ ╰─content: stringSegment("")
    │       │ │         │     │         │ │ │     │     │ ├─[1]: ExpressionSegmentSyntax
    │       │ │         │     │         │ │ │     │     │ │ ├─backslash: backslash
    │       │ │         │     │         │ │ │     │     │ │ ├─leftParen: leftParen
    │       │ │         │     │         │ │ │     │     │ │ ├─expressions: LabeledExprListSyntax
    │       │ │         │     │         │ │ │     │     │ │ │ ╰─[0]: LabeledExprSyntax
    │       │ │         │     │         │ │ │     │     │ │ │   ╰─expression: DeclReferenceExprSyntax
    │       │ │         │     │         │ │ │     │     │ │ │     ╰─baseName: dollarIdentifier("$0")
    │       │ │         │     │         │ │ │     │     │ │ ╰─rightParen: rightParen
    │       │ │         │     │         │ │ │     │     │ ╰─[2]: StringSegmentSyntax
    │       │ │         │     │         │ │ │     │     │   ╰─content: stringSegment("")
    │       │ │         │     │         │ │ │     │     ╰─closingQuote: stringQuote
    │       │ │         │     │         │ │ │     ╰─rightBrace: rightBrace
    │       │ │         │     │         │ │ ├─rightParen: rightParen
    │       │ │         │     │         │ │ ╰─additionalTrailingClosures: MultipleTrailingClosureElementListSyntax
    │       │ │         │     │         │ ├─period: period
    │       │ │         │     │         │ ╰─declName: DeclReferenceExprSyntax
    │       │ │         │     │         │   ╰─baseName: identifier("joined")
    │       │ │         │     │         ├─leftParen: leftParen
    │       │ │         │     │         ├─arguments: LabeledExprListSyntax
    │       │ │         │     │         ├─rightParen: rightParen
    │       │ │         │     │         ╰─additionalTrailingClosures: MultipleTrailingClosureElementListSyntax
    │       │ │         │     ╰─rightBrace: rightBrace
    │       │ │         ╰─rightBrace: rightBrace
    │       │ ├─[2]: MemberBlockItemSyntax
    │       │ │ ╰─decl: VariableDeclSyntax
    │       │ │   ├─attributes: AttributeListSyntax
    │       │ │   ├─modifiers: DeclModifierListSyntax
    │       │ │   │ ╰─[0]: DeclModifierSyntax
    │       │ │   │   ╰─name: keyword(SwiftSyntax.Keyword.private)
    │       │ │   ├─bindingSpecifier: keyword(SwiftSyntax.Keyword.var)
    │       │ │   ╰─bindings: PatternBindingListSyntax
    │       │ │     ╰─[0]: PatternBindingSyntax
    │       │ │       ├─pattern: IdentifierPatternSyntax
    │       │ │       │ ╰─identifier: identifier("array_string")
    │       │ │       ╰─typeAnnotation: TypeAnnotationSyntax
    │       │ │         ├─colon: colon
    │       │ │         ╰─type: IdentifierTypeSyntax
    │       │ │           ╰─name: identifier("String")
    │       │ ├─[3]: MemberBlockItemSyntax
    │       │ │ ╰─decl: InitializerDeclSyntax
    │       │ │   ├─attributes: AttributeListSyntax
    │       │ │   ├─modifiers: DeclModifierListSyntax
    │       │ │   ├─initKeyword: keyword(SwiftSyntax.Keyword.init)
    │       │ │   ├─signature: FunctionSignatureSyntax
    │       │ │   │ ╰─parameterClause: FunctionParameterClauseSyntax
    │       │ │   │   ├─leftParen: leftParen
    │       │ │   │   ├─parameters: FunctionParameterListSyntax
    │       │ │   │   │ ├─[0]: FunctionParameterSyntax
    │       │ │   │   │ │ ├─attributes: AttributeListSyntax
    │       │ │   │   │ │ ├─modifiers: DeclModifierListSyntax
    │       │ │   │   │ │ ├─firstName: identifier("name")
    │       │ │   │   │ │ ├─colon: colon
    │       │ │   │   │ │ ├─type: IdentifierTypeSyntax
    │       │ │   │   │ │ │ ╰─name: identifier("String")
    │       │ │   │   │ │ ╰─trailingComma: comma
    │       │ │   │   │ ╰─[1]: FunctionParameterSyntax
    │       │ │   │   │   ├─attributes: AttributeListSyntax
    │       │ │   │   │   ├─modifiers: DeclModifierListSyntax
    │       │ │   │   │   ├─firstName: identifier("array")
    │       │ │   │   │   ├─colon: colon
    │       │ │   │   │   ╰─type: ArrayTypeSyntax
    │       │ │   │   │     ├─leftSquare: leftSquare
    │       │ │   │   │     ├─element: IdentifierTypeSyntax
    │       │ │   │   │     │ ╰─name: identifier("CustomStringConvertible")
    │       │ │   │   │     ╰─rightSquare: rightSquare
    │       │ │   │   ╰─rightParen: rightParen
    │       │ │   ╰─body: CodeBlockSyntax
    │       │ │     ├─leftBrace: leftBrace
    │       │ │     ├─statements: CodeBlockItemListSyntax
    │       │ │     │ ├─[0]: CodeBlockItemSyntax
    │       │ │     │ │ ╰─item: SequenceExprSyntax
    │       │ │     │ │   ╰─elements: ExprListSyntax
    │       │ │     │ │     ├─[0]: MemberAccessExprSyntax
    │       │ │     │ │     │ ├─base: DeclReferenceExprSyntax
    │       │ │     │ │     │ │ ╰─baseName: keyword(SwiftSyntax.Keyword.self)
    │       │ │     │ │     │ ├─period: period
    │       │ │     │ │     │ ╰─declName: DeclReferenceExprSyntax
    │       │ │     │ │     │   ╰─baseName: identifier("name")
    │       │ │     │ │     ├─[1]: AssignmentExprSyntax
    │       │ │     │ │     │ ╰─equal: equal
    │       │ │     │ │     ╰─[2]: DeclReferenceExprSyntax
    │       │ │     │ │       ╰─baseName: identifier("name")
    │       │ │     │ ├─[1]: CodeBlockItemSyntax
    │       │ │     │ │ ╰─item: SequenceExprSyntax
    │       │ │     │ │   ╰─elements: ExprListSyntax
    │       │ │     │ │     ├─[0]: MemberAccessExprSyntax
    │       │ │     │ │     │ ├─base: DeclReferenceExprSyntax
    │       │ │     │ │     │ │ ╰─baseName: keyword(SwiftSyntax.Keyword.self)
    │       │ │     │ │     │ ├─period: period
    │       │ │     │ │     │ ╰─declName: DeclReferenceExprSyntax
    │       │ │     │ │     │   ╰─baseName: identifier("array")
    │       │ │     │ │     ├─[1]: AssignmentExprSyntax
    │       │ │     │ │     │ ╰─equal: equal
    │       │ │     │ │     ╰─[2]: DeclReferenceExprSyntax
    │       │ │     │ │       ╰─baseName: identifier("array")
    │       │ │     │ ╰─[2]: CodeBlockItemSyntax
    │       │ │     │   ╰─item: SequenceExprSyntax
    │       │ │     │     ╰─elements: ExprListSyntax
    │       │ │     │       ├─[0]: MemberAccessExprSyntax
    │       │ │     │       │ ├─base: DeclReferenceExprSyntax
    │       │ │     │       │ │ ╰─baseName: keyword(SwiftSyntax.Keyword.self)
    │       │ │     │       │ ├─period: period
    │       │ │     │       │ ╰─declName: DeclReferenceExprSyntax
    │       │ │     │       │   ╰─baseName: identifier("array_string")
    │       │ │     │       ├─[1]: AssignmentExprSyntax
    │       │ │     │       │ ╰─equal: equal
    │       │ │     │       ╰─[2]: FunctionCallExprSyntax
    │       │ │     │         ├─calledExpression: MemberAccessExprSyntax
    │       │ │     │         │ ├─base: FunctionCallExprSyntax
    │       │ │     │         │ │ ├─calledExpression: MemberAccessExprSyntax
    │       │ │     │         │ │ │ ├─base: DeclReferenceExprSyntax
    │       │ │     │         │ │ │ │ ╰─baseName: identifier("array")
    │       │ │     │         │ │ │ ├─period: period
    │       │ │     │         │ │ │ ╰─declName: DeclReferenceExprSyntax
    │       │ │     │         │ │ │   ╰─baseName: identifier("map")
    │       │ │     │         │ │ ├─leftParen: leftParen
    │       │ │     │         │ │ ├─arguments: LabeledExprListSyntax
    │       │ │     │         │ │ │ ╰─[0]: LabeledExprSyntax
    │       │ │     │         │ │ │   ╰─expression: ClosureExprSyntax
    │       │ │     │         │ │ │     ├─leftBrace: leftBrace
    │       │ │     │         │ │ │     ├─statements: CodeBlockItemListSyntax
    │       │ │     │         │ │ │     │ ╰─[0]: CodeBlockItemSyntax
    │       │ │     │         │ │ │     │   ╰─item: StringLiteralExprSyntax
    │       │ │     │         │ │ │     │     ├─openingQuote: stringQuote
    │       │ │     │         │ │ │     │     ├─segments: StringLiteralSegmentListSyntax
    │       │ │     │         │ │ │     │     │ ├─[0]: StringSegmentSyntax
    │       │ │     │         │ │ │     │     │ │ ╰─content: stringSegment("")
    │       │ │     │         │ │ │     │     │ ├─[1]: ExpressionSegmentSyntax
    │       │ │     │         │ │ │     │     │ │ ├─backslash: backslash
    │       │ │     │         │ │ │     │     │ │ ├─leftParen: leftParen
    │       │ │     │         │ │ │     │     │ │ ├─expressions: LabeledExprListSyntax
    │       │ │     │         │ │ │     │     │ │ │ ╰─[0]: LabeledExprSyntax
    │       │ │     │         │ │ │     │     │ │ │   ╰─expression: DeclReferenceExprSyntax
    │       │ │     │         │ │ │     │     │ │ │     ╰─baseName: dollarIdentifier("$0")
    │       │ │     │         │ │ │     │     │ │ ╰─rightParen: rightParen
    │       │ │     │         │ │ │     │     │ ╰─[2]: StringSegmentSyntax
    │       │ │     │         │ │ │     │     │   ╰─content: stringSegment("")
    │       │ │     │         │ │ │     │     ╰─closingQuote: stringQuote
    │       │ │     │         │ │ │     ╰─rightBrace: rightBrace
    │       │ │     │         │ │ ├─rightParen: rightParen
    │       │ │     │         │ │ ╰─additionalTrailingClosures: MultipleTrailingClosureElementListSyntax
    │       │ │     │         │ ├─period: period
    │       │ │     │         │ ╰─declName: DeclReferenceExprSyntax
    │       │ │     │         │   ╰─baseName: identifier("joined")
    │       │ │     │         ├─leftParen: leftParen
    │       │ │     │         ├─arguments: LabeledExprListSyntax
    │       │ │     │         ├─rightParen: rightParen
    │       │ │     │         ╰─additionalTrailingClosures: MultipleTrailingClosureElementListSyntax
    │       │ │     ╰─rightBrace: rightBrace
    │       │ ╰─[4]: MemberBlockItemSyntax
    │       │   ╰─decl: VariableDeclSyntax
    │       │     ├─attributes: AttributeListSyntax
    │       │     ├─modifiers: DeclModifierListSyntax
    │       │     ├─bindingSpecifier: keyword(SwiftSyntax.Keyword.var)
    │       │     ╰─bindings: PatternBindingListSyntax
    │       │       ╰─[0]: PatternBindingSyntax
    │       │         ├─pattern: IdentifierPatternSyntax
    │       │         │ ╰─identifier: identifier("html")
    │       │         ├─typeAnnotation: TypeAnnotationSyntax
    │       │         │ ├─colon: colon
    │       │         │ ╰─type: IdentifierTypeSyntax
    │       │         │   ╰─name: identifier("String")
    │       │         ╰─accessorBlock: AccessorBlockSyntax
    │       │           ├─leftBrace: leftBrace
    │       │           ├─accessors: CodeBlockItemListSyntax
    │       │           │ ╰─[0]: CodeBlockItemSyntax
    │       │           │   ╰─item: MacroExpansionExprSyntax
    │       │           │     ├─pound: pound
    │       │           │     ├─macroName: identifier("p")
    │       │           │     ├─leftParen: leftParen
    │       │           │     ├─arguments: LabeledExprListSyntax
    │       │           │     │ ├─[0]: LabeledExprSyntax
    │       │           │     │ │ ├─expression: StringLiteralExprSyntax
    │       │           │     │ │ │ ├─openingQuote: stringQuote
    │       │           │     │ │ │ ├─segments: StringLiteralSegmentListSyntax
    │       │           │     │ │ │ │ ├─[0]: StringSegmentSyntax
    │       │           │     │ │ │ │ │ ╰─content: stringSegment("")
    │       │           │     │ │ │ │ ├─[1]: ExpressionSegmentSyntax
    │       │           │     │ │ │ │ │ ├─backslash: backslash
    │       │           │     │ │ │ │ │ ├─leftParen: leftParen
    │       │           │     │ │ │ │ │ ├─expressions: LabeledExprListSyntax
    │       │           │     │ │ │ │ │ │ ╰─[0]: LabeledExprSyntax
    │       │           │     │ │ │ │ │ │   ╰─expression: DeclReferenceExprSyntax
    │       │           │     │ │ │ │ │ │     ╰─baseName: identifier("name")
    │       │           │     │ │ │ │ │ ╰─rightParen: rightParen
    │       │           │     │ │ │ │ ╰─[2]: StringSegmentSyntax
    │       │           │     │ │ │ │   ╰─content: stringSegment("")
    │       │           │     │ │ │ ╰─closingQuote: stringQuote
    │       │           │     │ │ ╰─trailingComma: comma
    │       │           │     │ ╰─[1]: LabeledExprSyntax
    │       │           │     │   ╰─expression: StringLiteralExprSyntax
    │       │           │     │     ├─openingQuote: stringQuote
    │       │           │     │     ├─segments: StringLiteralSegmentListSyntax
    │       │           │     │     │ ├─[0]: StringSegmentSyntax
    │       │           │     │     │ │ ╰─content: stringSegment("")
    │       │           │     │     │ ├─[1]: ExpressionSegmentSyntax
    │       │           │     │     │ │ ├─backslash: backslash
    │       │           │     │     │ │ ├─leftParen: leftParen
    │       │           │     │     │ │ ├─expressions: LabeledExprListSyntax
    │       │           │     │     │ │ │ ╰─[0]: LabeledExprSyntax
    │       │           │     │     │ │ │   ╰─expression: DeclReferenceExprSyntax
    │       │           │     │     │ │ │     ╰─baseName: identifier("array_string")
    │       │           │     │     │ │ ╰─rightParen: rightParen
    │       │           │     │     │ ╰─[2]: StringSegmentSyntax
    │       │           │     │     │   ╰─content: stringSegment("")
    │       │           │     │     ╰─closingQuote: stringQuote
    │       │           │     ├─rightParen: rightParen
    │       │           │     ╰─additionalTrailingClosures: MultipleTrailingClosureElementListSyntax

*/