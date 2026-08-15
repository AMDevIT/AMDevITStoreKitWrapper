# Managed StoreKit Client Step

## Objective

Provide an idiomatic task-based .NET API over the callback-based native StoreKit binding without changing Objective Sharpie output or exposing Swift concurrency across the native boundary.

## Public API

- `IStoreKitClient` defines initialization, shutdown, product retrieval, current entitlements, App Store synchronization, unfinished transactions, purchase, and transaction finishing as task-based methods.
- `StoreKitClient` is the recommended application-facing implementation and privately owns the generated native `StoreKitManager`.
- `StoreKitPurchaseOutcome` preserves pending, customer-cancelled, successful, and failed purchase outcomes together with the nullable transaction.
- `StoreKitTransactionUpdatedEventArgs` carries persistent listener updates independently of operation tasks.
- `StoreKitWrapperException` exposes the stable `StoreKitWrapperErrorCode` reported by native callbacks.
- The client accepts an optional `ILogger<StoreKitClient>` and privately bridges native structured diagnostics to Microsoft logging.

## Concurrency and threading decisions

- Every operation category has a separate `TaskCompletionSource`, allowing unrelated native operations to overlap without mixing their callbacks.
- Completion sources use `TaskCreationOptions.RunContinuationsAsynchronously` so managed continuations don't execute inline on the native callback thread.
- Initialization and shutdown callers share an already-active task; duplicate product, entitlement, synchronization, unfinished-transaction, purchase, and finish calls fail locally with their matching in-progress error code.
- Transaction updates remain events and are raised on the native callback thread; the managed layer doesn't dispatch them to the main thread.
- The internal delegate holds the client through `WeakReference<StoreKitClient>` to avoid a retain cycle through the native manager's strong delegate property.
- Disposal clears the native delegate, disposes native objects, and faults pending operations with `ObjectDisposedException`.

## Cancellation decision

- Every asynchronous public method accepts an optional `CancellationToken`, rejects pre-cancelled calls, and uses `Task.WaitAsync` so cancellation stops the managed wait immediately.
- A token cancellation also invokes the matching Objective-C-compatible cancellation selector on the native manager.
- Native cancellation is cooperative. A StoreKit result or irreversible action that already completed may win the race against cancellation.
- The managed completion source remains registered until the native terminal callback arrives. This prevents a late callback from being associated with a later request in the same operation category.
- A native `operationCancelled` error is translated to `OperationCanceledException` when it was caused by the caller's token; direct low-level native cancellation remains a `StoreKitWrapperException`.
- Native faults arriving after the managed wait was cancelled are observed to avoid unobserved task exceptions.

## Objective Sharpie compatibility

- The generated manager contract gains only ordinary `void` cancellation selectors; no Swift `Task`, actor, or async method crosses the Objective-C boundary.
- Managed facade files are registered as `ObjcBindingCoreSource` items and therefore don't collide with future Sharpie extraction.

## Logging integration

- The binding references `Microsoft.Extensions.Logging.Abstractions` because only the logging contract is required; provider selection remains with the consuming application.
- `StoreKitLoggerBridge` maps every native log level to its Microsoft equivalent and preserves numeric and named event identifiers.
- Native `NSError` values become `NSErrorException` instances passed to `ILogger.Log`.
- The bridge remains private and is retained by the client while the native manager is active; the low-level manager still accepts direct native logger implementations.

## Verification status

- Static source, callback-name, cancellation-selector, completion-source retention, project-item, formatting, and diff checks completed.
- Restore and build were not run because repository instructions require separate user approval.
