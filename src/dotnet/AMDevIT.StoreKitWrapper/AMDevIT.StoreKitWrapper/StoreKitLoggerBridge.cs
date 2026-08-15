using System;
using Foundation;
using Microsoft.Extensions.Logging;

namespace AMDevIT.StoreKitWrapper;

/// <summary>Bridges native StoreKit wrapper diagnostics to Microsoft.Extensions.Logging.</summary>
internal sealed class StoreKitLoggerBridge : StoreKitWrapperLogger
{
    #region Fields

    private readonly ILogger logger;

    #endregion

    #region .ctor

    internal StoreKitLoggerBridge(ILogger logger)
    {
        this.logger = logger;
    }

    #endregion

    #region Methods

    /// <inheritdoc/>
    public override bool IsEnabledWithLogLevel(StoreKitWrapperLogLevel logLevel)
    {
        LogLevel microsoftLogLevel;

        microsoftLogLevel = MapLogLevel(logLevel);
        return microsoftLogLevel != LogLevel.None && this.logger.IsEnabled(microsoftLogLevel);
    }

    /// <inheritdoc/>
    public override void LogWithLogLevel(StoreKitWrapperLogLevel logLevel,
                                         nint eventId,
                                         string? eventName,
                                         string message,
                                         NSError? error)
    {
        LogLevel microsoftLogLevel;
        EventId microsoftEventId;
        NSErrorException? exception;

        microsoftLogLevel = MapLogLevel(logLevel);
        if (microsoftLogLevel == LogLevel.None || !this.logger.IsEnabled(microsoftLogLevel))
        {
            return;
        }

        microsoftEventId = new EventId((int)eventId, eventName);
        exception = error is null ? null : new NSErrorException(error);
        this.logger.Log(microsoftLogLevel,
                        microsoftEventId,
                        message,
                        exception,
                        static (state, _) => state);
    }

    private static LogLevel MapLogLevel(StoreKitWrapperLogLevel logLevel)
    {
        return logLevel switch
        {
            StoreKitWrapperLogLevel.Trace => LogLevel.Trace,
            StoreKitWrapperLogLevel.Debug => LogLevel.Debug,
            StoreKitWrapperLogLevel.Information => LogLevel.Information,
            StoreKitWrapperLogLevel.Warning => LogLevel.Warning,
            StoreKitWrapperLogLevel.Error => LogLevel.Error,
            StoreKitWrapperLogLevel.Critical => LogLevel.Critical,
            StoreKitWrapperLogLevel.None => LogLevel.None,
            _ => LogLevel.None
        };
    }

    #endregion
}
