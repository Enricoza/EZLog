//
//  EZLogger.swift
//
//
//  Created by Enrico Zannini on 13/12/25.
//

import Foundation
import OSLog

public struct EZLogger {
    public let logger: Logger
    public var logLevel: MinLogLevel
    
    public static let disabled: EZLogger = EZLogger(.disabled)
    
    public init(logLevel: MinLogLevel = .verbose) {
        self.init(logger: Logger(), logLevel: logLevel)
    }
    
    public init(subsystem: String, category: String, logLevel: MinLogLevel = .verbose) {
        self.init(logger: Logger(subsystem: subsystem, category: category),
                  logLevel: logLevel)
    }
    
    public init(_ logObj: OSLog, logLevel: MinLogLevel = .verbose) {
        self.init(logger: Logger(logObj),
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
