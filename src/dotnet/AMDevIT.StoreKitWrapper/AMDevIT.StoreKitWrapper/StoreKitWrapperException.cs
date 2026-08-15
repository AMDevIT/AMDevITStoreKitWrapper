using System;

namespace AMDevIT.StoreKitWrapper;

public sealed class StoreKitWrapperException : Exception
{
    #region Properties

    public StoreKitWrapperErrorCode ErrorCode { get; }

    #endregion

    #region .ctor

    public StoreKitWrapperException(StoreKitWrapperErrorCode errorCode,
                                    string? message)
        : base(message ?? $"StoreKit operation failed with error code {errorCode}.")
    {
        this.ErrorCode = errorCode;
    }

    #endregion
}
