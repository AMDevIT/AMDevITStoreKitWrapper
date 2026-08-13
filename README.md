# AMDevITStoreKitWrapper

A StoreKit 2 native wrapper for .NET.

## Native StoreKit views

On iOS 17 and later, the framework exposes ordinary UIKit controllers that internally host StoreKit SwiftUI views:

- `StoreKitProductViewController`
- `StoreKitProductsViewController`
- `StoreKitSubscriptionsViewController`

Applications own presentation, parent containment, and external Auto Layout constraints. Initialize `StoreKitManager` before presenting these controllers to receive completed purchases through `StoreKitManagerDelegate.transactionUpdated`.

## Native contract verification

On macOS with Xcode installed, build the framework and verify its generated Objective-C interface with:

```bash
bash scripts/verify-native-contract.sh
```

The script builds the Release framework for the iOS Simulator and validates `StoreKitWrapper-Swift.h` before the framework is consumed by a .NET for iOS binding project.
