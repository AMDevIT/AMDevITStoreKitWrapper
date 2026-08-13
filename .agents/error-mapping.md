# Error Mapping Step

## Objective

Expose stable, Objective-C-compatible wrapper error codes while keeping native Swift and StoreKit error types internal.

## Implemented mapping

- `StoreKitWrapperErrorMapper` is an internal translation point shared by product retrieval, purchase, and App Store synchronization.
- Swift task cancellation, `StoreKitError.userCancelled`, cancelled `URLError` values, and user-cancelled URL authentication map to `operationCancelled`.
- StoreKit network, system, storefront, entitlement, and unknown errors have dedicated wrapper codes.
- Purchase errors distinguish unavailable products, disallowed purchases, invalid quantities, invalid offers, and offer ineligibility.
- Invalid offer identifier, price, signature, and missing parameters intentionally share `purchaseInvalidOffer`; the native localized message retains the detail.
- Unknown future StoreKit cases map to `storeKitUnknown`; unknown future purchase cases retain the operation fallback `purchaseFailed`.
- Errors outside the recognized StoreKit families retain the operation-specific fallback code.

## Public boundary

- Only `StoreKitWrapperErrorCode` and a nullable error message cross the delegate boundary.
- Native errors are still passed to the internal logger as `NSError`, allowing a future .NET logger bridge to preserve domain and numeric error information.
- `Product.PurchaseResult.userCancelled` remains a normal purchase outcome with `StoreKitPurchaseResult.cancelled` and no wrapper error. A thrown cancellation remains an operation error and uses `operationCancelled`.

## Compatibility decision

- Newly introduced or beta StoreKit cases aren't referenced directly until their SDK availability is verified. The `@unknown default` paths preserve forward compatibility in the meantime.

## Verification status

- Static mapping-reference, callback-code, formatting, and diff checks completed without errors.
- Compilation and automated tests were not run because repository instructions require separate approval and a macOS/Xcode environment.
