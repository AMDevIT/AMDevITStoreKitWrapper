//
//  StoreKitManager.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation
import StoreKit

public class StoreKitManager {
    // MARK: - Constants

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

    // MARK: - Properties

    private let state = StoreState()
    private let logger: IStoreKitWrapperLogger?
    public var delegate: StoreKitManagerDelegate? = nil

    // MARK: - Initialization

    public init(logger: IStoreKitWrapperLogger? = nil,
                delegate: StoreKitManagerDelegate? = nil) {
        self.logger = logger
        self.delegate = delegate
    }

    // MARK: - Methods

    public func Initialize() {

    }

    public func getProducts(productIdentifiers: [String]) {
        Task {
            await self.getProductsInternal(productIdentifiers: productIdentifiers)
        }
    }

    public func purchase(productIdentifier: String,
                         appAccountToken: String? = nil,
                         quantity: Int = 1) {
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
        let requestStarted = await self.state.beginProductsRequest()

        guard requestStarted else {
            let errorMessage = "A products request is already in progress."

            self.logger?.logWarning(eventId: Self.productsRequestInProgressEventId,
                                    eventName: "ProductsRequestInProgress",
                                    message: errorMessage)
            self.delegate?.availableProductsCompleted(withResult: [],
                                                      errorCode: .productsRequestInProgress,
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
        } catch is CancellationError {
            let errorMessage = "The products request was cancelled."

            await self.state.failProductsRequest()

            self.logger?.logInformation(eventId: Self.productsRequestCancelledEventId,
                                        eventName: "ProductsRequestCancelled",
                                        message: errorMessage)
            self.delegate?.availableProductsCompleted(withResult: [],
                                                      errorCode: .operationCancelled,
                                                      errorMessage: errorMessage)
        } catch {
            await self.state.failProductsRequest()

            self.logger?.logError(eventId: Self.productsRequestFailedEventId,
                                  eventName: "ProductsRequestFailed",
                                  message: "Error retrieving products: \(error.localizedDescription)",
                                  error: error as NSError)
            self.delegate?.availableProductsCompleted(withResult: [],
                                                      errorCode: .productsRequestFailed,
                                                      errorMessage: error.localizedDescription)
        }
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
        } catch is CancellationError {
            let errorMessage = "The purchase operation was cancelled."

            await self.state.failPurchase()

            self.logger?.logInformation(eventId: Self.purchaseCancelledEventId,
                                        eventName: "PurchaseCancelled",
                                        message: errorMessage)
            self.delegate?.purchaseCompleted(withResult: nil,
                                             purchaseResult: .cancelled,
                                             errorCode: .operationCancelled,
                                             errorMessage: errorMessage)
        } catch {
            await self.state.failPurchase()

            self.logger?.logError(eventId: Self.purchaseFailedEventId,
                                  eventName: "PurchaseFailed",
                                  message: "Purchase failed for product \(productIdentifier): \(error.localizedDescription)",
                                  error: error as NSError)
            self.delegate?.purchaseCompleted(withResult: nil,
                                             purchaseResult: .failed,
                                             errorCode: .purchaseFailed,
                                             errorMessage: error.localizedDescription)
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
