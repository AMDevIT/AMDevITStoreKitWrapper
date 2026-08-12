//
//  StoreState.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation
import StoreKit

actor StoreState {
    private var knownProducts: [String:Product] = [:]
    private var initialized: Bool = false
    
    // Initialization
    
    func isInitialized() -> Bool {
        return self.initialized
    }
    
    func setInitialized(isInitialized: Bool) {
        self.initialized = isInitialized
    }
    
    // Products
    
    func addProduct(product: Product) {
        self.knownProducts.updateValue(product, forKey: product.id)
    }
    
    func removeProduct(product: Product) {
        self.knownProducts.removeValue(forKey: product.id)
    }
    
    func clearProducts() {
        self.knownProducts.removeAll()
    }
    
    func getProducts() -> [Product] {
        return Array(self.knownProducts.values)
    }
}
