using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace AMDevIT.StoreKitWrapper;

public interface IStoreKitClient : IDisposable
{
    #region Events

    event EventHandler<StoreKitTransactionUpdatedEventArgs>? TransactionUpdated;

    #endregion

    #region Methods

    Task InitializeAsync(CancellationToken cancellationToken = default);

    Task ShutdownAsync(CancellationToken cancellationToken = default);

    Task<IReadOnlyList<StoreKitProduct>> GetProductsAsync(IEnumerable<string> productIdentifiers,
                                                         CancellationToken cancellationToken = default);

    Task<IReadOnlyList<StoreKitTransaction>> GetCurrentEntitlementsAsync(CancellationToken cancellationToken = default);

    Task SyncAsync(CancellationToken cancellationToken = default);

    Task<IReadOnlyList<StoreKitTransaction>> GetUnfinishedTransactionsAsync(CancellationToken cancellationToken = default);

    Task<StoreKitPurchaseOutcome> PurchaseAsync(string productIdentifier,
                                                string? appAccountToken = null,
                                                int quantity = 1,
                                                CancellationToken cancellationToken = default);

    Task FinishTransactionAsync(ulong transactionIdentifier,
                                CancellationToken cancellationToken = default);

    #endregion
}
