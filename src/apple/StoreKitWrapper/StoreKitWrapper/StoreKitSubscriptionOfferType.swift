//
//  StoreKitSubscriptionOfferType.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

/// Identifies the kind of subscription offer represented by product metadata.
@objc public enum StoreKitSubscriptionOfferType: Int {
    /// An offer type that isn't recognized by this version of the wrapper.
    case unknown = -1
    /// An offer available to eligible new subscribers.
    case introductory = 0
    /// A promotional offer configured for selected customers.
    case promotional = 1
    /// An offer intended to recover a previous subscriber.
    case winBack = 2

    // MARK: - Initialization

    init(subscriptionOfferType: Product.SubscriptionOffer.OfferType) {
        if subscriptionOfferType == .introductory {
            self = .introductory
        } else if subscriptionOfferType == .promotional {
            self = .promotional
        } else if #available(iOS 18.0, macCatalyst 18.0, *), subscriptionOfferType == .winBack {
            self = .winBack
        } else {
            self = .unknown
        }
    }
}
