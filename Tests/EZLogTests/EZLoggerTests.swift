//
//  EZLoggerTests.swift
//  
//
//  Created by Enrico Zannini on 13/12/25.
//

import XCTest
import EZLog

final class EZLoggerTests: XCTestCase {
    var logLevel = MinLogLevel.verbose
    lazy var logger = EZLogger(subsystem: "subsystem", category: "category", logLevel: logLevel)
    
    func testVerboseLevelAllowsAllLevels() {
        logLevel = .verbose
        XCTAssertTrue(logger.allows(level: .trace))
        XCTAssertTrue(logger.allows(level: .debug))
        XCTAssertTrue(logger.allows(level: .info))
        XCTAssertTrue(logger.allows(level: .notice))
        XCTAssertTrue(logger.allows(level: .warn))
        XCTAssertTrue(logger.allows(level: .error))
        XCTAssertTrue(logger.allows(level: .fault))
    }

    func testTraceLevelAllowsAllLevels() {
        logLevel = .trace
        XCTAssertTrue(logger.allows(level: .trace))
        XCTAssertTrue(logger.allows(level: .debug))
        XCTAssertTrue(logger.allows(level: .info))
        XCTAssertTrue(logger.allows(level: .notice))
        XCTAssertTrue(logger.allows(level: .warn))
        XCTAssertTrue(logger.allows(level: .error))
        XCTAssertTrue(logger.allows(level: .fault))
    }
    
    func testDebugLevelAllowsAllLevelsHigherThanTrace() {
        logLevel = .debug
        XCTAssertFalse(logger.allows(level: .trace))
        XCTAssertTrue(logger.allows(level: .debug))
        XCTAssertTrue(logger.allows(level: .info))
        XCTAssertTrue(logger.allows(level: .notice))
        XCTAssertTrue(logger.allows(level: .warn))
        XCTAssertTrue(logger.allows(level: .error))
        XCTAssertTrue(logger.allows(level: .fault))
    }
    
    func testInfoLevelAllowsAllLevelsHigherThanDebug() {
        logLevel = .info
        XCTAssertFalse(logger.allows(level: .trace))
        XCTAssertFalse(logger.allows(level: .debug))
        XCTAssertTrue(logger.allows(level: .info))
        XCTAssertTrue(logger.allows(level: .notice))
        XCTAssertTrue(logger.allows(level: .warn))
        XCTAssertTrue(logger.allows(level: .error))
        XCTAssertTrue(logger.allows(level: .fault))
    }
    
    func testNoticeLevelAllowsAllLevelsHigherThanInfo() {
        logLevel = .notice
        XCTAssertFalse(logger.allows(level: .trace))
        XCTAssertFalse(logger.allows(level: .debug))
        XCTAssertFalse(logger.allows(level: .info))
        XCTAssertTrue(logger.allows(level: .notice))
        XCTAssertTrue(logger.allows(level: .warn))
        XCTAssertTrue(logger.allows(level: .error))
        XCTAssertTrue(logger.allows(level: .fault))
    }
    
    func testWarnLevelAllowsAllLevelsHigherThanNotice() {
        logLevel = .warn
        XCTAssertFalse(logger.allows(level: .trace))
        XCTAssertFalse(logger.allows(level: .debug))
        XCTAssertFalse(logger.allows(level: .info))
        XCTAssertFalse(logger.allows(level: .notice))
        XCTAssertTrue(logger.allows(level: .warn))
        XCTAssertTrue(logger.allows(level: .error))
        XCTAssertTrue(logger.allows(level: .fault))
    }
    
    func testErrorLevelAllowsAllLevelsHigherThanWarn() {
        logLevel = .error
        XCTAssertFalse(logger.allows(level: .trace))
        XCTAssertFalse(logger.allows(level: .debug))
        XCTAssertFalse(logger.allows(level: .info))
        XCTAssertFalse(logger.allows(level: .notice))
        XCTAssertFalse(logger.allows(level: .warn))
        XCTAssertTrue(logger.allows(level: .error))
        XCTAssertTrue(logger.allows(level: .fault))
    }
    
    func testFaultLevelAllowsAllLevelsHigherThanError() {
        logLevel = .fault
        XCTAssertFalse(logger.allows(level: .trace))
        XCTAssertFalse(logger.allows(level: .debug))
        XCTAssertFalse(logger.allows(level: .info))
        XCTAssertFalse(logger.allows(level: .notice))
        XCTAssertFalse(logger.allows(level: .warn))
        XCTAssertFalse(logger.allows(level: .error))
        XCTAssertTrue(logger.allows(level: .fault))
    }
    
    func testSilentLevelAllowsNoLevel() {
        logLevel = .silent
        XCTAssertFalse(logger.allows(level: .trace))
        XCTAssertFalse(logger.allows(level: .debug))
        XCTAssertFalse(logger.allows(level: .info))
        XCTAssertFalse(logger.allows(level: .notice))
        XCTAssertFalse(logger.allows(level: .warn))
        XCTAssertFalse(logger.allows(level: .error))
        XCTAssertFalse(logger.allows(level: .fault))
    }
}
