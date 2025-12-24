//
//  EZLog.swift
//
//
//  Created by Enrico Zannini on 13/12/25.
//

import OSLog

/**
 * Log messages using a Swift `Logger` by conditionally excluding logs that have a lower level than what is accepted by the `EZLogger` wrapper.
 *
 * Create an `EZLogger` with the desired `MinLogLevel` and then pass it to this method to conditionally exclude logs that are lower than the desired minimum log level.
 * This macro keeps all the benefits of using a Swift `Logger` by wrapping the calls to that `Logger` with in-line minimum level condition evaluation and direct `Logger` usage.
 *
 * The basic expansion looks like the following:
 * ```swift
 * #log(logger, level: .debug, "Some message")
 * // Which expands to
 * logger.allows(level: .debug) ? logger.logger.log(level: .debug, "Some Message) : ()
 * ```
 *
 * Note that you can create the `OSLogMessage` with all of the interpolations and privacy options it supports and they will be passed as they are to the underlying `Logger` instance:
 * ```swift
 * #log(logger, level: .debug, "Some message \(somePrivateVariable, privacy: .private)")
 * #log(logger, level: .debug, "Some other message \(somePublicVariable, privacy: .public)")
 * ```
 *
 * - Parameters:
 *      - logger: An `EZLogger` instance that can be used to filter out the logs that are lower level than the minimum allowed log level
 *      - level: The optional `LogLevel` for this log message, that will be used for filtering and for applying the correct `OSLogType` to the `Logger.log` method call.
 *      Default is `LogLevel.notice`.
 *      - message: The `OSLogMessage` that will be forwarded, as it was provided, to the underlying `Logger` instance.
 */
@freestanding(expression)
public macro log(_ logger: EZLogger,
                 level: LogLevel = .notice,
                 _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                   type: "EZLogMacro")
/**
 * Log messages at `LogLevel.trace` level, using a Swift `Logger` by conditionally excluding logs if the passed `EZLogger` wrapper has a log level of `MinLogLevel.debug` or higher..
 *
 * Create an `EZLogger` with the desired `MinLogLevel` and then pass it to this method to conditionally exclude logs if the `EZLogger` log level is debug or higher.
 * This macro keeps all the benefits of using a Swift `Logger` by wrapping the calls to that `Logger` with in-line minimum level condition evaluation and direct `Logger` usage.
 *
 * The basic expansion looks like the following:
 * ```swift
 * #trace(logger, "Some message")
 * // Which expands to
 * logger.allows(level: .debug) ? logger.logger.trace("Some Message) : ()
 * ```
 *
 * Note that you can create the `OSLogMessage` with all of the interpolations and privacy options it supports and they will be passed as they are to the underlying `Logger` instance:
 * ```swift
 * #trace(logger, "Some message \(somePrivateVariable, privacy: .private)")
 * #trace(logger, "Some other message \(somePublicVariable, privacy: .public)")
 * ```
 *
 * - Parameters:
 *      - logger: An `EZLogger` instance that can be used to filter out the logs that are lower level than the minimum allowed log level
 *      - message: The `OSLogMessage` that will be forwarded, as it was provided, to the underlying `Logger` instance.
 */
@freestanding(expression)
public macro trace(_ logger: EZLogger,
                   _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                     type: "EZNamedLogMacro")
/**
 * Log messages at `LogLevel.debug` level, using a Swift `Logger` by conditionally excluding logs if the passed `EZLogger` wrapper has a log level of `MinLogLevel.info` or higher..
 *
 * Create an `EZLogger` with the desired `MinLogLevel` and then pass it to this method to conditionally exclude logs if the `EZLogger` log level is info or higher.
 * This macro keeps all the benefits of using a Swift `Logger` by wrapping the calls to that `Logger` with in-line minimum level condition evaluation and direct `Logger` usage.
 *
 * The basic expansion looks like the following:
 * ```swift
 * #debug(logger, "Some message")
 * // Which expands to
 * logger.allows(level: .debug) ? logger.logger.debug("Some Message) : ()
 * ```
 *
 * Note that you can create the `OSLogMessage` with all of the interpolations and privacy options it supports and they will be passed as they are to the underlying `Logger` instance:
 * ```swift
 * #debug(logger, "Some message \(somePrivateVariable, privacy: .private)")
 * #debug(logger, "Some other message \(somePublicVariable, privacy: .public)")
 * ```
 *
 * - Parameters:
 *      - logger: An `EZLogger` instance that can be used to filter out the logs that are lower level than the minimum allowed log level
 *      - message: The `OSLogMessage` that will be forwarded, as it was provided, to the underlying `Logger` instance.
 */
