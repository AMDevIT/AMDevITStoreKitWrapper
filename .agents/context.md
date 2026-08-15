# StoreKit Wrapper Context

## Latest step: managed StoreKit client

- Objective: provide an idiomatic task-based .NET facade over the native callback API without changing Objective Sharpie output.
- Status: `StoreKitClient`, its interface, native delegate bridge, managed result/event/exception types, project registration, and README guidance are implemented; compilation and runtime verification remain pending separate approval.
- Decisions: retain the generated `StoreKitManager` name; use independent completion sources with asynchronous continuations; expose transaction updates as same-thread events; reject duplicate category operations locally; accept cancellation tokens but only check pre-cancellation before invoking Swift.
- Affected files: the new managed client sources, the binding `.csproj`, `README.md`, `.agents/managed-storekit-client.md`, and `.agents/context.md`.
- Checks: verified all eight async methods have cancellation pre-checks, all nine native callbacks have delegate overrides, every new source is registered, project XML parses, no main-thread dispatch or in-flight cancellation registration was introduced, and scoped formatting/diff checks pass.
- Open issues and recommended next step: with user approval, restore and build the binding; then validate callback correlation, disposal, listener events, and error propagation in an iOS consumer before adding real in-flight cancellation.

## Latest step: NuGet packaging

- Objective: configure the .NET 10 for iOS binding as a publishable NuGet package with complete metadata, documentation, licensing, and a deterministic output location.
- Status: configuration completed; restore, build, pack, package inspection, and consumer validation remain pending separate approval.
- Decisions: use package ID `AMDevIT.StoreKitWrapper`, version `0.130.0`, author `Alessandro Morvillo`, and company/copyright `AMDev.IT di Alessandro Morvillo`; embed README, LICENSE, and an optimized 128x128 package icon; write packages to `artifacts/packages`; do not claim public availability before publication.
- Affected files: the binding `.csproj`, `README.md`, `assets/icons/nuget_icon_128.png`, `.agents/nuget-packaging.md`, and `.agents/context.md`.
- Checks: package properties, paths, XML structure, documentation, icon dimensions, icon size, visual preservation, and scoped diffs were checked statically. No restore, build, or pack command was run.
- Open issues and recommended next step: with user approval, restore, build, pack, inspect the `.nupkg`, and consume it from a local feed before publishing.

## Latest step: README refresh

- Objective: document the project definition, important and truthful shields, requirements, quick-start usage, common operations, native StoreKit views, verification workflow, and project status.
- Status: completed. The README now reflects the current Swift framework and .NET 10 for iOS binding surface.
- Decisions: keep the README in English; omit unsupported CI, NuGet, and release shields; require verified and durably delivered transactions before finishing; use the generated C# API names in examples.
- Affected files: `README.md`, `.agents/readme-refresh.md`, and `.agents/context.md`.
- Checks: API names, enum names, versions, targets, paths, Markdown structure, links, and repository diff were checked statically. Restore and build were not run because they require separate approval.
- Open issues and recommended next step: run the existing native checks on macOS/Xcode and restore/build the .NET binding when separately authorized; update installation guidance if a NuGet package is published.

## Objective and status

