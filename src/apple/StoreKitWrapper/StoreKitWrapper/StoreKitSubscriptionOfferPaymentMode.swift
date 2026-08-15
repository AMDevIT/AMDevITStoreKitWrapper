//
//  StoreKitSubscriptionOfferPaymentMode.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

/// Describes how an introductory, promotional, or win-back offer is charged.
@objc public enum StoreKitSubscriptionOfferPaymentMode: Int {
    /// A payment mode that isn't recognized by this version of the wrapper.
    case unknown = -1
    /// The customer pays nothing during the offer period.
    case freeTrial = 0
    /// The customer pays in multiple installments during the offer period.
    case payAsYouGo = 1
    /// The customer pays once for the complete offer period.
    case payUpFront = 2

    // MARK: - Initialization

    init(subscriptionOfferPaymentMode: Product.SubscriptionOffer.PaymentMode) {
        if subscriptionOfferPaymentMode == .freeTrial {
            self = .freeTrial
        } else if subscriptionOfferPaymentMode == .payAsYouGo {
            self = .payAsYouGo
        } else if subscriptionOfferPaymentMode == .payUpFront {
            self = .payUpFront
        } else {
            self = .unknown
        }
    }
}
