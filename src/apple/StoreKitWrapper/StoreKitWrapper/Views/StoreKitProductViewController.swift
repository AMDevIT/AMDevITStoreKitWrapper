//
//  StoreKitProductViewController.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 14/08/2026.
//

import StoreKit
import SwiftUI
import UIKit

/// Hosts StoreKit's SwiftUI `ProductView` in an Objective-C-compatible view controller.
@available(iOS 17.0, *)
@MainActor
@objcMembers public final class StoreKitProductViewController: UIViewController {
    // MARK: - Properties

    private let hostingContainer: StoreKitViewHostingContainer
    /// The product identifier displayed by the controller.
    public let productIdentifier: String

    // MARK: - Initialization

    /// Creates a controller that displays one StoreKit product.
    /// - Parameter productIdentifier: The App Store Connect product identifier to display.
    public init(productIdentifier: String) {
        self.productIdentifier = productIdentifier
        self.hostingContainer = StoreKitViewHostingContainer(rootView: AnyView(ProductView(id: productIdentifier)))
        super.init(nibName: nil,
                   bundle: nil)
    }

    /// Storyboard and archive initialization aren't supported.
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("StoreKitProductViewController doesn't support initialization from a coder.")
    }

    // MARK: - Methods

    /// Installs the hosted StoreKit product view when the controller loads.
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.hostingContainer.install(in: self)
    }
}
