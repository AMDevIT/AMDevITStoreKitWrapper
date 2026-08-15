//
//  StoreKitProduct.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation
import StoreKit

/// Provides an Objective-C-compatible snapshot of StoreKit product metadata.
@objcMembers public final class StoreKitProduct: NSObject {
    // MARK: - Properties

    /// The App Store Connect product identifier.
    public let identifier: String
    /// The normalized StoreKit product category.
    public let productType: StoreKitProductType
    /// StoreKit's localized description of the product category.
    public let productTypeDisplayName: String
    /// The localized product name configured in App Store Connect.
    public let displayName: String
    /// The localized product description configured in App Store Connect.
    public let displayDescription: String
    /// The localized, currency-formatted product price.
    public let displayPrice: String
    /// The product price as a decimal number.
    public let price: NSDecimalNumber
    /// The ISO 4217 currency code used by the price.
    public let currencyCode: String
    /// The locale identifier used to format the product price.
    public let localeIdentifier: String
    /// Indicates whether the product supports Family Sharing.
    public let isFamilyShareable: Bool
    /// Subscription metadata, or `nil` when the product isn't an auto-renewable subscription.
    public let subscriptionInfo: StoreKitSubscriptionInfo?
    /// StoreKit's raw product JSON represented as a UTF-8 string.
    public let jsonRepresentation: String

    // MARK: - Initialization

    /// Creates a product metadata snapshot.
    public init(identifier: String,
                productType: StoreKitProductType,
                productTypeDisplayName: String,
                displayName: String,
                displayDescription: String,
                displayPrice: String,
                price: NSDecimalNumber,
                currencyCode: String,
                localeIdentifier: String,
                isFamilyShareable: Bool,
                subscriptionInfo: StoreKitSubscriptionInfo?,
                jsonRepresentation: String) {
        self.identifier = identifier
        self.productType = productType
        self.productTypeDisplayName = productTypeDisplayName
        self.displayName = displayName
        self.displayDescription = displayDescription
        self.displayPrice = displayPrice
        self.price = price
        self.currencyCode = currencyCode
        self.localeIdentifier = localeIdentifier
        self.isFamilyShareable = isFamilyShareable
        self.subscriptionInfo = subscriptionInfo
        self.jsonRepresentation = jsonRepresentation
        super.init()
    }

    convenience init(product: Product,
                     subscriptionInfo: StoreKitSubscriptionInfo?) {
        self.init(identifier: product.id,
                  productType: StoreKitProductType(productType: product.type),
                  productTypeDisplayName: product.type.localizedDescription,
                  displayName: product.displayName,
                  displayDescription: product.description,
                  displayPrice: product.displayPrice,
                  price: NSDecimalNumber(decimal: product.price),
                  currencyCode: product.priceFormatStyle.currencyCode,
                  localeIdentifier: product.priceFormatStyle.locale.identifier,
                  isFamilyShareable: product.isFamilyShareable,
                  subscriptionInfo: subscriptionInfo,
                  jsonRepresentation: String(decoding: product.jsonRepresentation, as: UTF8.self))
    }
}
