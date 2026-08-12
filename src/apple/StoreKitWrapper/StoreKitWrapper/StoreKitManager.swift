//
//  StoreKitManager.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation
import StoreKit

public class StoreKitManager {
    
    // Fields
    
    private let state = StoreState()
    private let logger: IStoreKitWrapperLogger?
    var delegate: StoreKitManagerDelegate? = nil
    
    // .ctor
    
    public init(logger: IStoreKitWrapperLogger? = nil,
                delegate: StoreKitManagerDelegate? = nil) {
        self.logger = logger
        self.delegate = delegate
    }
    
    public func Initialize() {
        
    }
    
    // Public functions
    public func getProductsAsync(productsIdentifies: [String]) {
        Task {
            await getProductsInternalAsync(productsIdentifies: productsIdentifies)
        }
    }
    
    // Internal private async functions.
    
    private func getProductsInternalAsync(productsIdentifies: [String]) async {
        do {
            var wrappedStoreProducts: [StoreKitProduct] = []
            
            self.logger?.logDebug("Clearing products before fetching products from Apple servers...")
            await self.state.clearProducts()
            
            self.logger?.logTrace("Fetching products from Apple servers...")
            let fatchedProducts = try await Product.products(for: productsIdentifies)
            for currentProduct in fatchedProducts {
                let wrappedProduct = StoreKitProduct(identifier: currentProduct.id,
                                                     displayName: currentProduct.displayName,
                                                     displayDescription: currentProduct.description,
                                                     displayPrice: currentProduct.displayPrice)
                wrappedStoreProducts.append(wrappedProduct)
                await self.state.addProduct(product: currentProduct)
                self.logger?.logDebug("Found product with identifier: \(currentProduct.id)")
                
            }
            
            self.logger?.logDebug("Products retrieved successfully. Count: \(wrappedStoreProducts.count)")
            self.delegate?.availableProductsCompleted(withResult: wrappedStoreProducts,
                                                      isFaulted: false,
                                                      errorMessage: nil)
        } catch {
            self.logger?.logError("Error retrieving products: \(error.localizedDescription)",
                                  errorMessage: error.localizedDescription)
            self.delegate?.availableProductsCompleted(withResult: [],
                                                      isFaulted: true,
                                                      errorMessage: error.localizedDescription)
        }
    }
}
