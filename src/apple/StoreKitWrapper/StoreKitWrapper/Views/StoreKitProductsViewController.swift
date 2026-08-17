//
//  StoreKitProductsViewController.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 14/08/2026.
//

import StoreKit
import SwiftUI
import UIKit

/// Hosts StoreKit's SwiftUI `StoreView` in an Objective-C-compatible view controller.
@available(iOS 17.0, macCatalyst 17.0, *)
@MainActor
@objcMembers public final class StoreKitProductsViewController: UIViewController {
    // MARK: - Properties

    private let hostingContainer: StoreKitViewHostingContainer
    /// The product identifiers displayed by the controller.
    public let productIdentifiers: [String]

    // MARK: - Initialization

    /// Creates a controller that displays a collection of StoreKit products.
    /// - Parameter productIdentifiers: The App Store Connect product identifiers to display.
    public init(productIdentifiers: [String]) {
        self.productIdentifiers = productIdentifiers
        self.hostingContainer = StoreKitViewHostingContainer(rootView: AnyView(StoreView(ids: productIdentifiers)))
        super.init(nibName: nil,
                   bundle: nil)
    }

    /// Storyboard and archive initialization aren't supported.
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("StoreKitProductsViewController doesn't support initialization from a coder.")
    }

    // MARK: - Methods

    /// Installs the hosted StoreKit products view when the controller loads.
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.hostingContainer.install(in: self)
    }
}
