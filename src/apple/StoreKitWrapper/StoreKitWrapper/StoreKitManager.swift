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
}
