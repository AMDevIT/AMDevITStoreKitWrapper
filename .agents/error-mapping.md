# Error Mapping Step

## Objective

Expose stable, Objective-C-compatible wrapper error codes while keeping native Swift and StoreKit error types internal.

## Implemented mapping

- `StoreKitWrapperErrorMapper` is an internal translation point shared by product retrieval, purchase, and App Store synchronization.
- Swift task cancellation, `StoreKitError.userCancelled`, cancelled `URLError` values, and user-cancelled URL authentication map to `operationCancelled`.
- Every StoreKit network, system, storefront, entitlement, unknown, and unsupported-operation error known to the verified SDK has a dedicated wrapper code.
- Every known purchase error has a dedicated wrapper code, including each invalid-offer variant, missing offer parameters, offer ineligibility, and payment-method binding requirements.
- Unknown future StoreKit cases map to `storeKitUnknown`; unknown future purchase cases retain the operation fallback `purchaseFailed`.
- Errors outside the recognized StoreKit families retain the operation-specific fallback code.

## Public boundary

- Only `StoreKitWrapperErrorCode` and a nullable error message cross the delegate boundary.
- Native errors are still passed to the internal logger as `NSError`, allowing a future .NET logger bridge to preserve domain and numeric error information.
- `Product.PurchaseResult.userCancelled` remains a normal purchase outcome with `StoreKitPurchaseResult.cancelled` and no wrapper error. A thrown cancellation remains an operation error and uses `operationCancelled`.

## Compatibility decision

- All cases known to the active StoreKit SDK are handled explicitly, including newly introduced and beta cases.
- Known StoreKit cases aren't collapsed into generic categories because doing so would discard actionable information at the Objective-C and future C# boundary.
- Documentation-only beta cases aren't referenced until they are present in the StoreKit SDK used to compile the framework.
- The `@unknown default` paths remain present for cases introduced by future SDKs.

## Verification status

- Static mapping-reference, callback-code, formatting, and diff checks completed without errors.
- Added the StoreKit cases required for exhaustive switches by current Swift compilers.
- Updated raw-value and mapper tests for the one-to-one public error contract.
- Removed the documentation-only beta `invalidPresentationContext` case after Xcode confirmed that it isn't present in the installed StoreKit SDK.
- Compilation and automated tests were not run because repository instructions require separate approval and a macOS/Xcode environment.
