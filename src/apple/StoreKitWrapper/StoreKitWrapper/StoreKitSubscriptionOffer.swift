//
//  StoreKitSubscriptionOffer.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

/// Provides pricing and duration metadata for a subscription offer.
@objcMembers public final class StoreKitSubscriptionOffer: NSObject {
    // MARK: - Properties

    /// The offer identifier, or `nil` when StoreKit doesn't assign one.
    public let identifier: String?
    /// The normalized kind of offer.
    public let offerType: StoreKitSubscriptionOfferType
    /// StoreKit's localized description of the offer kind.
    public let offerTypeDisplayName: String
    /// The localized, currency-formatted offer price.
    public let displayPrice: String
    /// The offer price as a decimal number.
    public let price: NSDecimalNumber
    /// The ISO 4217 currency code used by the offer price.
    public let currencyCode: String
    /// The locale identifier used to format the offer price.
    public let localeIdentifier: String
    /// The normalized offer payment mode.
    public let paymentMode: StoreKitSubscriptionOfferPaymentMode
    /// StoreKit's localized description of the payment mode.
    public let paymentModeDisplayName: String
    /// The duration of one offer period.
    public let period: StoreKitSubscriptionPeriod
    /// The number of periods included in the offer.
    public let periodCount: Int

    // MARK: - Initialization

    /// Creates a subscription-offer metadata snapshot.
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
