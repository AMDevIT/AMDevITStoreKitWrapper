//
//  StoreState.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation
import StoreKit

actor StoreState {
    // MARK: - Properties

    private var knownProducts = [String: Product]()
    private var initialized: Bool = false
    private var isProductsRequestInProgress: Bool = false

    // MARK: - Methods

    func isInitialized() -> Bool {
        return self.initialized
    }

    func setInitialized(isInitialized: Bool) {
        self.initialized = isInitialized
    }

    func beginProductsRequest() -> Bool {
        guard !self.isProductsRequestInProgress else {
            return false
        }

        self.isProductsRequestInProgress = true
        self.knownProducts.removeAll()

        return true
    }

    func completeProductsRequest(products: [Product]) {
        var productsByIdentifier = [String: Product]()

        for product in products {
            productsByIdentifier[product.id] = product
        }

        self.knownProducts = productsByIdentifier
        self.isProductsRequestInProgress = false
    }

    func failProductsRequest() {
        self.isProductsRequestInProgress = false
    }

    func getProducts() -> [Product] {
        return Array(self.knownProducts.values)
    }
}
