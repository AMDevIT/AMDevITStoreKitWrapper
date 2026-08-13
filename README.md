# AMDevITStoreKitWrapper
A Storekit 2 native wrapper for dotnet

## Native contract verification

On macOS with Xcode installed, build the framework and verify its generated Objective-C interface with:

```bash
bash scripts/verify-native-contract.sh
```

The script builds the Release framework for the iOS Simulator and validates `StoreKitWrapper-Swift.h` before the framework is consumed by a .NET for iOS binding project.

## Native contract verification

On macOS with Xcode installed, build the framework and verify its generated Objective-C interface with:

```bash
bash scripts/verify-native-contract.sh
```

The script builds the Release framework for the iOS Simulator and validates `StoreKitWrapper-Swift.h` before the framework is consumed by a .NET for iOS binding project.
