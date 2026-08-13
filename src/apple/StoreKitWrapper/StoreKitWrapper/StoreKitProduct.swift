//
//  StoreKitProduct.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation
import StoreKit

@objcMembers public final class StoreKitProduct: NSObject {
    // MARK: - Properties

    public let identifier: String
    public let productType: StoreKitProductType
    public let productTypeDisplayName: String
    public let displayName: String
    public let displayDescription: String
    public let displayPrice: String
    public let price: NSDecimalNumber
    public let currencyCode: String
    public let localeIdentifier: String
    public let isFamilyShareable: Bool
    public let subscriptionInfo: StoreKitSubscriptionInfo?
    public let jsonRepresentation: String

    // MARK: - Initialization

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
