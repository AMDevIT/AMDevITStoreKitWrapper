using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace AMDevIT.StoreKitWrapper;

/// <summary>Implements the task-based .NET StoreKit facade over a privately owned native manager.</summary>
public sealed class StoreKitClient : IStoreKitClient
{
    #region Const

    private const string ProductsRequestInProgressMessage = "A product request is already in progress.";
    private const string CurrentEntitlementsRequestInProgressMessage = "A current entitlements request is already in progress.";
    private const string AppStoreSyncInProgressMessage = "An App Store synchronization is already in progress.";
    private const string UnfinishedTransactionsRequestInProgressMessage = "An unfinished transactions request is already in progress.";
    private const string PurchaseInProgressMessage = "A purchase is already in progress.";
    private const string TransactionFinishInProgressMessage = "A transaction finish operation is already in progress.";

    #endregion

    #region Events

    /// <inheritdoc/>
    public event EventHandler<StoreKitTransactionUpdatedEventArgs>? TransactionUpdated;

    #endregion

    #region Fields

    private readonly object synchronizationLock = new();
    private readonly StoreKitClientDelegate clientDelegate;
    private readonly StoreKitManager manager;
    private TaskCompletionSource<bool>? initializationCompletionSource;
    private TaskCompletionSource<bool>? shutdownCompletionSource;
    private TaskCompletionSource<IReadOnlyList<StoreKitProduct>>? productsCompletionSource;
    private TaskCompletionSource<IReadOnlyList<StoreKitTransaction>>? currentEntitlementsCompletionSource;
    private TaskCompletionSource<bool>? appStoreSyncCompletionSource;
    private TaskCompletionSource<IReadOnlyList<StoreKitTransaction>>? unfinishedTransactionsCompletionSource;
    private TaskCompletionSource<StoreKitPurchaseOutcome>? purchaseCompletionSource;
    private TaskCompletionSource<bool>? finishTransactionCompletionSource;
    private ulong finishTransactionIdentifier;
    private bool disposed;

    #endregion

    #region .ctor

    /// <summary>Creates a StoreKit client with optional native structured logging.</summary>
    /// <param name="logger">A native logger implementation, or <see langword="null"/> to disable logging.</param>
    public StoreKitClient(StoreKitWrapperLogger? logger = null)
    {
        this.clientDelegate = new StoreKitClientDelegate(this);
        this.manager = new StoreKitManager(logger, this.clientDelegate);
    }

    #endregion

    #region Methods

    /// <inheritdoc/>
    public async Task InitializeAsync(CancellationToken cancellationToken = default)
    {
        TaskCompletionSource<bool> completionSource;
        bool invokeNativeOperation = false;

        cancellationToken.ThrowIfCancellationRequested();

        lock (this.synchronizationLock)
        {
            this.ThrowIfDisposed();

            if (this.initializationCompletionSource is null)
            {
                this.initializationCompletionSource = CreateCompletionSource<bool>();
                invokeNativeOperation = true;
            }

            completionSource = this.initializationCompletionSource;
        }

        if (invokeNativeOperation)
        {
            try
            {
                this.manager.Initialize();
            }
            catch (Exception exception)
            {
                this.FailInitializationInvocation(completionSource, exception);
            }
        }

        _ = await AwaitOperationAsync(completionSource.Task,
                                      cancellationToken,
                                      () => this.CancelInitialization(completionSource)).ConfigureAwait(false);
    }

    /// <inheritdoc/>
    public async Task ShutdownAsync(CancellationToken cancellationToken = default)
    {
        TaskCompletionSource<bool> completionSource;
        bool invokeNativeOperation = false;

        cancellationToken.ThrowIfCancellationRequested();

        lock (this.synchronizationLock)
        {
            this.ThrowIfDisposed();

            if (this.shutdownCompletionSource is null)
            {
                this.shutdownCompletionSource = CreateCompletionSource<bool>();
                invokeNativeOperation = true;
            }

            completionSource = this.shutdownCompletionSource;
        }

        if (invokeNativeOperation)
        {
            try
            {
                this.manager.Shutdown();
            }
            catch (Exception exception)
            {
                this.FailShutdownInvocation(completionSource, exception);
            }
        }

        _ = await AwaitOperationAsync(completionSource.Task,
                                      cancellationToken,
                                      () => this.CancelShutdown(completionSource)).ConfigureAwait(false);
    }

