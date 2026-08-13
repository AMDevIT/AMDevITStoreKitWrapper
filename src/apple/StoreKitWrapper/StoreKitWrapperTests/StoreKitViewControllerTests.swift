//
//  StoreKitViewControllerTests.swift
//  StoreKitWrapperTests
//
//  Created by Alessandro Morvillo on 14/08/2026.
//

import Testing
import UIKit
@testable import StoreKitWrapper

@available(iOS 17.0, *)
@MainActor
struct StoreKitViewControllerTests {
    // MARK: - Tests

    @Test func productControllerPreservesIdentifierAndInstallsHostedView() {
        let controller = StoreKitProductViewController(productIdentifier: "premium")

        controller.loadViewIfNeeded()

        #expect(controller.productIdentifier == "premium")
        self.expectSingleHostedChild(in: controller)
    }

    @Test func productsControllerPreservesIdentifiersAndInstallsHostedView() {
        let identifiers = ["premium", "credits"]
        let controller = StoreKitProductsViewController(productIdentifiers: identifiers)

        controller.loadViewIfNeeded()

        #expect(controller.productIdentifiers == identifiers)
        self.expectSingleHostedChild(in: controller)
    }

    @Test func subscriptionsControllerPreservesGroupAndInstallsHostedView() {
        let controller = StoreKitSubscriptionsViewController(subscriptionGroupIdentifier: "premium-group")

        controller.loadViewIfNeeded()

        #expect(controller.subscriptionGroupIdentifier == "premium-group")
        self.expectSingleHostedChild(in: controller)
    }

    @Test func repeatedViewLoadingDoesNotDuplicateHostedController() {
        let controller = StoreKitProductViewController(productIdentifier: "premium")

        controller.loadViewIfNeeded()
        controller.viewDidLoad()

        self.expectSingleHostedChild(in: controller)
    }

    // MARK: - Helpers

    private func expectSingleHostedChild(in controller: UIViewController) {
        let childViewController = controller.children.first

        #expect(controller.children.count == 1)
        #expect(childViewController?.parent === controller)
        #expect(childViewController?.view.superview === controller.view)
        #expect(childViewController?.view.translatesAutoresizingMaskIntoConstraints == false)
    }
}
