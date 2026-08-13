# Unfinished Transactions Step

## Objective

Expose `Transaction.unfinished` through a callback-based operation and register recovered verified transactions for explicit finishing.

## Implemented API

- `StoreKitManager.getUnfinishedTransactions()` enumerates StoreKit unfinished transactions asynchronously.
- `StoreKitManagerDelegate.unfinishedTransactionsCompleted` returns mapped DTOs and wrapper error information.
- `unfinishedTransactionsRequestInProgress` rejects concurrent unfinished-transaction refreshes.

## State and concurrency behavior

- The manager must be initialized and not shutting down.
- Starting a valid refresh immediately invalidates the previous unfinished-transaction cache.
- Refresh and `finishTransaction` are mutually exclusive. This prevents a transaction that finishes during enumeration from being reintroduced by the final cache replacement.
- Verified transactions are installed in the actor before the callback and can immediately be finished by identifier.
- Verified purchase results and listener updates received during enumeration are preserved in a side collection and merged into the refreshed cache.
- Cancellation keeps only verified transactions received from purchases or listener updates during the cancelled refresh.
- An unfinished refresh already active when shutdown starts is allowed to complete under the established lifecycle policy.

## Verification behavior

- Verified and unverified results are both returned as DTOs.
- Only verified transactions enter the finishable internal collection.
- If any result is unverified, the callback returns the complete array with `transactionVerificationFailed` and an aggregate message.
- Unverified transactions can't be passed successfully to `finishTransaction` because the wrapper doesn't retain their native transaction value.

## StoreKit semantics

- A transaction remains unfinished until the application persists and delivers the purchase, then calls `finish()`.
- The unfinished sequence is especially important for consumables, which don't appear in current entitlements.
- Enumeration is explicit rather than automatic, avoiding an unsolicited bulk callback during manager initialization.

## Verification status

- Static whitespace, callback-reference, lifecycle-gating, finish-exclusion, concurrent-update-preservation, main-thread-dispatch, and diff checks completed without errors.
- Compilation, generated Objective-C header inspection, and automated tests were not run because they require separate approval and a macOS/Xcode environment.
