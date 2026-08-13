//
//  StoreKitManager.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation
import StoreKit

@objcMembers public final class StoreKitManager: NSObject {
    // MARK: - Constants

    private static let initializationStartedEventId: Int = 1
    private static let initializationCompletedEventId: Int = 2
    private static let alreadyInitializedEventId: Int = 3
    private static let initializationRejectedEventId: Int = 4
    private static let shutdownStartedEventId: Int = 5
    private static let shutdownCompletedEventId: Int = 6
    private static let alreadyShutdownEventId: Int = 7
    private static let transactionListenerStartedEventId: Int = 10
    private static let verifiedTransactionUpdatedEventId: Int = 11
    private static let unverifiedTransactionUpdatedEventId: Int = 12
    private static let transactionListenerStoppedEventId: Int = 13
    private static let managerNotInitializedEventId: Int = 20
    private static let managerShutdownOperationEventId: Int = 21
    private static let productsRequestInProgressEventId: Int = 1000
    private static let productsRequestStartedEventId: Int = 1001
    private static let productFoundEventId: Int = 1002
    private static let productsRequestCompletedEventId: Int = 1003
    private static let productsRequestFailedEventId: Int = 1004
    private static let productsRequestCancelledEventId: Int = 1005
    private static let productsNotReturnedEventId: Int = 1006
    private static let invalidProductIdentifiersEventId: Int = 1007
    private static let invalidPurchaseArgumentsEventId: Int = 2000
    private static let productNotFoundEventId: Int = 2001
    private static let purchaseInProgressEventId: Int = 2002
    private static let purchaseStartedEventId: Int = 2003
    private static let purchaseSucceededEventId: Int = 2004
    private static let purchasePendingEventId: Int = 2005
    private static let purchaseCancelledEventId: Int = 2006
    private static let purchaseVerificationFailedEventId: Int = 2007
    private static let purchaseFailedEventId: Int = 2008
    private static let unknownPurchaseResultEventId: Int = 2009
    private static let transactionNotFoundEventId: Int = 3000
    private static let transactionFinishInProgressEventId: Int = 3001
    private static let transactionFinishStartedEventId: Int = 3002
    private static let transactionFinishCompletedEventId: Int = 3003
    private static let currentEntitlementsRequestInProgressEventId: Int = 4000
    private static let currentEntitlementsRequestStartedEventId: Int = 4001
    private static let currentEntitlementFoundEventId: Int = 4002
    private static let currentEntitlementVerificationFailedEventId: Int = 4003
    private static let currentEntitlementsRequestCompletedEventId: Int = 4004
    private static let currentEntitlementsRequestCancelledEventId: Int = 4005
    private static let appStoreSyncInProgressEventId: Int = 5000
    private static let appStoreSyncStartedEventId: Int = 5001
    private static let appStoreSyncCompletedEventId: Int = 5002
    private static let appStoreSyncCancelledEventId: Int = 5003
    private static let appStoreSyncFailedEventId: Int = 5004
    private static let unfinishedTransactionsRequestInProgressEventId: Int = 6000
    private static let unfinishedTransactionsRequestStartedEventId: Int = 6001
    private static let unfinishedTransactionFoundEventId: Int = 6002
    private static let unfinishedTransactionVerificationFailedEventId: Int = 6003
    private static let unfinishedTransactionsRequestCompletedEventId: Int = 6004
    private static let unfinishedTransactionsRequestCancelledEventId: Int = 6005
    private static let unfinishedTransactionsRequestBlockedEventId: Int = 6006

    // MARK: - Properties

    private let state = StoreState()
    private let logger: IStoreKitWrapperLogger?
    private var transactionUpdatesTask: Task<Void, Never>?
    public var delegate: StoreKitManagerDelegate? = nil

    // MARK: - Initialization

    public override convenience init() {
        self.init(logger: nil,
                  delegate: nil)
    }

    public init(logger: IStoreKitWrapperLogger?,
                delegate: StoreKitManagerDelegate?) {
        self.logger = logger
        self.delegate = delegate
        super.init()
    }

    deinit {
        self.transactionUpdatesTask?.cancel()
    }

    // MARK: - Methods

    public func initialize() {
        Task {
            await self.initializeInternal()
        }
    }

    public func shutdown() {
        Task {
            await self.shutdownInternal()
        }
    }

    public func getProducts(productIdentifiers: [String]) {
        Task {
            await self.getProductsInternal(productIdentifiers: productIdentifiers)
        }
    }

    public func getCurrentEntitlements() {
        Task {
            await self.getCurrentEntitlementsInternal()
        }
    }

    public func sync() {
        Task {
            await self.syncInternal()
        }
    }

    public func getUnfinishedTransactions() {
        Task {
            await self.getUnfinishedTransactionsInternal()
        }
    }

    public func purchase(productIdentifier: String) {
        self.purchase(productIdentifier: productIdentifier,
                      appAccountToken: nil,
                      quantity: 1)
    }

    public func purchase(productIdentifier: String,
                         appAccountToken: String?) {
        self.purchase(productIdentifier: productIdentifier,
                      appAccountToken: appAccountToken,
                      quantity: 1)
    }

