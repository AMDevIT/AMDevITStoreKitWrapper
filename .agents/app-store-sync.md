# App Store Synchronization Step

## Objective

Expose `AppStore.sync()` through a callback-based operation for an explicit Restore Purchases action.

## Implemented API

- `StoreKitManager.sync()` starts App Store synchronization without exposing Swift concurrency.
- `StoreKitManagerDelegate.appStoreSyncCompleted` reports success, cancellation, lifecycle rejection, concurrency rejection, or failure.
- `appStoreSyncInProgress` prevents concurrent synchronization attempts.
- Recognized StoreKit and network failures use their stable wrapper codes; unrecognized synchronization failures use `appStoreSyncFailed`.

## State and lifecycle behavior

- The manager must be initialized and not shutting down.
- `StoreState` atomically allows one App Store synchronization at a time.
- Task cancellation, `StoreKitError.userCancelled`, and cancellation reported through `URLError` map to `operationCancelled`.
- All completion paths clear the synchronization-in-progress flag.
- Synchronization already active when shutdown starts is allowed to complete under the established lifecycle policy.

## API behavior decisions

- Synchronization doesn't automatically call `getCurrentEntitlements()` afterward. The application decides whether and when it needs a fresh entitlement snapshot.
- Transaction updates produced while synchronization is active continue through the existing `transactionUpdated` callback.
- The wrapper doesn't invoke synchronization automatically. Apple requires `AppStore.sync()` to be called only in response to an explicit user action because it can display an App Store authentication prompt.
- Normal startup entitlement restoration continues to use `Transaction.currentEntitlements`; synchronization is a user-requested recovery mechanism for exceptional cases.

## Verification status

- Static whitespace, callback-reference, lifecycle-gating, cancellation-path, main-thread-dispatch, and diff checks completed without errors.
- Compilation, generated Objective-C header inspection, and automated tests were not run because they require separate approval and a macOS/Xcode environment.
