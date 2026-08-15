# API Documentation Step

## Objective

Provide complete IDE-facing documentation for the public Swift and .NET StoreKit wrapper APIs and include .NET XML documentation in the NuGet package.

## Swift documentation

- Public classes, protocols, enums, properties, initializers, methods, callbacks, and enum cases use Swift `///` DocC-style comments.
- Documentation describes lifecycle prerequisites, callback threading, cooperative cancellation, transaction verification, durable delivery before finishing, and StoreKit UI availability.
- Important internal coordination types have concise type-level documentation without exposing implementation details as public API.

## .NET documentation

- Binding types and members in `ApiDefinition.cs` have XML summaries aligned with their Swift counterparts.
- Every public enum and enum value has XML documentation.
- The managed facade documents parameters, results, exceptions, threading, cancellation, and irreversible StoreKit operation races.
- Managed implementation members use `inheritdoc` where the interface owns the complete public contract.

## NuGet behavior

- `GenerateDocumentationFile` is enabled in the binding project.
- SDK-style packing is expected to place the generated XML documentation beside the assembly under the package's framework-specific `lib` directory, enabling IntelliSense in compatible IDEs.
- README packaging guidance now lists the XML documentation artifact.

## Verification status

- Static coverage checks found no undocumented public declarations in the Swift or C# source surface.
- Attribute and documentation-comment ordering was checked for Swift and C#.
- The project file parses as XML and scoped whitespace checks completed without source errors.
- Build, pack, `.nupkg` inspection, and IDE consumer verification remain pending explicit approval.
