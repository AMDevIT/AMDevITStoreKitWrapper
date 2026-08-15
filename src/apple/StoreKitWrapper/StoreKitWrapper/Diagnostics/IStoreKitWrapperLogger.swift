//
//  IStoreKitWrapperLogger.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation

/// Receives structured diagnostic events emitted by the StoreKit wrapper.
///
/// The contract mirrors the core concepts of `Microsoft.Extensions.Logging.ILogger`
/// so that applications can implement a small bridge between the two logging systems.
@objc public protocol IStoreKitWrapperLogger: AnyObject {
    /// Determines whether events at the specified severity should be emitted.
    /// - Parameter logLevel: The severity to test.
    /// - Returns: `true` when logging is enabled for the severity; otherwise, `false`.
    func isEnabled(logLevel: StoreKitWrapperLogLevel) -> Bool

    /// Records a structured log event.
    /// - Parameters:
    ///   - logLevel: The event severity.
    ///   - eventId: A stable numeric identifier for the event.
    ///   - eventName: An optional human-readable event name.
    ///   - message: The formatted event message.
    ///   - error: An optional native error associated with the event.
    func log(logLevel: StoreKitWrapperLogLevel,
             eventId: Int,
             eventName: String?,
             message: String,
             error: NSError?)
}

/// Provides severity-specific convenience methods for structured logging.
public extension IStoreKitWrapperLogger {
    // MARK: - Methods

    /// Records a trace event when trace logging is enabled.
    func logTrace(eventId: Int,
                  eventName: String? = nil,
                  message: String,
                  error: NSError? = nil) {
        self.logIfEnabled(logLevel: .trace,
                          eventId: eventId,
                          eventName: eventName,
                          message: message,
                          error: error)
    }

    /// Records a debug event when debug logging is enabled.
    func logDebug(eventId: Int,
                  eventName: String? = nil,
                  message: String,
                  error: NSError? = nil) {
        self.logIfEnabled(logLevel: .debug,
                          eventId: eventId,
                          eventName: eventName,
                          message: message,
                          error: error)
    }

    /// Records an informational event when informational logging is enabled.
    func logInformation(eventId: Int,
                        eventName: String? = nil,
                        message: String,
                        error: NSError? = nil) {
        self.logIfEnabled(logLevel: .information,
                          eventId: eventId,
                          eventName: eventName,
                          message: message,
                          error: error)
    }

    /// Records a warning event when warning logging is enabled.
    func logWarning(eventId: Int,
                    eventName: String? = nil,
                    message: String,
                    error: NSError? = nil) {
        self.logIfEnabled(logLevel: .warning,
                          eventId: eventId,
                          eventName: eventName,
                          message: message,
                          error: error)
    }

    /// Records an error event when error logging is enabled.
    func logError(eventId: Int,
                  eventName: String? = nil,
                  message: String,
                  error: NSError? = nil) {
        self.logIfEnabled(logLevel: .error,
                          eventId: eventId,
                          eventName: eventName,
                          message: message,
                          error: error)
    }

    /// Records a critical event when critical logging is enabled.
    func logCritical(eventId: Int,
                     eventName: String? = nil,
                     message: String,
                     error: NSError? = nil) {
        self.logIfEnabled(logLevel: .critical,
                          eventId: eventId,
                          eventName: eventName,
                          message: message,
                          error: error)
    }

    private func logIfEnabled(logLevel: StoreKitWrapperLogLevel,
                              eventId: Int,
                              eventName: String?,
                              message: String,
                              error: NSError?) {
        guard self.isEnabled(logLevel: logLevel) else {
            return
        }

        self.log(logLevel: logLevel,
                 eventId: eventId,
                 eventName: eventName,
                 message: message,
                 error: error)
    }
}
