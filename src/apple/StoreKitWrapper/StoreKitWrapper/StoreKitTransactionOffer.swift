//
//  StoreKitTransactionOffer.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation

/// Describes the subscription offer applied to a transaction.
@objcMembers public final class StoreKitTransactionOffer: NSObject {
    // MARK: - Properties

    /// The applied offer identifier, when supplied by StoreKit.
    public let identifier: String?
    /// The normalized kind of applied offer.
    public let offerType: StoreKitTransactionOfferType
    /// The normalized payment mode of the applied offer.
    public let paymentMode: StoreKitTransactionOfferPaymentMode
    /// The applied offer period when available on the running OS.
    public let period: StoreKitSubscriptionPeriod?

    // MARK: - Initialization

    /// Creates an applied transaction-offer snapshot.
    public init(identifier: String?,
                offerType: StoreKitTransactionOfferType,
                paymentMode: StoreKitTransactionOfferPaymentMode,
                period: StoreKitSubscriptionPeriod?) {
        self.identifier = identifier
        self.offerType = offerType
        self.paymentMode = paymentMode
        self.period = period
        super.init()
    }
}
