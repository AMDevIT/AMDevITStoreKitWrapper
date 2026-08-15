namespace AMDevIT.StoreKitWrapper;

public sealed class StoreKitPurchaseOutcome
{
    #region Properties

    public StoreKitPurchaseResult PurchaseResult { get; }

    public StoreKitTransaction? Transaction { get; }

    #endregion

    #region .ctor

    internal StoreKitPurchaseOutcome(StoreKitPurchaseResult purchaseResult,
                                     StoreKitTransaction? transaction)
    {
        this.PurchaseResult = purchaseResult;
        this.Transaction = transaction;
    }

    #endregion
}
