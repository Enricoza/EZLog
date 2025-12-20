//
//  LogExpression.swift
//  
//
//  Created by Enrico Zannini on 20/12/25.
//

import Foundation
import SwiftSyntax

struct LogExpression {
    
    let loggerArgument: LabeledExprListSyntax.Element
    let level: ExprSyntax
    let logMethod: ExprSyntax
    let levelArgument: ExprSyntax?
    let messageArgument: LabeledExprListSyntax.Element
    
    init(loggerArgument: LabeledExprListSyntax.Element,
         level: ExprSyntax,
         logMethod: ExprSyntax,
         levelArgument: ExprSyntax? = nil,
         messageArgument: LabeledExprListSyntax.Element) {
        self.loggerArgument = loggerArgument
        self.level = level
        self.logMethod = logMethod
        self.levelArgument = levelArgument
        self.messageArgument = messageArgument
    }
    
    func render() -> ExprSyntax {
        let sanitizedLogger = sanitizeLoggerArgument(loggerArgument)
        let methodExpression = logMethodExpr(logMethod: logMethod, levelArgument: levelArgument, messageArgument: messageArgument)
        return """
        \(sanitizedLogger).allows(level: \(level)) ? \(sanitizedLogger).logger.\(methodExpression) : ()
        """
    }
    
    private func sanitizeLoggerArgument(_ argument: LabeledExprListSyntax.Element) -> ExprSyntax {
        guard var memberAccess = argument.expression.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else {
            return argument.expression
        }
        memberAccess.base = "EZLogger"
        return ExprSyntax(memberAccess)
    }
    
    private func logMethodExpr(logMethod: ExprSyntax,
                              levelArgument: ExprSyntax? = nil,
                              messageArgument: LabeledExprListSyntax.Element) -> ExprSyntax {
        if let levelArgument {
            "\(logMethod)(level: \(levelArgument), \(messageArgument))"
        } else {
            "\(logMethod)(\(messageArgument))"
        }
    }
}
