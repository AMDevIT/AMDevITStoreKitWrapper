# Managed StoreKit Client Step

## Objective

Provide an idiomatic task-based .NET API over the callback-based native StoreKit binding without changing Objective Sharpie output or exposing Swift concurrency across the native boundary.

## Public API

- `IStoreKitClient` defines initialization, shutdown, product retrieval, current entitlements, App Store synchronization, unfinished transactions, purchase, and transaction finishing as task-based methods.
- `StoreKitClient` is the recommended application-facing implementation and privately owns the generated native `StoreKitManager`.
- `StoreKitPurchaseOutcome` preserves pending, customer-cancelled, successful, and failed purchase outcomes together with the nullable transaction.
- `StoreKitTransactionUpdatedEventArgs` carries persistent listener updates independently of operation tasks.
- `StoreKitWrapperException` exposes the stable `StoreKitWrapperErrorCode` reported by native callbacks.

## Concurrency and threading decisions

- Every operation category has a separate `TaskCompletionSource`, allowing unrelated native operations to overlap without mixing their callbacks.
- Completion sources use `TaskCreationOptions.RunContinuationsAsynchronously` so managed continuations don't execute inline on the native callback thread.
- Initialization and shutdown callers share an already-active task; duplicate product, entitlement, synchronization, unfinished-transaction, purchase, and finish calls fail locally with their matching in-progress error code.
- Transaction updates remain events and are raised on the native callback thread; the managed layer doesn't dispatch them to the main thread.
- The internal delegate holds the client through `WeakReference<StoreKitClient>` to avoid a retain cycle through the native manager's strong delegate property.
- Disposal clears the native delegate, disposes native objects, and faults pending operations with `ObjectDisposedException`.

## Cancellation decision

- Every asynchronous public method accepts an optional `CancellationToken` for forward compatibility.
- The token is currently checked only with `ThrowIfCancellationRequested` before reserving state or invoking Swift.
- Cancellation requested after the native operation begins doesn't cancel the native operation or the returned task yet.
- No completion source is removed early, preventing a late native callback from being associated with a later request.

## Objective Sharpie compatibility

- `ApiDefinition.cs`, its generated `StoreKitManager`, and `StoreKitManagerDelegate` remain unchanged.
- Managed facade files are registered as `ObjcBindingCoreSource` items and therefore don't collide with future Sharpie extraction.

## Verification status

- Static source, callback-name, cancellation-entry, completion-source, project-item, formatting, and diff checks completed.
- Restore and build were not run because repository instructions require separate user approval.
