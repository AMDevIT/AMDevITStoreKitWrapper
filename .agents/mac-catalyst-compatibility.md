# Mac Catalyst Compatibility

## Objective

Extend the native StoreKit framework, .NET binding, and NuGet source package to support Mac Catalyst alongside iOS.

## Decisions

- Keep one Swift framework target and enable `SUPPORTS_MACCATALYST` for the framework and its tests.
- Preserve the iOS 15.6 deployment target and use Mac Catalyst 15.6 as the managed minimum.
- Build one XCFramework containing iOS device, iOS Simulator, and Mac Catalyst variants.
- Target `net10.0-ios` and `net10.0-maccatalyst` from the same binding project and package the same multi-platform XCFramework for both targets.
- Declare Mac Catalyst availability explicitly wherever the Swift implementation uses version-gated StoreKit APIs.
- Expose the StoreKit merchandising controllers on iOS 17.0 and Mac Catalyst 17.0 or later.
- Advance the native framework and source package version from `0.130.0` to `0.131.0`. The already-published `0.130.0` NuGet package remains unchanged and iOS-only.

## Affected files

- `src/apple/StoreKitWrapper/StoreKitWrapper.xcodeproj/project.pbxproj`
- `src/apple/StoreKitWrapper/build_xcframework.sh`
- `scripts/verify-native-contract.sh`
- Swift sources and tests containing StoreKit availability checks
- `src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper.csproj`
- `src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/ApiDefinition.cs`
- `src/dotnet/AMDevIT.StoreKitWrapper/Directory.Build.props`
- `README.md`
- `.agents/mac-catalyst-compatibility.md`
- `.agents/context.md`

## Checks

- Parsed the binding project and shared properties file as XML.
- Confirmed through MSBuild property evaluation that the binding targets `net10.0-ios;net10.0-maccatalyst`, with source version `0.131.0` and dual-platform package metadata.
- Confirmed the installed .NET 10 SDK provides iOS and Mac Catalyst reference and runtime packs.
- Checked both shell scripts with `bash -n`.
- Checked that every existing Swift iOS availability declaration now carries the matching Mac Catalyst version.
- Checked the edited files with scoped whitespace and diff validation.
- Restore, build, pack, Xcode compilation, generated-header inspection, and runtime tests were not run because the checked-in XCFramework still lacks a Mac Catalyst variant.

## Open issues and recommended next step

- On macOS, run `src/apple/StoreKitWrapper/build_xcframework.sh` and replace the XCFramework under the binding project's `libs` directory with the generated three-variant artifact.
- Run `scripts/verify-native-contract.sh` on macOS to compile and inspect both the iOS Simulator and Mac Catalyst Objective-C headers.
- Restore and build the .NET solution in Release, then pack version `0.131.0` and inspect the `.nupkg` for both target-framework asset groups.
- Validate StoreKit operations and merchandising controllers in iOS and Mac Catalyst consumer applications before publishing the new package.
