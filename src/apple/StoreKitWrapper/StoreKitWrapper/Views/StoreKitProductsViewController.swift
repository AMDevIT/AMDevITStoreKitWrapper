//
//  StoreKitProductsViewController.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 14/08/2026.
//

import StoreKit
import SwiftUI
import UIKit

@available(iOS 17.0, *)
@MainActor
@objcMembers public final class StoreKitProductsViewController: UIViewController {
    // MARK: - Properties

    private let hostingContainer: StoreKitViewHostingContainer
    public let productIdentifiers: [String]

    // MARK: - Initialization

    public init(productIdentifiers: [String]) {
        self.productIdentifiers = productIdentifiers
        self.hostingContainer = StoreKitViewHostingContainer(rootView: AnyView(StoreView(ids: productIdentifiers)))
        super.init(nibName: nil,
                   bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("StoreKitProductsViewController doesn't support initialization from a coder.")
    }

    // MARK: - Methods

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.hostingContainer.install(in: self)
    }
}
