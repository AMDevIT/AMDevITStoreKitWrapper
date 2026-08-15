# NuGet Packaging Step

## Objective

Configure the .NET 10 for iOS binding project so it can produce a publishable NuGet package containing the managed binding, native XCFramework, package metadata, README, and license.

## Decisions

- The package identifier is `AMDevIT.StoreKitWrapper`.
- Package version `0.130.0` stays aligned with the native framework marketing version.
- The author is `Alessandro Morvillo`.
- The company and copyright values are `AMDev.IT di Alessandro Morvillo`.
- The package uses the SPDX license expression `Apache-2.0` and also includes the repository license file.
- The root README is included as the NuGet package README.
- The original 1254x1254 package artwork remains unchanged; a deterministic 128x128 PNG variant is embedded as the NuGet icon.
- Packages are written to the ignored `artifacts/packages` directory.
- Package creation does not imply publication; the README distinguishes local packaging from a future public NuGet release.

## Affected files

- `src/dotnet/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper/AMDevIT.StoreKitWrapper.csproj`
- `README.md`
- `assets/icons/nuget_icon_128.png`
- `.agents/nuget-packaging.md`
- `.agents/context.md`

## Checks

- Checked package metadata, repository paths, license expression, README and icon inclusion, and output path statically.
- Verified that the optimized icon is a 128x128 PNG of 25,079 bytes and visually preserves the original artwork.
- Checked project XML parsing and scoped diffs after the change.
- Restore, build, pack, and package-content inspection were not run because they require separate approval.

## Open issues and recommended next step

- Run restore, build, and pack after user approval.
- Inspect the generated `.nupkg` to confirm the managed binding and native XCFramework assets are present in the expected locations.
- Test the package from a local feed in a clean .NET for iOS consumer application before publishing it.