    public func purchase(productIdentifier: String,
                         appAccountToken: String?,
                         quantity: Int) {
        Task {
            await self.purchaseInternal(productIdentifier: productIdentifier,
                                        appAccountToken: appAccountToken,
                                        quantity: quantity)
        }
    }

    public func finishTransaction(transactionIdentifier: UInt64) {
        Task {
            await self.finishTransactionInternal(transactionIdentifier: transactionIdentifier)
        }
    }

    private func initializeInternal() async {
        let initializationResult = await self.state.beginInitialization()

        switch initializationResult {
        case .started:
            self.logger?.logInformation(eventId: Self.initializationStartedEventId,
                                        eventName: "InitializationStarted",
                                        message: "Initializing StoreKit manager...")
            self.transactionUpdatesTask = self.createTransactionUpdatesTask()
            await self.state.completeInitialization()

            self.logger?.logInformation(eventId: Self.initializationCompletedEventId,
                                        eventName: "InitializationCompleted",
                                        message: "StoreKit manager initialized successfully.")
            self.delegate?.initializationCompleted(errorCode: .none,
                                                   errorMessage: nil)
        case .inProgress:
            let initialized = await self.state.waitForInitializationCompletion()

            if initialized {
                self.delegate?.initializationCompleted(errorCode: .none,
                                                       errorMessage: nil)
            } else {
                let errorMessage = "StoreKit manager was shut down before initialization completed."

                self.logger?.logWarning(eventId: Self.initializationRejectedEventId,
                                        eventName: "InitializationRejected",
                                        message: errorMessage)
                self.delegate?.initializationCompleted(errorCode: .managerShutdown,
                                                       errorMessage: errorMessage)
            }
        case .alreadyInitialized:
            self.logger?.logDebug(eventId: Self.alreadyInitializedEventId,
                                  eventName: "AlreadyInitialized",
                                  message: "StoreKit manager is already initialized.")
            self.delegate?.initializationCompleted(errorCode: .none,
                                                   errorMessage: nil)
        case .managerShutdown:
            let errorMessage = "StoreKit manager has been shut down and cannot be initialized again."

            self.logger?.logWarning(eventId: Self.initializationRejectedEventId,
                                    eventName: "InitializationRejected",
                                    message: errorMessage)
            self.delegate?.initializationCompleted(errorCode: .managerShutdown,
                                                   errorMessage: errorMessage)
        }
    }

    private func shutdownInternal() async {
        let shutdownResult = await self.state.beginShutdown()

        switch shutdownResult {
        case .started:
            self.logger?.logInformation(eventId: Self.shutdownStartedEventId,
                                        eventName: "ShutdownStarted",
                                        message: "Shutting down StoreKit manager...")
            let transactionUpdatesTask = self.transactionUpdatesTask

            self.transactionUpdatesTask = nil
            transactionUpdatesTask?.cancel()
            await transactionUpdatesTask?.value
            await self.state.completeShutdown()

            self.logger?.logInformation(eventId: Self.shutdownCompletedEventId,
                                        eventName: "ShutdownCompleted",
                                        message: "StoreKit manager shut down successfully.")
            self.delegate?.shutdownCompleted(errorCode: .none,
                                             errorMessage: nil)
        case .inProgress:
            await self.state.waitForShutdownCompletion()
            self.delegate?.shutdownCompleted(errorCode: .none,
                                             errorMessage: nil)
        case .alreadyShutdown:
            self.logger?.logDebug(eventId: Self.alreadyShutdownEventId,
                                  eventName: "AlreadyShutdown",
                                  message: "StoreKit manager is already shut down.")
            self.delegate?.shutdownCompleted(errorCode: .none,
                                             errorMessage: nil)
        }
    }

    private func createTransactionUpdatesTask() -> Task<Void, Never> {
        let state = self.state

        return Task { [weak self] in
            let initialized = await state.waitForInitializationCompletion()

            guard initialized else {
                return
            }

            self?.logger?.logInformation(eventId: Self.transactionListenerStartedEventId,
                                         eventName: "TransactionListenerStarted",
                                         message: "Listening for StoreKit transaction updates...")

            for await verificationResult in Transaction.updates {
                if Task.isCancelled {
                    break
                }

                guard let self = self else {
                    break
                }

                await self.handleTransactionUpdate(verificationResult: verificationResult)
            }

            self?.logger?.logDebug(eventId: Self.transactionListenerStoppedEventId,
                                   eventName: "TransactionListenerStopped",
                                   message: "StoreKit transaction update listener stopped.")
        }
    }

