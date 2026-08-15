# .NET for iOS Binding Step

## Objective

Generate and validate the .NET 10 for iOS binding definitions for the StoreKitWrapper XCFramework.

## Implemented binding

- `ApiDefinition.cs` maps the native manager, logger and delegate protocols, product and transaction DTOs, StoreKit view controllers, properties, methods, and Objective-C selectors.
- `StructsAndEnums.cs` maps all 15 Objective-C-compatible native enums.
- The binding project references `StoreKitWrapper.xcframework` and its Foundation, StoreKit, SwiftUI, and UIKit dependencies.
- Protocol definitions use `[Model]`, `[Protocol]`, and `[BaseType(typeof(NSObject))]`. This generates both `IStoreKitWrapperLogger` / `IStoreKitManagerDelegate` interfaces and subclassable `StoreKitWrapperLogger` / `StoreKitManagerDelegate` model classes.
- The `StoreKitManager` constructor and delegate wrapper use the generated model classes, avoiding unresolved protocol types during binding generation.
- Explicit `ViewDidLoad` declarations were removed from the three controller bindings because `UIViewController` already provides that member.

## Verification status

- `dotnet restore` completed successfully from `src/dotnet/AMDevIT.StoreKitWrapper`.
- `dotnet build` completed successfully for `net10.0-ios` with zero warnings and zero errors on Windows using the installed iOS workload.
- Generated sources contain both protocol interfaces and abstract model classes.
- Scoped `git diff --check` for `ApiDefinition.cs` completed without errors. A repository-wide diff check could not inspect several long XCFramework paths on Windows.
- Native linking, packaging in a consumer application, and runtime callback behavior still require testing on macOS/iOS.
