//
//  StoreKitTransactionMapper.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

enum StoreKitTransactionMapper {
    // MARK: - Methods

    static func map(verificationResult: VerificationResult<Transaction>) -> StoreKitTransaction {
        let transaction = verificationResult.unsafePayloadValue
        let verificationStatus: StoreKitTransactionVerificationStatus
        let verificationErrorCode: StoreKitTransactionVerificationErrorCode
        let verificationErrorMessage: String?

        switch verificationResult {
        case .verified:
            verificationStatus = .verified
            verificationErrorCode = .none
            verificationErrorMessage = nil
        case .unverified(_, let verificationError):
            verificationStatus = .unverified
            verificationErrorCode = self.map(verificationError: verificationError)
            verificationErrorMessage = verificationError.localizedDescription
        }

        return StoreKitTransaction(identifier: transaction.id,
                                   originalIdentifier: transaction.originalID,
                                   webOrderLineItemIdentifier: transaction.webOrderLineItemID,
                                   appBundleIdentifier: transaction.appBundleID,
                                   productIdentifier: transaction.productID,
                                   productType: StoreKitProductType(productType: transaction.productType),
                                   subscriptionGroupIdentifier: transaction.subscriptionGroupID,
                                   purchaseDate: transaction.purchaseDate,
                                   originalPurchaseDate: transaction.originalPurchaseDate,
                                   expirationDate: transaction.expirationDate,
                                   signedDate: verificationResult.signedDate,
                                   price: self.map(price: transaction),
                                   currencyCode: self.mapCurrencyCode(transaction: transaction),
                                   purchasedQuantity: transaction.purchasedQuantity,
                                   isUpgraded: transaction.isUpgraded,
                                   ownershipType: self.map(ownershipType: transaction.ownershipType),
                                   environment: self.mapEnvironment(transaction: transaction),
                                   storefrontIdentifier: self.mapStorefrontIdentifier(transaction: transaction),
                                   storefrontCountryCode: self.mapStorefrontCountryCode(transaction: transaction),
                                   reason: self.mapReason(transaction: transaction),
                                   revocationDate: transaction.revocationDate,
                                   revocationReason: self.map(revocationReason: transaction.revocationReason),
                                   appAccountToken: transaction.appAccountToken?.uuidString,
                                   offer: self.mapOffer(transaction: transaction),
                                   jsonRepresentation: String(decoding: transaction.jsonRepresentation, as: UTF8.self),
                                   jwsRepresentation: verificationResult.jwsRepresentation,
                                   deviceVerification: verificationResult.deviceVerification.base64EncodedString(),
                                   deviceVerificationNonce: verificationResult.deviceVerificationNonce.uuidString,
                                   verificationStatus: verificationStatus,
                                   verificationErrorCode: verificationErrorCode,
                                   verificationErrorMessage: verificationErrorMessage)
    }

    private static func map(verificationError: VerificationResult<Transaction>.VerificationError) -> StoreKitTransactionVerificationErrorCode {
        switch verificationError {
        case .invalidCertificateChain:
            return .invalidCertificateChain
        case .invalidDeviceVerification:
            return .invalidDeviceVerification
        case .invalidEncoding:
            return .invalidEncoding
        case .invalidSignature:
            return .invalidSignature
        case .missingRequiredProperties:
            return .missingRequiredProperties
        case .revokedCertificate:
            return .revokedCertificate
        @unknown default:
            return .unknown
        }
    }

    private static func map(price transaction: Transaction) -> NSDecimalNumber? {
        guard let price = transaction.price else {
            return nil
        }

        return NSDecimalNumber(decimal: price)
    }

    private static func mapCurrencyCode(transaction: Transaction) -> String? {
        if #available(iOS 16.0, *) {
            return transaction.currency?.identifier
        }

