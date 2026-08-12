//
//  StoreKitProductType.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

@objc public enum StoreKitProductType: Int {
    case unknown = -1
    case consumable = 0
    case nonConsumable = 1
    case nonRenewableSubscription = 2
    case autoRenewableSubscription = 3

    // MARK: - Initialization

    init(productType: Product.ProductType) {
        if productType == .consumable {
            self = .consumable
        } else if productType == .nonConsumable {
            self = .nonConsumable
        } else if productType == .nonRenewable {
            self = .nonRenewableSubscription
        } else if productType == .autoRenewable {
            self = .autoRenewableSubscription
        } else {
            self = .unknown
        }
    }
}
