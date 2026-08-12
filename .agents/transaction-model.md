# Transaction Model Step

## Objective

Represent StoreKit 2 transactions with binding-friendly DTOs while keeping `Transaction`, `VerificationResult`, and Swift concurrency internal.

## Implemented API

- `StoreKitTransaction` exposes identifiers, product and purchase metadata, price and currency, ownership, environment, storefront, transaction reason, revocation details, account token, applied offer, JSON, JWS, device-verification data, and verification outcome.
- `StoreKitTransactionOffer` exposes the applied offer identifier, offer type, payment mode, and period.
- Objective-C-compatible integer enums represent verification status and errors, ownership, environment, transaction reason, revocation reason, offer type, and offer payment mode.
- JWS, JSON, device verification, nonce, and UUID values are represented as strings suitable for a future .NET binding. Device verification uses Base64.

## Mapping decisions

- `StoreKitTransactionMapper` accepts only `VerificationResult<Transaction>`, preventing callers from accidentally separating a transaction from its StoreKit verification result.
- Verified and unverified payloads are both mapped, but unverified DTOs carry an explicit status, error code, and message so the consumer can reject them.
- Modern StoreKit properties are used where available. Deprecated StoreKit representations provide the iOS 15.6 fallback for environment, storefront country, transaction reason, and offer metadata.
- The StoreKit JWS is preserved as received. No second client-side signature verifier or server dependency is introduced.
- Subscription status, Advanced Commerce data, and native transaction references are intentionally excluded.

## Verification status

- `git diff --check` and static source searches completed without errors.
- Compilation, generated Objective-C header inspection, and automated tests require a macOS/Xcode verification step and were not run.
