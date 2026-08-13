# Initialization and Transaction Listener Step

## Objective

Initialize the StoreKit manager idempotently and start a persistent callback-based bridge over `Transaction.updates` without exposing Swift concurrency.

## Implemented API

- `StoreKitManager.initialize()` starts initialization asynchronously.
- `StoreKitManagerDelegate.initializationCompleted` reports completion. Repeated initialization calls are idempotent: they don't create another listener and complete successfully.
- `StoreKitManagerDelegate.transactionUpdated` reports every mapped StoreKit transaction update with wrapper error information.
- Verified updates use `StoreKitWrapperErrorCode.none`; unverified updates carry `transactionVerificationFailed` and the StoreKit verification message.

## State and listener behavior

- `StoreState.beginInitialization()` atomically permits only the first listener creation.
- The manager retains the listener `Task`; Swift concurrency and `Transaction` remain private implementation details.
- Verified listener transactions are stored in the actor before the callback, making them immediately available to `finishTransaction`.
- Unverified transactions are mapped and reported but are not stored as finishable transactions.
- Listener callbacks are not explicitly dispatched to the main thread.
- Listener events are not permanently deduplicated by transaction identifier because `Transaction.updates` can represent meaningful changes to an existing transaction.
- StoreKit documents same-device purchases as being returned through `Product.PurchaseResult.success`; `Transaction.updates` covers unfinished startup transactions and transactions created or changed outside the app or on other devices.

## Deferred work

- Reporting an unexpected listener termination as a dedicated lifecycle event.

## Verification status

- Static whitespace, callback-reference, main-thread-dispatch, and diff checks completed without errors.
- Compilation, generated Objective-C header inspection, and automated tests were not run because they require separate approval and a macOS/Xcode environment.
