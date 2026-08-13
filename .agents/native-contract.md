# Objective-C Native Contract Step

## Objective

Make the native Swift surface deterministically visible in the framework's generated Objective-C header so it can be consumed by a .NET for iOS binding project.

## Exported boundary

- `StoreKitManager` is a final `NSObject` subclass and exports its Objective-C-compatible public members.
- `StoreKitManagerDelegate` and `IStoreKitWrapperLogger` are class-bound Objective-C protocols.
- Product, subscription, transaction, and offer DTOs are final `NSObject` subclasses whose public immutable properties are Objective-C visible.
- All public wrapper enums are Objective-C-compatible `Int` enums.
- Swift concurrency, actors, native StoreKit types, verification results, tasks, and internal mappers remain outside the Objective-C contract.

## Manager construction and methods

- The manager has an Objective-C-visible parameterless initializer and an initializer accepting optional logger and delegate implementations.
- `initialize()` now follows Swift naming conventions and replaces the previous uppercase `Initialize()` spelling.
- Purchase has explicit one-, two-, and three-argument overloads. This avoids relying on Swift default arguments, which don't create Objective-C overloads.
- All asynchronous work still completes through the delegate protocol; no `async` method crosses the public boundary.

## Framework configuration

- `DEFINES_MODULE` is explicitly enabled for Debug and Release.
- `SWIFT_INSTALL_OBJC_HEADER` is enabled for Debug and Release.
- The generated interface header has the stable name `StoreKitWrapper-Swift.h`.
- `BUILD_LIBRARY_FOR_DISTRIBUTION` remains enabled.

## Verification status

- Static checks confirm that every public class or protocol at the wrapper boundary is Objective-C enabled and that all public enums use `@objc` with `Int` raw values.
- Static checks confirm that no actor, `Task`, `async` method, `Product`, `Transaction`, or `VerificationResult` occurs in a public declaration.
- The actual generated header still needs to be inspected on macOS after an Xcode build; repository instructions require separate authorization for that build.
