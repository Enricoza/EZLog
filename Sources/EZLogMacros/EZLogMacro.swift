import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

struct WrongArgumentsCount: DiagnosticMessage {
    
    let expected: Int
    let or: Int?
    let actual: Int
    
    init(expected: Int, or: Int? = nil, actual: Int) {
        self.expected = expected
        self.or = or
        self.actual = actual
    }
    
    var diagnosticID: MessageID { MessageID(domain: "com.ez.logger", id: "WrongArgumentCount\(expected)-\(actual)") }
    var message: String {
        let expected = if let or {
            "\(expected) or \(or)"
        } else {
            "\(expected)"
        }
        return """
        Expecting \(expected) parameters but got \(actual).
        This should not have happened.
        Please open an issue at: https://github.com/Enricoza/EZLog
        """
    }

    var severity: DiagnosticSeverity { .error }
    
    func diagnoseWith(node: some SyntaxProtocol) -> Diagnostic {
        Diagnostic(node: node, message: self)
    }
}

public struct EZLogMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        let macro = node.macro.text
        let arguments = node.argumentList.map { $0 }
        guard macro == "log" else {
            guard arguments.count == 2 else {
                throw DiagnosticsError(diagnostics: [
                    WrongArgumentsCount(expected: 2, actual: arguments.count)
                        .diagnoseWith(node: node.argumentList),
                ])
            }
            return expansionLog(loggerArgument: arguments[0],
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
            return expansionLog(loggerArgument: arguments[0],
                                level: macroToLevelExpr(macro: "notice"),
                                logMethod: "log",
                                messageArgument: arguments[1])
        }
        return expansionLog(loggerArgument: arguments[0],
                            levelArgument: arguments[1],
                            messageArgument: arguments[2])
    }
    
    static func expansionLog(
        loggerArgument: LabeledExprListSyntax.Element,
        levelArgument: LabeledExprListSyntax.Element,
        messageArgument: LabeledExprListSyntax.Element
    ) -> ExprSyntax {
        guard let member = levelArgument.expression.as(MemberAccessExprSyntax.self),
              member.base == nil || member.base?.as(DeclReferenceExprSyntax.self)?.baseName.text == "LogLevel" else {
            return expansionLog(loggerArgument: loggerArgument,
                                level: levelArgument.expression,
                                logMethod: "log",
                                levelArgument: "\(levelArgument.expression).toOSLogType()",
                                messageArgument: messageArgument)
        }
        return expansionLog(loggerArgument: loggerArgument,
                            level: ExprSyntax(member),
                            logMethod: levelNameToLogMethod(member.declName.baseName.text),
                            messageArgument: messageArgument)
    }

    static func expansionLog(
        loggerArgument: LabeledExprListSyntax.Element,
        level: ExprSyntax,
        logMethod: ExprSyntax,
        levelArgument: ExprSyntax? = nil,
        messageArgument: LabeledExprListSyntax.Element
    ) -> ExprSyntax {
        let sanitizedLogger = sanitizeLoggerArgument(loggerArgument)
        let methodExpression = logMethodExpr(logMethod: logMethod, levelArgument: levelArgument, messageArgument: messageArgument)
        return """
        \(sanitizedLogger).allows(level: \(level)) ? \(sanitizedLogger).logger.\(methodExpression) : ()
        """
    }
    
    static func logMethodExpr(logMethod: ExprSyntax,
                              levelArgument: ExprSyntax? = nil,
                              messageArgument: LabeledExprListSyntax.Element) -> ExprSyntax {
        if let levelArgument {
            "\(logMethod)(level: \(levelArgument), \(messageArgument))"
        } else {
            "\(logMethod)(\(messageArgument))"
        }
    }
    
    static func sanitizeLoggerArgument(_ argument: LabeledExprListSyntax.Element) -> ExprSyntax {
        guard var memberAccess = argument.expression.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else {
            return argument.expression
        }
        memberAccess.base = "EZLogger"
        return ExprSyntax(memberAccess)
    }
    
    static func levelNameToLogMethod(_ levelName: String) -> ExprSyntax {
        switch levelName {
        case "warn": "warning"
        case "err": "error"
        default: ExprSyntax(stringLiteral: levelName)
        }
    }
    
    static func macroToLevelExpr(macro: TokenSyntax) -> ExprSyntax {
        if macro.text == "err" {
            ExprSyntax(".error")
        } else {
            ExprSyntax(".\(macro)")
        }
    }
}

@main
struct EZLogPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EZLogMacro.self,
    ]
}
