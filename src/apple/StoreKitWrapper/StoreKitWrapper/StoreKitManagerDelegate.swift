//
//  StoreKitManagerDelegate.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation

@objc public protocol StoreKitManagerDelegate: AnyObject {
    func initializationCompleted(errorCode: StoreKitWrapperErrorCode,
                                 errorMessage: String?)

    func shutdownCompleted(errorCode: StoreKitWrapperErrorCode,
                           errorMessage: String?)

    func availableProductsCompleted(withResult: [StoreKitProduct],
                                    errorCode: StoreKitWrapperErrorCode,
                                    errorMessage: String?)

    func currentEntitlementsCompleted(withResult: [StoreKitTransaction],
                                      errorCode: StoreKitWrapperErrorCode,
                                      errorMessage: String?)

    func appStoreSyncCompleted(errorCode: StoreKitWrapperErrorCode,
                               errorMessage: String?)

    func unfinishedTransactionsCompleted(withResult: [StoreKitTransaction],
                                         errorCode: StoreKitWrapperErrorCode,
                                         errorMessage: String?)

    func purchaseCompleted(withResult: StoreKitTransaction?,
                           purchaseResult: StoreKitPurchaseResult,
                           errorCode: StoreKitWrapperErrorCode,
                           errorMessage: String?)

    func finishTransactionCompleted(transactionIdentifier: UInt64,
                                    errorCode: StoreKitWrapperErrorCode,
                                    errorMessage: String?)

    func transactionUpdated(withResult: StoreKitTransaction,
                            errorCode: StoreKitWrapperErrorCode,
                            errorMessage: String?)
}
