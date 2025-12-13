//
//  EZLogger.swift
//
//
//  Created by Enrico Zannini on 13/12/25.
//

import Foundation
import OSLog

public protocol EZLogLimiter {
    var logger: Logger { get }
    func allows(level: LogLevel) -> Bool
}

public struct EZLogger: EZLogLimiter {
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
