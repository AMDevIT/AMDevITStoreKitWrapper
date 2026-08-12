# StoreKit Wrapper Context

## Objective and status

- Objective: establish callback-based, binding-friendly StoreKit product and transaction contracts for future cross-platform bindings.
- Status: product catalog and transaction DTO/mapper implemented; purchase and listener operations remain to be designed. Build and tests are pending explicit approval.

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

## Affected files

- `src/apple/StoreKitWrapper/StoreKitWrapper/StoreKitWrapperErrorCode.swift`
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
- `.agents/transaction-model.md`

## Checks

- Inspected the source diff and searched for references to the replaced logger methods and `isFaulted` callback parameter.
- Inspected the expanded product API and searched for the replaced `getProductsAsync` method and misspelled parameter.
- Ran `git diff --check` and static searches over the transaction DTO and mapper.
- Build and automated tests were not run because repository instructions require separate approval.

## Open issues and recommended next step

- Verify compilation and the generated Objective-C interface on macOS with Xcode.
- Verify availability guards for subscription metadata using the configured Xcode SDK.
- Add StoreKit product and transaction-mapper tests after the native API contract is confirmed.
- Design purchase results, transaction updates, entitlement callbacks, and transaction finishing next.
