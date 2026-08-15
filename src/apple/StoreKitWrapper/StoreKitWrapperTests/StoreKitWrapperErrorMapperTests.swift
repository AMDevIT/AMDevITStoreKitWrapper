//
//  StoreKitWrapperErrorMapperTests.swift
//  StoreKitWrapperTests
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit
import Testing
@testable import StoreKitWrapper

struct StoreKitWrapperErrorMapperTests {
    // MARK: - Tests

    @Test func mapsCancellationErrors() {
        let taskCancellation = StoreKitWrapperErrorMapper.map(error: CancellationError(),
                                                              fallbackCode: .purchaseFailed)
        let storeKitCancellation = StoreKitWrapperErrorMapper.map(error: StoreKitError.userCancelled,
                                                                  fallbackCode: .appStoreSyncFailed)
        let urlCancellation = StoreKitWrapperErrorMapper.map(error: URLError(.cancelled),
                                                             fallbackCode: .productsRequestFailed)

        #expect(taskCancellation.code == .operationCancelled)
        #expect(storeKitCancellation.code == .operationCancelled)
        #expect(urlCancellation.code == .operationCancelled)
    }

    @Test func mapsStoreKitErrors() {
        let networkError = StoreKitWrapperErrorMapper.map(error: StoreKitError.networkError(URLError(.notConnectedToInternet)),
                                                          fallbackCode: .productsRequestFailed)
        let systemError = StoreKitWrapperErrorMapper.map(error: StoreKitError.systemError(TestError()),
                                                         fallbackCode: .appStoreSyncFailed)
        let storefrontError = StoreKitWrapperErrorMapper.map(error: StoreKitError.notAvailableInStorefront,
                                                             fallbackCode: .appStoreSyncFailed)
        let entitlementError = StoreKitWrapperErrorMapper.map(error: StoreKitError.notEntitled,
                                                              fallbackCode: .appStoreSyncFailed)
        let unknownError = StoreKitWrapperErrorMapper.map(error: StoreKitError.unknown,
                                                          fallbackCode: .appStoreSyncFailed)

        #expect(networkError.code == .storeKitNetworkError)
        #expect(systemError.code == .storeKitSystemError)
        #expect(systemError.message == "Test error")
        #expect(storefrontError.code == .storeKitNotAvailableInStorefront)
        #expect(entitlementError.code == .storeKitNotEntitled)
        #expect(unknownError.code == .storeKitUnknown)
    }

    @Test func mapsPurchaseErrors() {
        let productUnavailable = StoreKitWrapperErrorMapper.map(error: Product.PurchaseError.productUnavailable,
                                                                fallbackCode: .purchaseFailed)
        let purchaseNotAllowed = StoreKitWrapperErrorMapper.map(error: Product.PurchaseError.purchaseNotAllowed,
                                                                fallbackCode: .purchaseFailed)
        let invalidQuantity = StoreKitWrapperErrorMapper.map(error: Product.PurchaseError.invalidQuantity,
                                                             fallbackCode: .purchaseFailed)
        let invalidOfferIdentifier = StoreKitWrapperErrorMapper.map(error: Product.PurchaseError.invalidOfferIdentifier,
                                                                    fallbackCode: .purchaseFailed)
        let invalidOfferPrice = StoreKitWrapperErrorMapper.map(error: Product.PurchaseError.invalidOfferPrice,
                                                               fallbackCode: .purchaseFailed)
        let invalidOfferSignature = StoreKitWrapperErrorMapper.map(error: Product.PurchaseError.invalidOfferSignature,
                                                                   fallbackCode: .purchaseFailed)
        let missingOfferParameters = StoreKitWrapperErrorMapper.map(error: Product.PurchaseError.missingOfferParameters,
                                                                    fallbackCode: .purchaseFailed)
        let ineligibleForOffer = StoreKitWrapperErrorMapper.map(error: Product.PurchaseError.ineligibleForOffer,
                                                                fallbackCode: .purchaseFailed)

        #expect(productUnavailable.code == .purchaseProductUnavailable)
        #expect(purchaseNotAllowed.code == .purchaseNotAllowed)
        #expect(invalidQuantity.code == .purchaseInvalidQuantity)
        #expect(invalidOfferIdentifier.code == .purchaseInvalidOfferIdentifier)
        #expect(invalidOfferPrice.code == .purchaseInvalidOfferPrice)
        #expect(invalidOfferSignature.code == .purchaseInvalidOfferSignature)
        #expect(missingOfferParameters.code == .purchaseMissingOfferParameters)
        #expect(ineligibleForOffer.code == .purchaseIneligibleForOffer)
    }

    @Test func preservesOperationFallbackForUnrecognizedErrors() {
        let mappedError = StoreKitWrapperErrorMapper.map(error: TestError(),
                                                         fallbackCode: .productsRequestFailed)

        #expect(mappedError.code == .productsRequestFailed)
        #expect(mappedError.message == "Test error")
    }
}

private struct TestError: LocalizedError {
    // MARK: - Properties

    var errorDescription: String? {
        return "Test error"
    }
}
