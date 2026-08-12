//
//  IStoreKitWrapperLogger.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 12/08/2026.
//

import Foundation

public protocol IStoreKitWrapperLogger {
    // Logging functions
    
    func log(_ message: String)
    
    func logTrace(_ message: String)
    func logDebug(_ message: String)
    func logInfo(_ message: String)
    func logWarning(_ message: String, errorMessage: String?)
    func logError(_ message: String, errorMessage: String?)
    func logFatal(_ message: String, errorMessage: String?)
}