    private func handleTransactionUpdate(verificationResult: VerificationResult<Transaction>) async {
        let transaction = verificationResult.unsafePayloadValue
        let isVerified: Bool

        switch verificationResult {
        case .verified:
            isVerified = true
        case .unverified:
            isVerified = false
        }

        let shouldReport = await self.state.registerTransactionUpdate(transaction: transaction,
                                                                      isVerified: isVerified)

        guard shouldReport else {
            return
        }

        let wrappedTransaction = StoreKitTransactionMapper.map(verificationResult: verificationResult)

        switch verificationResult {
        case .verified:
            self.logger?.logInformation(eventId: Self.verifiedTransactionUpdatedEventId,
                                        eventName: "VerifiedTransactionUpdated",
                                        message: "Received verified transaction update: \(transaction.id)")
            self.delegate?.transactionUpdated(withResult: wrappedTransaction,
                                              errorCode: .none,
                                              errorMessage: nil)
        case .unverified(_, let verificationError):
            self.logger?.logError(eventId: Self.unverifiedTransactionUpdatedEventId,
                                  eventName: "UnverifiedTransactionUpdated",
                                  message: "StoreKit could not verify transaction update \(transaction.id): \(verificationError.localizedDescription)",
                                  error: verificationError as NSError)
            self.delegate?.transactionUpdated(withResult: wrappedTransaction,
                                              errorCode: .transactionVerificationFailed,
                                              errorMessage: verificationError.localizedDescription)
        }
    }

    private func getProductsInternal(productIdentifiers: [String]) async {
        guard !productIdentifiers.isEmpty,
              productIdentifiers.allSatisfy({ !$0.isEmpty }) else {
            let errorMessage = "At least one non-empty product identifier is required."

            self.logger?.logWarning(eventId: Self.invalidProductIdentifiersEventId,
                                    eventName: "InvalidProductIdentifiers",
                                    message: errorMessage)
            self.delegate?.availableProductsCompleted(withResult: [],
                                                      errorCode: .invalidArgument,
                                                      errorMessage: errorMessage)
            return
        }

        var knownIdentifiers = Set<String>()
        let uniqueProductIdentifiers = productIdentifiers.filter { knownIdentifiers.insert($0).inserted }
        let requestStartResult = await self.state.beginProductsRequest()

        switch requestStartResult {
        case .ready:
            break
        case .inProgress:
            let errorMessage = "A products request is already in progress."

            self.logger?.logWarning(eventId: Self.productsRequestInProgressEventId,
                                    eventName: "ProductsRequestInProgress",
                                    message: errorMessage)
            self.delegate?.availableProductsCompleted(withResult: [],
                                                      errorCode: .productsRequestInProgress,
                                                      errorMessage: errorMessage)
            return
        case .managerNotInitialized:
            let errorMessage = "StoreKit manager must be initialized before requesting products."

            self.logger?.logWarning(eventId: Self.managerNotInitializedEventId,
                                    eventName: "ManagerNotInitialized",
                                    message: errorMessage)
            self.delegate?.availableProductsCompleted(withResult: [],
                                                      errorCode: .managerNotInitialized,
                                                      errorMessage: errorMessage)
            return
        case .managerShutdown:
            let errorMessage = "StoreKit manager has been shut down and cannot request products."

            self.logger?.logWarning(eventId: Self.managerShutdownOperationEventId,
                                    eventName: "ManagerShutdown",
                                    message: errorMessage)
            self.delegate?.availableProductsCompleted(withResult: [],
                                                      errorCode: .managerShutdown,
                                                      errorMessage: errorMessage)
            return
        }

        do {
            var wrappedStoreProducts = [StoreKitProduct]()

            self.logger?.logTrace(eventId: Self.productsRequestStartedEventId,
                                  eventName: "ProductsRequestStarted",
                                  message: "Fetching products from Apple servers...")
            let fetchedProducts = try await Product.products(for: uniqueProductIdentifiers)
            for currentProduct in fetchedProducts {
                let currencyCode = currentProduct.priceFormatStyle.currencyCode
                let localeIdentifier = currentProduct.priceFormatStyle.locale.identifier
                let subscriptionInfo: StoreKitSubscriptionInfo?

                if let currentSubscriptionInfo = currentProduct.subscription {
                    subscriptionInfo = await StoreKitSubscriptionInfo.create(subscriptionInfo: currentSubscriptionInfo,
                                                                              currencyCode: currencyCode,
                                                                              localeIdentifier: localeIdentifier)
                } else {
                    subscriptionInfo = nil
                }

                let wrappedProduct = StoreKitProduct(product: currentProduct,
                                                     subscriptionInfo: subscriptionInfo)
                wrappedStoreProducts.append(wrappedProduct)
                self.logger?.logDebug(eventId: Self.productFoundEventId,
                                      eventName: "ProductFound",
                                      message: "Found product with identifier: \(currentProduct.id)")
            }

            let fetchedProductIdentifiers = Set(fetchedProducts.map { $0.id })
            let missingProductIdentifiers = uniqueProductIdentifiers.filter {
                !fetchedProductIdentifiers.contains($0)
            }

            if !missingProductIdentifiers.isEmpty {
                self.logger?.logWarning(eventId: Self.productsNotReturnedEventId,
                                        eventName: "ProductsNotReturned",
                                        message: "Apple did not return products for identifiers: \(missingProductIdentifiers.joined(separator: ", "))")
            }

            await self.state.completeProductsRequest(products: fetchedProducts)

            self.logger?.logDebug(eventId: Self.productsRequestCompletedEventId,
                                  eventName: "ProductsRequestCompleted",
                                  message: "Products retrieved successfully. Count: \(wrappedStoreProducts.count)")
            self.delegate?.availableProductsCompleted(withResult: wrappedStoreProducts,
                                                      errorCode: .none,
                                                      errorMessage: nil)
        } catch {
            let mappedError = StoreKitWrapperErrorMapper.map(error: error,
                                                             fallbackCode: .productsRequestFailed)

            await self.state.failProductsRequest()

            if mappedError.code == .operationCancelled {
                self.logger?.logInformation(eventId: Self.productsRequestCancelledEventId,
                                            eventName: "ProductsRequestCancelled",
                                            message: mappedError.message)
            } else {
                self.logger?.logError(eventId: Self.productsRequestFailedEventId,
                                      eventName: "ProductsRequestFailed",
                                      message: "Error retrieving products: \(mappedError.message)",
                                      error: error as NSError)
            }

            self.delegate?.availableProductsCompleted(withResult: [],
                                                      errorCode: mappedError.code,
                                                      errorMessage: mappedError.message)
        }
    }

