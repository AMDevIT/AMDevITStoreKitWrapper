//
//  StoreKitPurchaseResult.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Foundation

@objc public enum StoreKitPurchaseResult: Int {
    case unknown = -1
    case succeeded = 0
    case pending = 1
    case cancelled = 2
    case failed = 3
}
