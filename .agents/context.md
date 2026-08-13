# StoreKit Wrapper Context

## Objective and status

- Objective: establish callback-based, binding-friendly StoreKit lifecycle, product, transaction, purchase, entitlement, synchronization, unfinished-transaction, and update-listener contracts for future cross-platform bindings.
- Status: the native StoreKit implementation and Objective-C-visible contract are implemented, and a repeatable Xcode contract-verification script is available. Its execution and automated StoreKit tests remain pending a macOS/Xcode environment.

## Decisions

- Swift concurrency remains internal; public operations complete through delegate callbacks.
- Product refreshes invalidate the cached catalog immediately.
- `StoreState` permits only one product request at a time through an actor-isolated flag.
- Failed and cancelled refreshes leave the product catalog empty.
- Wrapper error codes use an Objective-C-compatible integer enum.
- Logging follows the core `Microsoft.Extensions.Logging.ILogger` model: `isEnabled` and a single `log` requirement, with Swift convenience methods for individual levels.
- Logger callbacks are not dispatched to the main thread by the wrapper.
- Product metadata is represented by wrapper DTOs; no native `Product` or Swift concurrency type is exposed.
- Numeric prices use `NSDecimalNumber`, and raw product JSON uses a UTF-8 `String`.
- Valid product requests are deduplicated and invalidate the previous catalog immediately.
- Missing products produce a warning while preserving successful partial results.
- Native `Transaction` and `VerificationResult` values remain internal and are converted together by one mapper.
- Transaction JSON and JWS are exposed as strings; device verification is exposed as Base64 and its nonce as a UUID string.
- Unverified transactions remain representable but carry an explicit verification status, error code, and message.
- Modern transaction metadata uses availability-guarded iOS 15.6 fallbacks where StoreKit provides them.
- One purchase operation at a time is enforced atomically by `StoreState` before StoreKit is called.
- Purchase callbacks distinguish success, pending approval, user cancellation, failure, and unknown future results.
- Verified native transactions are retained internally until the application explicitly finishes them by identifier.
- Unverified transactions are returned for diagnostics but cannot be finished through the wrapper.
- App account tokens use nullable UUID strings at the public boundary; purchase quantities are limited to StoreKit's range of 1 through 10.
- Initialization is idempotent and actor-isolated; repeated calls complete successfully without creating another listener.
- `Transaction.updates` starts during initialization and reports verified and unverified transactions through the delegate.
- Verified listener transactions are stored before their callbacks and are immediately available for explicit finishing.
- Listener events are not permanently deduplicated because an existing transaction may receive a meaningful update.
- Manager lifecycle transitions are actor-isolated and include initializing and shutting-down intermediate states.
- Concurrent initialization and shutdown callers wait for the active lifecycle transition and receive their callback only after it completes.
- Explicit shutdown cancels and awaits the transaction listener; `deinit` provides a non-blocking cancellation fallback.
- Product retrieval, purchase, and transaction finishing require an initialized manager and reject new calls during or after shutdown.
- Operations already active when shutdown starts are allowed to complete normally.
- Current entitlement refreshes are actor-serialized and immediately invalidate the previous internal entitlement cache.
- Verified and unverified entitlement results are returned together, with an aggregate verification error when necessary.
- Only verified current entitlements enter the internal cache; entitlement enumeration never marks transactions as unfinished.
- App Store synchronization is actor-serialized and exposed only as an explicit public operation.
- User, task, URL, and authentication cancellation map to `operationCancelled`; recognized StoreKit and network failures use stable wrapper codes, while unrecognized synchronization errors map to `appStoreSyncFailed`.
- Synchronization doesn't automatically refresh current entitlements; transaction listener callbacks remain active during synchronization.
- Unfinished-transaction refreshes invalidate the previous finishable cache and are mutually exclusive with transaction finishing.
- Verified purchase and listener transactions received during an unfinished refresh are preserved and merged into the final cache.
- Recovered verified transactions are finishable before their callback; unverified results remain diagnostic-only.
- Product, purchase, and synchronization failures use one internal mapper rather than operation-specific StoreKit switches.
- StoreKit network, system, storefront, entitlement, and unknown failures have stable wrapper codes.
- Purchase failures distinguish unavailable products, disallowed purchases, invalid quantities, invalid offers, and offer ineligibility.
- Native StoreKit errors remain internal; delegate callbacks expose only an Objective-C-compatible integer code and message.
- Public manager and DTO classes inherit from `NSObject` and explicitly export Objective-C-compatible members.
- Public delegates and loggers are class-bound Objective-C protocols; all public enums use Objective-C-compatible integer raw values.
- The manager provides explicit Objective-C initializers and purchase overloads instead of relying on Swift default arguments.
- The framework installs a generated Objective-C header named `StoreKitWrapper-Swift.h`.
- Native contract verification builds the Release iOS Simulator framework and validates the installed generated header, not only the Swift source.
- The StoreKit framework reference is relative to the active Apple SDK rather than a hardcoded local Xcode SDK path.

