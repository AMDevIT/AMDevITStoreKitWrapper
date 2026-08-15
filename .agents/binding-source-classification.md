# Binding Source Classification Fix

## Objective

Prevent the managed `StoreKitClient` facade from being compiled as input to the Objective-C binding generator.

## Decision

- `ApiDefinition.cs` remains the only `ObjcBindingApiDefinition`.
- `StructsAndEnums.cs` remains the only `ObjcBindingCoreSource` because the API definition references its enum types during binding generation.
- The seven managed facade files use the SDK's automatic `Compile` inclusion and are not declared explicitly in the project file.

## Rationale

Declaring the managed facade as `ObjcBindingCoreSource` compiled it in the preliminary binding context against the internal API-definition interfaces. This caused inconsistent-accessibility errors, missing delegate override errors, and nullable-context warnings. Explicit `Compile` entries are unnecessary because the SDK already includes these files and would create duplicate items.

## Verification

- MSBuild project evaluation reports the seven facade files exactly once as `Compile` items.
- `StructsAndEnums.cs` is the only `ObjcBindingCoreSource`.
- `ApiDefinition.cs` is the only `ObjcBindingApiDefinition`.
- The scoped diff whitespace check passes.
- `dotnet restore AMDevIT.StoreKitWrapper.slnx` completed successfully.
- `dotnet build AMDevIT.StoreKitWrapper.slnx --no-restore` completed successfully with zero warnings and zero errors.
- The Debug `net10.0-ios` assembly was generated at `AMDevIT.StoreKitWrapper/bin/Debug/net10.0-ios/AMDevIT.StoreKitWrapper.dll`.
