//
//  StoreKitProduct.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

public class StoreKitProduct {
    public let identifier: String
    public let displayName: String
    public let displayDescription: String
    public let displayPrice: String
    
    public init (identifier: String,
                 displayName: String,
                 displayDescription: String,
                 displayPrice: String) {
        self.identifier = identifier
        self.displayName = displayName
        self.displayDescription = displayDescription
        self.displayPrice = displayPrice
    }
}