- Objective: establish callback-based, binding-friendly StoreKit lifecycle, product, transaction, purchase, entitlement, synchronization, unfinished-transaction, update-listener, and .NET for iOS binding contracts.
- Status: the native StoreKit implementation, Objective-C-visible contract, deterministic tests, Xcode verification script, UIViewController wrappers, and .NET 10 for iOS binding definitions are implemented. The .NET binding builds successfully; native execution remains pending a macOS/iOS environment.

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
- Applied-offer periods are populated only on iOS 18.4 and later; earlier supported versions expose the remaining offer metadata with a `nil` period.
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
- Every currently known StoreKit and purchase failure has a distinct, stable wrapper code; only future unknown cases use generic fallbacks.
- Native StoreKit errors remain internal; delegate callbacks expose only an Objective-C-compatible integer code and message.
- Public manager and DTO classes inherit from `NSObject` and explicitly export Objective-C-compatible members.
- Public delegates and loggers are class-bound Objective-C protocols; all public enums use Objective-C-compatible integer raw values.
- The manager provides explicit Objective-C initializers and purchase overloads instead of relying on Swift default arguments.
- The framework installs a generated Objective-C header named `StoreKitWrapper-Swift.h`.
- Native contract verification builds the Release iOS Simulator framework and validates the installed generated header, not only the Swift source.
- The StoreKit framework reference is relative to the active Apple SDK rather than a hardcoded local Xcode SDK path.
- Native tests cover actor lifecycle and exclusion rules, centralized error mapping, logger filtering and forwarding, stable enum raw values, and representative DTO construction.
- Internal state-result enums without payloads conform to `Equatable` solely to support direct deterministic assertions.
- StoreKit service injection and StoreKit Test integration remain deferred to avoid an invasive production refactor before the native framework compiles on macOS.
- StoreKit SwiftUI merchandising is exposed only through concrete `UIViewController` subclasses; SwiftUI and `UIHostingController` remain internal.
- The .NET application will own presentation, containment, and external Auto Layout constraints for these controllers.
- StoreKit-view purchases will be reported through `transactionUpdated`; `purchaseCompleted` remains specific to programmatic manager purchases.
- Applications must initialize `StoreKitManager` before presenting these controllers to receive their completed transactions through the listener.
- Product, products, and subscription-group controllers are available on iOS 17 and later while the framework retains its iOS 15.6 deployment target.
- An internal hosting container installs one `UIHostingController` child using full-edge Auto Layout constraints and prevents duplicate installation.
- The StoreKitWrapper framework marketing version is `0.130.0` for both Debug and Release; its build and Mach-O compatibility versions remain independent.
- The .NET binding represents implementable native protocols with generated interfaces and subclassable model classes by combining `Model`, `Protocol`, and an `NSObject` base type.
- The .NET binding omits explicit `ViewDidLoad` declarations for the StoreKit controllers because the member is already inherited from `UIViewController`.
- The binding project references the StoreKitWrapper XCFramework and its Foundation, StoreKit, SwiftUI, and UIKit dependencies.
- The .NET binding provides `StoreKitClient` as a task-based managed facade while retaining the Sharpie-generated `StoreKitManager` as its low-level native API.
- Managed task continuations are asynchronous, while transaction-update events remain on the native callback thread.
- Managed methods accept cancellation tokens but currently check them only before invoking Swift; in-flight cancellation remains deferred.

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
- `src/apple/StoreKitWrapper/StoreKitWrapperTests/StoreStateTests.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapperTests/StoreKitWrapperErrorMapperTests.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapperTests/StoreKitWrapperLoggerTests.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapperTests/StoreKitWrapperPublicContractTests.swift`
- `.agents/native-tests.md`
- `.agents/storekit-view-controllers.md`
- `.agents/dotnet-binding.md`
- `src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/ApiDefinition.cs`
- `src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/StructsAndEnums.cs`
- `src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper.csproj`
- `src/apple/StoreKitWrapper/StoreKitWrapper/Views/StoreKitViewHostingContainer.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/Views/StoreKitProductViewController.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/Views/StoreKitProductsViewController.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapper/Views/StoreKitSubscriptionsViewController.swift`
- `src/apple/StoreKitWrapper/StoreKitWrapperTests/StoreKitViewControllerTests.swift`
- `.agents/managed-storekit-client.md`
- `src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/IStoreKitClient.cs`
- `src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/StoreKitClient.cs`
- `src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/StoreKitClientDelegate.cs`
- `src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/StoreKitPurchaseOutcome.cs`
- `src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/StoreKitTransactionUpdatedEventArgs.cs`
- `src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/StoreKitWrapperException.cs`

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
- Added deterministic Swift Testing coverage for actor state, error mapping, logging, ABI-stable enum values, and binding DTOs.
- Performed static test discovery, raw-value consistency, source-reference, formatting, and diff checks; native tests weren't compiled or executed because the Apple toolchain is unavailable.
- Added the three public StoreKit view controllers, their internal hosting container, generated-header assertions, and deterministic containment tests.
- Corrected the nested iOS 18.4 availability check required by `Transaction.Offer.period` and performed static source and diff validation.
- Made the `StoreKitError` and `Product.PurchaseError` switches exhaustive for the current StoreKit SDK while preserving future `@unknown default` fallbacks.
- Replaced generic mappings for known StoreKit and purchase failures with one-to-one public error codes and updated their deterministic contract tests.
- Removed the documentation-only beta `StoreKitError.invalidPresentationContext` mapping because the installed StoreKit SDK doesn't expose that symbol.
- Updated the StoreKitWrapper framework `MARKETING_VERSION` to `0.130.0` in Debug and Release.
- Native Swift compilation and automated tests were not run as part of this Windows-side .NET binding verification.
- Restored and built the .NET 10 for iOS binding project successfully with zero warnings and zero errors after correcting protocol model generation and removing duplicate `ViewDidLoad` bindings.
- Inspected generated binding sources and confirmed that both logger/delegate interfaces and abstract protocol model classes are emitted.
- A repository-wide `git diff --check` encountered Windows path-length errors inside the XCFramework; the scoped check for the edited binding definition passed.
- Added the task-based `StoreKitClient`, its native callback bridge, typed purchase and transaction-update results, managed exception, cancellation-token placeholders, project registration, and usage documentation.

## Open issues and recommended next step

- Verify compilation and the generated Objective-C interface on macOS with Xcode.
- Verify availability guards for subscription metadata using the configured Xcode SDK.
- Add StoreKit product, transaction-mapper, purchase-state, entitlement-state, unfinished-state, and finish-state tests after the native API contract is confirmed.
- Run `bash scripts/verify-native-contract.sh` on macOS and resolve any compiler or generated-header differences it reports.
- Compile and run the `StoreKitWrapperTests` target on macOS.
- Add StoreKit Configuration integration tests and any necessary internal service injection only after the deterministic suite and generated contract pass.
- Verify the three view controllers against the intended Xcode SDK and StoreKit Configuration on macOS.
- Link the generated .NET binding into a consumer iOS application and verify manager construction, protocol callbacks, and StoreKit view-controller presentation on macOS/iOS.
- Build and validate `StoreKitClient` against native callbacks on iOS after receiving verification approval.
- Add in-flight cancellation forwarding only after the Swift manager exposes deterministic cancellation and terminal callbacks.
