import EZLog
import OSLog

let a = "abc"
var logger = EZLogger(subsystem: "com.app.my", category: "SomeCategory")
var other = EZLogger(subsystem: "com.app.my", category: "OtherCategory", logLevel: .notice)
#log(logger, level: .trace, "Some log - trace: \(a, privacy: .private)")
#trace(logger, "Some trace \(a, align: .right(columns: 20))")
#debug(logger, "Some debug \(a, privacy: .public)")
#info(logger, "Some info \(a, privacy: .private(mask: .hash))")
#warn(logger, "Some warn \(a, privacy: .sensitive)")
#err(logger, "Some err \(a, attributes: "Some Attributes")")
#fault(logger, "Some fault \(a, align: .none, privacy: .sensitive(mask: .hash), attributes: "Some")")

typealias SomeLogLevel = LogLevel

#log(logger, level: SomeLogLevel.debug, "something")

extension EZLogger {
    static let sharedLevel = MinLogLevel.verbose
    static let myLog = EZLogger(subsystem: "my.subsystem", category: "my_category", logLevel: sharedLevel)
}

#trace(EZLogger.myLog, "Using static constant with type")
#trace(.myLog, "Using static constant with implied type")


#trace(other, "Should not be logged")
#debug(other, "Should not be logged")
#info(other, "Should not be logged")
#notice(other, "Notice should be logged")
#warn(other, "Warning should be logged")
#err(other, "Error should be logged")
#fault(other, "Fault should be logged")

struct Slow: CustomStringConvertible {
    
    var description: String {
        var text = ""
        for number in 0..<20 {
            text += text + "\(number)"
        }
        return text
    }
}

#notice(other, "Before")
#trace(other, "Avoided for log level: \(Slow())")
#notice(other, "After")

