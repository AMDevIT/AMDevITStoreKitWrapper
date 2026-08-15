# NuGet Publication Step

## Objective

Update the repository documentation after the first public publication of `AMDevIT.StoreKitWrapper` on NuGet.org.

## Status

- Package ID: `AMDevIT.StoreKitWrapper`.
- Published version: `0.130.0`.
- Package URL: `https://www.nuget.org/packages/AMDevIT.StoreKitWrapper/0.130.0`.
- Publication was performed externally by the user and explicitly confirmed.

## Decisions

- NuGet.org is now the primary installation path in the quick start.
- Local packing and project references remain documented for repository development.
- The static version shield is replaced by dynamic NuGet version and total-download shields.
- The project status links directly to the published package.
- Local pack instructions clarify that package creation alone does not publish a new version.

## Affected files

- `README.md`
- `.agents/nuget-publication.md`
- `.agents/context.md`

## Checks

- Confirmed that the README package ID and version match the user-confirmed NuGet publication.
- Checked the NuGet URL, installation command, badge URLs, Markdown structure, and scoped diff statically.
- No restore, build, pack, push, or external package mutation was performed.

## Open issues and recommended next step

- Validate installation and runtime behavior from the public NuGet feed in a clean .NET for iOS consumer application.
- Update the package version, installation command, and version-specific links together for the next release.
