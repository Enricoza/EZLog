//
//  EZLogTests.swift
//
//
//  Created by Enrico Zannini on 13/12/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(EZLogMacros)
import EZLogMacros

let testMacros: [String: Macro.Type] = [
    "trace": EZLogMacro.self,
    "debug": EZLogMacro.self,
    "info": EZLogMacro.self,
    "notice": EZLogMacro.self,
    "warn": EZLogMacro.self,
    "err": EZLogMacro.self,
    "fault": EZLogMacro.self,
    "log": EZLogMacro.self,
]
#endif

final class EZLogTests: XCTestCase {
    func testTrace() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion("""
            #trace(EZLogger(), "AAA")
            """,
            expandedSource:
            """
            EZLogger().allows(level: .trace) ? EZLogger().logger.trace("AAA") : ()
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testDebug() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion("""
            #debug(EZLogger(), "AAA")
            """,
            expandedSource:
            """
            EZLogger().allows(level: .debug) ? EZLogger().logger.debug("AAA") : ()
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInfo() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion("""
            #info(EZLogger(), "AAA")
            """,
            expandedSource:
            """
            EZLogger().allows(level: .info) ? EZLogger().logger.info("AAA") : ()
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testNotice() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion("""
            #notice(EZLogger(), "AAA")
            """,
            expandedSource:
            """
            EZLogger().allows(level: .notice) ? EZLogger().logger.notice("AAA") : ()
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testWarn() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion("""
            #warn(EZLogger(), "AAA")
            """,
            expandedSource:
            """
            EZLogger().allows(level: .warn) ? EZLogger().logger.warning("AAA") : ()
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testError() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion("""
            #err(EZLogger(), "AAA")
            """,
            expandedSource:
            """
            EZLogger().allows(level: .error) ? EZLogger().logger.error("AAA") : ()
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testLogDefault() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion("""
            #log(EZLogger(), "AAA")
            """,
            expandedSource:
            """
            EZLogger().allows(level: .notice) ? EZLogger().logger.log("AAA") : ()
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testLogWithAllLevels() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion("""
            #log(EZLogger(), level: .trace, "AAA")
            #log(EZLogger(), level: .debug, "BBB")
            #log(EZLogger(), level: .info, "CCC")
            #log(EZLogger(), level: .notice, "DDD")
            #log(EZLogger(), "DDD2")
            #log(EZLogger(), level: .warn, "EEE")
            #log(EZLogger(), level: .error, "FFF")
            #log(EZLogger(), level: .fault, "GGG")
            """,
            expandedSource: 
            """
            EZLogger().allows(level: .trace) ? EZLogger().logger.trace("AAA") : ()
            EZLogger().allows(level: .debug) ? EZLogger().logger.debug("BBB") : ()
            EZLogger().allows(level: .info) ? EZLogger().logger.info("CCC") : ()
            EZLogger().allows(level: .notice) ? EZLogger().logger.notice("DDD") : ()
            EZLogger().allows(level: .notice) ? EZLogger().logger.log("DDD2") : ()
            EZLogger().allows(level: .warn) ? EZLogger().logger.warning("EEE") : ()
            EZLogger().allows(level: .error) ? EZLogger().logger.error("FFF") : ()
            EZLogger().allows(level: .fault) ? EZLogger().logger.fault("GGG") : ()
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testLogWithStringInterpolation() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion(
            #"""
            #log(EZLogger(), level: .trace, "AAA \(variable, privacy: .private)")
            """#,
            expandedSource:
            #"""
            EZLogger().allows(level: .trace) ? EZLogger().logger.trace("AAA \(variable, privacy: .private)") : ()
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testLogWithStaticExtensionWithType() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion(
            """
            #log(EZLogger.myLog, level: .trace, "AAA")
            """,
            expandedSource:
            """
            EZLogger.myLog.allows(level: .trace) ? EZLogger.myLog.logger.trace("AAA") : ()
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testLogWithStaticExtensionWithImpliedType() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion(
            """
            #log(.myLog, level: .trace, "AAA")
            """,
            expandedSource:
            """
            EZLogger.myLog.allows(level: .trace) ? EZLogger.myLog.logger.trace("AAA") : ()
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testLogWithLevelType() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion(
            """
            #log(.myLog, level: LogLevel.trace, "AAA")
            """,
            expandedSource:
            """
            EZLogger.myLog.allows(level: LogLevel.trace) ? EZLogger.myLog.logger.trace("AAA") : ()
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testLogWithLevelVariable() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion(
            """
            #log(.myLog, level: someLevel, "AAA")
            """,
            expandedSource:
            """
            EZLogger.myLog.allows(level: someLevel) ? EZLogger.myLog.logger.log(level: someLevel.toOSLogType(), "AAA") : ()
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testLogWithNamespacedLevel() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion(
            """
            #log(.myLog, level: Namespace.someLevel, "AAA")
            """,
            expandedSource:
            """
            EZLogger.myLog.allows(level: Namespace.someLevel) ? EZLogger.myLog.logger.log(level: Namespace.someLevel.toOSLogType(), "AAA") : ()
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testLogWithNamespacedLogger() throws {
        #if canImport(EZLogMacros)
        assertMacroExpansion(
            """
            #log(Namespace.myLog, level: someLevel, "AAA")
            """,
            expandedSource:
            """
            Namespace.myLog.allows(level: someLevel) ? Namespace.myLog.logger.log(level: someLevel.toOSLogType(), "AAA") : ()
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}