    /// <inheritdoc/>
    public async Task<IReadOnlyList<StoreKitProduct>> GetProductsAsync(IEnumerable<string> productIdentifiers,
                                                                      CancellationToken cancellationToken = default)
    {
        string[] identifiers;
        TaskCompletionSource<IReadOnlyList<StoreKitProduct>> completionSource;

        cancellationToken.ThrowIfCancellationRequested();
        ArgumentNullException.ThrowIfNull(productIdentifiers);

        identifiers = productIdentifiers.ToArray();

        lock (this.synchronizationLock)
        {
            this.ThrowIfDisposed();

            if (this.productsCompletionSource is not null)
            {
                throw CreateException(StoreKitWrapperErrorCode.ProductsRequestInProgress,
                                      ProductsRequestInProgressMessage);
            }

            completionSource = CreateCompletionSource<IReadOnlyList<StoreKitProduct>>();
            this.productsCompletionSource = completionSource;
        }

        try
        {
            this.manager.GetProductsWithProductIdentifiers(identifiers);
        }
        catch (Exception exception)
        {
            this.FailProductsInvocation(completionSource, exception);
        }

        return await AwaitOperationAsync(completionSource.Task,
                                         cancellationToken,
                                         () => this.CancelProductsRequest(completionSource)).ConfigureAwait(false);
    }

    /// <inheritdoc/>
    public async Task<IReadOnlyList<StoreKitTransaction>> GetCurrentEntitlementsAsync(CancellationToken cancellationToken = default)
    {
        TaskCompletionSource<IReadOnlyList<StoreKitTransaction>> completionSource;

        cancellationToken.ThrowIfCancellationRequested();

        lock (this.synchronizationLock)
        {
            this.ThrowIfDisposed();

            if (this.currentEntitlementsCompletionSource is not null)
            {
                throw CreateException(StoreKitWrapperErrorCode.CurrentEntitlementsRequestInProgress,
                                      CurrentEntitlementsRequestInProgressMessage);
            }

            completionSource = CreateCompletionSource<IReadOnlyList<StoreKitTransaction>>();
            this.currentEntitlementsCompletionSource = completionSource;
        }

        try
        {
            this.manager.GetCurrentEntitlements();
        }
        catch (Exception exception)
        {
            this.FailCurrentEntitlementsInvocation(completionSource, exception);
        }

        return await AwaitOperationAsync(completionSource.Task,
                                         cancellationToken,
                                         () => this.CancelCurrentEntitlementsRequest(completionSource)).ConfigureAwait(false);
    }

    /// <inheritdoc/>
    public async Task SyncAsync(CancellationToken cancellationToken = default)
    {
        TaskCompletionSource<bool> completionSource;

        cancellationToken.ThrowIfCancellationRequested();

        lock (this.synchronizationLock)
        {
            this.ThrowIfDisposed();

            if (this.appStoreSyncCompletionSource is not null)
            {
                throw CreateException(StoreKitWrapperErrorCode.AppStoreSyncInProgress,
                                      AppStoreSyncInProgressMessage);
            }

            completionSource = CreateCompletionSource<bool>();
            this.appStoreSyncCompletionSource = completionSource;
        }

        try
        {
            this.manager.Sync();
        }
        catch (Exception exception)
        {
            this.FailAppStoreSyncInvocation(completionSource, exception);
        }

        _ = await AwaitOperationAsync(completionSource.Task,
                                      cancellationToken,
                                      () => this.CancelAppStoreSync(completionSource)).ConfigureAwait(false);
    }

    /// <inheritdoc/>
    public async Task<IReadOnlyList<StoreKitTransaction>> GetUnfinishedTransactionsAsync(CancellationToken cancellationToken = default)
    {
        TaskCompletionSource<IReadOnlyList<StoreKitTransaction>> completionSource;

        cancellationToken.ThrowIfCancellationRequested();

        lock (this.synchronizationLock)
        {
            this.ThrowIfDisposed();

            if (this.unfinishedTransactionsCompletionSource is not null)
            {
                throw CreateException(StoreKitWrapperErrorCode.UnfinishedTransactionsRequestInProgress,
                                      UnfinishedTransactionsRequestInProgressMessage);
            }

            completionSource = CreateCompletionSource<IReadOnlyList<StoreKitTransaction>>();
            this.unfinishedTransactionsCompletionSource = completionSource;
        }

        try
        {
            this.manager.GetUnfinishedTransactions();
        }
        catch (Exception exception)
        {
            this.FailUnfinishedTransactionsInvocation(completionSource, exception);
        }

        return await AwaitOperationAsync(completionSource.Task,
                                         cancellationToken,
                                         () => this.CancelUnfinishedTransactionsRequest(completionSource)).ConfigureAwait(false);
    }

