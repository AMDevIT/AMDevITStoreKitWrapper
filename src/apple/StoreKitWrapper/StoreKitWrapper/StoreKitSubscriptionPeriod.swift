//
//  StoreKitSubscriptionPeriod.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

/// Represents a subscription duration using a numeric value and calendar unit.
@objcMembers public final class StoreKitSubscriptionPeriod: NSObject {
    // MARK: - Properties

    /// The number of calendar units in the period.
    public let value: Int
    /// The normalized calendar unit.
    public let unit: StoreKitSubscriptionPeriodUnit
    /// StoreKit's localized description of the calendar unit.
    public let unitDisplayName: String

    // MARK: - Initialization

    /// Creates a subscription period.
    public init(value: Int,
                unit: StoreKitSubscriptionPeriodUnit,
                unitDisplayName: String) {
        self.value = value
        self.unit = unit
        self.unitDisplayName = unitDisplayName
        super.init()
    }

    convenience init(subscriptionPeriod: Product.SubscriptionPeriod) {
        self.init(value: subscriptionPeriod.value,
                  unit: StoreKitSubscriptionPeriodUnit(subscriptionPeriodUnit: subscriptionPeriod.unit),
                  unitDisplayName: subscriptionPeriod.unit.localizedDescription)
    }
}
