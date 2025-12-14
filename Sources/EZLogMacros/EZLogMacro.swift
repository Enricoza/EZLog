import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum MacroError: Error, CustomStringConvertible {
    case unexpectedLoglevel
    var description: String {
        switch self {
        case .unexpectedLoglevel: "Unexpected log level"
        }
    }
}

// TODO: Maybe split this in multiple macros with some utility to reuse?

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
                                    level: macroToLevelName(macro: node.macro),
                                    logMethod: logMethod,
                                    messageArgument: arguments[1])
        }
        
        guard arguments.count == 3 else {
            guard arguments.count == 2 else {
                fatalError("Arguments should be 3, got \(arguments.count)")
            }
            return try expansionLog(loggerArgument: arguments[0],
                                    level: macroToLevelName(macro: "notice"),
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
        guard let level = levelArgument.expression.as(MemberAccessExprSyntax.self)?.declName else {
            fatalError("compiler bug: the macro does not have any arguments")
        }
        return try expansionLog(loggerArgument: loggerArgument,
                                level: level,
                                logMethod: logMethod(argument: levelArgument),
                                messageArgument: messageArgument)
    }
    
    // TODO: use swift syntax builders to make this expression type safe

    static func expansionLog(
        loggerArgument: LabeledExprListSyntax.Element,
        level: DeclReferenceExprSyntax,
        logMethod: ExprSyntax,
        messageArgument: LabeledExprListSyntax.Element
    ) throws -> ExprSyntax {
        let sanitizedLogger = sanitizeLoggerArgument(loggerArgument)
        return """
        \(sanitizedLogger).allows(level: .\(level)) ? \(sanitizedLogger).logger.\(logMethod)(\(messageArgument)) : ()
        """
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
    
    static func macroToLevelName(macro: TokenSyntax) -> DeclReferenceExprSyntax {
        if macro.text == "err" {
            return DeclReferenceExprSyntax(baseName: TokenSyntax(stringLiteral: "error"))
        } else {
            return DeclReferenceExprSyntax(baseName: macro)
        }
    }
}

@main
struct EZLogPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EZLogMacro.self,
    ]
}
