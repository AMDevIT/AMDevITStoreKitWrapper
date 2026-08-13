# Native Contract Verification Step

## Objective

Provide a repeatable macOS/Xcode check that compiles the framework and validates the actual generated Objective-C interface before work starts on the .NET binding.

## Implemented verification

- `scripts/verify-native-contract.sh` builds the Release framework for the generic iOS Simulator without code signing.
- Build products and intermediates are written under the ignored `.build/native-contract` directory by default.
- The script locates the installed `StoreKitWrapper-Swift.h` inside the built framework rather than inspecting only Swift source declarations.
- It verifies the manager, delegate, logger, DTOs, error/result enums, lifecycle operations, product operations, all purchase parameters, and transaction finishing selectors.
- It rejects known internal implementation types if they appear in the generated header.
- The script exits at the first build or contract failure, making it suitable for a future CI job.
- The Xcode project references `StoreKit.framework` relative to `SDKROOT`, avoiding a machine- and SDK-version-specific `DEVELOPER_DIR` path.

## Environment result

- This workspace is running on Windows and has no `xcodebuild`, `swiftc`, or Apple Swift toolchain.
- The verification script couldn't be executed here. No compilation or generated-header result is claimed.
- Run `bash scripts/verify-native-contract.sh` on macOS with the intended Xcode SDK to complete the verification.