## Affected files

- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitWrapperErrorCode.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitWrapperErrorMapper.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/Diagnostics/StoreKitWrapperLogLevel.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/Diagnostics/IStoreKitWrapperLogger.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitManagerDelegate.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreState.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitManager.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitProduct.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitProductType.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitSubscriptionInfo.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitSubscriptionOffer.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitSubscriptionOfferPaymentMode.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitSubscriptionOfferType.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitSubscriptionPeriod.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitSubscriptionPeriodUnit.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitTransaction.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitTransactionMapper.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitTransactionOffer.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitTransactionTypes.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitPurchaseResult.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper.xcodeproj/project.pbxproj`
- `.agents/transaction-model.md`
- `.agents/purchase-flow.md`
- `.agents/transaction-listener.md`
- `.agents/manager-lifecycle.md`
- `.agents/current-entitlements.md`
- `.agents/app-store-sync.md`
- `.agents/unfinished-transactions.md`
- `.agents/error-mapping.md`
- `.agents/native-contract.md`
- `scripts/verify-native-contract.sh`
- `README.md`
- `.agents/native-verification.md`

## Checks

- Inspected the source diff and searched for references to the replaced logger methods and `isFaulted` callback parameter.
- Inspected the expanded product API and searched for the replaced `getProductsAsync` method and misspelled parameter.
- Ran `git diff --check` and static searches over the transaction DTO and mapper.
- Ran static whitespace, callback-reference, actor-state, and diff checks over the purchase and finish implementation.
- Ran static whitespace, callback-reference, main-thread-dispatch, actor-state, and diff checks over initialization and the transaction listener.
- Ran static whitespace, lifecycle-reference, callback-reference, main-thread-dispatch, and diff checks over deterministic shutdown and operation gating.
- Ran static whitespace, callback-reference, lifecycle-gating, verification-path, main-thread-dispatch, and diff checks over current entitlement retrieval.
- Ran static whitespace, callback-reference, lifecycle-gating, cancellation-path, main-thread-dispatch, and diff checks over App Store synchronization.
- Ran static whitespace, callback-reference, lifecycle-gating, finish-exclusion, concurrent-update-preservation, main-thread-dispatch, and diff checks over unfinished-transaction recovery.
- Ran static mapping-reference, callback-code, formatting, and diff checks over centralized StoreKit and purchase error translation.
- Ran static Objective-C surface, public-type leakage, generated-header-setting, selector-overload, formatting, and diff checks over the native contract.
- Added a macOS verification script that builds the framework and asserts the expected generated Objective-C declarations and absence of internal Swift implementation types.
- Replaced the machine-specific StoreKit framework reference with an `SDKROOT`-relative framework reference.
- Confirmed that this Windows environment doesn't provide `xcodebuild`, `swiftc`, or `swift`; the new native verification script was therefore not executed.
- Build and automated tests were not run because repository instructions require separate approval.

## Open issues and recommended next step

- Verify compilation and the generated Objective-C interface on macOS with Xcode.
- Verify availability guards for subscription metadata using the configured Xcode SDK.
- Add StoreKit product, transaction-mapper, purchase-state, entitlement-state, unfinished-state, and finish-state tests after the native API contract is confirmed.
- Run `bash scripts/verify-native-contract.sh` on macOS and resolve any compiler or generated-header differences it reports.
- Add StoreKit product, transaction-mapper, purchase-state, entitlement-state, unfinished-state, and finish-state tests after the generated native contract passes.