    /// <inheritdoc/>
    public async Task<StoreKitPurchaseOutcome> PurchaseAsync(string productIdentifier,
                                                             string? appAccountToken = null,
                                                             int quantity = 1,
                                                             CancellationToken cancellationToken = default)
    {
        TaskCompletionSource<StoreKitPurchaseOutcome> completionSource;

        cancellationToken.ThrowIfCancellationRequested();
        ArgumentException.ThrowIfNullOrWhiteSpace(productIdentifier);

        lock (this.synchronizationLock)
        {
            this.ThrowIfDisposed();

            if (this.purchaseCompletionSource is not null)
            {
                throw CreateException(StoreKitWrapperErrorCode.PurchaseInProgress,
                                      PurchaseInProgressMessage);
            }

            completionSource = CreateCompletionSource<StoreKitPurchaseOutcome>();
            this.purchaseCompletionSource = completionSource;
        }

        try
        {
            this.manager.PurchaseWithProductIdentifier(productIdentifier,
                                                       appAccountToken,
                                                       quantity);
        }
        catch (Exception exception)
        {
            this.FailPurchaseInvocation(completionSource, exception);
        }

        return await AwaitOperationAsync(completionSource.Task,
                                         cancellationToken,
                                         () => this.CancelPurchase(completionSource)).ConfigureAwait(false);
    }

    /// <inheritdoc/>
    public async Task FinishTransactionAsync(ulong transactionIdentifier,
                                             CancellationToken cancellationToken = default)
    {
        TaskCompletionSource<bool> completionSource;

        cancellationToken.ThrowIfCancellationRequested();

        lock (this.synchronizationLock)
        {
            this.ThrowIfDisposed();

            if (this.finishTransactionCompletionSource is not null)
            {
                throw CreateException(StoreKitWrapperErrorCode.TransactionFinishInProgress,
                                      TransactionFinishInProgressMessage);
            }

            completionSource = CreateCompletionSource<bool>();
            this.finishTransactionCompletionSource = completionSource;
            this.finishTransactionIdentifier = transactionIdentifier;
        }

        try
        {
            this.manager.FinishTransactionWithTransactionIdentifier(transactionIdentifier);
        }
        catch (Exception exception)
        {
            this.FailFinishTransactionInvocation(completionSource, exception);
        }

        _ = await AwaitOperationAsync(completionSource.Task,
                                      cancellationToken,
                                      () => this.CancelTransactionFinish(completionSource)).ConfigureAwait(false);
    }

    /// <inheritdoc/>
    public void Dispose()
    {
        TaskCompletionSource<bool>? initialization;
        TaskCompletionSource<bool>? shutdown;
        TaskCompletionSource<IReadOnlyList<StoreKitProduct>>? products;
        TaskCompletionSource<IReadOnlyList<StoreKitTransaction>>? currentEntitlements;
        TaskCompletionSource<bool>? appStoreSync;
        TaskCompletionSource<IReadOnlyList<StoreKitTransaction>>? unfinishedTransactions;
        TaskCompletionSource<StoreKitPurchaseOutcome>? purchase;
        TaskCompletionSource<bool>? finishTransaction;

        lock (this.synchronizationLock)
        {
            if (this.disposed)
            {
                return;
            }

            this.disposed = true;
            initialization = this.initializationCompletionSource;
            shutdown = this.shutdownCompletionSource;
            products = this.productsCompletionSource;
            currentEntitlements = this.currentEntitlementsCompletionSource;
            appStoreSync = this.appStoreSyncCompletionSource;
            unfinishedTransactions = this.unfinishedTransactionsCompletionSource;
            purchase = this.purchaseCompletionSource;
            finishTransaction = this.finishTransactionCompletionSource;
            this.initializationCompletionSource = null;
            this.shutdownCompletionSource = null;
            this.productsCompletionSource = null;
            this.currentEntitlementsCompletionSource = null;
            this.appStoreSyncCompletionSource = null;
            this.unfinishedTransactionsCompletionSource = null;
            this.purchaseCompletionSource = null;
            this.finishTransactionCompletionSource = null;
        }

        initialization?.TrySetException(CreateDisposedException());
        shutdown?.TrySetException(CreateDisposedException());
        products?.TrySetException(CreateDisposedException());
        currentEntitlements?.TrySetException(CreateDisposedException());
        appStoreSync?.TrySetException(CreateDisposedException());
        unfinishedTransactions?.TrySetException(CreateDisposedException());
        purchase?.TrySetException(CreateDisposedException());
        finishTransaction?.TrySetException(CreateDisposedException());
        this.manager.Delegate = null;
        this.manager.Dispose();
        this.clientDelegate.Dispose();
        GC.SuppressFinalize(this);
    }

