//
//  StoreKitWrapperLogLevel.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation

/// Defines log severity levels using the ordering of `Microsoft.Extensions.Logging.LogLevel`.
@objc public enum StoreKitWrapperLogLevel: Int {
    /// Detailed diagnostic information, typically useful only during development.
    case trace = 0
    /// Diagnostic information useful for debugging.
    case debug = 1
    /// Informational messages that describe normal operation.
    case information = 2
    /// A potentially harmful or unexpected condition that doesn't stop the operation.
    case warning = 3
    /// A failure in the current operation.
    case error = 4
    /// A critical failure that requires immediate attention.
    case critical = 5
    /// Logging is disabled.
    case none = 6
}
