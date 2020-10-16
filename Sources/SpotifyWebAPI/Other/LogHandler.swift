import Foundation
import Logging

/**
 The logging backend for this library. See `LoggingSystem.bootstrap(_:)`.
 */
public struct SpotifyAPILogHandler: LogHandler {

    private static var handlerIsInitialized = false
    
    private static let initializeHandlerDispatchQueue = DispatchQueue(
        label: "SpotifyAPILogHandler.initializeHandler"
    )
    
    /**
     Calls `LoggingSystem.bootstrap(_:)` and configures this type as the logging
     backend. The default log level is `info`.
    
     This method is automatically called when an instance of `SpotifyAPI`, the
     central class in this library, is created or decoded from JSON data.
     
     This function should only be called once. Calling it additional times is
     safe, but has no effect.
     
     # Thread Safety
     
     This method is thread-safe.
     */
    public static func bootstrap() {
        Self.initializeHandlerDispatchQueue.sync {
            if !Self.handlerIsInitialized {
                LoggingSystem.bootstrap { label in
                    Self(label: label, logLevel: .info)
                }
                Self.handlerIsInitialized = true
            }
        }
    }
    
    
    /// A label for the logger.
    public let label: String

    public var logLevel: Logger.Level = .critical
    
    public var metadata = Logger.Metadata()

    /// If `true`, call `assertionFailure` when a logging message with
    /// a `critical` level is received. See also the type property
    /// `allLoggersAssertOnCritical`.
    public var assertOnCritical: Bool
    
    /// If `true`, call `assertionFailure` when a logging message with
    /// a `critical` level is received for **all** loggers. See also the
    /// instance property `assertOnCritical`.
    public static var allLoggersAssertOnCritical = false
    
    /**
     Creates the logging backend.
     
     - Parameters:
       - label: A label for the logger.
       - logLevel: The log level.
       - metadata: Metadata for this logger.
       - assertOnCritical: If `true`, call `assertionFailure` when a logging
             message with a `critical` level is received. The default is `false`.
     */
    public init(
        label: String,
        logLevel: Logger.Level,
        metadata: Logger.Metadata = Logger.Metadata(),
        assertOnCritical: Bool = false
    ) {
        self.label = label
        self.logLevel = logLevel
        self.metadata = metadata
        self.assertOnCritical = assertOnCritical
    }
    
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return metadata[metadataKey]
        }
        set {
            metadata[metadataKey] = newValue
        }
    }

    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        let logMessage = """
            [\(label): \(level): \(function) line \(line)] \(message)
            """
        
        if (assertOnCritical || Self.allLoggersAssertOnCritical) &&
                level == .critical {
            assertionFailure(logMessage)
        }
        print(logMessage)
    }

}


public extension Logger {
    
    /**
     Calls through to `init(label:)`, then sets the log level.
     
     - Parameters:
       - label: An identifier for the creator of a `Logger`.
       - level: The log level for the logger.
     */
    init(label: String, level: Logger.Level) {
        self.init(label: label)
        self.logLevel = level
    }
    

    /**
     Construct a `Logger` given a `label` identifying the creator of the `Logger`
     or a non-standard `LogHandler`.
          
     The `label` should identify the creator of the `Logger`. This can be an
     application, a sub-system, or even a datatype. This initializer provides an
     escape hatch in case the global default logging backend implementation
     (set up using `LoggingSystem.bootstrap`) is not appropriate for this
     particular logger.

     - parameters:
       - label: An identifier for the creator of a `Logger`.
       - level: The log level for the logger.
       - factory: A closure creating non-standard `LogHandler`s.
     */
    init(
        label: String,
        level: Logger.Level,
        factory: (_ label: String) -> LogHandler
    ) {
        self.init(label: label, factory: factory)
        self.logLevel = level
        
    }
    

}