@freestanding(expression)
public macro debug(_ logger: EZLogger,
                   _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                     type: "EZNamedLogMacro")

/**
 * Log messages at `LogLevel.info` level, using a Swift `Logger` by conditionally excluding logs if the passed `EZLogger` wrapper has a log level of `MinLogLevel.notice` or higher..
 *
 * Create an `EZLogger` with the desired `MinLogLevel` and then pass it to this method to conditionally exclude logs if the `EZLogger` log level is notice or higher.
 * This macro keeps all the benefits of using a Swift `Logger` by wrapping the calls to that `Logger` with in-line minimum level condition evaluation and direct `Logger` usage.
 *
 * The basic expansion looks like the following:
 * ```swift
 * #info(logger, "Some message")
 * // Which expands to
 * logger.allows(level: .debug) ? logger.logger.info("Some Message) : ()
 * ```
 *
 * Note that you can create the `OSLogMessage` with all of the interpolations and privacy options it supports and they will be passed as they are to the underlying `Logger` instance:
 * ```swift
 * #info(logger, "Some message \(somePrivateVariable, privacy: .private)")
 * #info(logger, "Some other message \(somePublicVariable, privacy: .public)")
 * ```
 *
 * - Parameters:
 *      - logger: An `EZLogger` instance that can be used to filter out the logs that are lower level than the minimum allowed log level
 *      - message: The `OSLogMessage` that will be forwarded, as it was provided, to the underlying `Logger` instance.
 */
@freestanding(expression)
public macro info(_ logger: EZLogger,
                  _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                    type: "EZNamedLogMacro")
/**
 * Log messages at `LogLevel.notice` level, using a Swift `Logger` by conditionally excluding logs if the passed `EZLogger` wrapper has a log level of `MinLogLevel.warn` or higher..
 *
 * Create an `EZLogger` with the desired `MinLogLevel` and then pass it to this method to conditionally exclude logs if the `EZLogger` log level is warn or higher.
 * This macro keeps all the benefits of using a Swift `Logger` by wrapping the calls to that `Logger` with in-line minimum level condition evaluation and direct `Logger` usage.
 *
 * The basic expansion looks like the following:
 * ```swift
 * #notice(logger, "Some message")
 * // Which expands to
 * logger.allows(level: .debug) ? logger.logger.notice("Some Message) : ()
 * ```
 *
 * Note that you can create the `OSLogMessage` with all of the interpolations and privacy options it supports and they will be passed as they are to the underlying `Logger` instance:
 * ```swift
 * #notice(logger, "Some message \(somePrivateVariable, privacy: .private)")
 * #notice(logger, "Some other message \(somePublicVariable, privacy: .public)")
 * ```
 *
 * - Parameters:
 *      - logger: An `EZLogger` instance that can be used to filter out the logs that are lower level than the minimum allowed log level
 *      - message: The `OSLogMessage` that will be forwarded, as it was provided, to the underlying `Logger` instance.
 */
@freestanding(expression)
public macro notice(_ logger: EZLogger,
                    _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                      type: "EZNamedLogMacro")

