//
//  MinLogLevel.swift
//
//
//  Created by Enrico Zannini on 13/12/25.
//

import Foundation

/**
 * The representation of the minimum log level, that contains all of the possible LogLevels plus the `verbose` and `silent` option.
 */
public struct MinLogLevel: RawRepresentable {
    /// Used to allow all logs.
    public static let verbose = MinLogLevel(rawValue: -1000)
    /// Used to allow all logs higher or equal to `trace` (this is identical to `verbose`).
    public static let trace = MinLogLevel(rawValue: LogLevel.trace.rawValue)
    /// Used to allow all logs higher or equal to `debug`.
    public static let debug = MinLogLevel(rawValue: LogLevel.debug.rawValue)
    /// Used to allow all logs higher or equal to `info`.
    public static let info = MinLogLevel(rawValue: LogLevel.info.rawValue)
    /// Used to allow all logs higher or equal to `notice`.
    public static let notice = MinLogLevel(rawValue: LogLevel.notice.rawValue)
    /// Used to allow all logs higher or equal to `warn`.
    public static let warn = MinLogLevel(rawValue: LogLevel.warn.rawValue)
    /// Used to allow all logs higher or equal to `error`.
    public static let error = MinLogLevel(rawValue: LogLevel.error.rawValue)
    /// Used to allow all logs higher or equal to `fault`.
    public static let fault = MinLogLevel(rawValue: LogLevel.fault.rawValue)
    /// Used to silence all  logs.
    public static let silent = MinLogLevel(rawValue: 1000)
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
