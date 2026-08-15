//
//  StoreKitManagerDelegate.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation

/// Receives terminal operation callbacks and persistent transaction updates from a `StoreKitManager`.
///
/// Callbacks are delivered on the executor used by the underlying asynchronous operation.
/// The wrapper doesn't dispatch callbacks to the main thread.
@objc public protocol StoreKitManagerDelegate: AnyObject {
    /// Reports completion of manager initialization.
    func initializationCompleted(errorCode: StoreKitWrapperErrorCode,
                                 errorMessage: String?)

    /// Reports completion of manager shutdown.
    func shutdownCompleted(errorCode: StoreKitWrapperErrorCode,
                           errorMessage: String?)

    /// Reports the products returned by the most recent product request.
    func availableProductsCompleted(withResult: [StoreKitProduct],
                                    errorCode: StoreKitWrapperErrorCode,
                                    errorMessage: String?)

    /// Reports the current entitlement snapshot.
    func currentEntitlementsCompleted(withResult: [StoreKitTransaction],
                                      errorCode: StoreKitWrapperErrorCode,
                                      errorMessage: String?)

    /// Reports completion of an explicit App Store synchronization request.
    func appStoreSyncCompleted(errorCode: StoreKitWrapperErrorCode,
                               errorMessage: String?)

    /// Reports the currently unfinished verified transactions known to StoreKit.
    func unfinishedTransactionsCompleted(withResult: [StoreKitTransaction],
                                         errorCode: StoreKitWrapperErrorCode,
                                         errorMessage: String?)

    /// Reports the outcome of a programmatic purchase request.
    func purchaseCompleted(withResult: StoreKitTransaction?,
                           purchaseResult: StoreKitPurchaseResult,
                           errorCode: StoreKitWrapperErrorCode,
                           errorMessage: String?)

    /// Reports completion of a request to finish a verified transaction.
    func finishTransactionCompleted(transactionIdentifier: UInt64,
                                    errorCode: StoreKitWrapperErrorCode,
                                    errorMessage: String?)

    /// Reports a transaction emitted by the persistent StoreKit transaction listener.
    func transactionUpdated(withResult: StoreKitTransaction,
                            errorCode: StoreKitWrapperErrorCode,
                            errorMessage: String?)
}
