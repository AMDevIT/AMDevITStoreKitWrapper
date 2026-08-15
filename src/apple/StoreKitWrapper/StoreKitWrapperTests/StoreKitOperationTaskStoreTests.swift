//
//  StoreKitOperationTaskStoreTests.swift
//  StoreKitWrapperTests
//
//  Created by Alessandro Morvillo on 15/08/2026.
//

import Testing
@testable import StoreKitWrapper

struct StoreKitOperationTaskStoreTests {
    // MARK: - Tests

    @Test func cancellationReachesTheRegisteredTask() async {
        let taskStore = StoreKitOperationTaskStore()
        let probe = StoreKitOperationCancellationProbe()
        let cancellationObserved: Bool

        taskStore.start(operationKind: .productsRequest) {
            await probe.waitForCancellation()
        }

        await Task.yield()
        taskStore.cancel(operationKind: .productsRequest)

        for _ in 0..<100 {
            if await probe.wasCancellationObserved() {
                break
            }

            await Task.yield()
        }

        cancellationObserved = await probe.wasCancellationObserved()
        #expect(cancellationObserved)
    }
}

private actor StoreKitOperationCancellationProbe {
    // MARK: - Properties

    private var cancellationObserved: Bool = false

    // MARK: - Methods

    func waitForCancellation() async {
        while !Task.isCancelled {
            await Task.yield()
        }

        self.cancellationObserved = true
    }

    func wasCancellationObserved() -> Bool {
        return self.cancellationObserved
    }
}
