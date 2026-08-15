//
//  StoreKitProductType.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

/// Identifies the StoreKit category of a product.
@objc public enum StoreKitProductType: Int {
    /// A product type that isn't recognized by this version of the wrapper.
    case unknown = -1
    /// A product that can be purchased, consumed, and purchased again.
    case consumable = 0
    /// A product that is purchased once and doesn't expire.
    case nonConsumable = 1
    /// A subscription that doesn't renew automatically.
    case nonRenewableSubscription = 2
    /// A subscription that renews automatically until it is cancelled.
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
