//
//  StoreKitSubscriptionsViewController.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 14/08/2026.
//

import StoreKit
import SwiftUI
import UIKit

@available(iOS 17.0, *)
@MainActor
@objcMembers public final class StoreKitSubscriptionsViewController: UIViewController {
    // MARK: - Properties

    private let hostingContainer: StoreKitViewHostingContainer
    public let subscriptionGroupIdentifier: String

    // MARK: - Initialization

    public init(subscriptionGroupIdentifier: String) {
        self.subscriptionGroupIdentifier = subscriptionGroupIdentifier
        self.hostingContainer = StoreKitViewHostingContainer(rootView: AnyView(SubscriptionStoreView(groupID: subscriptionGroupIdentifier)))
        super.init(nibName: nil,
                   bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("StoreKitSubscriptionsViewController doesn't support initialization from a coder.")
    }

    // MARK: - Methods

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.hostingContainer.install(in: self)
    }
}
