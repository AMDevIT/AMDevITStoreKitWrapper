//
//  StoreState.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation
import StoreKit

enum StoreStateInitializationResult: Equatable {
    case started
    case inProgress
    case alreadyInitialized
    case managerShutdown
}

enum StoreStateProductsRequestStartResult: Equatable {
    case ready
    case inProgress
    case managerNotInitialized
    case managerShutdown
}

enum StoreStateCurrentEntitlementsRequestStartResult: Equatable {
    case ready
    case inProgress
    case managerNotInitialized
    case managerShutdown
}

enum StoreStateAppStoreSyncStartResult: Equatable {
    case ready
    case inProgress
    case managerNotInitialized
    case managerShutdown
}

enum StoreStateUnfinishedTransactionsRequestStartResult: Equatable {
    case ready
    case inProgress
    case transactionFinishInProgress
    case managerNotInitialized
    case managerShutdown
}

enum StoreStateShutdownResult: Equatable {
    case started
    case inProgress
    case alreadyShutdown
}

enum StoreStateTransactionFinishResult {
    case ready(Transaction)
    case inProgress
    case notFound
    case unfinishedTransactionsRequestInProgress
    case managerNotInitialized
    case managerShutdown
}

enum StoreStatePurchaseStartResult {
    case ready(Product)
    case inProgress
    case productNotFound
    case managerNotInitialized
    case managerShutdown
}

private enum StoreStateLifecycle: Equatable {
    case uninitialized
    case initializing
    case initialized
    case shuttingDown
    case shutdown
}

