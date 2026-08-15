using ObjCRuntime;

namespace AMDevIT.StoreKitWrapper {
	/// <summary>Identifies the StoreKit category of a product.</summary>
	[Native]
	public enum StoreKitProductType : long {
		/// <summary>A product type unknown to this wrapper version.</summary>
		Unknown = -1,
		/// <summary>A product that can be consumed and purchased repeatedly.</summary>
		Consumable = 0,
		/// <summary>A product purchased once without expiration.</summary>
		NonConsumable = 1,
		/// <summary>A subscription that doesn't renew automatically.</summary>
		NonRenewableSubscription = 2,
		/// <summary>A subscription that renews automatically until cancelled.</summary>
		AutoRenewableSubscription = 3
	}

	/// <summary>Describes the outcome of a programmatic purchase request.</summary>
	[Native]
	public enum StoreKitPurchaseResult : long {
		/// <summary>A purchase result unknown to this wrapper version.</summary>
		Unknown = -1,
		/// <summary>The purchase completed and produced a transaction.</summary>
		Succeeded = 0,
		/// <summary>The purchase is waiting for an external action.</summary>
		Pending = 1,
		/// <summary>The customer cancelled the purchase flow.</summary>
		Cancelled = 2,
		/// <summary>The purchase failed.</summary>
		Failed = 3
	}

	/// <summary>Describes how a product-level subscription offer is charged.</summary>
	[Native]
	public enum StoreKitSubscriptionOfferPaymentMode : long {
		/// <summary>A payment mode unknown to this wrapper version.</summary>
		Unknown = -1,
		/// <summary>The customer pays nothing during the offer.</summary>
		FreeTrial = 0,
		/// <summary>The customer pays in installments.</summary>
		PayAsYouGo = 1,
		/// <summary>The customer pays once for the complete offer period.</summary>
		PayUpFront = 2
	}

	/// <summary>Identifies a product-level subscription offer kind.</summary>
	[Native]
	public enum StoreKitSubscriptionOfferType : long {
		/// <summary>An offer kind unknown to this wrapper version.</summary>
		Unknown = -1,
		/// <summary>An offer for eligible new subscribers.</summary>
		Introductory = 0,
		/// <summary>A promotional offer for selected customers.</summary>
		Promotional = 1,
		/// <summary>An offer intended to recover a previous subscriber.</summary>
		WinBack = 2
	}

	/// <summary>Identifies the calendar unit used by a subscription period.</summary>
	[Native]
	public enum StoreKitSubscriptionPeriodUnit : long {
		/// <summary>A period unit unknown to this wrapper version.</summary>
		Unknown = -1,
		/// <summary>A period measured in days.</summary>
		Day = 0,
		/// <summary>A period measured in weeks.</summary>
		Week = 1,
		/// <summary>A period measured in months.</summary>
		Month = 2,
		/// <summary>A period measured in years.</summary>
		Year = 3
	}

	/// <summary>Identifies the App Store environment that created a transaction.</summary>
	[Native]
	public enum StoreKitTransactionEnvironment : long {
		/// <summary>An environment unknown to this wrapper version.</summary>
		Unknown = -1,
		/// <summary>An Xcode StoreKit configuration.</summary>
		Xcode = 0,
		/// <summary>The App Store sandbox.</summary>
		Sandbox = 1,
		/// <summary>The production App Store.</summary>
		Production = 2
	}

	/// <summary>Describes how the offer attached to a transaction was charged.</summary>
	[Native]
	public enum StoreKitTransactionOfferPaymentMode : long {
		/// <summary>A payment mode unknown to this wrapper version.</summary>
		Unknown = -1,
		/// <summary>The offer provided a free trial.</summary>
		FreeTrial = 0,
		/// <summary>The offer charged in installments.</summary>
		PayAsYouGo = 1,
		/// <summary>The offer charged once for its full period.</summary>
		PayUpFront = 2,
		/// <summary>The offer used a one-time payment.</summary>
		OneTime = 3
	}

	/// <summary>Identifies the subscription offer applied to a transaction.</summary>
	[Native]
	public enum StoreKitTransactionOfferType : long {
		/// <summary>An offer kind unknown to this wrapper version.</summary>
		Unknown = -1,
		/// <summary>An introductory offer.</summary>
		Introductory = 0,
		/// <summary>A promotional offer.</summary>
		Promotional = 1,
		/// <summary>An offer code.</summary>
		Code = 2,
		/// <summary>A win-back offer.</summary>
		WinBack = 3
	}

	/// <summary>Describes how the current customer obtained a transaction.</summary>
	[Native]
	public enum StoreKitTransactionOwnershipType : long {
		/// <summary>An ownership type unknown to this wrapper version.</summary>
		Unknown = -1,
		/// <summary>The customer purchased the product directly.</summary>
		Purchased = 0,
		/// <summary>The customer received access through Family Sharing.</summary>
		FamilyShared = 1
	}

	/// <summary>Describes why the App Store created a transaction.</summary>
	[Native]
	public enum StoreKitTransactionReason : long {
		/// <summary>A reason unknown to this wrapper version.</summary>
		Unknown = -1,
		/// <summary>The customer initiated a purchase.</summary>
		Purchase = 0,
		/// <summary>StoreKit renewed an auto-renewable subscription.</summary>
		Renewal = 1
	}

	/// <summary>Identifies why the App Store revoked a transaction.</summary>
	[Native]
	public enum StoreKitTransactionRevocationReason : long {
		/// <summary>The transaction hasn't been revoked.</summary>
		None = -1,
		/// <summary>The App Store refunded the transaction because of a developer issue.</summary>
		DeveloperIssue = 0,
		/// <summary>The App Store revoked the transaction for another recognized reason.</summary>
		Other = 1,
		/// <summary>A revocation reason unknown to this wrapper version.</summary>
		Unknown = 999
	}

