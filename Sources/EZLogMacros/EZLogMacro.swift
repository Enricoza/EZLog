//
//  EZLogMacro.swift
//
//
//  Created by Enrico Zannini on 13/12/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct EZLogMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        try logExpression(of: node, in: context).render()
    }
    
    static func logExpression(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> LogExpression {
        let macro = node.macro.text
        let arguments = node.argumentList.map { $0 }
        guard macro == "log" else {
            guard arguments.count == 2 else {
                throw DiagnosticsError(diagnostics: [
                    WrongArgumentsCount(expected: 2, actual: arguments.count)
                        .diagnoseWith(node: node.argumentList),
                ])
            }
            return LogExpression(loggerArgument: arguments[0],
                                 level: macroToLevelExpr(macro: node.macro),
                                 logMethod: levelNameToLogMethod(macro),
                                 messageArgument: arguments[1])
        }
        guard arguments.count == 3 else {
            guard arguments.count == 2 else {
                throw DiagnosticsError(diagnostics: [
                    WrongArgumentsCount(expected: 2, or: 3, actual: arguments.count)
                        .diagnoseWith(node: node.argumentList),
                ])
            }
            return LogExpression(loggerArgument: arguments[0],
                                 level: macroToLevelExpr(macro: "notice"),
                                 logMethod: "log",
                                 messageArgument: arguments[1])
        }
        return logExpr(loggerArgument: arguments[0],
                       levelArgument: arguments[1],
                       messageArgument: arguments[2])
    }
    
    static func logExpr(
        loggerArgument: LabeledExprListSyntax.Element,
        levelArgument: LabeledExprListSyntax.Element,
        messageArgument: LabeledExprListSyntax.Element
    ) -> LogExpression {
        guard let member = levelArgument.expression.as(MemberAccessExprSyntax.self),
              member.base == nil || member.base?.as(DeclReferenceExprSyntax.self)?.baseName.text == "LogLevel" else {
            return LogExpression(loggerArgument: loggerArgument,
                                 level: levelArgument.expression,
                                 logMethod: "log",
                                 levelArgument: "\(levelArgument.expression).toOSLogType()",
                                 messageArgument: messageArgument)
        }
        return LogExpression(loggerArgument: loggerArgument,
                             level: ExprSyntax(member),
                             logMethod: levelNameToLogMethod(member.declName.baseName.text),
                             messageArgument: messageArgument)
    }
    
    static func levelNameToLogMethod(_ levelName: String) -> ExprSyntax {
        switch levelName {
        case "warn": "warning"
        case "err": "error"
        default: ExprSyntax(stringLiteral: levelName)
        }
    }
    
    static func macroToLevelExpr(macro: TokenSyntax) -> ExprSyntax {
        switch macro.text {
        case "err": ".error"
        default: ".\(macro)"
        }
    }
}

@main
struct EZLogPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EZLogMacro.self,
    ]
}
