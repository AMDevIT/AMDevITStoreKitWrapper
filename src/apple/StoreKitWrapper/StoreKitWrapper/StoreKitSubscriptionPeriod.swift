//
//  StoreKitSubscriptionPeriod.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

public final class StoreKitSubscriptionPeriod: NSObject {
    // MARK: - Properties

    public let value: Int
    public let unit: StoreKitSubscriptionPeriodUnit
    public let unitDisplayName: String

    // MARK: - Initialization

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
