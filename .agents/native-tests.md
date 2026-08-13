# Native Unit Tests Step

## Objective

Add deterministic Swift tests for internal synchronization, error translation, logging behavior, and the public values that form the future .NET binding contract.

## Implemented tests

- `StoreStateTests` covers initialization and shutdown idempotency, lifecycle gating, mutual exclusion for product, entitlement, synchronization, and unfinished-transaction requests, retry after cancellation, and the exclusion between unfinished refresh and transaction finishing.
- `StoreKitWrapperErrorMapperTests` covers Swift, StoreKit, and URL cancellation; network, system, storefront, entitlement, and unknown StoreKit failures; purchase-specific errors; and operation-specific fallbacks.
- `StoreKitWrapperLoggerTests` verifies that disabled levels aren't forwarded and enabled entries preserve level, event metadata, message, and `NSError` identity.
- `StoreKitWrapperPublicContractTests` locks all wrapper error-code raw values, purchase results, logging levels, product/subscription/transaction metadata enums, transaction-verification errors, and representative DTO construction and value preservation.

## Testability changes

- Internal state-result enums without associated values now conform to `Equatable` so actor outcomes can be asserted directly.
- No production API was added for tests.
- No StoreKit service abstraction or mock `Product`/`Transaction` layer was introduced; tests remain focused on logic that can be deterministic without an App Store environment.

## Verification status

- Static test discovery, raw-value consistency, source-reference, formatting, and diff checks were performed.
- Tests weren't compiled or executed because this Windows environment has no Xcode or Apple Swift toolchain.
- Run the `StoreKitWrapperTests` target on macOS after the native contract verification succeeds.
