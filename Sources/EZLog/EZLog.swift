//
//  EZLog.swift
//
//
//  Created by Enrico Zannini on 13/12/25.
//

import OSLog

@freestanding(expression)
public macro log(_ logger: EZLogger,
                 level: LogLevel = .notice,
                 _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                   type: "EZLogMacro")

@freestanding(expression)
public macro trace(_ logger: EZLogger,
                   _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                     type: "EZLogMacro")

@freestanding(expression)
public macro debug(_ logger: EZLogger,
                   _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                     type: "EZLogMacro")

@freestanding(expression)
public macro info(_ logger: EZLogger,
                  _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                    type: "EZLogMacro")

@freestanding(expression)
public macro notice(_ logger: EZLogger,
                    _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                      type: "EZLogMacro")

@freestanding(expression)
public macro warn(_ logger: EZLogger,
                  _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                    type: "EZLogMacro")

@freestanding(expression)
public macro err(_ logger: EZLogger,
                 _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                   type: "EZLogMacro")

@freestanding(expression)
public macro fault(_ logger: EZLogger,
                   _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                     type: "EZLogMacro")
