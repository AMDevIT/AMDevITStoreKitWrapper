//
//  StoreKitTransaction.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation

public final class StoreKitTransaction: NSObject {
    // MARK: - Properties

    public let identifier: UInt64
    public let originalIdentifier: UInt64
    public let webOrderLineItemIdentifier: String?
    public let appBundleIdentifier: String
    public let productIdentifier: String
    public let productType: StoreKitProductType
    public let subscriptionGroupIdentifier: String?
    public let purchaseDate: Date
    public let originalPurchaseDate: Date
    public let expirationDate: Date?
    public let signedDate: Date
    public let price: NSDecimalNumber?
    public let currencyCode: String?
    public let purchasedQuantity: Int
    public let isUpgraded: Bool
    public let ownershipType: StoreKitTransactionOwnershipType
    public let environment: StoreKitTransactionEnvironment
    public let storefrontIdentifier: String?
    public let storefrontCountryCode: String
    public let reason: StoreKitTransactionReason
    public let revocationDate: Date?
    public let revocationReason: StoreKitTransactionRevocationReason
    public let appAccountToken: String?
    public let offer: StoreKitTransactionOffer?
    public let jsonRepresentation: String
    public let jwsRepresentation: String
    public let deviceVerification: String
    public let deviceVerificationNonce: String
    public let verificationStatus: StoreKitTransactionVerificationStatus
    public let verificationErrorCode: StoreKitTransactionVerificationErrorCode
    public let verificationErrorMessage: String?

    // MARK: - Initialization

    public init(identifier: UInt64,
                originalIdentifier: UInt64,
                webOrderLineItemIdentifier: String?,
                appBundleIdentifier: String,
                productIdentifier: String,
                productType: StoreKitProductType,
                subscriptionGroupIdentifier: String?,
                purchaseDate: Date,
                originalPurchaseDate: Date,
                expirationDate: Date?,
                signedDate: Date,
                price: NSDecimalNumber?,
                currencyCode: String?,
                purchasedQuantity: Int,
                isUpgraded: Bool,
                ownershipType: StoreKitTransactionOwnershipType,
                environment: StoreKitTransactionEnvironment,
                storefrontIdentifier: String?,
                storefrontCountryCode: String,
                reason: StoreKitTransactionReason,
                revocationDate: Date?,
                revocationReason: StoreKitTransactionRevocationReason,
                appAccountToken: String?,
                offer: StoreKitTransactionOffer?,
                jsonRepresentation: String,
                jwsRepresentation: String,
                deviceVerification: String,
                deviceVerificationNonce: String,
                verificationStatus: StoreKitTransactionVerificationStatus,
                verificationErrorCode: StoreKitTransactionVerificationErrorCode,
                verificationErrorMessage: String?) {
        self.identifier = identifier
        self.originalIdentifier = originalIdentifier
        self.webOrderLineItemIdentifier = webOrderLineItemIdentifier
        self.appBundleIdentifier = appBundleIdentifier
        self.productIdentifier = productIdentifier
        self.productType = productType
        self.subscriptionGroupIdentifier = subscriptionGroupIdentifier
        self.purchaseDate = purchaseDate
        self.originalPurchaseDate = originalPurchaseDate
        self.expirationDate = expirationDate
        self.signedDate = signedDate
        self.price = price
        self.currencyCode = currencyCode
        self.purchasedQuantity = purchasedQuantity
        self.isUpgraded = isUpgraded
        self.ownershipType = ownershipType
        self.environment = environment
        self.storefrontIdentifier = storefrontIdentifier
        self.storefrontCountryCode = storefrontCountryCode
        self.reason = reason
        self.revocationDate = revocationDate
        self.revocationReason = revocationReason
        self.appAccountToken = appAccountToken
        self.offer = offer
        self.jsonRepresentation = jsonRepresentation
        self.jwsRepresentation = jwsRepresentation
        self.deviceVerification = deviceVerification
        self.deviceVerificationNonce = deviceVerificationNonce
        self.verificationStatus = verificationStatus
        self.verificationErrorCode = verificationErrorCode
        self.verificationErrorMessage = verificationErrorMessage
        super.init()
    }
}
