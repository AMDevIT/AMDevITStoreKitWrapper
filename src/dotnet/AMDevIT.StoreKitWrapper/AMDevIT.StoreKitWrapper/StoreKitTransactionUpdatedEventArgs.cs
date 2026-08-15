using System;

namespace AMDevIT.StoreKitWrapper;

/// <summary>Provides data for a transaction update emitted by the persistent StoreKit listener.</summary>
public sealed class StoreKitTransactionUpdatedEventArgs : EventArgs
{
    #region Properties

    /// <summary>Gets the verified or diagnostic unverified transaction.</summary>
    public StoreKitTransaction Transaction { get; }

    /// <summary>Gets the stable verification or listener error code.</summary>
    public StoreKitWrapperErrorCode ErrorCode { get; }

    /// <summary>Gets the diagnostic error message, when available.</summary>
    public string? ErrorMessage { get; }

    #endregion

    #region .ctor

    internal StoreKitTransactionUpdatedEventArgs(StoreKitTransaction transaction,
                                                 StoreKitWrapperErrorCode errorCode,
                                                 string? errorMessage)
    {
        this.Transaction = transaction;
        this.ErrorCode = errorCode;
        this.ErrorMessage = errorMessage;
    }

    #endregion
}