    internal void HandleInitializationCompleted(StoreKitWrapperErrorCode errorCode,
                                                string? errorMessage)
    {
        TaskCompletionSource<bool>? completionSource;

        lock (this.synchronizationLock)
        {
            completionSource = this.initializationCompletionSource;
            this.initializationCompletionSource = null;
        }

        Complete(completionSource, true, errorCode, errorMessage);
    }

    internal void HandleShutdownCompleted(StoreKitWrapperErrorCode errorCode,
                                          string? errorMessage)
    {
        TaskCompletionSource<bool>? completionSource;

        lock (this.synchronizationLock)
        {
            completionSource = this.shutdownCompletionSource;
            this.shutdownCompletionSource = null;
        }

        Complete(completionSource, true, errorCode, errorMessage);
    }

    internal void HandleAvailableProductsCompleted(StoreKitProduct[] products,
                                                   StoreKitWrapperErrorCode errorCode,
                                                   string? errorMessage)
    {
        TaskCompletionSource<IReadOnlyList<StoreKitProduct>>? completionSource;

        lock (this.synchronizationLock)
        {
            completionSource = this.productsCompletionSource;
            this.productsCompletionSource = null;
        }

        Complete(completionSource, Array.AsReadOnly(products), errorCode, errorMessage);
    }

    internal void HandleCurrentEntitlementsCompleted(StoreKitTransaction[] transactions,
                                                     StoreKitWrapperErrorCode errorCode,
                                                     string? errorMessage)
    {
        TaskCompletionSource<IReadOnlyList<StoreKitTransaction>>? completionSource;

        lock (this.synchronizationLock)
        {
            completionSource = this.currentEntitlementsCompletionSource;
            this.currentEntitlementsCompletionSource = null;
        }

        Complete(completionSource, Array.AsReadOnly(transactions), errorCode, errorMessage);
    }

    internal void HandleAppStoreSyncCompleted(StoreKitWrapperErrorCode errorCode,
                                              string? errorMessage)
    {
        TaskCompletionSource<bool>? completionSource;

        lock (this.synchronizationLock)
        {
            completionSource = this.appStoreSyncCompletionSource;
            this.appStoreSyncCompletionSource = null;
        }

        Complete(completionSource, true, errorCode, errorMessage);
    }

    internal void HandleUnfinishedTransactionsCompleted(StoreKitTransaction[] transactions,
                                                        StoreKitWrapperErrorCode errorCode,
                                                        string? errorMessage)
    {
        TaskCompletionSource<IReadOnlyList<StoreKitTransaction>>? completionSource;

        lock (this.synchronizationLock)
        {
            completionSource = this.unfinishedTransactionsCompletionSource;
            this.unfinishedTransactionsCompletionSource = null;
        }

        Complete(completionSource, Array.AsReadOnly(transactions), errorCode, errorMessage);
    }

    internal void HandlePurchaseCompleted(StoreKitTransaction? transaction,
                                          StoreKitPurchaseResult purchaseResult,
                                          StoreKitWrapperErrorCode errorCode,
                                          string? errorMessage)
    {
        TaskCompletionSource<StoreKitPurchaseOutcome>? completionSource;
        StoreKitPurchaseOutcome outcome;

        lock (this.synchronizationLock)
        {
            completionSource = this.purchaseCompletionSource;
            this.purchaseCompletionSource = null;
        }

        outcome = new StoreKitPurchaseOutcome(purchaseResult, transaction);
        Complete(completionSource, outcome, errorCode, errorMessage);
    }

    internal void HandleFinishTransactionCompleted(ulong transactionIdentifier,
                                                   StoreKitWrapperErrorCode errorCode,
                                                   string? errorMessage)
    {
        TaskCompletionSource<bool>? completionSource = null;

        lock (this.synchronizationLock)
        {
            if (this.finishTransactionCompletionSource is not null &&
                this.finishTransactionIdentifier == transactionIdentifier)
            {
                completionSource = this.finishTransactionCompletionSource;
                this.finishTransactionCompletionSource = null;
                this.finishTransactionIdentifier = 0;
            }
        }

        Complete(completionSource, true, errorCode, errorMessage);
    }