    private func getCurrentEntitlementsInternal() async {
        let requestStartResult = await self.state.beginCurrentEntitlementsRequest()

        switch requestStartResult {
        case .ready:
            break
        case .inProgress:
            let errorMessage = "A current entitlements request is already in progress."

            self.logger?.logWarning(eventId: Self.currentEntitlementsRequestInProgressEventId,
                                    eventName: "CurrentEntitlementsRequestInProgress",
                                    message: errorMessage)
            self.delegate?.currentEntitlementsCompleted(withResult: [],
                                                        errorCode: .currentEntitlementsRequestInProgress,
                                                        errorMessage: errorMessage)
            return
        case .managerNotInitialized:
            let errorMessage = "StoreKit manager must be initialized before requesting current entitlements."

            self.logger?.logWarning(eventId: Self.managerNotInitializedEventId,
                                    eventName: "ManagerNotInitialized",
                                    message: errorMessage)
            self.delegate?.currentEntitlementsCompleted(withResult: [],
                                                        errorCode: .managerNotInitialized,
                                                        errorMessage: errorMessage)
            return
        case .managerShutdown:
            let errorMessage = "StoreKit manager has been shut down and cannot request current entitlements."

            self.logger?.logWarning(eventId: Self.managerShutdownOperationEventId,
                                    eventName: "ManagerShutdown",
                                    message: errorMessage)
            self.delegate?.currentEntitlementsCompleted(withResult: [],
                                                        errorCode: .managerShutdown,
                                                        errorMessage: errorMessage)
            return
        }

        var wrappedTransactions = [StoreKitTransaction]()
        var verifiedTransactions = [Transaction]()
        var verificationErrorMessages = [String]()

        self.logger?.logTrace(eventId: Self.currentEntitlementsRequestStartedEventId,
                              eventName: "CurrentEntitlementsRequestStarted",
                              message: "Fetching current StoreKit entitlements...")

        for await verificationResult in Transaction.currentEntitlements {
            if Task.isCancelled {
                await self.completeCancelledCurrentEntitlementsRequest()
                return
            }

            let transaction = verificationResult.unsafePayloadValue
            let wrappedTransaction = StoreKitTransactionMapper.map(verificationResult: verificationResult)

            wrappedTransactions.append(wrappedTransaction)

            switch verificationResult {
            case .verified(let verifiedTransaction):
                verifiedTransactions.append(verifiedTransaction)
                self.logger?.logDebug(eventId: Self.currentEntitlementFoundEventId,
                                      eventName: "CurrentEntitlementFound",
                                      message: "Found verified current entitlement: \(transaction.id)")
            case .unverified(_, let verificationError):
                let verificationErrorMessage = "Transaction \(transaction.id): \(verificationError.localizedDescription)"

                verificationErrorMessages.append(verificationErrorMessage)
                self.logger?.logError(eventId: Self.currentEntitlementVerificationFailedEventId,
                                      eventName: "CurrentEntitlementVerificationFailed",
                                      message: verificationErrorMessage,
                                      error: verificationError as NSError)
            }
        }

        if Task.isCancelled {
            await self.completeCancelledCurrentEntitlementsRequest()
            return
        }

        await self.state.completeCurrentEntitlementsRequest(transactions: verifiedTransactions)

        if verificationErrorMessages.isEmpty {
            self.logger?.logInformation(eventId: Self.currentEntitlementsRequestCompletedEventId,
                                        eventName: "CurrentEntitlementsRequestCompleted",
                                        message: "Current entitlements retrieved successfully. Count: \(wrappedTransactions.count)")
            self.delegate?.currentEntitlementsCompleted(withResult: wrappedTransactions,
                                                        errorCode: .none,
                                                        errorMessage: nil)
        } else {
            let errorMessage = "One or more current entitlements could not be verified. \(verificationErrorMessages.joined(separator: "; "))"

            self.logger?.logWarning(eventId: Self.currentEntitlementsRequestCompletedEventId,
                                    eventName: "CurrentEntitlementsRequestCompletedWithVerificationErrors",
                                    message: errorMessage)
            self.delegate?.currentEntitlementsCompleted(withResult: wrappedTransactions,
                                                        errorCode: .transactionVerificationFailed,
                                                        errorMessage: errorMessage)
        }
    }

