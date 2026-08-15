using System;
using Foundation;
using ObjCRuntime;
using UIKit;

namespace AMDevIT.StoreKitWrapper {
	// @protocol IStoreKitWrapperLogger
	/// <summary>Receives structured diagnostic events emitted by the StoreKit wrapper.</summary>
	[BaseType (typeof (NSObject))]
	[Model, Protocol (Name = "_TtP15StoreKitWrapper22IStoreKitWrapperLogger_")]
	interface StoreKitWrapperLogger {
		/// <summary>Determines whether logging is enabled for the specified severity.</summary>
		// @required -(BOOL)isEnabledWithLogLevel:(enum StoreKitWrapperLogLevel)logLevel __attribute__((warn_unused_result("")));
		[Abstract]
		[Export ("isEnabledWithLogLevel:")]
		bool IsEnabledWithLogLevel (StoreKitWrapperLogLevel logLevel);

		/// <summary>Records a structured StoreKit wrapper log event.</summary>
		// @required -(void)logWithLogLevel:(enum StoreKitWrapperLogLevel)logLevel eventId:(NSInteger)eventId eventName:(NSString * _Nullable)eventName message:(NSString * _Nonnull)message error:(NSError * _Nullable)error;
		[Abstract]
		[Export ("logWithLogLevel:eventId:eventName:message:error:")]
		void LogWithLogLevel (StoreKitWrapperLogLevel logLevel, nint eventId, [NullAllowed] string eventName, string message, [NullAllowed] NSError error);
	}

	// @interface StoreKitManager : NSObject
	/// <summary>Coordinates StoreKit operations through an Objective-C-compatible callback API.</summary>
	/// <remarks>Set <see cref="Delegate"/>, initialize the manager, and process terminal delegate callbacks before issuing dependent operations. Callbacks aren't dispatched to the main thread.</remarks>
	[BaseType (typeof (NSObject), Name = "_TtC15StoreKitWrapper15StoreKitManager")]
	interface StoreKitManager {
		/// <summary>Gets or sets the strongly typed receiver for operation completions and transaction updates.</summary>
		[Wrap ("WeakDelegate")]
		[NullAllowed]
		StoreKitManagerDelegate Delegate { get; set; }

		/// <summary>Gets or sets the untyped native delegate reference.</summary>
		// @property (nonatomic, strong) id<StoreKitManagerDelegate> _Nullable delegate;
		[NullAllowed, Export ("delegate", ArgumentSemantic.Strong)]
		NSObject WeakDelegate { get; set; }

		/// <summary>Creates a manager with optional logging and callback receivers.</summary>
		// -(instancetype _Nonnull)initWithLogger:(id<IStoreKitWrapperLogger> _Nullable)logger delegate:(id<StoreKitManagerDelegate> _Nullable)delegate __attribute__((objc_designated_initializer));
		[Export ("initWithLogger:delegate:")]
		[DesignatedInitializer]
		NativeHandle Constructor ([NullAllowed] StoreKitWrapperLogger logger,
		                          [NullAllowed] StoreKitManagerDelegate @delegate);

		/// <summary>Initializes the manager and starts its persistent transaction listener.</summary>
		// -(void)initialize;
		[Export ("initialize")]
		void Initialize ();

		/// <summary>Stops the transaction listener and shuts down the manager.</summary>
		// -(void)shutdown;
		[Export ("shutdown")]
		void Shutdown ();

		/// <summary>Invalidates the current product catalog and requests fresh metadata for the supplied product identifiers.</summary>
		// -(void)getProductsWithProductIdentifiers:(NSArray<NSString *> * _Nonnull)productIdentifiers;
		[Export ("getProductsWithProductIdentifiers:")]
		void GetProductsWithProductIdentifiers (string [] productIdentifiers);

		/// <summary>Invalidates and reloads the customer's current entitlement snapshot.</summary>
		// -(void)getCurrentEntitlements;
		[Export ("getCurrentEntitlements")]
		void GetCurrentEntitlements ();

		/// <summary>Explicitly synchronizes transaction information with the App Store.</summary>
		/// <remarks>Invoke this operation only from a user-initiated restore action because StoreKit may display authentication UI.</remarks>
		// -(void)sync;
		[Export ("sync")]
		void Sync ();

		/// <summary>Invalidates and reloads the currently unfinished verified transactions.</summary>
		// -(void)getUnfinishedTransactions;
		[Export ("getUnfinishedTransactions")]
		void GetUnfinishedTransactions ();

		/// <summary>Purchases one unit of a previously loaded product.</summary>
		// -(void)purchaseWithProductIdentifier:(NSString * _Nonnull)productIdentifier;
		[Export ("purchaseWithProductIdentifier:")]
		void PurchaseWithProductIdentifier (string productIdentifier);

		/// <summary>Purchases one unit of a product with an optional application account token.</summary>
		// -(void)purchaseWithProductIdentifier:(NSString * _Nonnull)productIdentifier appAccountToken:(NSString * _Nullable)appAccountToken;
		[Export ("purchaseWithProductIdentifier:appAccountToken:")]
		void PurchaseWithProductIdentifier (string productIdentifier, [NullAllowed] string appAccountToken);