actor StoreState {
    // MARK: - Properties

    private var knownProducts = [String: Product]()
    private var currentEntitlements = [UInt64: Transaction]()
    private var unfinishedTransactions = [UInt64: Transaction]()
    private var unfinishedTransactionsReceivedDuringRequest = [UInt64: Transaction]()
    private var transactionsBeingFinished = Set<UInt64>()
    private var lifecycle: StoreStateLifecycle = .uninitialized
    private var initializationWaiters = [CheckedContinuation<Bool, Never>]()
    private var shutdownWaiters = [CheckedContinuation<Void, Never>]()
    private var isProductsRequestInProgress: Bool = false
    private var isCurrentEntitlementsRequestInProgress: Bool = false
    private var isAppStoreSyncInProgress: Bool = false
    private var isUnfinishedTransactionsRequestInProgress: Bool = false
    private var isPurchaseInProgress: Bool = false

    // MARK: - Methods

    func beginInitialization() -> StoreStateInitializationResult {
        switch self.lifecycle {
        case .uninitialized:
            self.lifecycle = .initializing
            return .started
        case .initializing:
            return .inProgress
        case .initialized:
            return .alreadyInitialized
        case .shuttingDown, .shutdown:
            return .managerShutdown
        }
    }

    func completeInitialization() {
        guard self.lifecycle == .initializing else {
            return
        }

        self.lifecycle = .initialized
        self.resumeInitializationWaiters(initialized: true)
    }

    func waitForInitializationCompletion() async -> Bool {
        switch self.lifecycle {
        case .initializing:
            return await withCheckedContinuation { continuation in
                self.initializationWaiters.append(continuation)
            }
        case .initialized:
            return true
        case .uninitialized, .shuttingDown, .shutdown:
            return false
        }
    }

    func beginShutdown() async -> StoreStateShutdownResult {
        if self.lifecycle == .initializing {
            _ = await self.waitForInitializationCompletion()
        }

        switch self.lifecycle {
        case .shuttingDown:
            return .inProgress
        case .shutdown:
            return .alreadyShutdown
        case .uninitialized, .initialized:
            self.lifecycle = .shuttingDown
            self.resumeInitializationWaiters(initialized: false)
            return .started
        case .initializing:
            return .inProgress
        }
    }

    func completeShutdown() {
        self.lifecycle = .shutdown
        let waiters = self.shutdownWaiters

        self.shutdownWaiters.removeAll()

        for waiter in waiters {
            waiter.resume()
        }
    }

    func waitForShutdownCompletion() async {
        guard self.lifecycle == .shuttingDown else {
            return
        }

        await withCheckedContinuation { continuation in
            self.shutdownWaiters.append(continuation)
        }
    }

    func beginProductsRequest() -> StoreStateProductsRequestStartResult {
        switch self.lifecycle {
        case .uninitialized, .initializing:
            return .managerNotInitialized
        case .shuttingDown, .shutdown:
            return .managerShutdown
        case .initialized:
            break
        }

        guard !self.isProductsRequestInProgress else {
            return .inProgress
        }

        self.isProductsRequestInProgress = true
        self.knownProducts.removeAll()

        return .ready
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

    func beginCurrentEntitlementsRequest() -> StoreStateCurrentEntitlementsRequestStartResult {
        switch self.lifecycle {
        case .uninitialized, .initializing:
            return .managerNotInitialized
        case .shuttingDown, .shutdown:
            return .managerShutdown
        case .initialized:
            break
        }

        guard !self.isCurrentEntitlementsRequestInProgress else {
            return .inProgress
        }

        self.isCurrentEntitlementsRequestInProgress = true
        self.currentEntitlements.removeAll()
        return .ready
    }

    func completeCurrentEntitlementsRequest(transactions: [Transaction]) {
        var entitlementsByIdentifier = [UInt64: Transaction]()

        for transaction in transactions {
            entitlementsByIdentifier[transaction.id] = transaction
        }

        self.currentEntitlements = entitlementsByIdentifier
        self.isCurrentEntitlementsRequestInProgress = false
    }

    func failCurrentEntitlementsRequest() {
        self.isCurrentEntitlementsRequestInProgress = false
    }

    func beginAppStoreSync() -> StoreStateAppStoreSyncStartResult {
        switch self.lifecycle {
        case .uninitialized, .initializing:
            return .managerNotInitialized
        case .shuttingDown, .shutdown:
            return .managerShutdown
        case .initialized:
            break
        }

        guard !self.isAppStoreSyncInProgress else {
            return .inProgress
        }

        self.isAppStoreSyncInProgress = true
        return .ready
    }

    func completeAppStoreSync() {
        self.isAppStoreSyncInProgress = false
    }

    func beginUnfinishedTransactionsRequest() -> StoreStateUnfinishedTransactionsRequestStartResult {
        switch self.lifecycle {
        case .uninitialized, .initializing:
            return .managerNotInitialized
        case .shuttingDown, .shutdown:
            return .managerShutdown
        case .initialized:
            break
        }

        guard !self.isUnfinishedTransactionsRequestInProgress else {
            return .inProgress
        }

        guard self.transactionsBeingFinished.isEmpty else {
            return .transactionFinishInProgress
        }

        self.isUnfinishedTransactionsRequestInProgress = true
        self.unfinishedTransactions.removeAll()
        self.unfinishedTransactionsReceivedDuringRequest.removeAll()
        return .ready
    }

    func completeUnfinishedTransactionsRequest(transactions: [Transaction]) {
        var transactionsByIdentifier = [UInt64: Transaction]()

        for transaction in transactions {
            transactionsByIdentifier[transaction.id] = transaction
        }

        for transaction in self.unfinishedTransactionsReceivedDuringRequest.values {
            transactionsByIdentifier[transaction.id] = transaction
        }

        self.unfinishedTransactions = transactionsByIdentifier
        self.unfinishedTransactionsReceivedDuringRequest.removeAll()
        self.isUnfinishedTransactionsRequestInProgress = false
    }

    func failUnfinishedTransactionsRequest() {
        self.unfinishedTransactions = self.unfinishedTransactionsReceivedDuringRequest
        self.unfinishedTransactionsReceivedDuringRequest.removeAll()
        self.isUnfinishedTransactionsRequestInProgress = false
    }

    func beginPurchase(productIdentifier: String) -> StoreStatePurchaseStartResult {
        switch self.lifecycle {
        case .uninitialized, .initializing:
            return .managerNotInitialized
        case .shuttingDown, .shutdown:
            return .managerShutdown
        case .initialized:
            break
        }

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

            if self.isUnfinishedTransactionsRequestInProgress {
                self.unfinishedTransactionsReceivedDuringRequest[transaction.id] = transaction
            }
        }

        self.isPurchaseInProgress = false
    }

    func failPurchase() {
        self.isPurchaseInProgress = false
    }

    func beginTransactionFinish(transactionIdentifier: UInt64) -> StoreStateTransactionFinishResult {
        switch self.lifecycle {
        case .uninitialized, .initializing:
            return .managerNotInitialized
        case .shuttingDown, .shutdown:
            return .managerShutdown
        case .initialized:
            break
        }

        guard !self.isUnfinishedTransactionsRequestInProgress else {
            return .unfinishedTransactionsRequestInProgress
        }

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

    func registerTransactionUpdate(transaction: Transaction,
                                   isVerified: Bool) -> Bool {
        guard self.lifecycle == .initialized else {
            return false
        }

        if isVerified {
            self.unfinishedTransactions[transaction.id] = transaction

            if self.isUnfinishedTransactionsRequestInProgress {
                self.unfinishedTransactionsReceivedDuringRequest[transaction.id] = transaction
            }
        }

        return true
    }

    private func resumeInitializationWaiters(initialized: Bool) {
        let waiters = self.initializationWaiters

        self.initializationWaiters.removeAll()

        for waiter in waiters {
            waiter.resume(returning: initialized)
        }
    }
}
