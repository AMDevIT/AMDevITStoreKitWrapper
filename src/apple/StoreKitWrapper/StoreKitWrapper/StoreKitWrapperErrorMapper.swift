//
//  StoreKitWrapperErrorMapper.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

/// Carries a stable wrapper error code and its diagnostic message.
internal struct StoreKitWrapperMappedError {
    // MARK: - Properties

    internal let code: StoreKitWrapperErrorCode
    internal let message: String
}

/// Maps StoreKit, purchase, network, and cancellation errors to stable wrapper error codes.
internal enum StoreKitWrapperErrorMapper {
    // MARK: - Constants

    private static let cancellationMessage = "The operation was cancelled."

    // MARK: - Methods

    internal static func map(error: Error,
                             fallbackCode: StoreKitWrapperErrorCode) -> StoreKitWrapperMappedError {
        if error is CancellationError {
            return StoreKitWrapperMappedError(code: .operationCancelled,
                                              message: Self.cancellationMessage)
        }

        if let storeKitError = error as? StoreKitError {
            return Self.map(storeKitError: storeKitError)
        }

        if let purchaseError = error as? Product.PurchaseError {
            return Self.map(purchaseError: purchaseError)
        }

        if let urlError = error as? URLError {
            return Self.map(urlError: urlError)
        }

        return StoreKitWrapperMappedError(code: fallbackCode,
                                          message: error.localizedDescription)
    }

    private static func map(storeKitError: StoreKitError) -> StoreKitWrapperMappedError {
        switch storeKitError {
        case .networkError(let urlError):
            return Self.map(urlError: urlError)
        case .systemError(let underlyingError):
            if underlyingError is CancellationError {
                return StoreKitWrapperMappedError(code: .operationCancelled,
                                                  message: Self.cancellationMessage)
            }

            if let urlError = underlyingError as? URLError {
                return Self.map(urlError: urlError)
            }

            return StoreKitWrapperMappedError(code: .storeKitSystemError,
                                              message: underlyingError.localizedDescription)
        case .userCancelled:
            return StoreKitWrapperMappedError(code: .operationCancelled,
                                              message: Self.cancellationMessage)
        case .notAvailableInStorefront:
            return StoreKitWrapperMappedError(code: .storeKitNotAvailableInStorefront,
                                              message: storeKitError.localizedDescription)
        case .notEntitled:
            return StoreKitWrapperMappedError(code: .storeKitNotEntitled,
                                              message: storeKitError.localizedDescription)
        case .unknown:
            return StoreKitWrapperMappedError(code: .storeKitUnknown,
                                              message: storeKitError.localizedDescription)
        case .unsupported:
            return StoreKitWrapperMappedError(code: .storeKitUnsupported,
                                              message: storeKitError.localizedDescription)
        @unknown default:
            return StoreKitWrapperMappedError(code: .storeKitUnknown,
                                              message: storeKitError.localizedDescription)
        }
    }

    private static func map(purchaseError: Product.PurchaseError) -> StoreKitWrapperMappedError {
        let code: StoreKitWrapperErrorCode

        switch purchaseError {
        case .productUnavailable:
            code = .purchaseProductUnavailable
        case .purchaseNotAllowed:
            code = .purchaseNotAllowed
        case .invalidQuantity:
            code = .purchaseInvalidQuantity
        case .invalidOfferIdentifier:
            code = .purchaseInvalidOfferIdentifier
        case .invalidOfferPrice:
            code = .purchaseInvalidOfferPrice
        case .invalidOfferSignature:
            code = .purchaseInvalidOfferSignature
        case .missingOfferParameters:
            code = .purchaseMissingOfferParameters
        case .ineligibleForOffer:
            code = .purchaseIneligibleForOffer
        case .paymentMethodBindingConfigurationRequired:
            code = .purchasePaymentMethodBindingConfigurationRequired
        @unknown default:
            code = .purchaseFailed
        }

        return StoreKitWrapperMappedError(code: code,
                                          message: purchaseError.localizedDescription)
    }

    private static func map(urlError: URLError) -> StoreKitWrapperMappedError {
        if urlError.code == .cancelled || urlError.errorCode == NSURLErrorUserCancelledAuthentication {
            return StoreKitWrapperMappedError(code: .operationCancelled,
                                              message: Self.cancellationMessage)
        }

        return StoreKitWrapperMappedError(code: .storeKitNetworkError,
                                          message: urlError.localizedDescription)
    }
}
