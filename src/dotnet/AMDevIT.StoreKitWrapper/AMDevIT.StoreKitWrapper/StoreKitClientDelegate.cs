using System;

namespace AMDevIT.StoreKitWrapper;

/// <summary>Bridges native manager callbacks into the owning managed StoreKit client.</summary>
internal sealed class StoreKitClientDelegate : StoreKitManagerDelegate
{
    #region Fields

    private readonly WeakReference<StoreKitClient> owner;

    #endregion

    #region .ctor

    internal StoreKitClientDelegate(StoreKitClient owner)
    {
        this.owner = new WeakReference<StoreKitClient>(owner);
    }

    #endregion

    #region Methods

    /// <inheritdoc/>
    public override void InitializationCompletedWithErrorCode(StoreKitWrapperErrorCode errorCode,
                                                              string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleInitializationCompleted(errorCode, errorMessage);
        }
    }

    /// <inheritdoc/>
    public override void ShutdownCompletedWithErrorCode(StoreKitWrapperErrorCode errorCode,
                                                        string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleShutdownCompleted(errorCode, errorMessage);
        }
    }

    /// <inheritdoc/>
    public override void AvailableProductsCompletedWithResult(StoreKitProduct[] withResult,
                                                              StoreKitWrapperErrorCode errorCode,
                                                              string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleAvailableProductsCompleted(withResult, errorCode, errorMessage);
        }
    }

    /// <inheritdoc/>
    public override void CurrentEntitlementsCompletedWithResult(StoreKitTransaction[] withResult,
                                                                StoreKitWrapperErrorCode errorCode,
                                                                string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleCurrentEntitlementsCompleted(withResult, errorCode, errorMessage);
        }
    }

    /// <inheritdoc/>
    public override void AppStoreSyncCompletedWithErrorCode(StoreKitWrapperErrorCode errorCode,
                                                            string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleAppStoreSyncCompleted(errorCode, errorMessage);
        }
    }

    /// <inheritdoc/>
    public override void UnfinishedTransactionsCompletedWithResult(StoreKitTransaction[] withResult,
                                                                   StoreKitWrapperErrorCode errorCode,
                                                                   string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleUnfinishedTransactionsCompleted(withResult, errorCode, errorMessage);
        }
    }

    /// <inheritdoc/>
    public override void PurchaseCompletedWithResult(StoreKitTransaction? withResult,
                                                     StoreKitPurchaseResult purchaseResult,
                                                     StoreKitWrapperErrorCode errorCode,
                                                     string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandlePurchaseCompleted(withResult, purchaseResult, errorCode, errorMessage);
        }
    }

    /// <inheritdoc/>
    public override void FinishTransactionCompletedWithTransactionIdentifier(ulong transactionIdentifier,
                                                                             StoreKitWrapperErrorCode errorCode,
                                                                             string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleFinishTransactionCompleted(transactionIdentifier, errorCode, errorMessage);
        }
    }

    /// <inheritdoc/>
    public override void TransactionUpdatedWithResult(StoreKitTransaction withResult,
                                                      StoreKitWrapperErrorCode errorCode,
                                                      string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleTransactionUpdated(withResult, errorCode, errorMessage);
        }
    }

    #endregion
}
