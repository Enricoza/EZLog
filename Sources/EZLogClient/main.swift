import EZLog
import OSLog


let a = "abc"
var logger = EZLogger(subsystem: "com.app.my", category: "SomeCategory")
var other = EZLogger(subsystem: "com.app.my", category: "OtherCategory", logLevel: .error)

#log(logger, level: .trace, "Some log - trace: \(a, privacy: .private)")
#trace(logger, "Some trace \(a)")
#debug(logger, "Some debug \(a)")
#info(logger, "Some info \(a, privacy: .private(mask: .hash))")
#warn(logger, "Some warn \(a)")
#err(logger, "Some err \(a)")
#fault(logger, "Some fault \(a)")


#trace(other, "Should not be logged")
#debug(other, "Should not be logged")
#info(other, "Should not be logged")
#notice(other, "Should not be logged")
#warn(other, "Should not be logged")
#err(other, "Error should be logged")
#fault(other, "Fault should be logged")

