//
//  StoreKitWrapperPublicContractTests.swift
//  StoreKitWrapperTests
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import Testing
@testable import StoreKitWrapper

struct StoreKitWrapperPublicContractTests {
    // MARK: - Tests

    @Test func errorCodeRawValuesRemainStable() {
        let expectedValues: [(StoreKitWrapperErrorCode, Int)] = [
            (.none, 0),
            (.unknown, 1),
            (.invalidArgument, 2),
            (.operationCancelled, 3),
            (.managerNotInitialized, 10),
            (.managerShutdown, 11),
            (.storeKitNetworkError, 20),
            (.storeKitSystemError, 21),
            (.storeKitNotAvailableInStorefront, 22),
            (.storeKitNotEntitled, 23),
            (.storeKitUnknown, 24),
            (.productsRequestInProgress, 100),
            (.productsRequestFailed, 101),
            (.productNotFound, 200),
            (.purchaseInProgress, 201),
            (.purchaseFailed, 202),
            (.transactionVerificationFailed, 203),
            (.purchaseProductUnavailable, 204),
            (.purchaseNotAllowed, 205),
            (.purchaseInvalidQuantity, 206),
            (.purchaseInvalidOffer, 207),
            (.purchaseIneligibleForOffer, 208),
            (.transactionNotFound, 300),
            (.transactionFinishInProgress, 301),
            (.currentEntitlementsRequestInProgress, 400),
            (.appStoreSyncInProgress, 500),
            (.appStoreSyncFailed, 501),
            (.unfinishedTransactionsRequestInProgress, 600)
        ]

        for (errorCode, expectedRawValue) in expectedValues {
            #expect(errorCode.rawValue == expectedRawValue)
        }
    }

    @Test func resultAndLogLevelRawValuesRemainStable() {
        let expectedValues: [(Int, Int)] = [
            (StoreKitPurchaseResult.unknown.rawValue, -1),
            (StoreKitPurchaseResult.succeeded.rawValue, 0),
            (StoreKitPurchaseResult.pending.rawValue, 1),
            (StoreKitPurchaseResult.cancelled.rawValue, 2),
            (StoreKitPurchaseResult.failed.rawValue, 3),
            (StoreKitWrapperLogLevel.trace.rawValue, 0),
            (StoreKitWrapperLogLevel.debug.rawValue, 1),
            (StoreKitWrapperLogLevel.information.rawValue, 2),
            (StoreKitWrapperLogLevel.warning.rawValue, 3),
            (StoreKitWrapperLogLevel.error.rawValue, 4),
            (StoreKitWrapperLogLevel.critical.rawValue, 5),
            (StoreKitWrapperLogLevel.none.rawValue, 6)
        ]

        for (rawValue, expectedRawValue) in expectedValues {
            #expect(rawValue == expectedRawValue)
        }
    }

    @Test func metadataEnumRawValuesRemainStable() {
        let expectedValues: [(Int, Int)] = [
            (StoreKitProductType.unknown.rawValue, -1),
            (StoreKitProductType.consumable.rawValue, 0),
            (StoreKitProductType.nonConsumable.rawValue, 1),
            (StoreKitProductType.nonRenewableSubscription.rawValue, 2),
            (StoreKitProductType.autoRenewableSubscription.rawValue, 3),
            (StoreKitSubscriptionPeriodUnit.unknown.rawValue, -1),
            (StoreKitSubscriptionPeriodUnit.day.rawValue, 0),
            (StoreKitSubscriptionPeriodUnit.week.rawValue, 1),
            (StoreKitSubscriptionPeriodUnit.month.rawValue, 2),
            (StoreKitSubscriptionPeriodUnit.year.rawValue, 3),
            (StoreKitSubscriptionOfferType.unknown.rawValue, -1),
            (StoreKitSubscriptionOfferType.introductory.rawValue, 0),
            (StoreKitSubscriptionOfferType.promotional.rawValue, 1),
            (StoreKitSubscriptionOfferType.winBack.rawValue, 2),
            (StoreKitSubscriptionOfferPaymentMode.unknown.rawValue, -1),
            (StoreKitSubscriptionOfferPaymentMode.freeTrial.rawValue, 0),
            (StoreKitSubscriptionOfferPaymentMode.payAsYouGo.rawValue, 1),
            (StoreKitSubscriptionOfferPaymentMode.payUpFront.rawValue, 2),
            (StoreKitTransactionVerificationStatus.unverified.rawValue, 0),
            (StoreKitTransactionVerificationStatus.verified.rawValue, 1),
            (StoreKitTransactionVerificationErrorCode.none.rawValue, 0),
            (StoreKitTransactionVerificationErrorCode.invalidCertificateChain.rawValue, 1),
            (StoreKitTransactionVerificationErrorCode.invalidDeviceVerification.rawValue, 2),
            (StoreKitTransactionVerificationErrorCode.invalidEncoding.rawValue, 3),
            (StoreKitTransactionVerificationErrorCode.invalidSignature.rawValue, 4),
            (StoreKitTransactionVerificationErrorCode.missingRequiredProperties.rawValue, 5),
            (StoreKitTransactionVerificationErrorCode.revokedCertificate.rawValue, 6),
            (StoreKitTransactionVerificationErrorCode.unknown.rawValue, 999),
            (StoreKitTransactionOwnershipType.unknown.rawValue, -1),
            (StoreKitTransactionOwnershipType.purchased.rawValue, 0),
            (StoreKitTransactionOwnershipType.familyShared.rawValue, 1),
            (StoreKitTransactionEnvironment.unknown.rawValue, -1),
            (StoreKitTransactionEnvironment.xcode.rawValue, 0),
            (StoreKitTransactionEnvironment.sandbox.rawValue, 1),
            (StoreKitTransactionEnvironment.production.rawValue, 2),
            (StoreKitTransactionReason.unknown.rawValue, -1),
            (StoreKitTransactionReason.purchase.rawValue, 0),
            (StoreKitTransactionReason.renewal.rawValue, 1),
            (StoreKitTransactionRevocationReason.none.rawValue, -1),
            (StoreKitTransactionRevocationReason.developerIssue.rawValue, 0),
            (StoreKitTransactionRevocationReason.other.rawValue, 1),
            (StoreKitTransactionRevocationReason.unknown.rawValue, 999),
            (StoreKitTransactionOfferType.unknown.rawValue, -1),
            (StoreKitTransactionOfferType.introductory.rawValue, 0),
            (StoreKitTransactionOfferType.promotional.rawValue, 1),
            (StoreKitTransactionOfferType.code.rawValue, 2),
            (StoreKitTransactionOfferType.winBack.rawValue, 3),
            (StoreKitTransactionOfferPaymentMode.unknown.rawValue, -1),
            (StoreKitTransactionOfferPaymentMode.freeTrial.rawValue, 0),
            (StoreKitTransactionOfferPaymentMode.payAsYouGo.rawValue, 1),
            (StoreKitTransactionOfferPaymentMode.payUpFront.rawValue, 2),
            (StoreKitTransactionOfferPaymentMode.oneTime.rawValue, 3)
        ]

        for (rawValue, expectedRawValue) in expectedValues {
            #expect(rawValue == expectedRawValue)
        }
    }

