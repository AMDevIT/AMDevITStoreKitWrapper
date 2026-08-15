using ObjCRuntime;

namespace AMDevIT.StoreKitWrapper {
	[Native]
	public enum StoreKitProductType : long {
		Unknown = -1,
		Consumable = 0,
		NonConsumable = 1,
		NonRenewableSubscription = 2,
		AutoRenewableSubscription = 3
	}

	[Native]
	public enum StoreKitPurchaseResult : long {
		Unknown = -1,
		Succeeded = 0,
		Pending = 1,
		Cancelled = 2,
		Failed = 3
	}

	[Native]
	public enum StoreKitSubscriptionOfferPaymentMode : long {
		Unknown = -1,
		FreeTrial = 0,
		PayAsYouGo = 1,
		PayUpFront = 2
	}

	[Native]
	public enum StoreKitSubscriptionOfferType : long {
		Unknown = -1,
		Introductory = 0,
		Promotional = 1,
		WinBack = 2
	}

	[Native]
	public enum StoreKitSubscriptionPeriodUnit : long {
		Unknown = -1,
		Day = 0,
		Week = 1,
		Month = 2,
		Year = 3
	}

	[Native]
	public enum StoreKitTransactionEnvironment : long {
		Unknown = -1,
		Xcode = 0,
		Sandbox = 1,
		Production = 2
	}

	[Native]
	public enum StoreKitTransactionOfferPaymentMode : long {
		Unknown = -1,
		FreeTrial = 0,
		PayAsYouGo = 1,
		PayUpFront = 2,
		OneTime = 3
	}

	[Native]
	public enum StoreKitTransactionOfferType : long {
		Unknown = -1,
		Introductory = 0,
		Promotional = 1,
		Code = 2,
		WinBack = 3
	}

	[Native]
	public enum StoreKitTransactionOwnershipType : long {
		Unknown = -1,
		Purchased = 0,
		FamilyShared = 1
	}

	[Native]
	public enum StoreKitTransactionReason : long {
		Unknown = -1,
		Purchase = 0,
		Renewal = 1
	}

	[Native]
	public enum StoreKitTransactionRevocationReason : long {
		None = -1,
		DeveloperIssue = 0,
		Other = 1,
		Unknown = 999
	}

	[Native]
	public enum StoreKitTransactionVerificationErrorCode : long {
		None = 0,
		InvalidCertificateChain = 1,
		InvalidDeviceVerification = 2,
		InvalidEncoding = 3,
		InvalidSignature = 4,
		MissingRequiredProperties = 5,
		RevokedCertificate = 6,
		Unknown = 999
	}

	[Native]
	public enum StoreKitTransactionVerificationStatus : long {
		Unverified = 0,
		Verified = 1
	}

	[Native]
	public enum StoreKitWrapperErrorCode : long {
		None = 0,
		Unknown = 1,
		InvalidArgument = 2,
		OperationCancelled = 3,
		ManagerNotInitialized = 10,
		ManagerShutdown = 11,
		StoreKitNetworkError = 20,
		StoreKitSystemError = 21,
		StoreKitNotAvailableInStorefront = 22,
		StoreKitNotEntitled = 23,
		StoreKitUnknown = 24,
		StoreKitUnsupported = 25,
		ProductsRequestInProgress = 100,
		ProductsRequestFailed = 101,
		ProductNotFound = 200,
		PurchaseInProgress = 201,
		PurchaseFailed = 202,
		TransactionVerificationFailed = 203,
		PurchaseProductUnavailable = 204,
		PurchaseNotAllowed = 205,
		PurchaseInvalidQuantity = 206,
		PurchaseInvalidOfferIdentifier = 207,
		PurchaseInvalidOfferPrice = 208,
		PurchaseInvalidOfferSignature = 209,
		PurchaseMissingOfferParameters = 210,
		PurchaseIneligibleForOffer = 211,
		PurchasePaymentMethodBindingConfigurationRequired = 212,
		TransactionNotFound = 300,
		TransactionFinishInProgress = 301,
		CurrentEntitlementsRequestInProgress = 400,
		AppStoreSyncInProgress = 500,
		AppStoreSyncFailed = 501,
		UnfinishedTransactionsRequestInProgress = 600
	}

	[Native]
	public enum StoreKitWrapperLogLevel : long {
		Trace = 0,
		Debug = 1,
		Information = 2,
		Warning = 3,
		Error = 4,
		Critical = 5,
		None = 6
	}
}