/**
 * Log messages at `LogLevel.warn` level, using a Swift `Logger` by conditionally excluding logs if the passed `EZLogger` wrapper has a log level of `MinLogLevel.error` or higher..
 *
 * Create an `EZLogger` with the desired `MinLogLevel` and then pass it to this method to conditionally exclude logs if the `EZLogger` log level is error or higher.
 * This macro keeps all the benefits of using a Swift `Logger` by wrapping the calls to that `Logger` with in-line minimum level condition evaluation and direct `Logger` usage.
 *
 * The basic expansion looks like the following:
 * ```swift
 * #warn(logger, "Some message")
 * // Which expands to
 * logger.allows(level: .debug) ? logger.logger.warning("Some Message) : ()
 * ```
 *
 * Note that you can create the `OSLogMessage` with all of the interpolations and privacy options it supports and they will be passed as they are to the underlying `Logger` instance:
 * ```swift
 * #warn(logger, "Some message \(somePrivateVariable, privacy: .private)")
 * #warn(logger, "Some other message \(somePublicVariable, privacy: .public)")
 * ```
 *
 * - Parameters:
 *      - logger: An `EZLogger` instance that can be used to filter out the logs that are lower level than the minimum allowed log level
 *      - message: The `OSLogMessage` that will be forwarded, as it was provided, to the underlying `Logger` instance.
 */
@freestanding(expression)
public macro warn(_ logger: EZLogger,
                  _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                    type: "EZNamedLogMacro")

/**
 * Log messages at `LogLevel.error` level, using a Swift `Logger` by conditionally excluding logs if the passed `EZLogger` wrapper has a log level of `MinLogLevel.fault` or higher..
 *
 * Create an `EZLogger` with the desired `MinLogLevel` and then pass it to this method to conditionally exclude logs if the `EZLogger` log level is fault or higher.
 * This macro keeps all the benefits of using a Swift `Logger` by wrapping the calls to that `Logger` with in-line minimum level condition evaluation and direct `Logger` usage.
 *
 * The basic expansion looks like the following:
 * ```swift
 * #err(logger, "Some message")
 * // Which expands to
 * logger.allows(level: .debug) ? logger.logger.error("Some Message) : ()
 * ```
 *
 * Note that you can create the `OSLogMessage` with all of the interpolations and privacy options it supports and they will be passed as they are to the underlying `Logger` instance:
 * ```swift
 * #err(logger, "Some message \(somePrivateVariable, privacy: .private)")
 * #err(logger, "Some other message \(somePublicVariable, privacy: .public)")
 * ```
 *
 * - Parameters:
 *      - logger: An `EZLogger` instance that can be used to filter out the logs that are lower level than the minimum allowed log level
 *      - message: The `OSLogMessage` that will be forwarded, as it was provided, to the underlying `Logger` instance.
 */
@freestanding(expression)
public macro err(_ logger: EZLogger,
                 _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                   type: "EZNamedLogMacro")

/**
 * Log messages at `LogLevel.fault` level, using a Swift `Logger` by conditionally excluding logs if the passed `EZLogger` wrapper has a log level of `MinLogLevel.silent`..
 *
 * Create an `EZLogger` with the desired `MinLogLevel` and then pass it to this method to conditionally exclude logs if the `EZLogger` log level is silent or higher.
 * This macro keeps all the benefits of using a Swift `Logger` by wrapping the calls to that `Logger` with in-line minimum level condition evaluation and direct `Logger` usage.
 *
 * The basic expansion looks like the following:
 * ```swift
 * #fault(logger, "Some message")
 * // Which expands to
 * logger.allows(level: .debug) ? logger.logger.fault("Some Message) : ()
 * ```
 *
 * Note that you can create the `OSLogMessage` with all of the interpolations and privacy options it supports and they will be passed as they are to the underlying `Logger` instance:
 * ```swift
 * #fault(logger, "Some message \(somePrivateVariable, privacy: .private)")
 * #fault(logger, "Some other message \(somePublicVariable, privacy: .public)")
 * ```
 *
 * - Parameters:
 *      - logger: An `EZLogger` instance that can be used to filter out the logs that are lower level than the minimum allowed log level
 *      - message: The `OSLogMessage` that will be forwarded, as it was provided, to the underlying `Logger` instance.
 */
@freestanding(expression)
public macro fault(_ logger: EZLogger,
                   _ message: OSLogMessage) -> Void = #externalMacro(module: "EZLogMacros",
                                                                     type: "EZNamedLogMacro")