    @Test func productDtoPreservesBindingValues() {
        let period = StoreKitSubscriptionPeriod(value: 1,
                                                unit: .month,
                                                unitDisplayName: "Month")
        let offer = StoreKitSubscriptionOffer(identifier: "intro",
                                              offerType: .introductory,
                                              offerTypeDisplayName: "Introductory",
                                              displayPrice: "€0.99",
                                              price: NSDecimalNumber(string: "0.99"),
                                              currencyCode: "EUR",
                                              localeIdentifier: "it_IT",
                                              paymentMode: .payAsYouGo,
                                              paymentModeDisplayName: "Pay as you go",
                                              period: period,
                                              periodCount: 3)
        let subscriptionInfo = StoreKitSubscriptionInfo(subscriptionGroupIdentifier: "premium",
                                                        groupDisplayName: "Premium",
                                                        groupLevel: 1,
                                                        subscriptionPeriod: period,
                                                        isEligibleForIntroductoryOffer: true,
                                                        introductoryOffer: offer,
                                                        promotionalOffers: [],
                                                        winBackOffers: [])
        let product = StoreKitProduct(identifier: "premium.monthly",
                                      productType: .autoRenewableSubscription,
                                      productTypeDisplayName: "Subscription",
                                      displayName: "Premium Monthly",
                                      displayDescription: "Unlocks premium features",
                                      displayPrice: "€4.99",
                                      price: NSDecimalNumber(string: "4.99"),
                                      currencyCode: "EUR",
                                      localeIdentifier: "it_IT",
                                      isFamilyShareable: true,
                                      subscriptionInfo: subscriptionInfo,
                                      jsonRepresentation: "{}")

        #expect(product.identifier == "premium.monthly")
        #expect(product.price == NSDecimalNumber(string: "4.99"))
        #expect(product.subscriptionInfo?.introductoryOffer?.periodCount == 3)
        #expect(product.jsonRepresentation == "{}")
    }

    @Test func transactionDtoPreservesBindingValues() {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let offer = StoreKitTransactionOffer(identifier: "offer",
                                             offerType: .promotional,
                                             paymentMode: .payUpFront,
                                             period: nil)
        let transaction = StoreKitTransaction(identifier: 10,
                                              originalIdentifier: 9,
                                              webOrderLineItemIdentifier: "8",
                                              appBundleIdentifier: "it.amdev.app",
                                              productIdentifier: "premium",
                                              productType: .nonConsumable,
                                              subscriptionGroupIdentifier: nil,
                                              purchaseDate: date,
                                              originalPurchaseDate: date,
                                              expirationDate: nil,
                                              signedDate: date,
                                              price: NSDecimalNumber(string: "9.99"),
                                              currencyCode: "EUR",
                                              purchasedQuantity: 1,
                                              isUpgraded: false,
                                              ownershipType: .purchased,
                                              environment: .sandbox,
                                              storefrontIdentifier: "143450",
                                              storefrontCountryCode: "IT",
                                              reason: .purchase,
                                              revocationDate: nil,
                                              revocationReason: .none,
                                              appAccountToken: nil,
                                              offer: offer,
                                              jsonRepresentation: "{}",
                                              jwsRepresentation: "header.payload.signature",
                                              deviceVerification: "verification",
                                              deviceVerificationNonce: "nonce",
                                              verificationStatus: .verified,
                                              verificationErrorCode: .none,
                                              verificationErrorMessage: nil)

        #expect(transaction.identifier == 10)
        #expect(transaction.productIdentifier == "premium")
        #expect(transaction.price == NSDecimalNumber(string: "9.99"))
        #expect(transaction.offer?.identifier == "offer")
        #expect(transaction.verificationStatus == .verified)
    }
}