    private func completeCancelledCurrentEntitlementsRequest() async {
        let errorMessage = "The current entitlements request was cancelled."

        await self.state.failCurrentEntitlementsRequest()

        self.logger?.logInformation(eventId: Self.currentEntitlementsRequestCancelledEventId,
                                    eventName: "CurrentEntitlementsRequestCancelled",
                                    message: errorMessage)
        self.delegate?.currentEntitlementsCompleted(withResult: [],
                                                    errorCode: .operationCancelled,
                                                    errorMessage: errorMessage)
    }

    private func syncInternal() async {
        let syncStartResult = await self.state.beginAppStoreSync()

        switch syncStartResult {
        case .ready:
            break
        case .inProgress:
            let errorMessage = "An App Store synchronization is already in progress."

            self.logger?.logWarning(eventId: Self.appStoreSyncInProgressEventId,
                                    eventName: "AppStoreSyncInProgress",
                                    message: errorMessage)
            self.delegate?.appStoreSyncCompleted(errorCode: .appStoreSyncInProgress,
                                                 errorMessage: errorMessage)
            return
        case .managerNotInitialized:
            let errorMessage = "StoreKit manager must be initialized before synchronizing with the App Store."

            self.logger?.logWarning(eventId: Self.managerNotInitializedEventId,
                                    eventName: "ManagerNotInitialized",
                                    message: errorMessage)
            self.delegate?.appStoreSyncCompleted(errorCode: .managerNotInitialized,
                                                 errorMessage: errorMessage)
            return
        case .managerShutdown:
            let errorMessage = "StoreKit manager has been shut down and cannot synchronize with the App Store."

            self.logger?.logWarning(eventId: Self.managerShutdownOperationEventId,
                                    eventName: "ManagerShutdown",
                                    message: errorMessage)
            self.delegate?.appStoreSyncCompleted(errorCode: .managerShutdown,
                                                 errorMessage: errorMessage)
            return
        }

        do {
            self.logger?.logInformation(eventId: Self.appStoreSyncStartedEventId,
                                        eventName: "AppStoreSyncStarted",
                                        message: "Synchronizing transaction information with the App Store...")
            try await AppStore.sync()
            await self.state.completeAppStoreSync()

            self.logger?.logInformation(eventId: Self.appStoreSyncCompletedEventId,
                                        eventName: "AppStoreSyncCompleted",
                                        message: "App Store synchronization completed successfully.")
            self.delegate?.appStoreSyncCompleted(errorCode: .none,
                                                 errorMessage: nil)
        } catch {
            let mappedError = StoreKitWrapperErrorMapper.map(error: error,
                                                             fallbackCode: .appStoreSyncFailed)

            await self.state.completeAppStoreSync()

            if mappedError.code == .operationCancelled {
                self.logger?.logInformation(eventId: Self.appStoreSyncCancelledEventId,
                                            eventName: "AppStoreSyncCancelled",
                                            message: mappedError.message)
            } else {
                self.logger?.logError(eventId: Self.appStoreSyncFailedEventId,
                                      eventName: "AppStoreSyncFailed",
                                      message: "App Store synchronization failed: \(mappedError.message)",
                                      error: error as NSError)
            }

            self.delegate?.appStoreSyncCompleted(errorCode: mappedError.code,
                                                 errorMessage: mappedError.message)
        }
    }

