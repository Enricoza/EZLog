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
        let arguments = node.argumentList.map { $0 }
        return switch arguments.count {
        case 2:
            LogExpression(loggerArgument: arguments[0],
                          level: LogLevelConverter.macroToLevelExpr(macro: "notice"),
                          logMethod: "log",
                          messageArgument: arguments[1])
        case 3:
            logExpr(loggerArgument: arguments[0],
                    levelArgument: arguments[1],
                    messageArgument: arguments[2])
        default:
            throw DiagnosticsError(diagnostics: [
                WrongArgumentsCount(expected: 2, or: 3, actual: arguments.count)
                    .diagnoseWith(node: node.argumentList),
            ])
        }
    }
    
    private static func logExpr(
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
                             logMethod: LogLevelConverter.levelNameToLogMethod(member.declName.baseName.text),
                             messageArgument: messageArgument)
    }
}

@main
struct EZLogPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EZLogMacro.self,
        EZNamedLogMacro.self
    ]
}
