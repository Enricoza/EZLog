import OSLog

@freestanding(expression)
public macro log(_ logger: EZLogger, level: LogLevel = .notice, _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                                                                  type: "EZLogMacro")

@freestanding(expression)
public macro trace(_ logger: EZLogger, _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                                         type: "EZLogMacro")

@freestanding(expression)
public macro debug(_ logger: EZLogger, _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                                         type: "EZLogMacro")

@freestanding(expression)
public macro info(_ logger: EZLogger, _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                                        type: "EZLogMacro")

@freestanding(expression)
public macro notice(_ logger: EZLogger, _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                                          type: "EZLogMacro")

@freestanding(expression)
public macro warn(_ logger: EZLogger, _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                                        type: "EZLogMacro")

@freestanding(expression)
public macro err(_ logger: EZLogger, _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                                       type: "EZLogMacro")

@freestanding(expression)
public macro fault(_ logger: EZLogger, _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                                         type: "EZLogMacro")

public struct MinLogLevel: RawRepresentable {
    public static let verbose = MinLogLevel(rawValue: -1000)
    public static let trace = MinLogLevel(rawValue: LogLevel.trace.rawValue)
    public static let debug = MinLogLevel(rawValue: LogLevel.debug.rawValue)
    public static let info = MinLogLevel(rawValue: LogLevel.info.rawValue)
    public static let notice = MinLogLevel(rawValue: LogLevel.notice.rawValue)
    public static let warn = MinLogLevel(rawValue: LogLevel.warn.rawValue)
    public static let error = MinLogLevel(rawValue: LogLevel.error.rawValue)
    public static let fault = MinLogLevel(rawValue: LogLevel.fault.rawValue)
    public static let silent = MinLogLevel(rawValue: 1000)
    public var rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public enum LogLevel: Int {
    case trace = 0
    case debug = 100
    case info = 200
    case notice = 300
    case warn = 400
    case error = 800
    case fault = 900
}

public struct EZLogger {
    public let logger: Logger
    public var logLevel: MinLogLevel
    
    public init(subsystem: String, category: String, logLevel: MinLogLevel = .verbose) {
        self.init(logger: Logger(subsystem: subsystem, category: category),
                  logLevel: logLevel)
    }
    
    public init(logger: Logger, logLevel: MinLogLevel = .verbose) {
        self.logger = logger
        self.logLevel = logLevel
    }
    
    public func allows(level: LogLevel) -> Bool {
        logLevel.rawValue <= level.rawValue
    }
}
