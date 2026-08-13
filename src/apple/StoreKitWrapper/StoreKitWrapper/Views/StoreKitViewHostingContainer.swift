//
//  StoreKitViewHostingContainer.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 14/08/2026.
//

import SwiftUI
import UIKit

@available(iOS 17.0, *)
@MainActor
final class StoreKitViewHostingContainer {
    // MARK: - Properties

    private let hostingController: UIHostingController<AnyView>

    // MARK: - Initialization

    init(rootView: AnyView) {
        self.hostingController = UIHostingController(rootView: rootView)
    }

    // MARK: - Methods

    func install(in parentViewController: UIViewController) {
        guard self.hostingController.parent !== parentViewController else {
            return
        }

        self.hostingController.loadViewIfNeeded()

        guard let hostedView = self.hostingController.view else {
            return
        }

        parentViewController.addChild(self.hostingController)
        parentViewController.view.addSubview(hostedView)
        hostedView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostedView.leadingAnchor.constraint(equalTo: parentViewController.view.leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: parentViewController.view.trailingAnchor),
            hostedView.topAnchor.constraint(equalTo: parentViewController.view.topAnchor),
            hostedView.bottomAnchor.constraint(equalTo: parentViewController.view.bottomAnchor)
        ])

        self.hostingController.didMove(toParent: parentViewController)
    }
}
