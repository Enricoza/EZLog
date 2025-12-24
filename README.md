# EZLog

A Swift `Logger` macro wrapper that allows to filter out logs that are lower than the minimum allowed log level, while keeping all the benefits of the Swift `Logger` APIs such as:
- Incredibly fast performance
- String interpolation specific parameters like: privacy, alignment and attributes.

This allows you to keep the logs in the app even in production, with the benefits of being able to debug your users issues, while still limiting the logs to the highest levels only.

You can, in fact:
- Ask your users to export their own logs and send them to you
- Programmatically fetch them with the `OSLogStore` and send them to yourself whenever you think is necessary (e.g. when the user reports a bug in an in-app submission form) 

# Why is this needed?

This is not really needed in most cases. The `Logger` is performant enough to keep all the logs in production apps, and you can already filter all of the logs you want to see via the console filters.
In some cases, though, you might not want to set up the filter every time.

For example, if all of your subsystems are logging at the same time, you have to filter them out every time you want to look at the logs. Whereas it would be nice to be able to do something like the following:
- For all subsystems, make the minimum log level be `error`
- For the specific subsystem that I'm working on right now, let's make the log level more verbose, like `trace` or `debug`

In general, anyway, limiting logs to a certain log level is something that most Swift developers are constantly trying to achieve, even if the performance benefit is negligible. 

## The usual, wrong, way

The way this is usually performed is by logging only when in `DEBUG` configuration (or anyway by setting some compilation flags):
```swift
#if DEBUG
logger.log("Some logs")
#endif
```
But this is both very verbose and usually doesn't allow for logs to be in production apps.

Alternatively, a lot of people just wrap the `Logger` with their own implementation, like so:
```swift
// Simplified for brevity
struct MyLogger {
    let minLogLevel: LogLevel
    let logger = Logger()
    
    func log(level: LogLevel, _ message: String) {
        if minLogLevel < level {
            logger.log("\(message, privacy: .public)")
        }
    }
}
```
But this removes all of the benefits of using the `Logger`, like the performance and the privacy of messages contents.

Read more about the `Logger` and **why you shouldn't wrap it** here: [Your Friend the System Log](https://developer.apple.com/forums/thread/705868).

## Aim

This macro aims to improve on both of these approaches by wrapping the `Logger` in line, by expanding the condition in a ternary operator that excludes logs based on the minimum allowed log level, while holding both performance and capabilities to the highest standards.


# Usage

The usage is very similar to how you would use the standard Swift `Logger`, except with a macro.

You are going to need to create an instance of an `EZLogger` and provide some optional parameters like:
- A subsystem
- A category
- A minimum allowed log level
```swift
let logger = EZLogger(subsystem: "com.app.my", category: "SomeCategory", logLevel: .error)
```

Then, you can start logging with the `#log` macro, by manually passing the `EZLogger` and log level for each logging event:
```swift
#log(logger, level: .debug, "This is a log")
``` 

> Note: in the provided example, the log will NOT be executed because the minimum log level is `error`, and the log is at `debug` level.

Or you can use specific logging macros like:
- `trace`
- `debug`
- `info`
- `notice`
- `warn`
- `err`
- `fault`