	/// <summary>Identifies why a transaction failed StoreKit verification.</summary>
	[Native]
	public enum StoreKitTransactionVerificationErrorCode : long {
		/// <summary>No verification error occurred.</summary>
		None = 0,
		/// <summary>The signing certificate chain is invalid.</summary>
		InvalidCertificateChain = 1,
		/// <summary>The device-verification data is invalid.</summary>
		InvalidDeviceVerification = 2,
		/// <summary>The signed transaction data has invalid encoding.</summary>
		InvalidEncoding = 3,
		/// <summary>The transaction signature is invalid.</summary>
		InvalidSignature = 4,
		/// <summary>Required signed transaction properties are missing.</summary>
		MissingRequiredProperties = 5,
		/// <summary>A certificate in the signing chain was revoked.</summary>
		RevokedCertificate = 6,
		/// <summary>A verification failure unknown to this wrapper version.</summary>
		Unknown = 999
	}

	/// <summary>Indicates whether StoreKit cryptographically verified a transaction.</summary>
	[Native]
	public enum StoreKitTransactionVerificationStatus : long {
		/// <summary>The transaction failed verification and must not grant content.</summary>
		Unverified = 0,
		/// <summary>StoreKit successfully verified the transaction.</summary>
		Verified = 1
	}

	/// <summary>Defines stable error codes returned by the native wrapper.</summary>
	[Native]
	public enum StoreKitWrapperErrorCode : long {
		/// <summary>The operation completed successfully.</summary>
		None = 0,
		/// <summary>An unknown failure occurred.</summary>
		Unknown = 1,
		/// <summary>One or more arguments are invalid.</summary>
		InvalidArgument = 2,
		/// <summary>The operation was cancelled.</summary>
		OperationCancelled = 3,
		/// <summary>The manager hasn't been initialized.</summary>
		ManagerNotInitialized = 10,
		/// <summary>The manager has shut down or is shutting down.</summary>
		ManagerShutdown = 11,
		/// <summary>StoreKit failed because of a network error.</summary>
		StoreKitNetworkError = 20,
		/// <summary>StoreKit reported an underlying system error.</summary>
		StoreKitSystemError = 21,
		/// <summary>The item isn't available in the current storefront.</summary>
		StoreKitNotAvailableInStorefront = 22,
		/// <summary>The customer isn't entitled to perform the operation.</summary>
		StoreKitNotEntitled = 23,
		/// <summary>StoreKit reported an unknown error.</summary>
		StoreKitUnknown = 24,
		/// <summary>The requested StoreKit operation isn't supported.</summary>
		StoreKitUnsupported = 25,
		/// <summary>Another product request is already active.</summary>
		ProductsRequestInProgress = 100,
		/// <summary>The product request failed.</summary>
		ProductsRequestFailed = 101,
		/// <summary>The requested product wasn't found.</summary>
		ProductNotFound = 200,
		/// <summary>Another purchase is already active.</summary>
		PurchaseInProgress = 201,
		/// <summary>The purchase failed without a more specific code.</summary>
		PurchaseFailed = 202,
		/// <summary>StoreKit couldn't verify the returned transaction.</summary>
		TransactionVerificationFailed = 203,
		/// <summary>The product isn't available for purchase.</summary>
		PurchaseProductUnavailable = 204,
		/// <summary>Purchases aren't allowed for the current customer or device.</summary>
		PurchaseNotAllowed = 205,
		/// <summary>The requested purchase quantity is invalid.</summary>
		PurchaseInvalidQuantity = 206,
		/// <summary>The promotional offer identifier is invalid.</summary>
		PurchaseInvalidOfferIdentifier = 207,
		/// <summary>The promotional offer price is invalid.</summary>
		PurchaseInvalidOfferPrice = 208,
		/// <summary>The promotional offer signature is invalid.</summary>
		PurchaseInvalidOfferSignature = 209,
		/// <summary>Required promotional offer parameters are missing.</summary>
		PurchaseMissingOfferParameters = 210,
		/// <summary>The customer isn't eligible for the requested offer.</summary>
		PurchaseIneligibleForOffer = 211,
		/// <summary>The storefront requires payment-method binding configuration.</summary>
		PurchasePaymentMethodBindingConfigurationRequired = 212,
		/// <summary>No finishable verified transaction matches the identifier.</summary>
		TransactionNotFound = 300,
		/// <summary>The transaction is already being finished.</summary>
		TransactionFinishInProgress = 301,
		/// <summary>Another current-entitlements request is already active.</summary>
		CurrentEntitlementsRequestInProgress = 400,
		/// <summary>Another App Store synchronization request is already active.</summary>
		AppStoreSyncInProgress = 500,
		/// <summary>App Store synchronization failed.</summary>
		AppStoreSyncFailed = 501,
		/// <summary>Another unfinished-transactions request is already active.</summary>
		UnfinishedTransactionsRequestInProgress = 600
	}

	/// <summary>Defines log severity levels compatible with Microsoft.Extensions.Logging.</summary>
	[Native]
	public enum StoreKitWrapperLogLevel : long {
		/// <summary>Detailed diagnostic information.</summary>
		Trace = 0,
		/// <summary>Debugging information.</summary>
		Debug = 1,
		/// <summary>Normal operational information.</summary>
		Information = 2,
		/// <summary>A potentially harmful or unexpected condition.</summary>
		Warning = 3,
		/// <summary>A failure in the current operation.</summary>
		Error = 4,
		/// <summary>A critical failure requiring immediate attention.</summary>
		Critical = 5,
		/// <summary>Logging is disabled.</summary>
		None = 6
	}
}