    internal void HandleTransactionUpdated(StoreKitTransaction transaction,
                                           StoreKitWrapperErrorCode errorCode,
                                           string? errorMessage)
    {
        EventHandler<StoreKitTransactionUpdatedEventArgs>? eventHandler;
        StoreKitTransactionUpdatedEventArgs eventArgs;

        eventHandler = this.TransactionUpdated;
        if (eventHandler is null)
        {
            return;
        }

        eventArgs = new StoreKitTransactionUpdatedEventArgs(transaction, errorCode, errorMessage);
        eventHandler.Invoke(this, eventArgs);
    }

    private static TaskCompletionSource<T> CreateCompletionSource<T>()
    {
        return new TaskCompletionSource<T>(TaskCreationOptions.RunContinuationsAsynchronously);
    }

    private static StoreKitWrapperException CreateException(StoreKitWrapperErrorCode errorCode,
                                                            string? errorMessage)
    {
        return new StoreKitWrapperException(errorCode, errorMessage);
    }

    private static ObjectDisposedException CreateDisposedException()
    {
        return new ObjectDisposedException(nameof(StoreKitClient));
    }

    private static async Task<T> AwaitOperationAsync<T>(Task<T> operationTask,
                                                        CancellationToken cancellationToken,
                                                        Action cancelNativeOperation)
    {
        CancellationTokenRegistration cancellationRegistration;

        cancellationRegistration = cancellationToken.Register(cancelNativeOperation);

        try
        {
            return await operationTask.WaitAsync(cancellationToken).ConfigureAwait(false);
        }
        catch (StoreKitWrapperException exception) when (exception.ErrorCode == StoreKitWrapperErrorCode.OperationCancelled &&
                                                         cancellationToken.IsCancellationRequested)
        {
            throw new OperationCanceledException(cancellationToken);
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            ObserveFault(operationTask);
            throw;
        }
        finally
        {
            cancellationRegistration.Dispose();
        }
    }

    private static void ObserveFault(Task operationTask)
    {
        Action<Task> observeFault = static completedTask =>
        {
            _ = completedTask.Exception;
        };

        _ = operationTask.ContinueWith(observeFault,
                                       CancellationToken.None,
                                       TaskContinuationOptions.ExecuteSynchronously | TaskContinuationOptions.OnlyOnFaulted,
                                       TaskScheduler.Default);
    }

    private static void Complete<T>(TaskCompletionSource<T>? completionSource,
                                    T result,
                                    StoreKitWrapperErrorCode errorCode,
                                    string? errorMessage)
    {
        if (completionSource is null)
        {
            return;
        }

        if (errorCode == StoreKitWrapperErrorCode.None)
        {
            completionSource.TrySetResult(result);
            return;
        }

        completionSource.TrySetException(CreateException(errorCode, errorMessage));
    }

    private void ThrowIfDisposed()
    {
        ObjectDisposedException.ThrowIf(this.disposed, this);
    }

    private void CancelInitialization(TaskCompletionSource<bool> completionSource)
    {
        this.RequestNativeCancellation(() => ReferenceEquals(this.initializationCompletionSource, completionSource),
                                       static manager => manager.CancelInitialization());
    }

    private void CancelShutdown(TaskCompletionSource<bool> completionSource)
    {
        this.RequestNativeCancellation(() => ReferenceEquals(this.shutdownCompletionSource, completionSource),
                                       static manager => manager.CancelShutdown());
    }

    private void CancelProductsRequest(TaskCompletionSource<IReadOnlyList<StoreKitProduct>> completionSource)
    {
        this.RequestNativeCancellation(() => ReferenceEquals(this.productsCompletionSource, completionSource),
                                       static manager => manager.CancelProductsRequest());
    }

    private void CancelCurrentEntitlementsRequest(TaskCompletionSource<IReadOnlyList<StoreKitTransaction>> completionSource)
    {
        this.RequestNativeCancellation(() => ReferenceEquals(this.currentEntitlementsCompletionSource, completionSource),
                                       static manager => manager.CancelCurrentEntitlementsRequest());
    }

    private void CancelAppStoreSync(TaskCompletionSource<bool> completionSource)
    {
        this.RequestNativeCancellation(() => ReferenceEquals(this.appStoreSyncCompletionSource, completionSource),
                                       static manager => manager.CancelAppStoreSync());
    }

