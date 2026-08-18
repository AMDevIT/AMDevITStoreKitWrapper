//
//  StoreKitSubscriptionInfo.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

/// Provides subscription-specific metadata for an auto-renewable product.
@objcMembers public final class StoreKitSubscriptionInfo: NSObject {
    // MARK: - Properties

    /// The App Store Connect subscription-group identifier.
    public let subscriptionGroupIdentifier: String
    /// The localized subscription-group display name when supported by the OS.
    public let groupDisplayName: String?
    /// The service level within the subscription group when supported by the OS.
    public let groupLevel: Int?
    /// The standard renewal period of the subscription.
    public let subscriptionPeriod: StoreKitSubscriptionPeriod
    /// Indicates whether the current customer is eligible for the introductory offer.
    public let isEligibleForIntroductoryOffer: Bool
    /// The introductory offer configured for the product, if any.
    public let introductoryOffer: StoreKitSubscriptionOffer?
    /// Promotional offers configured for the product.
    public let promotionalOffers: [StoreKitSubscriptionOffer]
    /// Win-back offers configured for the product on supported OS versions.
    public let winBackOffers: [StoreKitSubscriptionOffer]

    // MARK: - Initialization

    /// Creates a subscription metadata snapshot.
    public init(subscriptionGroupIdentifier: String,
                groupDisplayName: String?,
                groupLevel: Int?,
                subscriptionPeriod: StoreKitSubscriptionPeriod,
                isEligibleForIntroductoryOffer: Bool,
                introductoryOffer: StoreKitSubscriptionOffer?,
                promotionalOffers: [StoreKitSubscriptionOffer],
                winBackOffers: [StoreKitSubscriptionOffer]) {
        self.subscriptionGroupIdentifier = subscriptionGroupIdentifier
        self.groupDisplayName = groupDisplayName
        self.groupLevel = groupLevel
        self.subscriptionPeriod = subscriptionPeriod
        self.isEligibleForIntroductoryOffer = isEligibleForIntroductoryOffer
        self.introductoryOffer = introductoryOffer
        self.promotionalOffers = promotionalOffers
        self.winBackOffers = winBackOffers
        super.init()
    }

    // MARK: - Methods

    static func create(subscriptionInfo: Product.SubscriptionInfo,
                       currencyCode: String,
                       localeIdentifier: String) async -> StoreKitSubscriptionInfo {
        let isEligibleForIntroductoryOffer = await subscriptionInfo.isEligibleForIntroOffer
        let introductoryOffer = subscriptionInfo.introductoryOffer.map {
            StoreKitSubscriptionOffer(subscriptionOffer: $0,
                                      currencyCode: currencyCode,
                                      localeIdentifier: localeIdentifier)
        }
        let promotionalOffers = subscriptionInfo.promotionalOffers.map {
            StoreKitSubscriptionOffer(subscriptionOffer: $0,
                                      currencyCode: currencyCode,
                                      localeIdentifier: localeIdentifier)
        }
        var winBackOffers = [StoreKitSubscriptionOffer]()

        if #available(iOS 18.0, macCatalyst 18.0, *) {
            winBackOffers = subscriptionInfo.winBackOffers.map {
                StoreKitSubscriptionOffer(subscriptionOffer: $0,
                                          currencyCode: currencyCode,
                                          localeIdentifier: localeIdentifier)
            }
        }
        
        var groupDisplayName: String?
        var groupLevel: Int?
        
        if #available(iOS 16.4, macCatalyst 16.4, *) {
            groupDisplayName = subscriptionInfo.groupDisplayName
            groupLevel = subscriptionInfo.groupLevel
        } else {
            // The Group Display Name and Level are not available
            groupDisplayName = nil
            groupLevel = nil
        }

        return StoreKitSubscriptionInfo(subscriptionGroupIdentifier: subscriptionInfo.subscriptionGroupID,
                                        groupDisplayName: groupDisplayName,
                                        groupLevel: groupLevel,
                                        subscriptionPeriod: StoreKitSubscriptionPeriod(subscriptionPeriod: subscriptionInfo.subscriptionPeriod),
                                        isEligibleForIntroductoryOffer: isEligibleForIntroductoryOffer,
                                        introductoryOffer: introductoryOffer,
                                        promotionalOffers: promotionalOffers,
                                        winBackOffers: winBackOffers)
    }
}
