namespace AMDevIT.StoreKitWrapper;

/// <summary>Represents the terminal outcome of a programmatic purchase request.</summary>
public sealed class StoreKitPurchaseOutcome
{
    #region Properties

    /// <summary>Gets the normalized purchase outcome.</summary>
    public StoreKitPurchaseResult PurchaseResult { get; }

    /// <summary>Gets the transaction produced by the purchase, when available.</summary>
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
