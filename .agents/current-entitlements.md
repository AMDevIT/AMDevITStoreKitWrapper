# Current Entitlements Step

## Objective

Expose StoreKit current entitlements through a callback-based, binding-friendly operation suitable for reconstructing active premium access.

## Implemented API

- `StoreKitManager.getCurrentEntitlements()` enumerates `Transaction.currentEntitlements` asynchronously.
- `StoreKitManagerDelegate.currentEntitlementsCompleted` returns mapped transaction DTOs and wrapper error information.
- `currentEntitlementsRequestInProgress` rejects a concurrent entitlement refresh before a second StoreKit enumeration starts.

## State and refresh behavior

- The manager must be initialized and not shutting down.
- `StoreState` atomically allows one entitlement refresh at a time.
- Starting a valid refresh immediately invalidates the previous internal entitlement cache.
- Successful completion atomically installs only verified native entitlement transactions in the cache.
- Cancellation leaves the cache empty and completes with `operationCancelled`.
- An operation already active when shutdown starts is allowed to complete under the established lifecycle policy.

## Verification behavior

- Verified and unverified StoreKit results are both mapped and returned so diagnostics aren't discarded.
- Each DTO carries its own verification status and detailed verification error.
- If any result is unverified, the callback returns the full result array with `transactionVerificationFailed` and an aggregate message.
- Only verified transactions enter the internal entitlement cache.
- Entitlement enumeration doesn't add transactions to the unfinished-transaction collection; current entitlements may already be finished.

## StoreKit semantics

- Current entitlements represent the latest transactions that currently grant access.
- StoreKit excludes refunded and revoked products from this sequence.
- Consumable purchases don't appear in current entitlements; unfinished consumables require `Transaction.unfinished` or transaction history.

## Verification status

- Static whitespace, callback-reference, lifecycle-gating, verification-path, main-thread-dispatch, and diff checks completed without errors.
- Compilation, generated Objective-C header inspection, and automated tests were not run because they require separate approval and a macOS/Xcode environment.
