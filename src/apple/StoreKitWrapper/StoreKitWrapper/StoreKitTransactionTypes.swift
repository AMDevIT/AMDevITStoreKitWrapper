//
//  StoreKitTransactionTypes.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation

@objc public enum StoreKitTransactionVerificationStatus: Int {
    case unverified = 0
    case verified = 1
}

@objc public enum StoreKitTransactionVerificationErrorCode: Int {
    case none = 0
    case invalidCertificateChain = 1
    case invalidDeviceVerification = 2
    case invalidEncoding = 3
    case invalidSignature = 4
    case missingRequiredProperties = 5
    case revokedCertificate = 6
    case unknown = 999
}

@objc public enum StoreKitTransactionOwnershipType: Int {
    case unknown = -1
    case purchased = 0
    case familyShared = 1
}

@objc public enum StoreKitTransactionEnvironment: Int {
    case unknown = -1
    case xcode = 0
    case sandbox = 1
    case production = 2
}

@objc public enum StoreKitTransactionReason: Int {
    case unknown = -1
    case purchase = 0
    case renewal = 1
}

@objc public enum StoreKitTransactionRevocationReason: Int {
    case none = -1
    case developerIssue = 0
    case other = 1
    case unknown = 999
}

@objc public enum StoreKitTransactionOfferType: Int {
    case unknown = -1
    case introductory = 0
    case promotional = 1
    case code = 2
    case winBack = 3
}

@objc public enum StoreKitTransactionOfferPaymentMode: Int {
    case unknown = -1
    case freeTrial = 0
    case payAsYouGo = 1
    case payUpFront = 2
    case oneTime = 3
}
