//
//  StoreKitTransaction.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation

/// Provides an Objective-C-compatible snapshot of a StoreKit transaction and its verification state.
@objcMembers public final class StoreKitTransaction: NSObject {
    // MARK: - Properties

    /// The unique StoreKit transaction identifier.
    public let identifier: UInt64
    /// The identifier of the original transaction in the purchase chain.
    public let originalIdentifier: UInt64
    /// The App Store web-order line-item identifier, when available.
    public let webOrderLineItemIdentifier: String?
    /// The bundle identifier of the application that owns the transaction.
    public let appBundleIdentifier: String
    /// The purchased product identifier.
    public let productIdentifier: String
    /// The normalized product category.
    public let productType: StoreKitProductType
    /// The subscription-group identifier for subscription transactions.
    public let subscriptionGroupIdentifier: String?
    /// The date of this purchase or renewal.
    public let purchaseDate: Date
    /// The date of the first purchase in the transaction chain.
    public let originalPurchaseDate: Date
    /// The subscription expiration date, when applicable.
    public let expirationDate: Date?
    /// The date StoreKit signed the transaction payload.
    public let signedDate: Date
    /// The transaction price when supplied by the running OS.
    public let price: NSDecimalNumber?
    /// The ISO 4217 currency code associated with `price`.
    public let currencyCode: String?
    /// The number of product units purchased by the transaction.
    public let purchasedQuantity: Int
    /// Indicates whether a subscription upgrade superseded this transaction.
    public let isUpgraded: Bool
    /// Describes whether the customer purchased or family-shared the product.
    public let ownershipType: StoreKitTransactionOwnershipType
    /// The App Store environment that created the transaction.
    public let environment: StoreKitTransactionEnvironment
    /// The storefront identifier active when the transaction was created.
    public let storefrontIdentifier: String?
    /// The storefront country code active when the transaction was created.
    public let storefrontCountryCode: String
    /// The reason StoreKit created the transaction.
    public let reason: StoreKitTransactionReason
    /// The date the App Store revoked the transaction, if applicable.
    public let revocationDate: Date?
    /// The normalized reason for revocation.
    public let revocationReason: StoreKitTransactionRevocationReason
    /// The application account token supplied during purchase as a UUID string.
    public let appAccountToken: String?
    /// The subscription offer applied to the transaction, if any.
    public let offer: StoreKitTransactionOffer?
    /// StoreKit's raw transaction JSON represented as a UTF-8 string.
    public let jsonRepresentation: String
    /// The transaction's JSON Web Signature representation.
    public let jwsRepresentation: String
    /// The device-verification data encoded as Base64.
    public let deviceVerification: String
    /// The device-verification nonce represented as a UUID string.
    public let deviceVerificationNonce: String
    /// Indicates whether StoreKit verified the transaction.
    public let verificationStatus: StoreKitTransactionVerificationStatus
    /// The normalized verification failure code.
    public let verificationErrorCode: StoreKitTransactionVerificationErrorCode
    /// StoreKit's verification error message, or `nil` for verified transactions.
    public let verificationErrorMessage: String?

    // MARK: - Initialization

    /// Creates a transaction snapshot.
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
