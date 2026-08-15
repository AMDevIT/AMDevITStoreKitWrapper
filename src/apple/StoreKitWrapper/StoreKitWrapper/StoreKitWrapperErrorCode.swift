//
//  StoreKitWrapperErrorCode.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation

/// Stable error codes returned across the Objective-C-compatible wrapper boundary.
@objc public enum StoreKitWrapperErrorCode: Int {
    /// The operation completed successfully.
    case none = 0
    /// An unknown failure occurred.
    case unknown = 1
    /// One or more arguments are invalid.
    case invalidArgument = 2
    /// The operation was cancelled.
    case operationCancelled = 3

    /// The manager hasn't been initialized.
    case managerNotInitialized = 10
    /// The manager has already shut down or is shutting down.
    case managerShutdown = 11

    /// StoreKit failed because of a network error.
    case storeKitNetworkError = 20
    /// StoreKit reported an underlying system error.
    case storeKitSystemError = 21
    /// The requested item isn't available in the current storefront.
    case storeKitNotAvailableInStorefront = 22
    /// The customer isn't entitled to perform the requested operation.
    case storeKitNotEntitled = 23
    /// StoreKit reported an unknown error.
    case storeKitUnknown = 24
    /// The requested StoreKit operation isn't supported.
    case storeKitUnsupported = 25

    /// Another product request is already active.
    case productsRequestInProgress = 100
    /// The product request failed.
    case productsRequestFailed = 101

    /// The requested product wasn't found in the current product catalog.
    case productNotFound = 200
    /// Another purchase is already active.
    case purchaseInProgress = 201
    /// The purchase failed for a reason without a more specific code.
    case purchaseFailed = 202
    /// StoreKit couldn't verify the returned transaction.
    case transactionVerificationFailed = 203
    /// The product isn't available for purchase.
    case purchaseProductUnavailable = 204
    /// Purchases aren't allowed for the current customer or device.
    case purchaseNotAllowed = 205
    /// The requested purchase quantity is invalid.
    case purchaseInvalidQuantity = 206
    /// The promotional offer identifier is invalid.
    case purchaseInvalidOfferIdentifier = 207
    /// The promotional offer price is invalid.
    case purchaseInvalidOfferPrice = 208
    /// The promotional offer signature is invalid.
    case purchaseInvalidOfferSignature = 209
    /// Required promotional offer parameters are missing.
    case purchaseMissingOfferParameters = 210
    /// The customer isn't eligible for the requested offer.
    case purchaseIneligibleForOffer = 211
    /// The storefront requires payment-method binding configuration.
    case purchasePaymentMethodBindingConfigurationRequired = 212

    /// No finishable verified transaction matches the requested identifier.
    case transactionNotFound = 300
    /// The transaction is already being finished.
    case transactionFinishInProgress = 301

    /// Another current-entitlements request is already active.
    case currentEntitlementsRequestInProgress = 400

    /// Another App Store synchronization request is already active.
    case appStoreSyncInProgress = 500
    /// App Store synchronization failed.
    case appStoreSyncFailed = 501

    /// Another unfinished-transactions request is already active.
    case unfinishedTransactionsRequestInProgress = 600
}