		/// <summary>Purchases a product using the supplied application account token and quantity.</summary>
		// -(void)purchaseWithProductIdentifier:(NSString * _Nonnull)productIdentifier appAccountToken:(NSString * _Nullable)appAccountToken quantity:(NSInteger)quantity;
		[Export ("purchaseWithProductIdentifier:appAccountToken:quantity:")]
		void PurchaseWithProductIdentifier (string productIdentifier, [NullAllowed] string appAccountToken, nint quantity);

		/// <summary>Finishes a verified transaction after the application has durably delivered its content.</summary>
		// -(void)finishTransactionWithTransactionIdentifier:(uint64_t)transactionIdentifier;
		[Export ("finishTransactionWithTransactionIdentifier:")]
		void FinishTransactionWithTransactionIdentifier (ulong transactionIdentifier);

		/// <summary>Cooperatively cancels active initialization work.</summary>
		// -(void)cancelInitialization;
		[Export ("cancelInitialization")]
		void CancelInitialization ();

		/// <summary>Cooperatively cancels an active shutdown wait.</summary>
		// -(void)cancelShutdown;
		[Export ("cancelShutdown")]
		void CancelShutdown ();

		/// <summary>Cooperatively cancels the active product request.</summary>
		// -(void)cancelProductsRequest;
		[Export ("cancelProductsRequest")]
		void CancelProductsRequest ();

		/// <summary>Cooperatively cancels the active current-entitlements request.</summary>
		// -(void)cancelCurrentEntitlementsRequest;
		[Export ("cancelCurrentEntitlementsRequest")]
		void CancelCurrentEntitlementsRequest ();

		/// <summary>Cooperatively cancels active App Store synchronization.</summary>
		// -(void)cancelAppStoreSync;
		[Export ("cancelAppStoreSync")]
		void CancelAppStoreSync ();

		/// <summary>Cooperatively cancels the active unfinished-transactions request.</summary>
		// -(void)cancelUnfinishedTransactionsRequest;
		[Export ("cancelUnfinishedTransactionsRequest")]
		void CancelUnfinishedTransactionsRequest ();

		/// <summary>Cooperatively cancels the active purchase task.</summary>
		/// <remarks>Cancellation can't guarantee dismissal or rollback of App Store UI or a transaction StoreKit has already created.</remarks>
		// -(void)cancelPurchase;
		[Export ("cancelPurchase")]
		void CancelPurchase ();

		/// <summary>Cooperatively cancels transaction finishing before StoreKit accepts the finish operation.</summary>
		// -(void)cancelTransactionFinish;
		[Export ("cancelTransactionFinish")]
		void CancelTransactionFinish ();
	}

