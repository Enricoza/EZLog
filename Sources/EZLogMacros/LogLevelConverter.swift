//
//  LogLevelConverter.swift
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


enum LogLevelConverter {
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
