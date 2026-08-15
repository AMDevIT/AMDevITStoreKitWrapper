# README Refresh Step

## Objective

Replace the minimal README with project positioning, accurate shields, requirements, a .NET for iOS quick start, API guidance, build instructions, and the current verification status.

## Decisions

- The README remains in English to match the existing source, API, and documentation language.
- Shields cover the repository version, minimum iOS version, .NET target, Swift version, preview status, and Apache 2.0 license.
- CI, NuGet, and GitHub Release shields are intentionally omitted because the repository has no workflow, published package metadata, or release tags.
- The quick start uses the generated .NET method and callback names and overrides every callback in the required native delegate protocol.
- Transaction examples require verification, durable delivery, and explicit finishing in that order.
- Build commands are documented but were not executed because build and restore require separate approval.

## Affected files

- `README.md`
- `.agents/readme-refresh.md`
- `.agents/context.md`

## Checks

- Compared the quick-start API with `ApiDefinition.cs`, `StructsAndEnums.cs`, and the previously generated binding sources.
- Verified the documented version, deployment target, Swift version, target framework, repository URL, license, and solution paths against repository files.
- Ran Markdown and diff-oriented static checks after the documentation change.

## Open issues and recommended next step

- Native compilation, tests, and generated-header verification still require macOS and Xcode.
- Restore and build the .NET solution only after separate user approval.
- Replace the project-reference installation step with a package reference if the binding is published to NuGet later.
