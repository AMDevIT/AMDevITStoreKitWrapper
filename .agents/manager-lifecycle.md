# Manager Lifecycle Step

## Objective

Provide deterministic lifecycle management for the StoreKit manager and its retained transaction-listener task.

## Implemented API

- `StoreKitManager.shutdown()` permanently shuts down the manager asynchronously.
- `StoreKitManagerDelegate.shutdownCompleted` reports completion.
- `managerNotInitialized` and `managerShutdown` wrapper error codes report lifecycle violations consistently.
- `deinit` cancels the listener as a non-blocking safety fallback; explicit `shutdown()` remains the deterministic path.

## Lifecycle behavior

- `StoreState` owns the lifecycle transitions: uninitialized, initializing, initialized, shutting down, and shut down.
- Initialization remains idempotent. Concurrent initialization callers wait for the first initialization to complete rather than creating another listener.
- Shutdown is idempotent. Concurrent shutdown callers wait until the first shutdown has actually stopped the listener.
- Shutdown racing with initialization waits until the listener task is installed, then cancels it safely.
- The shutdown callback occurs only after listener cancellation has completed.
- A shut-down manager cannot be initialized again.
- Product retrieval, entitlement and unfinished-transaction refreshes, synchronization, purchase, and transaction finishing require an initialized manager and are rejected during or after shutdown.
- Operations that started before shutdown are allowed to complete and may still invoke their operation callback.
- Transaction updates stop being accepted as soon as the actor enters the shutting-down state.

## Ownership decision

- The listener task weakly captures the manager while waiting for transaction updates, avoiding a permanent manager-task retain cycle.
- The actor is captured independently so the listener can wait for initialization completion without retaining the manager.
- The delegate is not cleared automatically. This preserves lifecycle callbacks and leaves delegate ownership under application control.

## Verification status

- Static whitespace, lifecycle-reference, callback-reference, forbidden-main-dispatch, and diff checks completed without errors.
- Compilation, generated Objective-C header inspection, and automated tests were not run because they require separate approval and a macOS/Xcode environment.
