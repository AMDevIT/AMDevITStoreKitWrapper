using System;

namespace AMDevIT.StoreKitWrapper;

public sealed class StoreKitTransactionUpdatedEventArgs : EventArgs
{
    #region Properties

    public StoreKitTransaction Transaction { get; }

    public StoreKitWrapperErrorCode ErrorCode { get; }

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