    private func getUnfinishedTransactionsInternal() async {
        let requestStartResult = await self.state.beginUnfinishedTransactionsRequest()

        switch requestStartResult {
        case .ready:
            break
        case .inProgress:
            let errorMessage = "An unfinished transactions request is already in progress."

            self.logger?.logWarning(eventId: Self.unfinishedTransactionsRequestInProgressEventId,
                                    eventName: "UnfinishedTransactionsRequestInProgress",
                                    message: errorMessage)
            self.delegate?.unfinishedTransactionsCompleted(withResult: [],
                                                           errorCode: .unfinishedTransactionsRequestInProgress,
                                                           errorMessage: errorMessage)
            return
        case .transactionFinishInProgress:
            let errorMessage = "Unfinished transactions cannot be refreshed while a transaction is being finished."

            self.logger?.logWarning(eventId: Self.unfinishedTransactionsRequestBlockedEventId,
                                    eventName: "UnfinishedTransactionsRequestBlocked",
                                    message: errorMessage)
            self.delegate?.unfinishedTransactionsCompleted(withResult: [],
                                                           errorCode: .transactionFinishInProgress,
                                                           errorMessage: errorMessage)
            return
        case .managerNotInitialized:
            let errorMessage = "StoreKit manager must be initialized before requesting unfinished transactions."

            self.logger?.logWarning(eventId: Self.managerNotInitializedEventId,
                                    eventName: "ManagerNotInitialized",
                                    message: errorMessage)
            self.delegate?.unfinishedTransactionsCompleted(withResult: [],
                                                           errorCode: .managerNotInitialized,
                                                           errorMessage: errorMessage)
            return
        case .managerShutdown:
            let errorMessage = "StoreKit manager has been shut down and cannot request unfinished transactions."

            self.logger?.logWarning(eventId: Self.managerShutdownOperationEventId,
                                    eventName: "ManagerShutdown",
                                    message: errorMessage)
            self.delegate?.unfinishedTransactionsCompleted(withResult: [],
                                                           errorCode: .managerShutdown,
                                                           errorMessage: errorMessage)
            return
        }

        var wrappedTransactions = [StoreKitTransaction]()
        var verifiedTransactions = [Transaction]()
        var verificationErrorMessages = [String]()

        self.logger?.logTrace(eventId: Self.unfinishedTransactionsRequestStartedEventId,
                              eventName: "UnfinishedTransactionsRequestStarted",
                              message: "Fetching unfinished StoreKit transactions...")

        for await verificationResult in Transaction.unfinished {
            if Task.isCancelled {
                await self.completeCancelledUnfinishedTransactionsRequest()
                return
            }

            let transaction = verificationResult.unsafePayloadValue
            let wrappedTransaction = StoreKitTransactionMapper.map(verificationResult: verificationResult)

            wrappedTransactions.append(wrappedTransaction)

            switch verificationResult {
            case .verified(let verifiedTransaction):
                verifiedTransactions.append(verifiedTransaction)
                self.logger?.logDebug(eventId: Self.unfinishedTransactionFoundEventId,
                                      eventName: "UnfinishedTransactionFound",
                                      message: "Found verified unfinished transaction: \(transaction.id)")
            case .unverified(_, let verificationError):
                let verificationErrorMessage = "Transaction \(transaction.id): \(verificationError.localizedDescription)"

                verificationErrorMessages.append(verificationErrorMessage)
                self.logger?.logError(eventId: Self.unfinishedTransactionVerificationFailedEventId,
                                      eventName: "UnfinishedTransactionVerificationFailed",
                                      message: verificationErrorMessage,
                                      error: verificationError as NSError)
            }
        }

        if Task.isCancelled {
            await self.completeCancelledUnfinishedTransactionsRequest()
            return
        }

        await self.state.completeUnfinishedTransactionsRequest(transactions: verifiedTransactions)

        if verificationErrorMessages.isEmpty {
            self.logger?.logInformation(eventId: Self.unfinishedTransactionsRequestCompletedEventId,
                                        eventName: "UnfinishedTransactionsRequestCompleted",
                                        message: "Unfinished transactions retrieved successfully. Count: \(wrappedTransactions.count)")
            self.delegate?.unfinishedTransactionsCompleted(withResult: wrappedTransactions,
                                                           errorCode: .none,
                                                           errorMessage: nil)
        } else {
            let errorMessage = "One or more unfinished transactions could not be verified. \(verificationErrorMessages.joined(separator: "; "))"

            self.logger?.logWarning(eventId: Self.unfinishedTransactionsRequestCompletedEventId,
                                    eventName: "UnfinishedTransactionsRequestCompletedWithVerificationErrors",
                                    message: errorMessage)
            self.delegate?.unfinishedTransactionsCompleted(withResult: wrappedTransactions,
                                                           errorCode: .transactionVerificationFailed,
                                                           errorMessage: errorMessage)
        }
    }

    private func completeCancelledUnfinishedTransactionsRequest() async {
        let errorMessage = "The unfinished transactions request was cancelled."

        await self.state.failUnfinishedTransactionsRequest()

        self.logger?.logInformation(eventId: Self.unfinishedTransactionsRequestCancelledEventId,
                                    eventName: "UnfinishedTransactionsRequestCancelled",
                                    message: errorMessage)
        self.delegate?.unfinishedTransactionsCompleted(withResult: [],
                                                       errorCode: .operationCancelled,
                                                       errorMessage: errorMessage)
    }

