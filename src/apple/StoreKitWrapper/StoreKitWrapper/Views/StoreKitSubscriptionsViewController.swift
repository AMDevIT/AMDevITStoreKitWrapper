//
//  StoreKitSubscriptionsViewController.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 14/08/2026.
//

import StoreKit
import SwiftUI
import UIKit

/// Hosts StoreKit's SwiftUI `SubscriptionStoreView` in an Objective-C-compatible view controller.
@available(iOS 17.0, *)
@MainActor
@objcMembers public final class StoreKitSubscriptionsViewController: UIViewController {
    // MARK: - Properties

    private let hostingContainer: StoreKitViewHostingContainer
    /// The subscription-group identifier displayed by the controller.
    public let subscriptionGroupIdentifier: String

    // MARK: - Initialization

    /// Creates a controller that displays an auto-renewable subscription group.
    /// - Parameter subscriptionGroupIdentifier: The App Store Connect subscription-group identifier.
    public init(subscriptionGroupIdentifier: String) {
        self.subscriptionGroupIdentifier = subscriptionGroupIdentifier
        self.hostingContainer = StoreKitViewHostingContainer(rootView: AnyView(SubscriptionStoreView(groupID: subscriptionGroupIdentifier)))
        super.init(nibName: nil,
                   bundle: nil)
    }

    /// Storyboard and archive initialization aren't supported.
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("StoreKitSubscriptionsViewController doesn't support initialization from a coder.")
    }

    // MARK: - Methods

    /// Installs the hosted StoreKit subscriptions view when the controller loads.
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.hostingContainer.install(in: self)
    }
}
