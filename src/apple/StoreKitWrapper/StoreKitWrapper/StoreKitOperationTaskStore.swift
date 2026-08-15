//
//  StoreKitOperationTaskStore.swift
//  StoreKitWrapper
//
//  Created by Alessandro Morvillo on 15/08/2026.
//

import Foundation

/// Identifies independently cancellable manager operation categories.
enum StoreKitOperationKind: Hashable {
    case initialization
    case shutdown
    case productsRequest
    case currentEntitlementsRequest
    case appStoreSync
    case unfinishedTransactionsRequest
    case purchase
    case transactionFinish
}

/// Stores internal Swift tasks and delivers category-based cooperative cancellation safely across threads.
final class StoreKitOperationTaskStore: @unchecked Sendable {
    // MARK: - Properties

    private let lock = NSLock()
    private var records = [StoreKitOperationKind: [UUID: StoreKitOperationTaskRecord]]()

    // MARK: - Methods

    func start(operationKind: StoreKitOperationKind,
               operation: @escaping @Sendable () async -> Void) {
        let identifier = UUID()

        self.reserve(operationKind: operationKind,
                     identifier: identifier)

        let task = Task { [weak self] in
            await operation()
            self?.complete(operationKind: operationKind,
                           identifier: identifier)
        }

        self.attach(task: task,
                    operationKind: operationKind,
                    identifier: identifier)
    }

    func cancel(operationKind: StoreKitOperationKind) {
        let tasks: [Task<Void, Never>]

        self.lock.lock()

        if var operationRecords = self.records[operationKind] {
            for identifier in Array(operationRecords.keys) {
                operationRecords[identifier]?.isCancellationRequested = true
            }

            self.records[operationKind] = operationRecords
            tasks = operationRecords.values.compactMap { $0.task }
        } else {
            tasks = []
        }

        self.lock.unlock()

        for task in tasks {
            task.cancel()
        }
    }

    func cancelAll() {
        let tasks: [Task<Void, Never>]

        self.lock.lock()

        for operationKind in Array(self.records.keys) {
            guard var operationRecords = self.records[operationKind] else {
                continue
            }

            for identifier in Array(operationRecords.keys) {
                operationRecords[identifier]?.isCancellationRequested = true
            }

            self.records[operationKind] = operationRecords
        }

        tasks = self.records.values.flatMap { operationRecords in
            operationRecords.values.compactMap { $0.task }
        }
        self.lock.unlock()

        for task in tasks {
            task.cancel()
        }
    }

    private func reserve(operationKind: StoreKitOperationKind,
                         identifier: UUID) {
        self.lock.lock()

        var operationRecords = self.records[operationKind] ?? [:]

        operationRecords[identifier] = StoreKitOperationTaskRecord(task: nil,
                                                                   isCancellationRequested: false)
        self.records[operationKind] = operationRecords
        self.lock.unlock()
    }

    private func attach(task: Task<Void, Never>,
                        operationKind: StoreKitOperationKind,
                        identifier: UUID) {
        let shouldCancel: Bool

        self.lock.lock()

        if var operationRecords = self.records[operationKind],
           var record = operationRecords[identifier] {
            shouldCancel = record.isCancellationRequested
            record.task = task
            operationRecords[identifier] = record
            self.records[operationKind] = operationRecords
        } else {
            shouldCancel = true
        }

        self.lock.unlock()

        if shouldCancel {
            task.cancel()
        }
    }

    private func complete(operationKind: StoreKitOperationKind,
                          identifier: UUID) {
        self.lock.lock()

        if var operationRecords = self.records[operationKind] {
            operationRecords.removeValue(forKey: identifier)

            if operationRecords.isEmpty {
                self.records.removeValue(forKey: operationKind)
            } else {
                self.records[operationKind] = operationRecords
            }
        }

        self.lock.unlock()
    }
}

private struct StoreKitOperationTaskRecord {
    // MARK: - Properties

    var task: Task<Void, Never>?
    var isCancellationRequested: Bool
}
