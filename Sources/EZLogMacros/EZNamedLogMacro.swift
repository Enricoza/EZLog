//
//  EZNamedLogMacro.swift
//  
//
//  Created by Enrico Zannini on 24/12/25.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

/**
 * The macro used to expand the named log macros.
 *
 * Examples:
 * ```swift
 * #trace(logger, "Message")
 * #debug(logger, "Message")
 * #info(logger, "Message")
 * #notice(logger, "Message")
 * #warn(logger, "Message")
 * #err(logger, "Message")
 * #fault(logger, "Message")
 * ```
 */
public struct EZNamedLogMacro: ExpressionMacro {

    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        let macro = node.macro.text
        let arguments = node.argumentList.map { $0 }
        return switch arguments.count {
        case 2:
            LogExpression(loggerArgument: arguments[0],
                                 level: LogLevelConverter.macroToLevelExpr(macro: node.macro),
                                 logMethod: LogLevelConverter.levelNameToLogMethod(macro),
                                 messageArgument: arguments[1]).render()
        default:
            throw DiagnosticsError(diagnostics: [
                WrongArgumentsCount(expected: 2, actual: arguments.count)
                    .diagnoseWith(node: node.argumentList),
            ])
        }
    }
    
}
