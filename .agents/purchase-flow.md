# Purchase Flow Step

## Objective

Expose a callback-based StoreKit purchase workflow while keeping `Product.purchase`, Swift concurrency, native transactions, and transaction finishing internal.

## Implemented API

- `StoreKitManager.purchase(productIdentifier:appAccountToken:quantity:)` starts a purchase for a previously loaded product.
- `StoreKitPurchaseResult` distinguishes succeeded, pending, cancelled, failed, and unknown outcomes.
- `StoreKitManagerDelegate.purchaseCompleted` returns the mapped transaction when StoreKit supplies one, together with the purchase result and wrapper error information.
- `StoreKitManager.finishTransaction(transactionIdentifier:)` explicitly finishes a verified transaction after the application persists and delivers the purchase.
- `StoreKitManagerDelegate.finishTransactionCompleted` reports whether the transaction was found, already being finished, or completed.

## State and concurrency decisions

- `StoreState` atomically resolves the cached product and starts one global purchase operation. Concurrent purchase attempts fail before calling StoreKit.
- A verified native transaction is stored in the actor before the purchase callback is invoked.
- Unverified transactions are mapped and returned for diagnostics, but they are not stored as finishable transactions.
- Transaction finishing is explicitly requested by identifier and duplicate concurrent finish requests are rejected atomically.
- Callbacks are invoked from the asynchronous operation without an explicit dispatch to the main thread. `Product.purchase` itself is main-actor isolated by StoreKit because it presents system UI.

## Validation and outcomes

- Product identifiers must be non-empty and refer to the current product catalog.
- Quantities must be between 1 and 10. Quantities greater than one are accepted only for consumable products.
- App account tokens cross the public boundary as nullable UUID strings and are converted internally to `UUID`.
- User cancellation and pending approval are normal purchase outcomes with no wrapper error.
- Task cancellation, thrown StoreKit errors, missing products, concurrent purchases, and failed transaction verification carry explicit wrapper error codes.

## Deferred work

- `Transaction.updates` listening and recovery of transactions across process restarts.
- Current-entitlement enumeration and restoration callbacks.
- Promotional and win-back purchase options.

## Verification status

- Static whitespace, reference, and diff checks completed without errors.
- Compilation, Objective-C generated-header inspection, and automated tests were not run because they require separate approval and a macOS/Xcode environment.
