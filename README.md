# AMDevIT StoreKit Wrapper

[![NuGet version](https://img.shields.io/nuget/v/AMDevIT.StoreKitWrapper?logo=nuget)](https://img.shields.io/nuget/v/AMDevIT.StoreKitWrapper)
[![iOS](https://img.shields.io/badge/iOS-15.6%2B-000000?logo=apple)](https://developer.apple.com/ios/)
[![Mac Catalyst](https://img.shields.io/badge/Mac%20Catalyst-15.6%2B-000000?logo=apple)](https://developer.apple.com/mac-catalyst/)
[![.NET](https://img.shields.io/badge/.NET-10.0-512BD4?logo=dotnet)](https://dotnet.microsoft.com/)
[![Swift](https://img.shields.io/badge/Swift-5-F05138?logo=swift&logoColor=white)](https://www.swift.org/)
[![Project status](https://img.shields.io/badge/status-preview-F59E0B)](#project-status)
[![License: Apache-2.0](https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg)](LICENSE)

AMDevIT StoreKit Wrapper is a native StoreKit 2 framework with a .NET 10 binding for iOS and Mac Catalyst. It provides a callback-based API for products, purchases, entitlements, transaction recovery, and StoreKit merchandising views without exposing Swift concurrency or native StoreKit types to .NET applications.

## Features

- Loads complete product and subscription metadata.
- Handles purchases, pending results, cancellation, and transaction verification.
- Retrieves current entitlements and unfinished transactions.
- Listens for StoreKit transaction updates throughout the manager lifecycle.
- Finishes verified transactions explicitly after the application delivers the purchase.
- Exposes an explicit App Store synchronization operation for Restore Purchases flows.
- Maps StoreKit failures to stable, Objective-C-compatible error codes.
- Bridges optional native structured logging to `Microsoft.Extensions.Logging` in the managed client.
- Provides a managed `StoreKitClient` facade with task-based .NET APIs.
- Provides UIKit controllers backed by StoreKit SwiftUI views on iOS and Mac Catalyst 17.0 or later.
- Keeps Swift concurrency, `Product`, `Transaction`, and `VerificationResult` behind the native boundary.

## Architecture

The repository contains two cooperating layers:

1. `src/apple/StoreKitWrapper` implements the StoreKit 2 framework in Swift and exposes an Objective-C-compatible surface.
2. `src/dotnet/AMDevIT.StoreKitWrapper` binds the packaged `StoreKitWrapper.xcframework` for .NET 10 for iOS and Mac Catalyst.

All asynchronous native operations complete through `StoreKitManagerDelegate`. The managed `StoreKitClient` converts those callbacks into .NET tasks while preserving `StoreKitManager` as the directly bound low-level API. This allows .NET consumers to use StoreKit 2 without crossing the binding boundary with Swift actors, tasks, async sequences, or generic StoreKit values.

## Requirements

- .NET 10 SDK with the iOS and Mac Catalyst workloads required by the target application.
- iOS 15.6 or Mac Catalyst 15.6 or later.
- macOS and a compatible Xcode installation for native framework builds, signing, simulator execution, or device deployment.
- iOS 17 or Mac Catalyst 17.0 or later when using the native StoreKit view controllers.
- StoreKit products configured in App Store Connect or in an Xcode StoreKit Configuration file.

## Quick start

### 1. Install the binding

Install the published [`AMDevIT.StoreKitWrapper`] (https://www.nuget.org/packages/AMDevIT.StoreKitWrapper) package from NuGet.org:

```bash
dotnet add package AMDevIT.StoreKitWrapper 
```

For repository development, clone the project and either create a local package or add a direct project reference. To produce and consume the local package from the repository root:

```bash
dotnet pack src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper.slnx --configuration Release
dotnet add package AMDevIT.StoreKitWrapper --version <version> --source ./artifacts/packages
```

where version is the current package version built from sources.
Alternatively, add a project reference from the consuming .NET for iOS or Mac Catalyst application:

```xml
<ItemGroup>
    <ProjectReference Include="../AMDevITStoreKitWrapper/src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper.csproj" />
</ItemGroup>
```

Adjust the relative path to match the location of the repositories on your machine.

### 2. Use the managed async client

`StoreKitClient` is the recommended application-facing API. It owns a native `StoreKitManager`, translates operation callbacks into tasks, and exposes independent transaction-listener updates as an event:

```csharp
private readonly StoreKitClient storeKitClient;

public MyStoreService(ILogger<StoreKitClient> logger)
{
    this.storeKitClient = new StoreKitClient(logger);
    this.storeKitClient.TransactionUpdated += this.OnTransactionUpdated;
}

public async Task InitializeAsync(CancellationToken cancellationToken)
{
    IReadOnlyList<StoreKitProduct> products;

    await this.storeKitClient.InitializeAsync(cancellationToken);
    products = await this.storeKitClient.GetProductsAsync(["com.example.premium"],
                                                          cancellationToken);

    foreach (StoreKitProduct product in products)
    {
        Console.WriteLine($"{product.DisplayName}: {product.DisplayPrice}");
    }
}

public async Task PurchasePremiumAsync(CancellationToken cancellationToken)
{
    StoreKitPurchaseOutcome outcome;

    outcome = await this.storeKitClient.PurchaseAsync("com.example.premium",
                                                      cancellationToken: cancellationToken);

    if (outcome.Transaction?.VerificationStatus == StoreKitTransactionVerificationStatus.Verified)
    {
        DeliverPurchase(outcome.Transaction);
        await this.storeKitClient.FinishTransactionAsync(outcome.Transaction.Identifier,
                                                         cancellationToken);
    }
}

private void OnTransactionUpdated(object? sender,
                                  StoreKitTransactionUpdatedEventArgs eventArgs)
{
    if (eventArgs.Transaction.VerificationStatus == StoreKitTransactionVerificationStatus.Verified)
    {
        DeliverPurchase(eventArgs.Transaction);
    }
}
```

All task continuations are detached from the native callback through `TaskCreationOptions.RunContinuationsAsynchronously`. The wrapper doesn't dispatch callbacks or events to the main thread.

The optional `ILogger<StoreKitClient>` receives native StoreKit diagnostics with their mapped Microsoft log level, numeric and named `EventId`, message, and an `NSErrorException` when the native event carries an error. The package depends only on `Microsoft.Extensions.Logging.Abstractions`; the application remains responsible for selecting and configuring logging providers.

Every task-based operation honors `CancellationToken` both before and after its native invocation. Cancellation stops the managed wait immediately and forwards a cooperative cancellation request to the corresponding Swift task. The internal completion source remains registered until the native terminal callback arrives, preventing late callbacks from being associated with a later request.

Cancellation is best effort for StoreKit operations that may already have reached system UI or an irreversible system action. In particular, cancelling a purchase wait doesn't guarantee that the App Store confirmation flow or transaction stops, and cancelling a transaction finish doesn't roll back a finish already accepted by StoreKit. Transactions completed after a cancelled purchase wait remain recoverable through `TransactionUpdated`.

Errors reported by native operation callbacks become `StoreKitWrapperException` instances containing the stable `StoreKitWrapperErrorCode`. Pending and customer-cancelled purchases remain successful task completions represented by `StoreKitPurchaseOutcome`.

### 3. Use the low-level delegate API

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

### 4. Create and initialize the low-level manager

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

On iOS and Mac Catalyst 17.0 or later, the framework exposes ordinary UIKit controllers that internally host StoreKit SwiftUI merchandising views:

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
dotnet build --configuration Release
```

Create the NuGet package from the repository root:

```bash
dotnet pack src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper.slnx --configuration Release
```

The package is written to `artifacts/packages` and includes the binding assembly, its XML documentation for IDE IntelliSense, the native XCFramework, README, license, package icon, and NuGet metadata. Creating a local package does not publish a new version; publishing still requires an explicit push to an authenticated NuGet source.

On macOS with Xcode installed, create the native XCFramework for iOS, iOS Simulator, and Mac Catalyst:

```bash
cd src/apple/StoreKitWrapper
bash build_xcframework.sh
```

Replace `src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/libs/StoreKitWrapper.xcframework` with the generated `src/apple/StoreKitWrapper/build/StoreKitWrapper.xcframework` before building or packing the .NET project.

Verify the generated Objective-C interface for both iOS Simulator and Mac Catalyst:

```bash
bash scripts/verify-native-contract.sh
```

The script builds the Release framework for both platforms and validates each installed `StoreKitWrapper-Swift.h`, including the expected public API and the absence of internal Swift implementation types.

## Project status

- Native StoreKit implementation: implemented; macOS/Xcode verification pending.
- Objective-C-compatible contract: implemented; generated-header verification covers iOS Simulator and Mac Catalyst.
- Native deterministic tests: implemented; execution on macOS pending.
- .NET 10 binding: targets `net10.0-ios` and `net10.0-maccatalyst`; the earlier iOS-only target built successfully, while the new dual-target Release build is pending the regenerated XCFramework.
- NuGet package: [`AMDevIT.StoreKitWrapper` version `0.130.0`](https://www.nuget.org/packages/AMDevIT.StoreKitWrapper/0.130.0) is published on NuGet.org.
- Source version: `0.131.0`; the regenerated dual-platform package has not been published yet.
- Consumer application and real StoreKit runtime validation: pending on iOS and Mac Catalyst.

See the files in `.agents` for the progressive implementation notes and verification history.

## License

Licensed under the [Apache License 2.0](LICENSE).
