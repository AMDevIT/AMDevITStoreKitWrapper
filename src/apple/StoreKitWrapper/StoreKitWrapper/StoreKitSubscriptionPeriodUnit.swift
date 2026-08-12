//
//  StoreKitSubscriptionPeriodUnit.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

@objc public enum StoreKitSubscriptionPeriodUnit: Int {
    case unknown = -1
    case day = 0
    case week = 1
    case month = 2
    case year = 3

    // MARK: - Initialization

    init(subscriptionPeriodUnit: Product.SubscriptionPeriod.Unit) {
        switch subscriptionPeriodUnit {
        case .day:
            self = .day
        case .week:
            self = .week
        case .month:
            self = .month
        case .year:
            self = .year
        @unknown default:
            self = .unknown
        }
    }
}
