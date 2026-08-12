# StoreKit Wrapper Context

## Objective and status

- Objective: establish a complete callback-based StoreKit product catalog contract for future cross-platform bindings.
- Status: product catalog implemented; build and tests are pending explicit approval.

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

## Checks

- Inspected the source diff and searched for references to the replaced logger methods and `isFaulted` callback parameter.
- Inspected the expanded product API and searched for the replaced `getProductsAsync` method and misspelled parameter.
- Build and automated tests were not run because repository instructions require separate approval.

## Open issues and recommended next step

- Verify compilation and the generated Objective-C interface on macOS with Xcode.
- Verify availability guards for subscription metadata using the configured Xcode SDK.
- Add StoreKit product tests after the native API contract is confirmed.
- Design purchase results, transaction updates, and entitlement callbacks next.
