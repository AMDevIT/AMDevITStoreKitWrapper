//
//  StoreKitManagerDelegate.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation

public protocol StoreKitManagerDelegate {
    func availableProductsCompleted(withResult: [StoreKitProduct],
                                    errorCode: StoreKitWrapperErrorCode,
                                    errorMessage: String?)
}
