//
//  StoreKitWrapperLoggerTests.swift
//  StoreKitWrapperTests
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import Testing
@testable import StoreKitWrapper

struct StoreKitWrapperLoggerTests {
    // MARK: - Tests

    @Test func disabledLevelDoesNotReachLogger() {
        let logger = StoreKitWrapperLoggerSpy(enabledLevels: [.error])

        logger.logInformation(eventId: 10,
                              eventName: "Information",
                              message: "Ignored")

        #expect(logger.entries.isEmpty)
    }

    @Test func enabledLevelPreservesLogData() {
        let logger = StoreKitWrapperLoggerSpy(enabledLevels: [.error])
        let error = NSError(domain: "StoreKitWrapperTests",
                            code: 42)

        logger.logError(eventId: 20,
                        eventName: "PurchaseFailed",
                        message: "Failure",
                        error: error)

        #expect(logger.entries.count == 1)
        #expect(logger.entries.first?.logLevel == .error)
        #expect(logger.entries.first?.eventId == 20)
        #expect(logger.entries.first?.eventName == "PurchaseFailed")
        #expect(logger.entries.first?.message == "Failure")
        #expect(logger.entries.first?.error === error)
    }
}

private final class StoreKitWrapperLoggerSpy: NSObject, IStoreKitWrapperLogger {
    // MARK: - Properties

    private let enabledLevelValues: Set<Int>
    private(set) var entries = [StoreKitWrapperLogEntry]()

    // MARK: - Initialization

    init(enabledLevels: [StoreKitWrapperLogLevel]) {
        self.enabledLevelValues = Set(enabledLevels.map { $0.rawValue })
        super.init()
    }

    // MARK: - Methods

    func isEnabled(logLevel: StoreKitWrapperLogLevel) -> Bool {
        return self.enabledLevelValues.contains(logLevel.rawValue)
    }

    func log(logLevel: StoreKitWrapperLogLevel,
             eventId: Int,
             eventName: String?,
             message: String,
             error: NSError?) {
        self.entries.append(StoreKitWrapperLogEntry(logLevel: logLevel,
                                                    eventId: eventId,
                                                    eventName: eventName,
                                                    message: message,
                                                    error: error))
    }
}

private struct StoreKitWrapperLogEntry {
    // MARK: - Properties

    let logLevel: StoreKitWrapperLogLevel
    let eventId: Int
    let eventName: String?
    let message: String
    let error: NSError?
}
