//
//  StoreKitSubscriptionPeriodUnit.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

/// Identifies the calendar unit used by a subscription period.
@objc public enum StoreKitSubscriptionPeriodUnit: Int {
    /// A period unit that isn't recognized by this version of the wrapper.
    case unknown = -1
    /// A period measured in days.
    case day = 0
    /// A period measured in weeks.
    case week = 1
    /// A period measured in months.
    case month = 2
    /// A period measured in years.
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
