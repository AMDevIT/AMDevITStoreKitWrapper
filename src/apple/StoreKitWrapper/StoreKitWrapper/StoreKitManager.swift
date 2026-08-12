//
//  StoreKitManager.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation
import StoreKit

public class StoreKitManager {
    
    private let logger: IStoreKitWrapperLogger?
    var delegate: StoreKitManagerDelegate? = nil
    
    public init(logger: IStoreKitWrapperLogger? = nil,
                delegate: StoreKitManagerDelegate? = nil) {
        self.logger = logger
        self.delegate = delegate
    }
    
    public func getProducts(productsIdentifies: [String]) {
        Task {
            await getProductsInternal(productsIdentifies: productsIdentifies)
        }
    }
    
    // Internal private async functions.
    
    private func getProductsInternal(productsIdentifies: [String]) async {
        do {
            var wrappedStoreProducts = Array<StoreKitProduct>()
            var productsIdentitfiers = try await Product.products(for: productsIdentifies)
            for currentProduct in productsIdentitfiers {
                let wrappedProduct = StoreKitProduct(identifier: currentProduct.id,
                                                     displayName: currentProduct.displayName,
                                                     displayDescription: currentProduct.description,
                                                     displayPrice: currentProduct.displayPrice)
            }
        } catch {
            
        }
    }
}
