using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace AMDevIT.StoreKitWrapper;

/// <summary>Provides an idiomatic task-based .NET facade over the native StoreKit callback API.</summary>
/// <remarks>Operation continuations run asynchronously. Transaction updates remain on the native callback thread.</remarks>
public interface IStoreKitClient : IDisposable
{
    #region Events

    /// <summary>Occurs when the persistent StoreKit listener receives a verified or unverified transaction.</summary>
    event EventHandler<StoreKitTransactionUpdatedEventArgs>? TransactionUpdated;

    #endregion

    #region Methods

    /// <summary>Initializes StoreKit and starts listening for transaction updates.</summary>
    /// <param name="cancellationToken">A token that cancels the managed wait and requests cooperative native cancellation.</param>
    /// <returns>A task that completes when initialization reaches a terminal state.</returns>
    /// <exception cref="OperationCanceledException">The cancellation token was cancelled before initialization completed.</exception>
    Task InitializeAsync(CancellationToken cancellationToken = default);

    /// <summary>Stops transaction listening and shuts down the native manager.</summary>
    /// <param name="cancellationToken">A token that cancels the managed wait and requests cooperative native cancellation.</param>
    /// <returns>A task that completes when shutdown reaches a terminal state.</returns>
    /// <exception cref="OperationCanceledException">The cancellation token was cancelled before shutdown completed.</exception>
    Task ShutdownAsync(CancellationToken cancellationToken = default);

    /// <summary>Invalidates the product catalog and retrieves fresh metadata for the supplied identifiers.</summary>
    /// <param name="productIdentifiers">The App Store Connect product identifiers to retrieve.</param>
    /// <param name="cancellationToken">A token that cancels the managed wait and requests cooperative native cancellation.</param>
    /// <returns>The products returned by StoreKit.</returns>
    /// <exception cref="ArgumentNullException"><paramref name="productIdentifiers"/> is <see langword="null"/>.</exception>
    /// <exception cref="StoreKitWrapperException">The native operation fails or another product request is active.</exception>
    /// <exception cref="OperationCanceledException">The cancellation token is cancelled before the request completes.</exception>
    Task<IReadOnlyList<StoreKitProduct>> GetProductsAsync(IEnumerable<string> productIdentifiers,
                                                         CancellationToken cancellationToken = default);

    /// <summary>Invalidates and reloads the customer's current entitlement snapshot.</summary>
    /// <param name="cancellationToken">A token that cancels the managed wait and requests cooperative native cancellation.</param>
    /// <returns>The current verified and unverified entitlement transactions.</returns>
    /// <exception cref="StoreKitWrapperException">The native operation fails or another entitlement request is active.</exception>
    /// <exception cref="OperationCanceledException">The cancellation token is cancelled before the request completes.</exception>
    Task<IReadOnlyList<StoreKitTransaction>> GetCurrentEntitlementsAsync(CancellationToken cancellationToken = default);

    /// <summary>Explicitly synchronizes transaction information with the App Store.</summary>
    /// <remarks>Call only from a user-initiated restore action because StoreKit may display authentication UI.</remarks>
    /// <param name="cancellationToken">A token that cancels the managed wait and requests cooperative native cancellation.</param>
    /// <returns>A task that completes when synchronization reaches a terminal state.</returns>
    /// <exception cref="StoreKitWrapperException">Synchronization fails or another synchronization request is active.</exception>
    /// <exception cref="OperationCanceledException">The cancellation token is cancelled before synchronization completes.</exception>
    Task SyncAsync(CancellationToken cancellationToken = default);

    /// <summary>Invalidates and reloads the currently unfinished verified transactions.</summary>
    /// <param name="cancellationToken">A token that cancels the managed wait and requests cooperative native cancellation.</param>
    /// <returns>The unfinished verified and diagnostic unverified transactions.</returns>
    /// <exception cref="StoreKitWrapperException">The operation fails or conflicts with another transaction operation.</exception>
    /// <exception cref="OperationCanceledException">The cancellation token is cancelled before the request completes.</exception>
    Task<IReadOnlyList<StoreKitTransaction>> GetUnfinishedTransactionsAsync(CancellationToken cancellationToken = default);

    /// <summary>Purchases a product previously loaded into the native product catalog.</summary>
    /// <param name="productIdentifier">The App Store Connect product identifier.</param>
    /// <param name="appAccountToken">An optional UUID string associated with the application account.</param>
    /// <param name="quantity">The quantity to purchase. Values greater than one are valid only for consumables.</param>
    /// <param name="cancellationToken">A token that cancels the managed wait and requests cooperative native cancellation.</param>
    /// <returns>The purchase outcome and its transaction, when one is produced.</returns>
    /// <remarks>Cancellation is best effort and can't roll back App Store UI or a transaction StoreKit has already created.</remarks>
    /// <exception cref="ArgumentException"><paramref name="productIdentifier"/> is empty or whitespace.</exception>
    /// <exception cref="StoreKitWrapperException">The purchase fails or another purchase is active.</exception>
    /// <exception cref="OperationCanceledException">The cancellation token is cancelled before a terminal purchase result wins the race.</exception>
    Task<StoreKitPurchaseOutcome> PurchaseAsync(string productIdentifier,
                                                string? appAccountToken = null,
                                                int quantity = 1,
                                                CancellationToken cancellationToken = default);

    /// <summary>Finishes a verified transaction after the application has durably delivered its content.</summary>
    /// <param name="transactionIdentifier">The identifier of a retained unfinished transaction.</param>
    /// <param name="cancellationToken">A token that cancels the managed wait and requests cooperative native cancellation.</param>
    /// <returns>A task that completes after StoreKit accepts the finish operation.</returns>
    /// <remarks>Cancellation can't roll back a finish operation already accepted by StoreKit.</remarks>
    /// <exception cref="StoreKitWrapperException">The transaction isn't finishable or another conflicting operation is active.</exception>
    /// <exception cref="OperationCanceledException">The cancellation token is cancelled before StoreKit accepts the finish operation.</exception>
    Task FinishTransactionAsync(ulong transactionIdentifier,
                                CancellationToken cancellationToken = default);

    #endregion
}
