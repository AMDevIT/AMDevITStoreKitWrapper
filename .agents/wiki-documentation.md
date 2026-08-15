# GitHub Wiki Documentation

## Objective

Create a complete GitHub Wiki for the StoreKit wrapper in the sibling `AMDevITStoreKitWrapper.wiki` repository.

## Decisions

- Keep the wiki in English to match the source code, public API documentation, NuGet metadata, and repository README.
- Use the managed `StoreKitClient` as the primary adoption path while documenting the low-level callback API separately.
- Organize the wiki around installation, architecture, operational workflows, API reference, development, validation, and production readiness.
- Make the preview status and pending macOS/iOS runtime verification visible on the home, testing, and production pages.
- Emphasize transaction verification, durable idempotent delivery, and explicit finishing in that order.
- Document current entitlements, unfinished transactions, listener updates, and App Store synchronization as distinct recovery mechanisms.
- Use GitHub Wiki-compatible page names and a `_Sidebar.md` navigation file.

## Affected files

- `AMDevITStoreKitWrapper.wiki/Home.md`
- `AMDevITStoreKitWrapper.wiki/_Sidebar.md`
- `AMDevITStoreKitWrapper.wiki/Getting-Started.md`
- `AMDevITStoreKitWrapper.wiki/Architecture.md`
- `AMDevITStoreKitWrapper.wiki/Managed-Client.md`
- `AMDevITStoreKitWrapper.wiki/Low-Level-Native-API.md`
- `AMDevITStoreKitWrapper.wiki/Products-and-Subscriptions.md`
- `AMDevITStoreKitWrapper.wiki/Purchases-and-Transactions.md`
- `AMDevITStoreKitWrapper.wiki/Entitlements-and-Restore.md`
- `AMDevITStoreKitWrapper.wiki/StoreKit-Views.md`
- `AMDevITStoreKitWrapper.wiki/Lifecycle-Threading-and-Cancellation.md`
- `AMDevITStoreKitWrapper.wiki/Error-Handling-and-Logging.md`
- `AMDevITStoreKitWrapper.wiki/API-Reference.md`
- `AMDevITStoreKitWrapper.wiki/Building-and-Packaging.md`
- `AMDevITStoreKitWrapper.wiki/Testing-and-Verification.md`
- `AMDevITStoreKitWrapper.wiki/Production-Checklist.md`
- `AMDevITStoreKitWrapper.wiki/Troubleshooting.md`
- `AMDevITStoreKitWrapper.wiki/Contributing.md`
- `.agents/wiki-documentation.md`
- `.agents/context.md`

## Verification status

- Compared documented managed method names with `IStoreKitClient.cs`.
- Compared low-level methods, delegate callbacks, DTO properties, view controllers, and cancellation selectors with `ApiDefinition.cs`.
- Compared enum and error-code names with `StructsAndEnums.cs`.
- Compared package requirements, target framework, dependency, version, and output paths with the project files and README.
- Checked all 18 expected Markdown files, GitHub Wiki page targets, code-fence balance, internal links, API tokens, trailing whitespace, and scoped repository diffs statically.
- The repository-wide main-project `git diff --check` could not traverse pre-existing long XCFramework paths on Windows; the scoped check for the two edited `.agents` files completed without errors.
- Restore, build, pack, and native tests were not run because this documentation-only task did not require them and no separate build approval was requested.

## Open issues and recommended next step

- Preview the committed wiki on GitHub to confirm sidebar rendering and relative-link behavior in the hosted UI.
- Update wiki version/status statements whenever package or runtime verification status changes.
- Add application-specific integration recipes after real StoreKit runtime validation is completed.
