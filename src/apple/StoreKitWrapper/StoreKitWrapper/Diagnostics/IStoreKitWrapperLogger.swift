//
//  IStoreKitWrapperLogger.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation

@objc public protocol IStoreKitWrapperLogger: AnyObject {
    func isEnabled(logLevel: StoreKitWrapperLogLevel) -> Bool

    func log(logLevel: StoreKitWrapperLogLevel,
             eventId: Int,
             eventName: String?,
             message: String,
             error: NSError?)
}

public extension IStoreKitWrapperLogger {
    // MARK: - Methods

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