That will use the relative log level. This is the suggested way to log when the log level is not coming from an unknown variable (i.e. when it's determined at development time).
```swift
#trace(logger, "This is a trace level log")
#err(logger, "This is an error level log")
```

## Expansion
 
### The basic macro expansion looks like the following:
 
```swift
#log(logger, level: .debug, "Some message")
// Which expands to
logger.allows(level: .debug) ? logger.logger.log(level: .debug, "Some Message) : ()
```

Note that you can create the `OSLogMessage` with all of the interpolations and privacy options it supports and they will be passed (as they are) to the underlying `Logger` instance:
```swift
#log(logger, level: .debug, "Some message \(somePrivateVariable, privacy: .private)")
#log(logger, level: .debug, "Some other message \(somePublicVariable, privacy: .public)")
```

And the expansion will look like the following:
```swift
logger.allows(level: .debug) ? logger.logger.debug("Some message \(somePrivateVariable, privacy: .private)") : ()
logger.allows(level: .debug) ? logger.logger.debug("Some other message \(somePublicVariable, privacy: .public)") : ()
```

### For level specific logs, instead, it's even more concise:
```swift
#trace(logger, "Some message")
// Which expands to
logger.allows(level: .debug) ? logger.logger.trace("Some Message) : ()
```

Note that you can create the `OSLogMessage` with all of the interpolations and privacy options it supports and they will be passed (as they are) to the underlying `Logger` instance:
```swift
#trace(logger, "Some message \(somePrivateVariable, privacy: .private)")
#trace(logger, "Some other message \(somePublicVariable, privacy: .public)")
```

And the expansion will look like the following:
```swift
logger.allows(level: .trace) ? logger.logger.trace("Some message \(somePrivateVariable, privacy: .private)") : ()
logger.allows(level: .trace) ? logger.logger.trace("Some other message \(somePublicVariable, privacy: .public)") : ()
```

## Best practices
You can create `EZLogger` instances and store them in an extension as `static let` so that they can be easily accessed.

As an example:
```swift
extension EZLogger {
    static let userStorage = EZLogger(subsystem: "com.app.my.storage", category: "User", logLevel: .notice)
    static let preferencesStorage = EZLogger(subsystem: "com.app.my.storage", category: "Preferences", logLevel: .notice)
    static let authenticationNetwork = EZLogger(subsystem: "com.app.my.network", category: "Authentication", logLevel: .notice)
    static let contentNetwork = EZLogger(subsystem: "com.app.my.network", category: "Content", logLevel: .notice)
    // ...
}

class NetworkClient {

    func logIn(/*...*/) {
        #trace(.authenticationNetwork, "User log in")    
    }
    
    func fetchContent(/*...*/) {
        #trace(.contentNetwork, "Fetching content")    
    }
}
```

Additionally, if you want to manage in a single place the minimum log level of all, or most, of the logger instances, you can do so with another `static let` in a `MinLogLevel` extension.

```swift
extension MinLogLevel {
    static let defaultLevel = Self.error
}

extension EZLogger {
    static let defaultLevel = MinLogLevel.error
    static let userStorage = EZLogger(subsystem: "com.app.my.storage", category: "User", logLevel: .defaultLevel)
    static let preferencesStorage = EZLogger(subsystem: "com.app.my.storage", category: "Preferences", logLevel: .defaultLevel)
    static let authenticationNetwork = EZLogger(subsystem: "com.app.my.network", category: "Authentication", logLevel: .defaultLevel)
    // And then customize single logger instances
    static let contentNetwork = EZLogger(subsystem: "com.app.my.network", category: "Content", logLevel: .trace)
}
```

# Install

## Installing from Xcode

1. Add a package by selecting `File` → `Add Packages…` in Xcode’s menu bar.
2. Search for the `EZLog` macro using the repo's URL: https://github.com/Enricoza/EZLog.git
3. Next, set the `Dependency Rule` to be `Up to Next Major Version`.
4. Then, select `Add Package`
5. Then, chose the target onto which to to add `EZLog`
6. Then, hit `Add Package` again. 


## Alternatively, add `EZLog` to a `Package.swift` manifest
To integrate via a `Package.swift` manifest instead of Xcode, you can add `EZLog` to the dependencies array of your package:

```swift
dependencies: [
  .package(
    name: "EZLog",
    url: "https://github.com/Enricoza/EZLog.git",
    .upToNextMajor(from: "1.0.0")
  ),
  // Any other dependencies you have...
],
```

# Contributions

Feel free to open issues or pull requests if you have problems or suggestions.

# License

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details.
