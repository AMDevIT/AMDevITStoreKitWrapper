//
//  StoreKitTransactionOffer.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation

@objcMembers public final class StoreKitTransactionOffer: NSObject {
    // MARK: - Properties

    public let identifier: String?
    public let offerType: StoreKitTransactionOfferType
    public let paymentMode: StoreKitTransactionOfferPaymentMode
    public let period: StoreKitSubscriptionPeriod?

    // MARK: - Initialization

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
