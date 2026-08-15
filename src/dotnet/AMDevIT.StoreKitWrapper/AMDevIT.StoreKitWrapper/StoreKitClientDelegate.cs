using System;

namespace AMDevIT.StoreKitWrapper;

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

    public override void InitializationCompletedWithErrorCode(StoreKitWrapperErrorCode errorCode,
                                                              string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleInitializationCompleted(errorCode, errorMessage);
        }
    }

    public override void ShutdownCompletedWithErrorCode(StoreKitWrapperErrorCode errorCode,
                                                        string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleShutdownCompleted(errorCode, errorMessage);
        }
    }

    public override void AvailableProductsCompletedWithResult(StoreKitProduct[] withResult,
                                                              StoreKitWrapperErrorCode errorCode,
                                                              string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleAvailableProductsCompleted(withResult, errorCode, errorMessage);
        }
    }

    public override void CurrentEntitlementsCompletedWithResult(StoreKitTransaction[] withResult,
                                                                StoreKitWrapperErrorCode errorCode,
                                                                string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleCurrentEntitlementsCompleted(withResult, errorCode, errorMessage);
        }
    }

    public override void AppStoreSyncCompletedWithErrorCode(StoreKitWrapperErrorCode errorCode,
                                                            string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleAppStoreSyncCompleted(errorCode, errorMessage);
        }
    }

    public override void UnfinishedTransactionsCompletedWithResult(StoreKitTransaction[] withResult,
                                                                   StoreKitWrapperErrorCode errorCode,
                                                                   string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleUnfinishedTransactionsCompleted(withResult, errorCode, errorMessage);
        }
    }

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

    public override void FinishTransactionCompletedWithTransactionIdentifier(ulong transactionIdentifier,
                                                                             StoreKitWrapperErrorCode errorCode,
                                                                             string? errorMessage)
    {
        if (this.owner.TryGetTarget(out StoreKitClient? client))
        {
            client.HandleFinishTransactionCompleted(transactionIdentifier, errorCode, errorMessage);
        }
    }

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
