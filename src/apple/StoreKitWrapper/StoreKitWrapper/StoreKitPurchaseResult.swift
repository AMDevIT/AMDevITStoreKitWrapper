//
//  StoreKitPurchaseResult.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation

/// Describes the outcome of a programmatic purchase request.
@objc public enum StoreKitPurchaseResult: Int {
    /// StoreKit returned a result unknown to this version of the wrapper.
    case unknown = -1
    /// The purchase completed and produced a transaction.
    case succeeded = 0
    /// The purchase is waiting for an external action, such as approval.
    case pending = 1
    /// The customer cancelled the purchase flow.
    case cancelled = 2
    /// The purchase failed.
    case failed = 3
}