    private func purchaseInternal(productIdentifier: String,
                                  appAccountToken: String?,
                                  quantity: Int) async {
        let accountToken: UUID?

        guard !productIdentifier.isEmpty,
              (1...10).contains(quantity) else {
            let errorMessage = "A non-empty product identifier and a quantity between 1 and 10 are required."

            self.logger?.logWarning(eventId: Self.invalidPurchaseArgumentsEventId,
                                    eventName: "InvalidPurchaseArguments",
                                    message: errorMessage)
            self.delegate?.purchaseCompleted(withResult: nil,
                                             purchaseResult: .failed,
                                             errorCode: .invalidArgument,
                                             errorMessage: errorMessage)
            return
        }

        if let appAccountToken = appAccountToken {
            guard let parsedAccountToken = UUID(uuidString: appAccountToken) else {
                let errorMessage = "The app account token must be a valid UUID."

                self.logger?.logWarning(eventId: Self.invalidPurchaseArgumentsEventId,
                                        eventName: "InvalidPurchaseArguments",
                                        message: errorMessage)
                self.delegate?.purchaseCompleted(withResult: nil,
                                                 purchaseResult: .failed,
                                                 errorCode: .invalidArgument,
                                                 errorMessage: errorMessage)
                return
            }

            accountToken = parsedAccountToken
        } else {
            accountToken = nil
        }

        let purchaseStartResult = await self.state.beginPurchase(productIdentifier: productIdentifier)
        let product: Product

        switch purchaseStartResult {
        case .ready(let availableProduct):
            product = availableProduct
        case .inProgress:
            let errorMessage = "A purchase is already in progress."

            self.logger?.logWarning(eventId: Self.purchaseInProgressEventId,
                                    eventName: "PurchaseInProgress",
                                    message: errorMessage)
            self.delegate?.purchaseCompleted(withResult: nil,
                                             purchaseResult: .failed,
                                             errorCode: .purchaseInProgress,
                                             errorMessage: errorMessage)
            return
        case .productNotFound:
            let errorMessage = "No loaded product was found with identifier: \(productIdentifier)"

            self.logger?.logWarning(eventId: Self.productNotFoundEventId,
                                    eventName: "ProductNotFound",
                                    message: errorMessage)
            self.delegate?.purchaseCompleted(withResult: nil,
                                             purchaseResult: .failed,
                                             errorCode: .productNotFound,
                                             errorMessage: errorMessage)
            return
        case .managerNotInitialized:
            let errorMessage = "StoreKit manager must be initialized before purchasing a product."

            self.logger?.logWarning(eventId: Self.managerNotInitializedEventId,
                                    eventName: "ManagerNotInitialized",
                                    message: errorMessage)
            self.delegate?.purchaseCompleted(withResult: nil,
                                             purchaseResult: .failed,
                                             errorCode: .managerNotInitialized,
                                             errorMessage: errorMessage)
            return
        case .managerShutdown:
            let errorMessage = "StoreKit manager has been shut down and cannot purchase products."

            self.logger?.logWarning(eventId: Self.managerShutdownOperationEventId,
                                    eventName: "ManagerShutdown",
                                    message: errorMessage)
            self.delegate?.purchaseCompleted(withResult: nil,
                                             purchaseResult: .failed,
                                             errorCode: .managerShutdown,
                                             errorMessage: errorMessage)
            return
        }

        guard quantity == 1 || product.type == .consumable else {
            let errorMessage = "A quantity greater than one is supported only for consumable products."

            await self.state.failPurchase()

            self.logger?.logWarning(eventId: Self.invalidPurchaseArgumentsEventId,
                                    eventName: "InvalidPurchaseArguments",
                                    message: errorMessage)
            self.delegate?.purchaseCompleted(withResult: nil,
                                             purchaseResult: .failed,
                                             errorCode: .invalidArgument,
                                             errorMessage: errorMessage)
            return
        }

        do {
            var purchaseOptions = Set<Product.PurchaseOption>()

            if let accountToken = accountToken {
                purchaseOptions.insert(.appAccountToken(accountToken))
            }

            if quantity > 1 {
                purchaseOptions.insert(.quantity(quantity))
            }

            self.logger?.logInformation(eventId: Self.purchaseStartedEventId,
                                        eventName: "PurchaseStarted",
                                        message: "Starting purchase for product: \(productIdentifier)")
            let purchaseResult = try await product.purchase(options: purchaseOptions)

            switch purchaseResult {
            case .success(let verificationResult):
                let wrappedTransaction = StoreKitTransactionMapper.map(verificationResult: verificationResult)

                switch verificationResult {
                case .verified(let transaction):
                    await self.state.completePurchase(transaction: transaction)

                    self.logger?.logInformation(eventId: Self.purchaseSucceededEventId,
                                                eventName: "PurchaseSucceeded",
                                                message: "Purchase succeeded for product: \(productIdentifier)")
                    self.delegate?.purchaseCompleted(withResult: wrappedTransaction,
                                                     purchaseResult: .succeeded,
                                                     errorCode: .none,
                                                     errorMessage: nil)
                case .unverified(_, let verificationError):
                    await self.state.completePurchase(transaction: nil)

                    self.logger?.logError(eventId: Self.purchaseVerificationFailedEventId,
                                          eventName: "PurchaseVerificationFailed",
                                          message: "StoreKit could not verify the transaction for product \(productIdentifier): \(verificationError.localizedDescription)",
                                          error: verificationError as NSError)
                    self.delegate?.purchaseCompleted(withResult: wrappedTransaction,
                                                     purchaseResult: .failed,
                                                     errorCode: .transactionVerificationFailed,
                                                     errorMessage: verificationError.localizedDescription)
                }
            case .pending:
                await self.state.completePurchase(transaction: nil)

                self.logger?.logInformation(eventId: Self.purchasePendingEventId,
                                            eventName: "PurchasePending",
                                            message: "Purchase is pending for product: \(productIdentifier)")
                self.delegate?.purchaseCompleted(withResult: nil,
                                                 purchaseResult: .pending,
                                                 errorCode: .none,
                                                 errorMessage: nil)
            case .userCancelled:
                await self.state.completePurchase(transaction: nil)

                self.logger?.logInformation(eventId: Self.purchaseCancelledEventId,
                                            eventName: "PurchaseCancelled",
                                            message: "The user cancelled the purchase for product: \(productIdentifier)")
                self.delegate?.purchaseCompleted(withResult: nil,
                                                 purchaseResult: .cancelled,
                                                 errorCode: .none,
                                                 errorMessage: nil)
            @unknown default:
                let errorMessage = "StoreKit returned an unknown purchase result."

                await self.state.failPurchase()

                self.logger?.logError(eventId: Self.unknownPurchaseResultEventId,
                                      eventName: "UnknownPurchaseResult",
                                      message: errorMessage)
                self.delegate?.purchaseCompleted(withResult: nil,
                                                 purchaseResult: .unknown,
                                                 errorCode: .unknown,
                                                 errorMessage: errorMessage)
            }
        } catch {
            let mappedError = StoreKitWrapperErrorMapper.map(error: error,
                                                             fallbackCode: .purchaseFailed)

            await self.state.failPurchase()

            if mappedError.code == .operationCancelled {
                self.logger?.logInformation(eventId: Self.purchaseCancelledEventId,
                                            eventName: "PurchaseCancelled",
                                            message: mappedError.message)
            } else {
                self.logger?.logError(eventId: Self.purchaseFailedEventId,
                                      eventName: "PurchaseFailed",
                                      message: "Purchase failed for product \(productIdentifier): \(mappedError.message)",
                                      error: error as NSError)
            }

            self.delegate?.purchaseCompleted(withResult: nil,
                                             purchaseResult: mappedError.code == .operationCancelled ? .cancelled : .failed,
                                             errorCode: mappedError.code,
                                             errorMessage: mappedError.message)
        }
    }

