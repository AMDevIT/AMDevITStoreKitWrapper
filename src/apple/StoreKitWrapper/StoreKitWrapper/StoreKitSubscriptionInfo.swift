//
//  StoreKitSubscriptionInfo.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation
import StoreKit

@objcMembers public final class StoreKitSubscriptionInfo: NSObject {
    // MARK: - Properties

    public let subscriptionGroupIdentifier: String
    public let groupDisplayName: String?
    public let groupLevel: Int?
    public let subscriptionPeriod: StoreKitSubscriptionPeriod
    public let isEligibleForIntroductoryOffer: Bool
    public let introductoryOffer: StoreKitSubscriptionOffer?
    public let promotionalOffers: [StoreKitSubscriptionOffer]
    public let winBackOffers: [StoreKitSubscriptionOffer]

    // MARK: - Initialization

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

        if #available(iOS 18.0, *) {
            winBackOffers = subscriptionInfo.winBackOffers.map {
                StoreKitSubscriptionOffer(subscriptionOffer: $0,
                                          currencyCode: currencyCode,
                                          localeIdentifier: localeIdentifier)
            }
        }
        
        var groupDisplayName: String?
        var groupLevel: Int?
        
        if #available(iOS 16.4, *) {
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