        return transaction.currencyCode
    }

    private static func map(ownershipType: Transaction.OwnershipType) -> StoreKitTransactionOwnershipType {
        if ownershipType == .purchased {
            return .purchased
        }

        if ownershipType == .familyShared {
            return .familyShared
        }

        return .unknown
    }

    private static func mapEnvironment(transaction: Transaction) -> StoreKitTransactionEnvironment {
        if #available(iOS 16.0, *) {
            if transaction.environment == .xcode {
                return .xcode
            }

            if transaction.environment == .sandbox {
                return .sandbox
            }

            if transaction.environment == .production {
                return .production
            }
        }

        return self.mapEnvironment(value: transaction.environmentStringRepresentation)
    }

    private static func mapEnvironment(value: String) -> StoreKitTransactionEnvironment {
        switch self.normalize(value: value) {
        case "xcode":
            return .xcode
        case "sandbox":
            return .sandbox
        case "production":
            return .production
        default:
            return .unknown
        }
    }

    private static func mapStorefrontIdentifier(transaction: Transaction) -> String? {
        if #available(iOS 17.0, *) {
            return transaction.storefront.id
        }

        return nil
    }

    private static func mapStorefrontCountryCode(transaction: Transaction) -> String {
        if #available(iOS 17.0, *) {
            return transaction.storefront.countryCode
        }

        return transaction.storefrontCountryCode
    }

    private static func mapReason(transaction: Transaction) -> StoreKitTransactionReason {
        if #available(iOS 17.0, *) {
            if transaction.reason == .purchase {
                return .purchase
            }

            if transaction.reason == .renewal {
                return .renewal
            }
        }

        switch self.normalize(value: transaction.reasonStringRepresentation) {
        case "purchase":
            return .purchase
        case "renewal":
            return .renewal
        default:
            return .unknown
        }
    }

    private static func map(revocationReason: Transaction.RevocationReason?) -> StoreKitTransactionRevocationReason {
        guard let revocationReason = revocationReason else {
            return .none
        }

        if revocationReason == .developerIssue {
            return .developerIssue
        }

        if revocationReason == .other {
            return .other
        }

        return .unknown
    }

    private static func mapOffer(transaction: Transaction) -> StoreKitTransactionOffer? {
        if #available(iOS 17.2, *) {
            guard let offer = transaction.offer else {
                return nil
            }

            let period: StoreKitSubscriptionPeriod?
            if #available(iOS 18.4, *) {
                period = offer.period.map { StoreKitSubscriptionPeriod(subscriptionPeriod: $0) }
            } else {
                period = nil
            }

            return StoreKitTransactionOffer(identifier: offer.id,
                                            offerType: self.map(offerType: offer.type),
                                            paymentMode: self.map(paymentMode: offer.paymentMode),
                                            period: period)
        }

        guard transaction.offerID != nil || transaction.offerType != nil else {
            return nil
        }

        return StoreKitTransactionOffer(identifier: transaction.offerID,
                                        offerType: self.map(offerType: transaction.offerType),
                                        paymentMode: self.map(paymentMode: transaction.offerPaymentModeStringRepresentation),
                                        period: nil)
    }

    private static func map(offerType: Transaction.OfferType?) -> StoreKitTransactionOfferType {
        guard let offerType = offerType else {
            return .unknown
        }

        switch offerType.rawValue {
        case 1:
            return .introductory
        case 2:
            return .promotional
        case 3:
            return .code
        case 4:
            return .winBack
        default:
            return .unknown
        }
    }

    @available(iOS 17.2, *)
    private static func map(paymentMode: Transaction.Offer.PaymentMode?) -> StoreKitTransactionOfferPaymentMode {
        guard let paymentMode = paymentMode else {
            return .unknown
        }

        return self.map(paymentMode: paymentMode.rawValue)
    }

    private static func map(paymentMode: String?) -> StoreKitTransactionOfferPaymentMode {
        guard let paymentMode = paymentMode else {
            return .unknown
        }

        switch self.normalize(value: paymentMode) {
        case "freetrial":
            return .freeTrial
        case "payasyougo":
            return .payAsYouGo
        case "payupfront":
            return .payUpFront
        case "onetime":
            return .oneTime
        default:
            return .unknown
        }
    }

    private static func normalize(value: String) -> String {
        return value.lowercased()
            .replacingOccurrences(of: "_", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
}