    private func finishTransactionInternal(transactionIdentifier: UInt64) async {
        let finishResult = await self.state.beginTransactionFinish(transactionIdentifier: transactionIdentifier)
        let transaction: Transaction

        switch finishResult {
        case .ready(let unfinishedTransaction):
            transaction = unfinishedTransaction
        case .inProgress:
            let errorMessage = "The transaction is already being finished."

            self.logger?.logWarning(eventId: Self.transactionFinishInProgressEventId,
                                    eventName: "TransactionFinishInProgress",
                                    message: errorMessage)
            self.delegate?.finishTransactionCompleted(transactionIdentifier: transactionIdentifier,
                                                      errorCode: .transactionFinishInProgress,
                                                      errorMessage: errorMessage)
            return
        case .notFound:
            let errorMessage = "No unfinished verified transaction was found with identifier: \(transactionIdentifier)"

            self.logger?.logWarning(eventId: Self.transactionNotFoundEventId,
                                    eventName: "TransactionNotFound",
                                    message: errorMessage)
            self.delegate?.finishTransactionCompleted(transactionIdentifier: transactionIdentifier,
                                                      errorCode: .transactionNotFound,
                                                      errorMessage: errorMessage)
            return
        case .unfinishedTransactionsRequestInProgress:
            let errorMessage = "A transaction cannot be finished while unfinished transactions are being refreshed."

            self.logger?.logWarning(eventId: Self.unfinishedTransactionsRequestBlockedEventId,
                                    eventName: "TransactionFinishBlocked",
                                    message: errorMessage)
            self.delegate?.finishTransactionCompleted(transactionIdentifier: transactionIdentifier,
                                                      errorCode: .unfinishedTransactionsRequestInProgress,
                                                      errorMessage: errorMessage)
            return
        case .managerNotInitialized:
            let errorMessage = "StoreKit manager must be initialized before finishing a transaction."

            self.logger?.logWarning(eventId: Self.managerNotInitializedEventId,
                                    eventName: "ManagerNotInitialized",
                                    message: errorMessage)
            self.delegate?.finishTransactionCompleted(transactionIdentifier: transactionIdentifier,
                                                      errorCode: .managerNotInitialized,
                                                      errorMessage: errorMessage)
            return
        case .managerShutdown:
            let errorMessage = "StoreKit manager has been shut down and cannot finish transactions."

            self.logger?.logWarning(eventId: Self.managerShutdownOperationEventId,
                                    eventName: "ManagerShutdown",
                                    message: errorMessage)
            self.delegate?.finishTransactionCompleted(transactionIdentifier: transactionIdentifier,
                                                      errorCode: .managerShutdown,
                                                      errorMessage: errorMessage)
            return
        }

        self.logger?.logTrace(eventId: Self.transactionFinishStartedEventId,
                              eventName: "TransactionFinishStarted",
                              message: "Finishing transaction: \(transactionIdentifier)")
        await transaction.finish()
        await self.state.completeTransactionFinish(transactionIdentifier: transactionIdentifier)

        self.logger?.logInformation(eventId: Self.transactionFinishCompletedEventId,
                                    eventName: "TransactionFinishCompleted",
                                    message: "Transaction finished successfully: \(transactionIdentifier)")
        self.delegate?.finishTransactionCompleted(transactionIdentifier: transactionIdentifier,
                                                  errorCode: .none,
                                                  errorMessage: nil)
    }
}
