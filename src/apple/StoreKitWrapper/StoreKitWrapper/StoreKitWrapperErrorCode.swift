//
//  StoreKitWrapperErrorCode.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation

@objc public enum StoreKitWrapperErrorCode: Int {
    case none = 0
    case unknown = 1
    case invalidArgument = 2
    case operationCancelled = 3

    case managerNotInitialized = 10
    case managerShutdown = 11

    case storeKitNetworkError = 20
    case storeKitSystemError = 21
    case storeKitNotAvailableInStorefront = 22
    case storeKitNotEntitled = 23
    case storeKitUnknown = 24

    case productsRequestInProgress = 100
    case productsRequestFailed = 101

    case productNotFound = 200
    case purchaseInProgress = 201
    case purchaseFailed = 202
    case transactionVerificationFailed = 203
    case purchaseProductUnavailable = 204
    case purchaseNotAllowed = 205
    case purchaseInvalidQuantity = 206
    case purchaseInvalidOffer = 207
    case purchaseIneligibleForOffer = 208

    case transactionNotFound = 300
    case transactionFinishInProgress = 301

    case currentEntitlementsRequestInProgress = 400

    case appStoreSyncInProgress = 500
    case appStoreSyncFailed = 501

    case unfinishedTransactionsRequestInProgress = 600
}
