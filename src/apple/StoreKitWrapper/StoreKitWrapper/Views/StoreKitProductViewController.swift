//
//  StoreKitProductViewController.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 14/08/2026.
//

import StoreKit
import SwiftUI
import UIKit

@available(iOS 17.0, *)
@MainActor
@objcMembers public final class StoreKitProductViewController: UIViewController {
    // MARK: - Properties

    private let hostingContainer: StoreKitViewHostingContainer
    public let productIdentifier: String

    // MARK: - Initialization

    public init(productIdentifier: String) {
        self.productIdentifier = productIdentifier
        self.hostingContainer = StoreKitViewHostingContainer(rootView: AnyView(ProductView(id: productIdentifier)))
        super.init(nibName: nil,
                   bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("StoreKitProductViewController doesn't support initialization from a coder.")
    }

    // MARK: - Methods

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.hostingContainer.install(in: self)
    }
}
