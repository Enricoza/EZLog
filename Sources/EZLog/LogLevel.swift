//
//  LogLevel.swift
//  
//
//  Created by Enrico Zannini on 13/12/25.
//

import Foundation
import OSLog

/// The supported log levels.
public enum LogLevel: Int {
    /// The most verbose log level, used for detailed log messages, mostly used during development.
    case trace = 0
    /// The second most verbose log level, used for debugging the behavior of an application without logging detailed objects.
    case debug = 100
    /// The log level used to log informative messages that could be useful, but not essantial, to troubleshooting errors.
    case info = 200
    /// The default log level, used to capture things that might result in a failure.
    case notice = 300
    /// Use this level to process-level warnings.
    case warn = 400
    /// Use this level to process-level errors.
    case error = 800
    /// Use this level only to capture system-level or multiprocess information when reporting system errors
    case fault = 900
    
    /**
     * Returns the `OSLogType` corresponding to this `LogLevel`.
     *
     * Note that not all `LogLevel` have a corresponding `OSLogType`, but this is normal as the underlying `OSLogType` is limited.
     * The mapping behavior is identical to what the `Logger` does with its log methods.
     *
     * - returns: The `OSLogType` corresponding to this `LogLevel`
     */
    public func toOSLogType() -> OSLogType {
        switch self {
        case .trace, .debug: .debug
        case .info: .info
        case .notice: .default
        case .warn, .error: .error
        case .fault: .fault
        }
    }
}
