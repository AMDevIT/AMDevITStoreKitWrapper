# AMDevIT StoreKit Wrapper

[![Version](https://img.shields.io/badge/version-0.130.0-0A7EA4)](https://github.com/AMDevIT/AMDevITStoreKitWrapper)
[![iOS](https://img.shields.io/badge/iOS-15.6%2B-000000?logo=apple)](https://developer.apple.com/ios/)
[![.NET](https://img.shields.io/badge/.NET-10.0-512BD4?logo=dotnet)](https://dotnet.microsoft.com/)
[![Swift](https://img.shields.io/badge/Swift-5-F05138?logo=swift&logoColor=white)](https://www.swift.org/)
[![Project status](https://img.shields.io/badge/status-preview-F59E0B)](#project-status)
[![License](https://img.shields.io/github/license/AMDevIT/AMDevITStoreKitWrapper)](LICENSE)

AMDevIT StoreKit Wrapper is a native StoreKit 2 framework with a .NET 10 for iOS binding. It provides a callback-based API for products, purchases, entitlements, transaction recovery, and StoreKit merchandising views without exposing Swift concurrency or native StoreKit types to .NET applications.

> [!IMPORTANT]
> This project is currently a preview. The .NET binding builds successfully, but native compilation and runtime behavior still need final verification on macOS and iOS before production use.

## Features

- Loads complete product and subscription metadata.
- Handles purchases, pending results, cancellation, and transaction verification.
- Retrieves current entitlements and unfinished transactions.
- Listens for StoreKit transaction updates throughout the manager lifecycle.
- Finishes verified transactions explicitly after the application delivers the purchase.
- Exposes an explicit App Store synchronization operation for Restore Purchases flows.
- Maps StoreKit failures to stable, Objective-C-compatible error codes.
- Supports optional structured logging through a native logger protocol.
- Provides UIKit controllers backed by StoreKit SwiftUI views on iOS 17 and later.
- Keeps Swift concurrency, `Product`, `Transaction`, and `VerificationResult` behind the native boundary.

## Architecture

The repository contains two cooperating layers:

1. `src/apple/StoreKitWrapper` implements the StoreKit 2 framework in Swift and exposes an Objective-C-compatible surface.
2. `src/dotnet/AMDevIT.StoreKitWrapper` binds the packaged `StoreKitWrapper.xcframework` for .NET 10 for iOS.

All asynchronous native operations complete through `StoreKitManagerDelegate`. This allows .NET consumers to use StoreKit 2 without crossing the binding boundary with Swift actors, tasks, async sequences, or generic StoreKit values.

## Requirements

- .NET 10 SDK with the iOS workload.
- iOS 15.6 or later.
- macOS and a compatible Xcode installation for native framework builds, signing, simulator execution, or device deployment.
- iOS 17 or later when using the native StoreKit view controllers.
- StoreKit products configured in App Store Connect or in an Xcode StoreKit Configuration file.

## Quick start

### 1. Install or reference the binding

The binding is configured as the `AMDevIT.StoreKitWrapper` NuGet package. After it is published, install version `0.130.0` from the configured NuGet source:

```bash
dotnet add package AMDevIT.StoreKitWrapper --version 0.130.0
```

Until the first public release, clone this repository and either create a local package or add a direct project reference. To produce and consume the local package from the repository root:

```bash
dotnet pack src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper.slnx --configuration Release
dotnet add package AMDevIT.StoreKitWrapper --version 0.130.0 --source ./artifacts/packages
```

Alternatively, add a project reference from the consuming .NET for iOS application:

```xml
<ItemGroup>
    <ProjectReference Include="../AMDevITStoreKitWrapper/src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper.csproj" />
</ItemGroup>
```

Adjust the relative path to match the location of the repositories on your machine.

### 2. Implement the StoreKit delegate

Derive from the generated `StoreKitManagerDelegate` model and override every callback that the native protocol can invoke. The following delegate initializes a product catalog and shows the essential transaction flow:

```csharp
using AMDevIT.StoreKitWrapper;

public sealed class AppStoreKitDelegate : StoreKitManagerDelegate
{
    #region Properties

    public StoreKitManager? Manager { get; set; }

    #endregion

    #region Methods

    public override void InitializationCompletedWithErrorCode(StoreKitWrapperErrorCode errorCode,
                                                               string? errorMessage)
    {
        if (errorCode == StoreKitWrapperErrorCode.None)
        {
            this.Manager?.GetProductsWithProductIdentifiers(["com.example.premium"]);
            return;
        }

        Console.WriteLine($"StoreKit initialization failed: {errorMessage}");
    }

    public override void AvailableProductsCompletedWithResult(StoreKitProduct[] withResult,
                                                              StoreKitWrapperErrorCode errorCode,
                                                              string? errorMessage)
    {
        foreach (StoreKitProduct product in withResult)
        {
            Console.WriteLine($"{product.DisplayName}: {product.DisplayPrice}");
        }
    }

    public override void PurchaseCompletedWithResult(StoreKitTransaction? withResult,
                                                     StoreKitPurchaseResult purchaseResult,
                                                     StoreKitWrapperErrorCode errorCode,
                                                     string? errorMessage)
    {
        Console.WriteLine($"Purchase result: {purchaseResult}");

        // Persist and deliver a verified purchase before finishing its transaction.
        if (withResult?.VerificationStatus == StoreKitTransactionVerificationStatus.Verified)
        {
            DeliverPurchase(withResult);
        }
    }

    public override void TransactionUpdatedWithResult(StoreKitTransaction withResult,
                                                      StoreKitWrapperErrorCode errorCode,
                                                      string? errorMessage)
    {
        // Updates include unfinished startup transactions and purchases from other devices.
        if (withResult.VerificationStatus == StoreKitTransactionVerificationStatus.Verified)
        {
            DeliverPurchase(withResult);
        }
    }

    public override void FinishTransactionCompletedWithTransactionIdentifier(ulong transactionIdentifier,
                                                                             StoreKitWrapperErrorCode errorCode,
                                                                             string? errorMessage)
    {
        Console.WriteLine($"Finished transaction {transactionIdentifier}: {errorCode}");
    }

    public override void CurrentEntitlementsCompletedWithResult(StoreKitTransaction[] withResult,
                                                                StoreKitWrapperErrorCode errorCode,
                                                                string? errorMessage)
    {
    }

    public override void UnfinishedTransactionsCompletedWithResult(StoreKitTransaction[] withResult,
                                                                   StoreKitWrapperErrorCode errorCode,
                                                                   string? errorMessage)
    {
    }

    public override void AppStoreSyncCompletedWithErrorCode(StoreKitWrapperErrorCode errorCode,
                                                            string? errorMessage)
    {
    }

    public override void ShutdownCompletedWithErrorCode(StoreKitWrapperErrorCode errorCode,
                                                        string? errorMessage)
    {
    }

    private void DeliverPurchase(StoreKitTransaction transaction)
    {
        // Persist the entitlement and deliver the content here. Finish only after success.
        this.Manager?.FinishTransactionWithTransactionIdentifier(transaction.Identifier);
    }

    #endregion
}
```

Replace `DeliverPurchase` with an idempotent delivery process backed by durable application storage. Never grant content solely because a transaction object exists: first confirm that `VerificationStatus` is `Verified`.

### 3. Create and initialize the manager

Keep strong references to both objects for as long as StoreKit callbacks are required:

```csharp
private readonly AppStoreKitDelegate storeKitDelegate;
private readonly StoreKitManager storeKitManager;

public MyStoreService()
{
    this.storeKitDelegate = new AppStoreKitDelegate();
    this.storeKitManager = new StoreKitManager(logger: null,
                                               @delegate: this.storeKitDelegate);
    this.storeKitDelegate.Manager = this.storeKitManager;
}

public void Initialize()
{
    this.storeKitManager.Initialize();
}

public void PurchasePremium()
{
    this.storeKitManager.PurchaseWithProductIdentifier("com.example.premium");
}

public void Shutdown()
{
    this.storeKitManager.Shutdown();
}
```

Call `Initialize` early in the application lifecycle so the persistent `Transaction.updates` listener can recover pending changes. Wait for `InitializationCompletedWithErrorCode` before requesting products or starting other operations.

## Common operations

After successful initialization, the manager exposes these callback-based operations:

| Operation | Completion callback | Purpose |
| --- | --- | --- |
| `GetProductsWithProductIdentifiers(...)` | `AvailableProductsCompletedWithResult(...)` | Load the current product catalog. |
| `PurchaseWithProductIdentifier(...)` | `PurchaseCompletedWithResult(...)` | Start a programmatic purchase. |
| `GetCurrentEntitlements()` | `CurrentEntitlementsCompletedWithResult(...)` | Reconstruct access currently granted to the customer. |
| `GetUnfinishedTransactions()` | `UnfinishedTransactionsCompletedWithResult(...)` | Recover verified transactions that still require delivery or finishing. |
| `FinishTransactionWithTransactionIdentifier(...)` | `FinishTransactionCompletedWithTransactionIdentifier(...)` | Finish a transaction after successful delivery. |
| `Sync()` | `AppStoreSyncCompletedWithErrorCode(...)` | Implement an explicit, user-initiated Restore Purchases action. |
| `Shutdown()` | `ShutdownCompletedWithErrorCode(...)` | Stop the transaction listener deterministically. |

Transactions arriving independently of a programmatic purchase are reported through `TransactionUpdatedWithResult(...)`.

## Native StoreKit views

On iOS 17 and later, the framework exposes ordinary UIKit controllers that internally host StoreKit SwiftUI merchandising views:

- `StoreKitProductViewController` for a single product.
- `StoreKitProductsViewController` for multiple products.
- `StoreKitSubscriptionsViewController` for a subscription group.

```csharp
StoreKitProductViewController productController = new("com.example.premium");

PresentViewController(productController, animated: true, completionHandler: null);
```

The application owns presentation, navigation, parent containment, and external Auto Layout constraints. Initialize `StoreKitManager` before presenting a controller: purchases started by these views are delivered through `TransactionUpdatedWithResult(...)`, not `PurchaseCompletedWithResult(...)`.

## Build and verification

Build the .NET binding from its solution directory:

```bash
cd src/dotnet/AMDevIT.StoreKitWrapper
dotnet restore
dotnet build
```

Create the NuGet package from the repository root:

```bash
dotnet pack src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper.slnx --configuration Release
```

The package is written to `artifacts/packages` and includes the binding assembly, native XCFramework, README, license, package icon, and NuGet metadata. Packing does not publish the package; use an authenticated NuGet source explicitly when it is ready for release.

On macOS with Xcode installed, build the native framework and verify its generated Objective-C interface:

```bash
bash scripts/verify-native-contract.sh
```

The script builds the Release framework for the iOS Simulator and validates the installed `StoreKitWrapper-Swift.h`, including the expected public API and the absence of internal Swift implementation types.

## Project status

- Native StoreKit implementation: implemented; macOS/Xcode verification pending.
- Objective-C-compatible contract: implemented; generated-header verification script available.
- Native deterministic tests: implemented; execution on macOS pending.
- .NET 10 for iOS binding: restored and built successfully with zero warnings and errors in the recorded project verification.
- NuGet packaging: configured for package ID `AMDevIT.StoreKitWrapper`; package creation and content inspection pending.
- Consumer application and real StoreKit runtime validation: pending on macOS/iOS.

See the files in `.agents` for the progressive implementation notes and verification history.

## License

Licensed under the [Apache License 2.0](LICENSE).
