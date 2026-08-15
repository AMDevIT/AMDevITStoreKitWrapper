using System;

namespace AMDevIT.StoreKitWrapper;

/// <summary>Represents a failure reported by the native StoreKit wrapper.</summary>
public sealed class StoreKitWrapperException : Exception
{
    #region Properties

    /// <summary>Gets the stable native wrapper error code.</summary>
    public StoreKitWrapperErrorCode ErrorCode { get; }

    #endregion

    #region .ctor

    /// <summary>Creates an exception for a native StoreKit wrapper failure.</summary>
    /// <param name="errorCode">The stable wrapper error code.</param>
    /// <param name="message">The native diagnostic message, or <see langword="null"/>.</param>
    public StoreKitWrapperException(StoreKitWrapperErrorCode errorCode,
                                    string? message)
        : base(message ?? $"StoreKit operation failed with error code {errorCode}.")
    {
        this.ErrorCode = errorCode;
    }

    #endregion
}
