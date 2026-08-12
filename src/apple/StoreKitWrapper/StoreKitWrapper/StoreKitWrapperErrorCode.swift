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

    case productsRequestInProgress = 100
    case productsRequestFailed = 101

    case productNotFound = 200
    case purchaseInProgress = 201
    case purchaseFailed = 202
    case transactionVerificationFailed = 203

    case transactionNotFound = 300
    case transactionFinishInProgress = 301
}
