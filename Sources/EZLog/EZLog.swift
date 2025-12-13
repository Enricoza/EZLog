import OSLog

@freestanding(expression)
public macro log(_ logger: EZLogLimiter,
                 level: LogLevel = .notice,
                 _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                   type: "EZLogMacro")

@freestanding(expression)
public macro trace(_ logger: EZLogLimiter,
                   _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                     type: "EZLogMacro")

@freestanding(expression)
public macro debug(_ logger: EZLogLimiter,
                   _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                     type: "EZLogMacro")

@freestanding(expression)
public macro info(_ logger: EZLogLimiter,
                  _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                    type: "EZLogMacro")

@freestanding(expression)
public macro notice(_ logger: EZLogLimiter,
                    _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                      type: "EZLogMacro")

@freestanding(expression)
public macro warn(_ logger: EZLogLimiter,
                  _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                    type: "EZLogMacro")

@freestanding(expression)
public macro err(_ logger: EZLogLimiter,
                 _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                   type: "EZLogMacro")

@freestanding(expression)
public macro fault(_ logger: EZLogLimiter,
                   _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                     type: "EZLogMacro")
