//
//  StoreKitWrapperLogLevel.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation

@objc public enum StoreKitWrapperLogLevel: Int {
    case trace = 0
    case debug = 1
    case information = 2
    case warning = 3
    case error = 4
    case critical = 5
    case none = 6
}
