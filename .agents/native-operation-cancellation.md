# Native Operation Cancellation

## Objective

Make every asynchronous StoreKit manager operation cooperatively cancellable without exposing Swift concurrency through the Objective-C or .NET binding surface.

## Public contract

- `StoreKitManager` exposes one normal `void` cancellation selector for each operation category: initialization, shutdown, products, current entitlements, App Store synchronization, unfinished transactions, purchase, and transaction finishing.
- The selectors are Objective-C-compatible and are mirrored by `ApiDefinition.cs`.
- Cancellation completes through the existing delegate callback with `StoreKitWrapperErrorCode.operationCancelled`; no second callback channel was introduced.

## Internal implementation

- `StoreKitOperationTaskStore` owns the unstructured Swift tasks behind the callback API.
- Each task is recorded by operation category and a unique identifier under `NSLock`, including cancellation requests that race with task attachment.
- The manager checks task cancellation before committing mutable state and during StoreKit async sequences.
- Initialization cancellation restores the lifecycle to `uninitialized`; refresh cancellation leaves invalidated caches empty or preserves transactions received concurrently according to existing state rules.
- Transaction finishing releases its in-progress reservation when cancelled before `Transaction.finish()` starts.
- Purchase and transaction-finish results may win after the StoreKit operation has crossed a point where cancellation cannot reliably roll back the system action.

## Managed behavior

- `StoreKitClient` combines `Task.WaitAsync` with forwarding to the matching native selector.
- A cancelled caller stops waiting immediately, while the internal completion source remains reserved until the native callback drains.
- This deliberately prevents a callback from an old operation from completing a new operation in the same category.

## Verification status

- Static selector, source-registration, callback-retention, and state-transition checks are complete.
- Native actor/task-store tests were added for initialization reset and task cancellation delivery.
- Xcode tests, XCFramework regeneration, .NET restore, and .NET build remain pending explicit approval and the appropriate Apple build environment.
