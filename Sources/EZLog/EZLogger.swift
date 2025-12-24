//
//  EZLogger.swift
//
//
//  Created by Enrico Zannini on 13/12/25.
//

import Foundation
import OSLog

/**
 * A `Logger` wrapper that holds a `MinLogLevel` to determine if logs of a certain level should be allowed or not.
 */
public struct EZLogger {
    /// The actual `Logger` that will need to perform the logging.
    public let logger: Logger
    /// The minimum log level allowed by this instance.
    public var logLevel: MinLogLevel
    
    /// A convenience shared logger that never logs anything.
    public static let disabled: EZLogger = EZLogger(.disabled)
    
    /**
     * Instanciate a logger that wraps the default `Logger()`.
     *
     * - parameter logLevel: The `MinimumLogLevel` allowed by this logger instance, defaults to `verbose`, which allows all logs.
     */
    public init(logLevel: MinLogLevel = .verbose) {
        self.init(logger: Logger(), logLevel: logLevel)
    }
    
    /**
     * Instanciate a logger that wraps a `Logger` with the specified subsystem and category.
     *
     * - parameter subsystem: The subsystem for the wrapped `Logger`.
     * - parameter category: The category for the wrapped `Logger`.
     * - parameter logLevel: The `MinimumLogLevel` allowed by this logger instance, defaults to `verbose`, which allows all logs.
     */
    public init(subsystem: String, category: String, logLevel: MinLogLevel = .verbose) {
        self.init(logger: Logger(subsystem: subsystem, category: category),
                  logLevel: logLevel)
    }
    
    /**
     * Instanciate a logger that wraps a `Logger` with the specified `OSLog` instance.
     *
     * - parameter logObj: The `OSLog` instance for the wrapped `Logger`.
     * - parameter logLevel: The `MinimumLogLevel` allowed by this logger instance, defaults to `verbose`, which allows all logs.
     */
    public init(_ logObj: OSLog, logLevel: MinLogLevel = .verbose) {
        self.init(logger: Logger(logObj),
                  logLevel: logLevel)
    }
    
    /**
     * Instanciate a logger that wraps the specified `Logger`.
     *
     * - parameter logger: The `Logger` instance to be wrapped.
     * - parameter logLevel: The `MinimumLogLevel` allowed by this logger instance, defaults to `verbose`, which allows all logs.
     */
    public init(logger: Logger, logLevel: MinLogLevel = .verbose) {
        self.logger = logger
        self.logLevel = logLevel
    }
    
    /**
     * Determins if a log with the specified `LogLevel` should be logged on the wrapped `Logger` instance.
     *
     * - parameter level: The `LogLevel` that should be evaluated.
     * - returns: True if the `LogLevel` is higher or equal to the `MinLogLevel` contained in this instance or false otherwise.
     */
    public func allows(level: LogLevel) -> Bool {
        logLevel.rawValue <= level.rawValue
    }
}
