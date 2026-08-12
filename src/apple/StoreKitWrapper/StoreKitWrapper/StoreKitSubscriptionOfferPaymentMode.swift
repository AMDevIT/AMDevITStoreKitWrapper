//
//  StoreKitSubscriptionOfferPaymentMode.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

@objc public enum StoreKitSubscriptionOfferPaymentMode: Int {
    case unknown = -1
    case freeTrial = 0
    case payAsYouGo = 1
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
