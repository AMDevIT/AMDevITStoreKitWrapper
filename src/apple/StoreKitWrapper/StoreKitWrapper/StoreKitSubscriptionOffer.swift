//
//  StoreKitSubscriptionOffer.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

@objcMembers public final class StoreKitSubscriptionOffer: NSObject {
    // MARK: - Properties

    public let identifier: String?
    public let offerType: StoreKitSubscriptionOfferType
    public let offerTypeDisplayName: String
    public let displayPrice: String
    public let price: NSDecimalNumber
    public let currencyCode: String
    public let localeIdentifier: String
    public let paymentMode: StoreKitSubscriptionOfferPaymentMode
    public let paymentModeDisplayName: String
    public let period: StoreKitSubscriptionPeriod
    public let periodCount: Int

    // MARK: - Initialization

    public init(identifier: String?,
                offerType: StoreKitSubscriptionOfferType,
                offerTypeDisplayName: String,
                displayPrice: String,
                price: NSDecimalNumber,
                currencyCode: String,
                localeIdentifier: String,
                paymentMode: StoreKitSubscriptionOfferPaymentMode,
                paymentModeDisplayName: String,
                period: StoreKitSubscriptionPeriod,
                periodCount: Int) {
        self.identifier = identifier
        self.offerType = offerType
        self.offerTypeDisplayName = offerTypeDisplayName
        self.displayPrice = displayPrice
        self.price = price
        self.currencyCode = currencyCode
        self.localeIdentifier = localeIdentifier
        self.paymentMode = paymentMode
        self.paymentModeDisplayName = paymentModeDisplayName
        self.period = period
        self.periodCount = periodCount
        super.init()
    }

    convenience init(subscriptionOffer: Product.SubscriptionOffer,
                     currencyCode: String,
                     localeIdentifier: String) {
        self.init(identifier: subscriptionOffer.id,
                  offerType: StoreKitSubscriptionOfferType(subscriptionOfferType: subscriptionOffer.type),
                  offerTypeDisplayName: subscriptionOffer.type.localizedDescription,
                  displayPrice: subscriptionOffer.displayPrice,
                  price: NSDecimalNumber(decimal: subscriptionOffer.price),
                  currencyCode: currencyCode,
                  localeIdentifier: localeIdentifier,
                  paymentMode: StoreKitSubscriptionOfferPaymentMode(subscriptionOfferPaymentMode: subscriptionOffer.paymentMode),
                  paymentModeDisplayName: subscriptionOffer.paymentMode.localizedDescription,
                  period: StoreKitSubscriptionPeriod(subscriptionPeriod: subscriptionOffer.period),
                  periodCount: subscriptionOffer.periodCount)
    }
}
