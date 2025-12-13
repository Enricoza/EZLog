//
//  MinLogLevel.swift
//
//
//  Created by Enrico Zannini on 13/12/25.
//

import Foundation

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