	// @protocol StoreKitManagerDelegate
	/// <summary>Receives operation completions and persistent transaction updates from the native manager.</summary>
	/// <remarks>Callbacks arrive on the executor used by the underlying native operation and aren't dispatched to the main thread.</remarks>
	[BaseType (typeof (NSObject))]
	[Model, Protocol (Name = "_TtP15StoreKitWrapper23StoreKitManagerDelegate_")]
	interface StoreKitManagerDelegate {
		/// <summary>Reports completion of manager initialization.</summary>
		// @required -(void)initializationCompletedWithErrorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("initializationCompletedWithErrorCode:errorMessage:")]
		void InitializationCompletedWithErrorCode (StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		/// <summary>Reports completion of manager shutdown.</summary>
		// @required -(void)shutdownCompletedWithErrorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("shutdownCompletedWithErrorCode:errorMessage:")]
		void ShutdownCompletedWithErrorCode (StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		/// <summary>Reports the products returned by the latest product request.</summary>
		// @required -(void)availableProductsCompletedWithResult:(NSArray<StoreKitProduct *> * _Nonnull)withResult errorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("availableProductsCompletedWithResult:errorCode:errorMessage:")]
		void AvailableProductsCompletedWithResult (StoreKitProduct [] withResult, StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		/// <summary>Reports the current entitlement snapshot.</summary>
		// @required -(void)currentEntitlementsCompletedWithResult:(NSArray<StoreKitTransaction *> * _Nonnull)withResult errorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("currentEntitlementsCompletedWithResult:errorCode:errorMessage:")]
		void CurrentEntitlementsCompletedWithResult (StoreKitTransaction [] withResult, StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		/// <summary>Reports completion of explicit App Store synchronization.</summary>
		// @required -(void)appStoreSyncCompletedWithErrorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("appStoreSyncCompletedWithErrorCode:errorMessage:")]
		void AppStoreSyncCompletedWithErrorCode (StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		/// <summary>Reports unfinished verified transactions known to StoreKit.</summary>
		// @required -(void)unfinishedTransactionsCompletedWithResult:(NSArray<StoreKitTransaction *> * _Nonnull)withResult errorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("unfinishedTransactionsCompletedWithResult:errorCode:errorMessage:")]
		void UnfinishedTransactionsCompletedWithResult (StoreKitTransaction [] withResult, StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		/// <summary>Reports the outcome of a programmatic purchase request.</summary>
		// @required -(void)purchaseCompletedWithResult:(StoreKitTransaction * _Nullable)withResult purchaseResult:(enum StoreKitPurchaseResult)purchaseResult errorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("purchaseCompletedWithResult:purchaseResult:errorCode:errorMessage:")]
		void PurchaseCompletedWithResult ([NullAllowed] StoreKitTransaction withResult, StoreKitPurchaseResult purchaseResult, StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		/// <summary>Reports completion of a request to finish a verified transaction.</summary>
		// @required -(void)finishTransactionCompletedWithTransactionIdentifier:(uint64_t)transactionIdentifier errorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("finishTransactionCompletedWithTransactionIdentifier:errorCode:errorMessage:")]
		void FinishTransactionCompletedWithTransactionIdentifier (ulong transactionIdentifier, StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		/// <summary>Reports a transaction emitted by the persistent StoreKit listener.</summary>
		// @required -(void)transactionUpdatedWithResult:(StoreKitTransaction * _Nonnull)withResult errorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("transactionUpdatedWithResult:errorCode:errorMessage:")]
		void TransactionUpdatedWithResult (StoreKitTransaction withResult, StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);
	}

	// @interface StoreKitProduct : NSObject
	/// <summary>Provides an immutable snapshot of StoreKit product metadata.</summary>
	[BaseType (typeof (NSObject), Name = "_TtC15StoreKitWrapper15StoreKitProduct")]
	[DisableDefaultCtor]
	interface StoreKitProduct {
		/// <summary>Gets the App Store Connect product identifier.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull identifier;
		[Export ("identifier")]
		string Identifier { get; }

		/// <summary>Gets the normalized StoreKit product category.</summary>
		// @property (readonly, nonatomic) enum StoreKitProductType productType;
		[Export ("productType")]
		StoreKitProductType ProductType { get; }

		/// <summary>Gets StoreKit's localized description of the product category.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull productTypeDisplayName;
		[Export ("productTypeDisplayName")]
		string ProductTypeDisplayName { get; }

		/// <summary>Gets the localized product name.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull displayName;
		[Export ("displayName")]
		string DisplayName { get; }

		/// <summary>Gets the localized product description.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull displayDescription;
		[Export ("displayDescription")]
		string DisplayDescription { get; }

		/// <summary>Gets the localized, currency-formatted product price.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull displayPrice;
		[Export ("displayPrice")]
		string DisplayPrice { get; }

		/// <summary>Gets the product price as a decimal number.</summary>
		// @property (readonly, nonatomic, strong) NSDecimalNumber * _Nonnull price;
		[Export ("price", ArgumentSemantic.Strong)]
		NSDecimalNumber Price { get; }

		/// <summary>Gets the ISO 4217 currency code used by the price.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull currencyCode;
		[Export ("currencyCode")]
		string CurrencyCode { get; }

		/// <summary>Gets the locale identifier used to format the price.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull localeIdentifier;
		[Export ("localeIdentifier")]
		string LocaleIdentifier { get; }

		/// <summary>Gets a value indicating whether the product supports Family Sharing.</summary>
		// @property (readonly, nonatomic) BOOL isFamilyShareable;
		[Export ("isFamilyShareable")]
		bool IsFamilyShareable { get; }

		/// <summary>Gets subscription metadata, or <see langword="null"/> for a non-subscription product.</summary>
		// @property (readonly, nonatomic, strong) StoreKitSubscriptionInfo * _Nullable subscriptionInfo;
		[NullAllowed, Export ("subscriptionInfo", ArgumentSemantic.Strong)]
		StoreKitSubscriptionInfo SubscriptionInfo { get; }

		/// <summary>Gets StoreKit's raw product JSON as a UTF-8 string.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull jsonRepresentation;
		[Export ("jsonRepresentation")]
		string JsonRepresentation { get; }

		/// <summary>Creates an immutable product metadata snapshot.</summary>
		// -(instancetype _Nonnull)initWithIdentifier:(NSString * _Nonnull)identifier productType:(enum StoreKitProductType)productType productTypeDisplayName:(NSString * _Nonnull)productTypeDisplayName displayName:(NSString * _Nonnull)displayName displayDescription:(NSString * _Nonnull)displayDescription displayPrice:(NSString * _Nonnull)displayPrice price:(NSDecimalNumber * _Nonnull)price currencyCode:(NSString * _Nonnull)currencyCode localeIdentifier:(NSString * _Nonnull)localeIdentifier isFamilyShareable:(BOOL)isFamilyShareable subscriptionInfo:(StoreKitSubscriptionInfo * _Nullable)subscriptionInfo jsonRepresentation:(NSString * _Nonnull)jsonRepresentation __attribute__((objc_designated_initializer));
		[Export ("initWithIdentifier:productType:productTypeDisplayName:displayName:displayDescription:displayPrice:price:currencyCode:localeIdentifier:isFamilyShareable:subscriptionInfo:jsonRepresentation:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string identifier, StoreKitProductType productType, string productTypeDisplayName, string displayName, string displayDescription, string displayPrice, NSDecimalNumber price, string currencyCode, string localeIdentifier, bool isFamilyShareable, [NullAllowed] StoreKitSubscriptionInfo subscriptionInfo, string jsonRepresentation);
	}

	// @interface StoreKitProductViewController : UIViewController
	/// <summary>Hosts StoreKit's single-product merchandising view in a UIKit view controller.</summary>
	[iOS (17, 0)]
	[BaseType (typeof (UIViewController), Name = "_TtC15StoreKitWrapper29StoreKitProductViewController")]
	interface StoreKitProductViewController {
		/// <summary>Gets the product identifier displayed by the controller.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull productIdentifier;
		[Export ("productIdentifier")]
		string ProductIdentifier { get; }

		/// <summary>Creates a controller that displays one StoreKit product.</summary>
		// -(instancetype _Nonnull)initWithProductIdentifier:(NSString * _Nonnull)productIdentifier __attribute__((objc_designated_initializer));
		[Export ("initWithProductIdentifier:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string productIdentifier);
	}

	// @interface StoreKitProductsViewController : UIViewController
	/// <summary>Hosts StoreKit's multi-product merchandising view in a UIKit view controller.</summary>
	[iOS (17, 0)]
	[BaseType (typeof (UIViewController), Name = "_TtC15StoreKitWrapper30StoreKitProductsViewController")]
	interface StoreKitProductsViewController {
		/// <summary>Gets the product identifiers displayed by the controller.</summary>
		// @property (readonly, copy, nonatomic) NSArray<NSString *> * _Nonnull productIdentifiers;
		[Export ("productIdentifiers", ArgumentSemantic.Copy)]
		string [] ProductIdentifiers { get; }

		/// <summary>Creates a controller that displays the supplied StoreKit products.</summary>
		// -(instancetype _Nonnull)initWithProductIdentifiers:(NSArray<NSString *> * _Nonnull)productIdentifiers __attribute__((objc_designated_initializer));
		[Export ("initWithProductIdentifiers:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string [] productIdentifiers);
	}

	// @interface StoreKitSubscriptionInfo : NSObject
	/// <summary>Provides subscription-specific metadata for an auto-renewable product.</summary>
	[BaseType (typeof (NSObject), Name = "_TtC15StoreKitWrapper24StoreKitSubscriptionInfo")]
	[DisableDefaultCtor]
	interface StoreKitSubscriptionInfo {
		/// <summary>Gets the App Store Connect subscription-group identifier.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull subscriptionGroupIdentifier;
		[Export ("subscriptionGroupIdentifier")]
		string SubscriptionGroupIdentifier { get; }

		/// <summary>Gets the localized subscription-group display name when available.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nullable groupDisplayName;
		[NullAllowed, Export ("groupDisplayName")]
		string GroupDisplayName { get; }

		/// <summary>Gets the standard renewal period.</summary>
		// @property (readonly, nonatomic, strong) StoreKitSubscriptionPeriod * _Nonnull subscriptionPeriod;
		[Export ("subscriptionPeriod", ArgumentSemantic.Strong)]
		StoreKitSubscriptionPeriod SubscriptionPeriod { get; }

		/// <summary>Gets a value indicating whether the customer is eligible for the introductory offer.</summary>
		// @property (readonly, nonatomic) BOOL isEligibleForIntroductoryOffer;
		[Export ("isEligibleForIntroductoryOffer")]
		bool IsEligibleForIntroductoryOffer { get; }

		/// <summary>Gets the introductory offer configured for the product, if any.</summary>
		// @property (readonly, nonatomic, strong) StoreKitSubscriptionOffer * _Nullable introductoryOffer;
		[NullAllowed, Export ("introductoryOffer", ArgumentSemantic.Strong)]
		StoreKitSubscriptionOffer IntroductoryOffer { get; }

		/// <summary>Gets promotional offers configured for the product.</summary>
		// @property (readonly, copy, nonatomic) NSArray<StoreKitSubscriptionOffer *> * _Nonnull promotionalOffers;
		[Export ("promotionalOffers", ArgumentSemantic.Copy)]
		StoreKitSubscriptionOffer [] PromotionalOffers { get; }

		/// <summary>Gets win-back offers configured for the product on supported OS versions.</summary>
		// @property (readonly, copy, nonatomic) NSArray<StoreKitSubscriptionOffer *> * _Nonnull winBackOffers;
		[Export ("winBackOffers", ArgumentSemantic.Copy)]
		StoreKitSubscriptionOffer [] WinBackOffers { get; }
	}

	// @interface StoreKitSubscriptionOffer : NSObject
	/// <summary>Provides pricing and duration metadata for a subscription offer.</summary>
	[BaseType (typeof (NSObject), Name = "_TtC15StoreKitWrapper25StoreKitSubscriptionOffer")]
	[DisableDefaultCtor]
	interface StoreKitSubscriptionOffer {
		/// <summary>Gets the offer identifier, when StoreKit assigns one.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nullable identifier;
		[NullAllowed, Export ("identifier")]
		string Identifier { get; }

		/// <summary>Gets the normalized kind of offer.</summary>
		// @property (readonly, nonatomic) enum StoreKitSubscriptionOfferType offerType;
		[Export ("offerType")]
		StoreKitSubscriptionOfferType OfferType { get; }

		/// <summary>Gets StoreKit's localized description of the offer kind.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull offerTypeDisplayName;
		[Export ("offerTypeDisplayName")]
		string OfferTypeDisplayName { get; }

		/// <summary>Gets the localized, currency-formatted offer price.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull displayPrice;
		[Export ("displayPrice")]
		string DisplayPrice { get; }

		/// <summary>Gets the offer price as a decimal number.</summary>
		// @property (readonly, nonatomic, strong) NSDecimalNumber * _Nonnull price;
		[Export ("price", ArgumentSemantic.Strong)]
		NSDecimalNumber Price { get; }

		/// <summary>Gets the ISO 4217 currency code used by the offer price.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull currencyCode;
		[Export ("currencyCode")]
		string CurrencyCode { get; }

		/// <summary>Gets the locale identifier used to format the offer price.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull localeIdentifier;
		[Export ("localeIdentifier")]
		string LocaleIdentifier { get; }

		/// <summary>Gets the normalized offer payment mode.</summary>
		// @property (readonly, nonatomic) enum StoreKitSubscriptionOfferPaymentMode paymentMode;
		[Export ("paymentMode")]
		StoreKitSubscriptionOfferPaymentMode PaymentMode { get; }

		/// <summary>Gets StoreKit's localized description of the payment mode.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull paymentModeDisplayName;
		[Export ("paymentModeDisplayName")]
		string PaymentModeDisplayName { get; }

		/// <summary>Gets the duration of one offer period.</summary>
		// @property (readonly, nonatomic, strong) StoreKitSubscriptionPeriod * _Nonnull period;
		[Export ("period", ArgumentSemantic.Strong)]
		StoreKitSubscriptionPeriod Period { get; }

		/// <summary>Gets the number of periods included in the offer.</summary>
		// @property (readonly, nonatomic) NSInteger periodCount;
		[Export ("periodCount")]
		nint PeriodCount { get; }

		/// <summary>Creates an immutable subscription-offer snapshot.</summary>
		// -(instancetype _Nonnull)initWithIdentifier:(NSString * _Nullable)identifier offerType:(enum StoreKitSubscriptionOfferType)offerType offerTypeDisplayName:(NSString * _Nonnull)offerTypeDisplayName displayPrice:(NSString * _Nonnull)displayPrice price:(NSDecimalNumber * _Nonnull)price currencyCode:(NSString * _Nonnull)currencyCode localeIdentifier:(NSString * _Nonnull)localeIdentifier paymentMode:(enum StoreKitSubscriptionOfferPaymentMode)paymentMode paymentModeDisplayName:(NSString * _Nonnull)paymentModeDisplayName period:(StoreKitSubscriptionPeriod * _Nonnull)period periodCount:(NSInteger)periodCount __attribute__((objc_designated_initializer));
		[Export ("initWithIdentifier:offerType:offerTypeDisplayName:displayPrice:price:currencyCode:localeIdentifier:paymentMode:paymentModeDisplayName:period:periodCount:")]
		[DesignatedInitializer]
		NativeHandle Constructor ([NullAllowed] string identifier, StoreKitSubscriptionOfferType offerType, string offerTypeDisplayName, string displayPrice, NSDecimalNumber price, string currencyCode, string localeIdentifier, StoreKitSubscriptionOfferPaymentMode paymentMode, string paymentModeDisplayName, StoreKitSubscriptionPeriod period, nint periodCount);
	}

	// @interface StoreKitSubscriptionPeriod : NSObject
	/// <summary>Represents a subscription duration using a numeric value and calendar unit.</summary>
	[BaseType (typeof (NSObject), Name = "_TtC15StoreKitWrapper26StoreKitSubscriptionPeriod")]
	[DisableDefaultCtor]
	interface StoreKitSubscriptionPeriod {
		/// <summary>Gets the number of calendar units in the period.</summary>
		// @property (readonly, nonatomic) NSInteger value;
		[Export ("value")]
		nint Value { get; }

		/// <summary>Gets the normalized calendar unit.</summary>
		// @property (readonly, nonatomic) enum StoreKitSubscriptionPeriodUnit unit;
		[Export ("unit")]
		StoreKitSubscriptionPeriodUnit Unit { get; }

		/// <summary>Gets StoreKit's localized description of the calendar unit.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull unitDisplayName;
		[Export ("unitDisplayName")]
		string UnitDisplayName { get; }

		/// <summary>Creates a subscription period.</summary>
		// -(instancetype _Nonnull)initWithValue:(NSInteger)value unit:(enum StoreKitSubscriptionPeriodUnit)unit unitDisplayName:(NSString * _Nonnull)unitDisplayName __attribute__((objc_designated_initializer));
		[Export ("initWithValue:unit:unitDisplayName:")]
		[DesignatedInitializer]
		NativeHandle Constructor (nint value, StoreKitSubscriptionPeriodUnit unit, string unitDisplayName);
	}

	// @interface StoreKitSubscriptionsViewController : UIViewController
	/// <summary>Hosts StoreKit's subscription-group merchandising view in a UIKit view controller.</summary>
	[iOS (17, 0)]
	[BaseType (typeof (UIViewController), Name = "_TtC15StoreKitWrapper35StoreKitSubscriptionsViewController")]
	interface StoreKitSubscriptionsViewController {
		/// <summary>Gets the subscription-group identifier displayed by the controller.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull subscriptionGroupIdentifier;
		[Export ("subscriptionGroupIdentifier")]
		string SubscriptionGroupIdentifier { get; }

		/// <summary>Creates a controller that displays an auto-renewable subscription group.</summary>
		// -(instancetype _Nonnull)initWithSubscriptionGroupIdentifier:(NSString * _Nonnull)subscriptionGroupIdentifier __attribute__((objc_designated_initializer));
		[Export ("initWithSubscriptionGroupIdentifier:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string subscriptionGroupIdentifier);
	}

	// @interface StoreKitTransaction : NSObject
	/// <summary>Provides an immutable StoreKit transaction snapshot and its verification state.</summary>
	[BaseType (typeof (NSObject), Name = "_TtC15StoreKitWrapper19StoreKitTransaction")]
	[DisableDefaultCtor]
	interface StoreKitTransaction {
		/// <summary>Gets the unique StoreKit transaction identifier.</summary>
		// @property (readonly, nonatomic) uint64_t identifier;
		[Export ("identifier")]
		ulong Identifier { get; }

		/// <summary>Gets the identifier of the original transaction in the purchase chain.</summary>
		// @property (readonly, nonatomic) uint64_t originalIdentifier;
		[Export ("originalIdentifier")]
		ulong OriginalIdentifier { get; }

		/// <summary>Gets the App Store web-order line-item identifier, when available.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nullable webOrderLineItemIdentifier;
		[NullAllowed, Export ("webOrderLineItemIdentifier")]
		string WebOrderLineItemIdentifier { get; }

		/// <summary>Gets the bundle identifier of the application that owns the transaction.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull appBundleIdentifier;
		[Export ("appBundleIdentifier")]
		string AppBundleIdentifier { get; }

		/// <summary>Gets the purchased product identifier.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull productIdentifier;
		[Export ("productIdentifier")]
		string ProductIdentifier { get; }

		/// <summary>Gets the normalized product category.</summary>
		// @property (readonly, nonatomic) enum StoreKitProductType productType;
		[Export ("productType")]
		StoreKitProductType ProductType { get; }

		/// <summary>Gets the subscription-group identifier, when applicable.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nullable subscriptionGroupIdentifier;
		[NullAllowed, Export ("subscriptionGroupIdentifier")]
		string SubscriptionGroupIdentifier { get; }

		/// <summary>Gets the date of this purchase or renewal.</summary>
		// @property (readonly, copy, nonatomic) NSDate * _Nonnull purchaseDate;
		[Export ("purchaseDate", ArgumentSemantic.Copy)]
		NSDate PurchaseDate { get; }

		/// <summary>Gets the date of the first purchase in the transaction chain.</summary>
		// @property (readonly, copy, nonatomic) NSDate * _Nonnull originalPurchaseDate;
		[Export ("originalPurchaseDate", ArgumentSemantic.Copy)]
		NSDate OriginalPurchaseDate { get; }

		/// <summary>Gets the subscription expiration date, when applicable.</summary>
		// @property (readonly, copy, nonatomic) NSDate * _Nullable expirationDate;
		[NullAllowed, Export ("expirationDate", ArgumentSemantic.Copy)]
		NSDate ExpirationDate { get; }

		/// <summary>Gets the date StoreKit signed the transaction payload.</summary>
		// @property (readonly, copy, nonatomic) NSDate * _Nonnull signedDate;
		[Export ("signedDate", ArgumentSemantic.Copy)]
		NSDate SignedDate { get; }

		/// <summary>Gets the transaction price when supplied by the running OS.</summary>
		// @property (readonly, nonatomic, strong) NSDecimalNumber * _Nullable price;
		[NullAllowed, Export ("price", ArgumentSemantic.Strong)]
		NSDecimalNumber Price { get; }

		/// <summary>Gets the ISO 4217 currency code associated with the transaction price.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nullable currencyCode;
		[NullAllowed, Export ("currencyCode")]
		string CurrencyCode { get; }

		/// <summary>Gets the number of product units purchased.</summary>
		// @property (readonly, nonatomic) NSInteger purchasedQuantity;
		[Export ("purchasedQuantity")]
		nint PurchasedQuantity { get; }

		/// <summary>Gets a value indicating whether a subscription upgrade superseded this transaction.</summary>
		// @property (readonly, nonatomic) BOOL isUpgraded;
		[Export ("isUpgraded")]
		bool IsUpgraded { get; }

		/// <summary>Gets how the current customer obtained the transaction.</summary>
		// @property (readonly, nonatomic) enum StoreKitTransactionOwnershipType ownershipType;
		[Export ("ownershipType")]
		StoreKitTransactionOwnershipType OwnershipType { get; }

		/// <summary>Gets the App Store environment that created the transaction.</summary>
		// @property (readonly, nonatomic) enum StoreKitTransactionEnvironment environment;
		[Export ("environment")]
		StoreKitTransactionEnvironment Environment { get; }

		/// <summary>Gets the storefront identifier active when the transaction was created.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nullable storefrontIdentifier;
		[NullAllowed, Export ("storefrontIdentifier")]
		string StorefrontIdentifier { get; }

		/// <summary>Gets the storefront country code active when the transaction was created.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull storefrontCountryCode;
		[Export ("storefrontCountryCode")]
		string StorefrontCountryCode { get; }

		/// <summary>Gets the reason StoreKit created the transaction.</summary>
		// @property (readonly, nonatomic) enum StoreKitTransactionReason reason;
		[Export ("reason")]
		StoreKitTransactionReason Reason { get; }

		/// <summary>Gets the date the App Store revoked the transaction, when applicable.</summary>
		// @property (readonly, copy, nonatomic) NSDate * _Nullable revocationDate;
		[NullAllowed, Export ("revocationDate", ArgumentSemantic.Copy)]
		NSDate RevocationDate { get; }

		/// <summary>Gets the normalized reason for revocation.</summary>
		// @property (readonly, nonatomic) enum StoreKitTransactionRevocationReason revocationReason;
		[Export ("revocationReason")]
		StoreKitTransactionRevocationReason RevocationReason { get; }

		/// <summary>Gets the application account token as a UUID string.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nullable appAccountToken;
		[NullAllowed, Export ("appAccountToken")]
		string AppAccountToken { get; }

		/// <summary>Gets the subscription offer applied to the transaction, if any.</summary>
		// @property (readonly, nonatomic, strong) StoreKitTransactionOffer * _Nullable offer;
		[NullAllowed, Export ("offer", ArgumentSemantic.Strong)]
		StoreKitTransactionOffer Offer { get; }

		/// <summary>Gets StoreKit's raw transaction JSON as a UTF-8 string.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull jsonRepresentation;
		[Export ("jsonRepresentation")]
		string JsonRepresentation { get; }

		/// <summary>Gets the transaction's JSON Web Signature representation.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull jwsRepresentation;
		[Export ("jwsRepresentation")]
		string JwsRepresentation { get; }

		/// <summary>Gets the device-verification data encoded as Base64.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull deviceVerification;
		[Export ("deviceVerification")]
		string DeviceVerification { get; }

		/// <summary>Gets the device-verification nonce as a UUID string.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nonnull deviceVerificationNonce;
		[Export ("deviceVerificationNonce")]
		string DeviceVerificationNonce { get; }

		/// <summary>Gets whether StoreKit cryptographically verified the transaction.</summary>
		// @property (readonly, nonatomic) enum StoreKitTransactionVerificationStatus verificationStatus;
		[Export ("verificationStatus")]
		StoreKitTransactionVerificationStatus VerificationStatus { get; }

		/// <summary>Gets the normalized verification failure code.</summary>
		// @property (readonly, nonatomic) enum StoreKitTransactionVerificationErrorCode verificationErrorCode;
		[Export ("verificationErrorCode")]
		StoreKitTransactionVerificationErrorCode VerificationErrorCode { get; }

		/// <summary>Gets StoreKit's verification error message, or <see langword="null"/> for a verified transaction.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nullable verificationErrorMessage;
		[NullAllowed, Export ("verificationErrorMessage")]
		string VerificationErrorMessage { get; }

		/// <summary>Creates an immutable transaction snapshot.</summary>
		// -(instancetype _Nonnull)initWithIdentifier:(uint64_t)identifier originalIdentifier:(uint64_t)originalIdentifier webOrderLineItemIdentifier:(NSString * _Nullable)webOrderLineItemIdentifier appBundleIdentifier:(NSString * _Nonnull)appBundleIdentifier productIdentifier:(NSString * _Nonnull)productIdentifier productType:(enum StoreKitProductType)productType subscriptionGroupIdentifier:(NSString * _Nullable)subscriptionGroupIdentifier purchaseDate:(NSDate * _Nonnull)purchaseDate originalPurchaseDate:(NSDate * _Nonnull)originalPurchaseDate expirationDate:(NSDate * _Nullable)expirationDate signedDate:(NSDate * _Nonnull)signedDate price:(NSDecimalNumber * _Nullable)price currencyCode:(NSString * _Nullable)currencyCode purchasedQuantity:(NSInteger)purchasedQuantity isUpgraded:(BOOL)isUpgraded ownershipType:(enum StoreKitTransactionOwnershipType)ownershipType environment:(enum StoreKitTransactionEnvironment)environment storefrontIdentifier:(NSString * _Nullable)storefrontIdentifier storefrontCountryCode:(NSString * _Nonnull)storefrontCountryCode reason:(enum StoreKitTransactionReason)reason revocationDate:(NSDate * _Nullable)revocationDate revocationReason:(enum StoreKitTransactionRevocationReason)revocationReason appAccountToken:(NSString * _Nullable)appAccountToken offer:(StoreKitTransactionOffer * _Nullable)offer jsonRepresentation:(NSString * _Nonnull)jsonRepresentation jwsRepresentation:(NSString * _Nonnull)jwsRepresentation deviceVerification:(NSString * _Nonnull)deviceVerification deviceVerificationNonce:(NSString * _Nonnull)deviceVerificationNonce verificationStatus:(enum StoreKitTransactionVerificationStatus)verificationStatus verificationErrorCode:(enum StoreKitTransactionVerificationErrorCode)verificationErrorCode verificationErrorMessage:(NSString * _Nullable)verificationErrorMessage __attribute__((objc_designated_initializer));
		[Export ("initWithIdentifier:originalIdentifier:webOrderLineItemIdentifier:appBundleIdentifier:productIdentifier:productType:subscriptionGroupIdentifier:purchaseDate:originalPurchaseDate:expirationDate:signedDate:price:currencyCode:purchasedQuantity:isUpgraded:ownershipType:environment:storefrontIdentifier:storefrontCountryCode:reason:revocationDate:revocationReason:appAccountToken:offer:jsonRepresentation:jwsRepresentation:deviceVerification:deviceVerificationNonce:verificationStatus:verificationErrorCode:verificationErrorMessage:")]
		[DesignatedInitializer]
		NativeHandle Constructor (ulong identifier, ulong originalIdentifier, [NullAllowed] string webOrderLineItemIdentifier, string appBundleIdentifier, string productIdentifier, StoreKitProductType productType, [NullAllowed] string subscriptionGroupIdentifier, NSDate purchaseDate, NSDate originalPurchaseDate, [NullAllowed] NSDate expirationDate, NSDate signedDate, [NullAllowed] NSDecimalNumber price, [NullAllowed] string currencyCode, nint purchasedQuantity, bool isUpgraded, StoreKitTransactionOwnershipType ownershipType, StoreKitTransactionEnvironment environment, [NullAllowed] string storefrontIdentifier, string storefrontCountryCode, StoreKitTransactionReason reason, [NullAllowed] NSDate revocationDate, StoreKitTransactionRevocationReason revocationReason, [NullAllowed] string appAccountToken, [NullAllowed] StoreKitTransactionOffer offer, string jsonRepresentation, string jwsRepresentation, string deviceVerification, string deviceVerificationNonce, StoreKitTransactionVerificationStatus verificationStatus, StoreKitTransactionVerificationErrorCode verificationErrorCode, [NullAllowed] string verificationErrorMessage);
	}

	// @interface StoreKitTransactionOffer : NSObject
	/// <summary>Describes the subscription offer applied to a transaction.</summary>
	[BaseType (typeof (NSObject), Name = "_TtC15StoreKitWrapper24StoreKitTransactionOffer")]
	[DisableDefaultCtor]
	interface StoreKitTransactionOffer {
		/// <summary>Gets the applied offer identifier, when supplied by StoreKit.</summary>
		// @property (readonly, copy, nonatomic) NSString * _Nullable identifier;
		[NullAllowed, Export ("identifier")]
		string Identifier { get; }

		/// <summary>Gets the normalized kind of applied offer.</summary>
		// @property (readonly, nonatomic) enum StoreKitTransactionOfferType offerType;
		[Export ("offerType")]
		StoreKitTransactionOfferType OfferType { get; }

		/// <summary>Gets the normalized payment mode of the applied offer.</summary>
		// @property (readonly, nonatomic) enum StoreKitTransactionOfferPaymentMode paymentMode;
		[Export ("paymentMode")]
		StoreKitTransactionOfferPaymentMode PaymentMode { get; }

		/// <summary>Gets the applied offer period when available on the running OS.</summary>
		// @property (readonly, nonatomic, strong) StoreKitSubscriptionPeriod * _Nullable period;
		[NullAllowed, Export ("period", ArgumentSemantic.Strong)]
		StoreKitSubscriptionPeriod Period { get; }

		/// <summary>Creates an immutable applied-offer snapshot.</summary>
		// -(instancetype _Nonnull)initWithIdentifier:(NSString * _Nullable)identifier offerType:(enum StoreKitTransactionOfferType)offerType paymentMode:(enum StoreKitTransactionOfferPaymentMode)paymentMode period:(StoreKitSubscriptionPeriod * _Nullable)period __attribute__((objc_designated_initializer));
		[Export ("initWithIdentifier:offerType:paymentMode:period:")]
		[DesignatedInitializer]
		NativeHandle Constructor ([NullAllowed] string identifier, StoreKitTransactionOfferType offerType, StoreKitTransactionOfferPaymentMode paymentMode, [NullAllowed] StoreKitSubscriptionPeriod period);
	}
}
