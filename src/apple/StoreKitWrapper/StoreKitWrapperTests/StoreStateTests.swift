//
//  StoreStateTests.swift
//  StoreKitWrapperTests
//
//  Created by Alessandro Morvillo on 13/08/2026.
//

import Testing
@testable import StoreKitWrapper

struct StoreStateTests {
    // MARK: - Tests

    @Test func initializationAndShutdownAreIdempotent() async {
        let state = StoreState()
        let firstInitialization = await state.beginInitialization()
        let concurrentInitialization = await state.beginInitialization()

        #expect(firstInitialization == .started)
        #expect(concurrentInitialization == .inProgress)

        await state.completeInitialization()

        let repeatedInitialization = await state.beginInitialization()
        let firstShutdown = await state.beginShutdown()

        #expect(repeatedInitialization == .alreadyInitialized)
        #expect(firstShutdown == .started)

        await state.completeShutdown()

        let repeatedShutdown = await state.beginShutdown()
        let rejectedInitialization = await state.beginInitialization()

        #expect(repeatedShutdown == .alreadyShutdown)
        #expect(rejectedInitialization == .managerShutdown)
    }

    @Test func cancelledInitializationCanBeRetried() async {
        let state = StoreState()
        let firstInitialization = await state.beginInitialization()

        #expect(firstInitialization == .started)

        await state.cancelInitialization()

        let retry = await state.beginInitialization()

        #expect(retry == .started)
    }

    @Test func operationsRequireInitialization() async {
        let state = StoreState()
        let productsResult = await state.beginProductsRequest()
        let entitlementsResult = await state.beginCurrentEntitlementsRequest()
        let syncResult = await state.beginAppStoreSync()
        let unfinishedResult = await state.beginUnfinishedTransactionsRequest()

        #expect(productsResult == .managerNotInitialized)
        #expect(entitlementsResult == .managerNotInitialized)
        #expect(syncResult == .managerNotInitialized)
        #expect(unfinishedResult == .managerNotInitialized)
    }

    @Test func productRequestIsExclusiveAndCancellationAllowsRetry() async {
        let state = await self.createInitializedState()
        let firstRequest = await state.beginProductsRequest()
        let concurrentRequest = await state.beginProductsRequest()

        #expect(firstRequest == .ready)
        #expect(concurrentRequest == .inProgress)

        await state.failProductsRequest()

        let retry = await state.beginProductsRequest()

        #expect(retry == .ready)
    }

    @Test func entitlementRequestIsExclusiveAndCancellationAllowsRetry() async {
        let state = await self.createInitializedState()
        let firstRequest = await state.beginCurrentEntitlementsRequest()
        let concurrentRequest = await state.beginCurrentEntitlementsRequest()

        #expect(firstRequest == .ready)
        #expect(concurrentRequest == .inProgress)

        await state.failCurrentEntitlementsRequest()

        let retry = await state.beginCurrentEntitlementsRequest()

        #expect(retry == .ready)
    }

    @Test func appStoreSynchronizationIsExclusive() async {
        let state = await self.createInitializedState()
        let firstRequest = await state.beginAppStoreSync()
        let concurrentRequest = await state.beginAppStoreSync()

        #expect(firstRequest == .ready)
        #expect(concurrentRequest == .inProgress)

        await state.completeAppStoreSync()

        let retry = await state.beginAppStoreSync()

        #expect(retry == .ready)
    }

    @Test func unfinishedRefreshIsExclusiveAndBlocksFinishing() async {
        let state = await self.createInitializedState()
        let firstRequest = await state.beginUnfinishedTransactionsRequest()
        let concurrentRequest = await state.beginUnfinishedTransactionsRequest()
        let finishResult = await state.beginTransactionFinish(transactionIdentifier: 42)
        let isFinishBlocked: Bool

        #expect(firstRequest == .ready)
        #expect(concurrentRequest == .inProgress)

        if case .unfinishedTransactionsRequestInProgress = finishResult {
            isFinishBlocked = true
        } else {
            isFinishBlocked = false
        }

        #expect(isFinishBlocked)

        await state.failUnfinishedTransactionsRequest()

        let retry = await state.beginUnfinishedTransactionsRequest()

        #expect(retry == .ready)
    }

    // MARK: - Helpers

    private func createInitializedState() async -> StoreState {
        let state = StoreState()

        _ = await state.beginInitialization()
        await state.completeInitialization()

        return state
    }
}
