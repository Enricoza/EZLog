import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct EZLogMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        let macro = node.macro.text
        let arguments = node.argumentList.map { $0 }
        guard macro == "log" else {
            guard arguments.count == 2 else {
                fatalError("Arguments should be 2, got \(arguments.count)")
            }
            guard let logMethod = levelNameToLogMethod(macro) else {
                fatalError("Wrong OS log type \(macro)")
            }
            return try expansionLog(loggerArgument: arguments[0], 
                                    level: macroToLevelExpr(macro: node.macro),
                                    logMethod: logMethod,
                                    messageArgument: arguments[1])
        }
        
        guard arguments.count == 3 else {
            guard arguments.count == 2 else {
                fatalError("Arguments should be 3, got \(arguments.count)")
            }
            return try expansionLog(loggerArgument: arguments[0],
                                    level: macroToLevelExpr(macro: "notice"),
                                    logMethod: "log",
                                    messageArgument: arguments[1])
        }
        return try expansionLog(loggerArgument: arguments[0], 
                                levelArgument: arguments[1],
                                messageArgument: arguments[2])
    }
    
    static func expansionLog(
        loggerArgument: LabeledExprListSyntax.Element,
        levelArgument: LabeledExprListSyntax.Element,
        messageArgument: LabeledExprListSyntax.Element
    ) throws -> ExprSyntax {
        guard let member = levelArgument.expression.as(MemberAccessExprSyntax.self),
              member.base == nil || member.base?.as(DeclReferenceExprSyntax.self)?.baseName.text == "LogLevel" else {
            return try expansionLog(loggerArgument: loggerArgument,
                                    level: levelArgument.expression,
                                    logMethod: "log",
                                    levelArgument: "\(levelArgument.expression).toOSLogType()",
                                    messageArgument: messageArgument)
        }
        return try expansionLog(loggerArgument: loggerArgument,
                                level: ExprSyntax(member),
                                logMethod: logMethod(argument: levelArgument),
                                messageArgument: messageArgument)
    }

    static func expansionLog(
        loggerArgument: LabeledExprListSyntax.Element,
        level: ExprSyntax,
        logMethod: ExprSyntax,
        levelArgument: ExprSyntax? = nil,
        messageArgument: LabeledExprListSyntax.Element
    ) throws -> ExprSyntax {
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
    
    static func logMethod(argument: LabeledExprListSyntax.Element) -> ExprSyntax {
        guard let levelName = argument.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text,
              let osType = levelNameToLogMethod(levelName) else {
            fatalError("Level name not present")
        }
        return osType
    }
    
    static func levelNameToLogMethod(_ levelName: String) -> ExprSyntax? {
        switch levelName {
        case "warn":
            return "warning"
        case "err":
            return "error"
        default:
            return ExprSyntax(stringLiteral: levelName)
        }
    }
    
    static func macroToLevelExpr(macro: TokenSyntax) -> ExprSyntax {
        if macro.text == "err" {
            return ExprSyntax(".error")
        } else {
            return ExprSyntax(".\(macro)")
        }
    }
}

@main
struct EZLogPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EZLogMacro.self,
    ]
}
