//
//  StoreKitSubscriptionOfferType.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

@objc public enum StoreKitSubscriptionOfferType: Int {
    case unknown = -1
    case introductory = 0
    case promotional = 1
    case winBack = 2

    // MARK: - Initialization

    init(subscriptionOfferType: Product.SubscriptionOffer.OfferType) {
        if subscriptionOfferType == .introductory {
            self = .introductory
        } else if subscriptionOfferType == .promotional {
            self = .promotional
        } else if #available(iOS 18.0, *), subscriptionOfferType == .winBack {
            self = .winBack
        } else {
            self = .unknown
        }
    }
}
