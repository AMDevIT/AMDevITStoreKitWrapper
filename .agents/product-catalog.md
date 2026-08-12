# Product Catalog Step

## Objective

Expose complete, binding-friendly StoreKit product metadata while keeping Swift concurrency and native StoreKit types internal.

## Implemented API

- `StoreKitProduct` now exposes product type, localized type name, localized product information, numeric and display prices, currency, locale, Family Sharing support, subscription metadata, and the UTF-8 JSON representation.
- `StoreKitSubscriptionInfo` exposes group information, renewal period, introductory-offer eligibility, and introductory, promotional, and win-back offers.
- `StoreKitSubscriptionOffer` exposes identifier, type, price, payment mode, period, and period count.
- Objective-C-compatible integer enums represent product types, subscription period units, offer types, and offer payment modes.

## Product request behavior

- The public method is callback-based and named `getProducts(productIdentifiers:)`.
- Empty input or empty identifiers fail with `invalidArgument` without invalidating the current catalog.
- Duplicate identifiers are removed before calling StoreKit.
- Starting a valid request atomically invalidates the current catalog.
- StoreKit may return only a subset of the requested identifiers; this remains a successful operation and missing identifiers are logged as a warning.
- Product metadata is installed in the actor state only after every returned product has been wrapped.

## Compatibility decisions

- Numeric prices use `NSDecimalNumber` for Objective-C and .NET for iOS compatibility.
- Raw product JSON is exposed as `String`, not `Data`, because StoreKit documents it as UTF-8.
- Group display names use StoreKit's back-deployed API.
- Win-back offers are populated on iOS 18 and later; older systems receive an empty array.
- Transaction, entitlement, renewal status, beta subscription bundles, and advanced billing structures are intentionally outside this catalog step.

## Verification status

- Static diff and legacy-reference checks were performed.
- Compilation, generated Objective-C header inspection, and automated tests require a macOS/Xcode verification step and were not run.
