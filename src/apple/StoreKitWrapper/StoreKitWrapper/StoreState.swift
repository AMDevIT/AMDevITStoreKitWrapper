//
//  StoreState.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation
import StoreKit

enum StoreStateTransactionFinishResult {
    case ready(Transaction)
    case inProgress
    case notFound
}

enum StoreStatePurchaseStartResult {
    case ready(Product)
    case inProgress
    case productNotFound
}

actor StoreState {
    // MARK: - Properties

    private var knownProducts = [String: Product]()
    private var unfinishedTransactions = [UInt64: Transaction]()
    private var transactionsBeingFinished = Set<UInt64>()
    private var initialized: Bool = false
    private var isProductsRequestInProgress: Bool = false
    private var isPurchaseInProgress: Bool = false

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

    func beginPurchase(productIdentifier: String) -> StoreStatePurchaseStartResult {
        guard !self.isPurchaseInProgress else {
            return .inProgress
        }

        guard let product = self.knownProducts[productIdentifier] else {
            return .productNotFound
        }

        self.isPurchaseInProgress = true
        return .ready(product)
    }

    func completePurchase(transaction: Transaction?) {
        if let transaction = transaction {
            self.unfinishedTransactions[transaction.id] = transaction
        }

        self.isPurchaseInProgress = false
    }

    func failPurchase() {
        self.isPurchaseInProgress = false
    }

    func beginTransactionFinish(transactionIdentifier: UInt64) -> StoreStateTransactionFinishResult {
        guard !self.transactionsBeingFinished.contains(transactionIdentifier) else {
            return .inProgress
        }

        guard let transaction = self.unfinishedTransactions[transactionIdentifier] else {
            return .notFound
        }

        self.transactionsBeingFinished.insert(transactionIdentifier)
        return .ready(transaction)
    }

    func completeTransactionFinish(transactionIdentifier: UInt64) {
        self.unfinishedTransactions.removeValue(forKey: transactionIdentifier)
        self.transactionsBeingFinished.remove(transactionIdentifier)
    }
}
