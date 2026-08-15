# Microsoft Logging Bridge Step

## Objective

Integrate native StoreKit diagnostics with the standard Microsoft.Extensions.Logging abstraction used by .NET applications.

## Public API

- `StoreKitClient` accepts an optional `ILogger<StoreKitClient>`.
- The previous native-logger constructor parameter was removed from the managed facade; direct native logger implementations remain available through the low-level `StoreKitManager` API.
- The public logging dependency is `Microsoft.Extensions.Logging.Abstractions` version `10.0.0`, matching the .NET 10 target without imposing a logging provider.

## Bridge behavior

- `StoreKitLoggerBridge` privately derives from the generated native logger model.
- All native log levels map to the corresponding Microsoft `LogLevel`; unknown future values map to `None`.
- Native event identifiers become Microsoft `EventId` values with both numeric ID and optional name preserved.
- Native errors become `Foundation.NSErrorException` instances and are supplied through the exception argument of `ILogger.Log`.
- The bridge checks `ILogger.IsEnabled` before logging, even though the native logger protocol also performs level filtering.

## Lifecycle

- `StoreKitClient` strongly retains the bridge while it owns the native manager.
- The bridge isn't force-disposed during client disposal because native Swift work already in flight may temporarily retain the manager and emit a final diagnostic event.
- The native manager's strong logger reference and normal NSObject lifecycle release the bridge after retained native work completes.

## Verification status

- Package registration, binding core-source registration, constructor wiring, level-map completeness, event/error forwarding, XML documentation, and project XML were checked statically.
- Restore and build remain pending separate approval.