    private void CancelUnfinishedTransactionsRequest(TaskCompletionSource<IReadOnlyList<StoreKitTransaction>> completionSource)
    {
        this.RequestNativeCancellation(() => ReferenceEquals(this.unfinishedTransactionsCompletionSource, completionSource),
                                       static manager => manager.CancelUnfinishedTransactionsRequest());
    }

    private void CancelPurchase(TaskCompletionSource<StoreKitPurchaseOutcome> completionSource)
    {
        this.RequestNativeCancellation(() => ReferenceEquals(this.purchaseCompletionSource, completionSource),
                                       static manager => manager.CancelPurchase());
    }

    private void CancelTransactionFinish(TaskCompletionSource<bool> completionSource)
    {
        this.RequestNativeCancellation(() => ReferenceEquals(this.finishTransactionCompletionSource, completionSource),
                                       static manager => manager.CancelTransactionFinish());
    }

    private void RequestNativeCancellation(Func<bool> isCurrentOperation,
                                           Action<StoreKitManager> cancelNativeOperation)
    {
        lock (this.synchronizationLock)
        {
            if (this.disposed || !isCurrentOperation())
            {
                return;
            }

            cancelNativeOperation(this.manager);
        }
    }

    private void FailInitializationInvocation(TaskCompletionSource<bool> completionSource,
                                              Exception exception)
    {
        lock (this.synchronizationLock)
        {
            if (ReferenceEquals(this.initializationCompletionSource, completionSource))
            {
                this.initializationCompletionSource = null;
            }
        }

        completionSource.TrySetException(exception);
    }

    private void FailShutdownInvocation(TaskCompletionSource<bool> completionSource,
                                        Exception exception)
    {
        lock (this.synchronizationLock)
        {
            if (ReferenceEquals(this.shutdownCompletionSource, completionSource))
            {
                this.shutdownCompletionSource = null;
            }
        }

        completionSource.TrySetException(exception);
    }

    private void FailProductsInvocation(TaskCompletionSource<IReadOnlyList<StoreKitProduct>> completionSource,
                                        Exception exception)
    {
        lock (this.synchronizationLock)
        {
            if (ReferenceEquals(this.productsCompletionSource, completionSource))
            {
                this.productsCompletionSource = null;
            }
        }

        completionSource.TrySetException(exception);
    }

    private void FailCurrentEntitlementsInvocation(TaskCompletionSource<IReadOnlyList<StoreKitTransaction>> completionSource,
                                                   Exception exception)
    {
        lock (this.synchronizationLock)
        {
            if (ReferenceEquals(this.currentEntitlementsCompletionSource, completionSource))
            {
                this.currentEntitlementsCompletionSource = null;
            }
        }

        completionSource.TrySetException(exception);
    }

    private void FailAppStoreSyncInvocation(TaskCompletionSource<bool> completionSource,
                                            Exception exception)
    {
        lock (this.synchronizationLock)
        {
            if (ReferenceEquals(this.appStoreSyncCompletionSource, completionSource))
            {
                this.appStoreSyncCompletionSource = null;
            }
        }

        completionSource.TrySetException(exception);
    }

    private void FailUnfinishedTransactionsInvocation(TaskCompletionSource<IReadOnlyList<StoreKitTransaction>> completionSource,
                                                      Exception exception)
    {
        lock (this.synchronizationLock)
        {
            if (ReferenceEquals(this.unfinishedTransactionsCompletionSource, completionSource))
            {
                this.unfinishedTransactionsCompletionSource = null;
            }
        }

        completionSource.TrySetException(exception);
    }

    private void FailPurchaseInvocation(TaskCompletionSource<StoreKitPurchaseOutcome> completionSource,
                                        Exception exception)
    {
        lock (this.synchronizationLock)
        {
            if (ReferenceEquals(this.purchaseCompletionSource, completionSource))
            {
                this.purchaseCompletionSource = null;
            }
        }

        completionSource.TrySetException(exception);
    }

    private void FailFinishTransactionInvocation(TaskCompletionSource<bool> completionSource,
                                                 Exception exception)
    {
        lock (this.synchronizationLock)
        {
            if (ReferenceEquals(this.finishTransactionCompletionSource, completionSource))
            {
                this.finishTransactionCompletionSource = null;
                this.finishTransactionIdentifier = 0;
            }
        }

        completionSource.TrySetException(exception);
    }

    #endregion
}
