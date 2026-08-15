using System;
using Foundation;
using ObjCRuntime;
using UIKit;

namespace AMDevIT.StoreKitWrapper {
	// @protocol IStoreKitWrapperLogger
	/*
  Check whether adding [Model] to this declaration is appropriate.
  [Model] is used to generate a C# class that implements this protocol,
  and might be useful for protocols that consumers are supposed to implement,
  since consumers can subclass the generated class instead of implementing
  the generated interface. If consumers are not supposed to implement this
  protocol, then [Model] is redundant and will generate code that will never
  be used.
*/
	[Protocol (Name = "_TtP15StoreKitWrapper22IStoreKitWrapperLogger_")]
	interface IStoreKitWrapperLogger {
		// @required -(BOOL)isEnabledWithLogLevel:(enum StoreKitWrapperLogLevel)logLevel __attribute__((warn_unused_result("")));
		[Abstract]
		[Export ("isEnabledWithLogLevel:")]
		bool IsEnabledWithLogLevel (StoreKitWrapperLogLevel logLevel);

		// @required -(void)logWithLogLevel:(enum StoreKitWrapperLogLevel)logLevel eventId:(NSInteger)eventId eventName:(NSString * _Nullable)eventName message:(NSString * _Nonnull)message error:(NSError * _Nullable)error;
		[Abstract]
		[Export ("logWithLogLevel:eventId:eventName:message:error:")]
		void LogWithLogLevel (StoreKitWrapperLogLevel logLevel, nint eventId, [NullAllowed] string eventName, string message, [NullAllowed] NSError error);
	}

	// @interface StoreKitManager : NSObject
	[BaseType (typeof (NSObject), Name = "_TtC15StoreKitWrapper15StoreKitManager")]
	interface StoreKitManager {
		[Wrap ("WeakDelegate")]
		[NullAllowed]
		StoreKitManagerDelegate Delegate { get; set; }

		// @property (nonatomic, strong) id<StoreKitManagerDelegate> _Nullable delegate;
		[NullAllowed, Export ("delegate", ArgumentSemantic.Strong)]
		NSObject WeakDelegate { get; set; }

		// -(instancetype _Nonnull)initWithLogger:(id<IStoreKitWrapperLogger> _Nullable)logger delegate:(id<StoreKitManagerDelegate> _Nullable)delegate __attribute__((objc_designated_initializer));
		[Export ("initWithLogger:delegate:")]
		[DesignatedInitializer]
		NativeHandle Constructor ([NullAllowed] IStoreKitWrapperLogger logger, [NullAllowed] StoreKitManagerDelegate @delegate);

		// -(void)initialize;
		[Export ("initialize")]
		void Initialize ();

		// -(void)shutdown;
		[Export ("shutdown")]
		void Shutdown ();

		// -(void)getProductsWithProductIdentifiers:(NSArray<NSString *> * _Nonnull)productIdentifiers;
		[Export ("getProductsWithProductIdentifiers:")]
		void GetProductsWithProductIdentifiers (string [] productIdentifiers);

		// -(void)getCurrentEntitlements;
		[Export ("getCurrentEntitlements")]
		void GetCurrentEntitlements ();

		// -(void)sync;
		[Export ("sync")]
		void Sync ();

		// -(void)getUnfinishedTransactions;
		[Export ("getUnfinishedTransactions")]
		void GetUnfinishedTransactions ();

		// -(void)purchaseWithProductIdentifier:(NSString * _Nonnull)productIdentifier;
		[Export ("purchaseWithProductIdentifier:")]
		void PurchaseWithProductIdentifier (string productIdentifier);

		// -(void)purchaseWithProductIdentifier:(NSString * _Nonnull)productIdentifier appAccountToken:(NSString * _Nullable)appAccountToken;
		[Export ("purchaseWithProductIdentifier:appAccountToken:")]
		void PurchaseWithProductIdentifier (string productIdentifier, [NullAllowed] string appAccountToken);

		// -(void)purchaseWithProductIdentifier:(NSString * _Nonnull)productIdentifier appAccountToken:(NSString * _Nullable)appAccountToken quantity:(NSInteger)quantity;
		[Export ("purchaseWithProductIdentifier:appAccountToken:quantity:")]
		void PurchaseWithProductIdentifier (string productIdentifier, [NullAllowed] string appAccountToken, nint quantity);

		// -(void)finishTransactionWithTransactionIdentifier:(uint64_t)transactionIdentifier;
		[Export ("finishTransactionWithTransactionIdentifier:")]
		void FinishTransactionWithTransactionIdentifier (ulong transactionIdentifier);
	}

	// @protocol StoreKitManagerDelegate
	[Protocol (Name = "_TtP15StoreKitWrapper23StoreKitManagerDelegate_"), Model]
	interface StoreKitManagerDelegate {
		// @required -(void)initializationCompletedWithErrorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("initializationCompletedWithErrorCode:errorMessage:")]
		void InitializationCompletedWithErrorCode (StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		// @required -(void)shutdownCompletedWithErrorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("shutdownCompletedWithErrorCode:errorMessage:")]
		void ShutdownCompletedWithErrorCode (StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		// @required -(void)availableProductsCompletedWithResult:(NSArray<StoreKitProduct *> * _Nonnull)withResult errorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("availableProductsCompletedWithResult:errorCode:errorMessage:")]
		void AvailableProductsCompletedWithResult (StoreKitProduct [] withResult, StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		// @required -(void)currentEntitlementsCompletedWithResult:(NSArray<StoreKitTransaction *> * _Nonnull)withResult errorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("currentEntitlementsCompletedWithResult:errorCode:errorMessage:")]
		void CurrentEntitlementsCompletedWithResult (StoreKitTransaction [] withResult, StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		// @required -(void)appStoreSyncCompletedWithErrorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("appStoreSyncCompletedWithErrorCode:errorMessage:")]
		void AppStoreSyncCompletedWithErrorCode (StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		// @required -(void)unfinishedTransactionsCompletedWithResult:(NSArray<StoreKitTransaction *> * _Nonnull)withResult errorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("unfinishedTransactionsCompletedWithResult:errorCode:errorMessage:")]
		void UnfinishedTransactionsCompletedWithResult (StoreKitTransaction [] withResult, StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		// @required -(void)purchaseCompletedWithResult:(StoreKitTransaction * _Nullable)withResult purchaseResult:(enum StoreKitPurchaseResult)purchaseResult errorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("purchaseCompletedWithResult:purchaseResult:errorCode:errorMessage:")]
		void PurchaseCompletedWithResult ([NullAllowed] StoreKitTransaction withResult, StoreKitPurchaseResult purchaseResult, StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		// @required -(void)finishTransactionCompletedWithTransactionIdentifier:(uint64_t)transactionIdentifier errorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("finishTransactionCompletedWithTransactionIdentifier:errorCode:errorMessage:")]
		void FinishTransactionCompletedWithTransactionIdentifier (ulong transactionIdentifier, StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);

		// @required -(void)transactionUpdatedWithResult:(StoreKitTransaction * _Nonnull)withResult errorCode:(enum StoreKitWrapperErrorCode)errorCode errorMessage:(NSString * _Nullable)errorMessage;
		[Abstract]
		[Export ("transactionUpdatedWithResult:errorCode:errorMessage:")]
		void TransactionUpdatedWithResult (StoreKitTransaction withResult, StoreKitWrapperErrorCode errorCode, [NullAllowed] string errorMessage);
	}

	// @interface StoreKitProduct : NSObject
	[BaseType (typeof (NSObject), Name = "_TtC15StoreKitWrapper15StoreKitProduct")]
	[DisableDefaultCtor]
	interface StoreKitProduct {
		// @property (readonly, copy, nonatomic) NSString * _Nonnull identifier;
		[Export ("identifier")]
		string Identifier { get; }

		// @property (readonly, nonatomic) enum StoreKitProductType productType;
		[Export ("productType")]
		StoreKitProductType ProductType { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull productTypeDisplayName;
		[Export ("productTypeDisplayName")]
		string ProductTypeDisplayName { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull displayName;
		[Export ("displayName")]
		string DisplayName { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull displayDescription;
		[Export ("displayDescription")]
		string DisplayDescription { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull displayPrice;
		[Export ("displayPrice")]
		string DisplayPrice { get; }

		// @property (readonly, nonatomic, strong) NSDecimalNumber * _Nonnull price;
		[Export ("price", ArgumentSemantic.Strong)]
		NSDecimalNumber Price { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull currencyCode;
		[Export ("currencyCode")]
		string CurrencyCode { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull localeIdentifier;
		[Export ("localeIdentifier")]
		string LocaleIdentifier { get; }

		// @property (readonly, nonatomic) BOOL isFamilyShareable;
		[Export ("isFamilyShareable")]
		bool IsFamilyShareable { get; }

		// @property (readonly, nonatomic, strong) StoreKitSubscriptionInfo * _Nullable subscriptionInfo;
		[NullAllowed, Export ("subscriptionInfo", ArgumentSemantic.Strong)]
		StoreKitSubscriptionInfo SubscriptionInfo { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull jsonRepresentation;
		[Export ("jsonRepresentation")]
		string JsonRepresentation { get; }

		// -(instancetype _Nonnull)initWithIdentifier:(NSString * _Nonnull)identifier productType:(enum StoreKitProductType)productType productTypeDisplayName:(NSString * _Nonnull)productTypeDisplayName displayName:(NSString * _Nonnull)displayName displayDescription:(NSString * _Nonnull)displayDescription displayPrice:(NSString * _Nonnull)displayPrice price:(NSDecimalNumber * _Nonnull)price currencyCode:(NSString * _Nonnull)currencyCode localeIdentifier:(NSString * _Nonnull)localeIdentifier isFamilyShareable:(BOOL)isFamilyShareable subscriptionInfo:(StoreKitSubscriptionInfo * _Nullable)subscriptionInfo jsonRepresentation:(NSString * _Nonnull)jsonRepresentation __attribute__((objc_designated_initializer));
		[Export ("initWithIdentifier:productType:productTypeDisplayName:displayName:displayDescription:displayPrice:price:currencyCode:localeIdentifier:isFamilyShareable:subscriptionInfo:jsonRepresentation:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string identifier, StoreKitProductType productType, string productTypeDisplayName, string displayName, string displayDescription, string displayPrice, NSDecimalNumber price, string currencyCode, string localeIdentifier, bool isFamilyShareable, [NullAllowed] StoreKitSubscriptionInfo subscriptionInfo, string jsonRepresentation);
	}

	// @interface StoreKitProductViewController : UIViewController
	[iOS (17, 0)]
	[BaseType (typeof (UIViewController), Name = "_TtC15StoreKitWrapper29StoreKitProductViewController")]
	interface StoreKitProductViewController {
		// @property (readonly, copy, nonatomic) NSString * _Nonnull productIdentifier;
		[Export ("productIdentifier")]
		string ProductIdentifier { get; }

		// -(instancetype _Nonnull)initWithProductIdentifier:(NSString * _Nonnull)productIdentifier __attribute__((objc_designated_initializer));
		[Export ("initWithProductIdentifier:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string productIdentifier);

		// -(void)viewDidLoad;
		[Export ("viewDidLoad")]
		void ViewDidLoad ();
	}

	// @interface StoreKitProductsViewController : UIViewController
	[iOS (17, 0)]
	[BaseType (typeof (UIViewController), Name = "_TtC15StoreKitWrapper30StoreKitProductsViewController")]
	interface StoreKitProductsViewController {
		// @property (readonly, copy, nonatomic) NSArray<NSString *> * _Nonnull productIdentifiers;
		[Export ("productIdentifiers", ArgumentSemantic.Copy)]
		string [] ProductIdentifiers { get; }

		// -(instancetype _Nonnull)initWithProductIdentifiers:(NSArray<NSString *> * _Nonnull)productIdentifiers __attribute__((objc_designated_initializer));
		[Export ("initWithProductIdentifiers:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string [] productIdentifiers);

		// -(void)viewDidLoad;
		[Export ("viewDidLoad")]
		void ViewDidLoad ();
	}

	// @interface StoreKitSubscriptionInfo : NSObject
	[BaseType (typeof (NSObject), Name = "_TtC15StoreKitWrapper24StoreKitSubscriptionInfo")]
	[DisableDefaultCtor]
	interface StoreKitSubscriptionInfo {
		// @property (readonly, copy, nonatomic) NSString * _Nonnull subscriptionGroupIdentifier;
		[Export ("subscriptionGroupIdentifier")]
		string SubscriptionGroupIdentifier { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable groupDisplayName;
		[NullAllowed, Export ("groupDisplayName")]
		string GroupDisplayName { get; }

		// @property (readonly, nonatomic, strong) StoreKitSubscriptionPeriod * _Nonnull subscriptionPeriod;
		[Export ("subscriptionPeriod", ArgumentSemantic.Strong)]
		StoreKitSubscriptionPeriod SubscriptionPeriod { get; }

		// @property (readonly, nonatomic) BOOL isEligibleForIntroductoryOffer;
		[Export ("isEligibleForIntroductoryOffer")]
		bool IsEligibleForIntroductoryOffer { get; }

		// @property (readonly, nonatomic, strong) StoreKitSubscriptionOffer * _Nullable introductoryOffer;
		[NullAllowed, Export ("introductoryOffer", ArgumentSemantic.Strong)]
		StoreKitSubscriptionOffer IntroductoryOffer { get; }

		// @property (readonly, copy, nonatomic) NSArray<StoreKitSubscriptionOffer *> * _Nonnull promotionalOffers;
		[Export ("promotionalOffers", ArgumentSemantic.Copy)]
		StoreKitSubscriptionOffer [] PromotionalOffers { get; }

		// @property (readonly, copy, nonatomic) NSArray<StoreKitSubscriptionOffer *> * _Nonnull winBackOffers;
		[Export ("winBackOffers", ArgumentSemantic.Copy)]
		StoreKitSubscriptionOffer [] WinBackOffers { get; }
	}

	// @interface StoreKitSubscriptionOffer : NSObject
	[BaseType (typeof (NSObject), Name = "_TtC15StoreKitWrapper25StoreKitSubscriptionOffer")]
	[DisableDefaultCtor]
	interface StoreKitSubscriptionOffer {
		// @property (readonly, copy, nonatomic) NSString * _Nullable identifier;
		[NullAllowed, Export ("identifier")]
		string Identifier { get; }

		// @property (readonly, nonatomic) enum StoreKitSubscriptionOfferType offerType;
		[Export ("offerType")]
		StoreKitSubscriptionOfferType OfferType { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull offerTypeDisplayName;
		[Export ("offerTypeDisplayName")]
		string OfferTypeDisplayName { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull displayPrice;
		[Export ("displayPrice")]
		string DisplayPrice { get; }

		// @property (readonly, nonatomic, strong) NSDecimalNumber * _Nonnull price;
		[Export ("price", ArgumentSemantic.Strong)]
		NSDecimalNumber Price { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull currencyCode;
		[Export ("currencyCode")]
		string CurrencyCode { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull localeIdentifier;
		[Export ("localeIdentifier")]
		string LocaleIdentifier { get; }

		// @property (readonly, nonatomic) enum StoreKitSubscriptionOfferPaymentMode paymentMode;
		[Export ("paymentMode")]
		StoreKitSubscriptionOfferPaymentMode PaymentMode { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull paymentModeDisplayName;
		[Export ("paymentModeDisplayName")]
		string PaymentModeDisplayName { get; }

		// @property (readonly, nonatomic, strong) StoreKitSubscriptionPeriod * _Nonnull period;
		[Export ("period", ArgumentSemantic.Strong)]
		StoreKitSubscriptionPeriod Period { get; }

		// @property (readonly, nonatomic) NSInteger periodCount;
		[Export ("periodCount")]
		nint PeriodCount { get; }

		// -(instancetype _Nonnull)initWithIdentifier:(NSString * _Nullable)identifier offerType:(enum StoreKitSubscriptionOfferType)offerType offerTypeDisplayName:(NSString * _Nonnull)offerTypeDisplayName displayPrice:(NSString * _Nonnull)displayPrice price:(NSDecimalNumber * _Nonnull)price currencyCode:(NSString * _Nonnull)currencyCode localeIdentifier:(NSString * _Nonnull)localeIdentifier paymentMode:(enum StoreKitSubscriptionOfferPaymentMode)paymentMode paymentModeDisplayName:(NSString * _Nonnull)paymentModeDisplayName period:(StoreKitSubscriptionPeriod * _Nonnull)period periodCount:(NSInteger)periodCount __attribute__((objc_designated_initializer));
		[Export ("initWithIdentifier:offerType:offerTypeDisplayName:displayPrice:price:currencyCode:localeIdentifier:paymentMode:paymentModeDisplayName:period:periodCount:")]
		[DesignatedInitializer]
		NativeHandle Constructor ([NullAllowed] string identifier, StoreKitSubscriptionOfferType offerType, string offerTypeDisplayName, string displayPrice, NSDecimalNumber price, string currencyCode, string localeIdentifier, StoreKitSubscriptionOfferPaymentMode paymentMode, string paymentModeDisplayName, StoreKitSubscriptionPeriod period, nint periodCount);
	}

	// @interface StoreKitSubscriptionPeriod : NSObject
	[BaseType (typeof (NSObject), Name = "_TtC15StoreKitWrapper26StoreKitSubscriptionPeriod")]
	[DisableDefaultCtor]
	interface StoreKitSubscriptionPeriod {
		// @property (readonly, nonatomic) NSInteger value;
		[Export ("value")]
		nint Value { get; }

		// @property (readonly, nonatomic) enum StoreKitSubscriptionPeriodUnit unit;
		[Export ("unit")]
		StoreKitSubscriptionPeriodUnit Unit { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull unitDisplayName;
		[Export ("unitDisplayName")]
		string UnitDisplayName { get; }

		// -(instancetype _Nonnull)initWithValue:(NSInteger)value unit:(enum StoreKitSubscriptionPeriodUnit)unit unitDisplayName:(NSString * _Nonnull)unitDisplayName __attribute__((objc_designated_initializer));
		[Export ("initWithValue:unit:unitDisplayName:")]
		[DesignatedInitializer]
		NativeHandle Constructor (nint value, StoreKitSubscriptionPeriodUnit unit, string unitDisplayName);
	}

	// @interface StoreKitSubscriptionsViewController : UIViewController
	[iOS (17, 0)]
	[BaseType (typeof (UIViewController), Name = "_TtC15StoreKitWrapper35StoreKitSubscriptionsViewController")]
	interface StoreKitSubscriptionsViewController {
		// @property (readonly, copy, nonatomic) NSString * _Nonnull subscriptionGroupIdentifier;
		[Export ("subscriptionGroupIdentifier")]
		string SubscriptionGroupIdentifier { get; }

		// -(instancetype _Nonnull)initWithSubscriptionGroupIdentifier:(NSString * _Nonnull)subscriptionGroupIdentifier __attribute__((objc_designated_initializer));
		[Export ("initWithSubscriptionGroupIdentifier:")]
		[DesignatedInitializer]
		NativeHandle Constructor (string subscriptionGroupIdentifier);

		// -(void)viewDidLoad;
		[Export ("viewDidLoad")]
		void ViewDidLoad ();
	}

	// @interface StoreKitTransaction : NSObject
	[BaseType (typeof (NSObject), Name = "_TtC15StoreKitWrapper19StoreKitTransaction")]
	[DisableDefaultCtor]
	interface StoreKitTransaction {
		// @property (readonly, nonatomic) uint64_t identifier;
		[Export ("identifier")]
		ulong Identifier { get; }

		// @property (readonly, nonatomic) uint64_t originalIdentifier;
		[Export ("originalIdentifier")]
		ulong OriginalIdentifier { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable webOrderLineItemIdentifier;
		[NullAllowed, Export ("webOrderLineItemIdentifier")]
		string WebOrderLineItemIdentifier { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull appBundleIdentifier;
		[Export ("appBundleIdentifier")]
		string AppBundleIdentifier { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull productIdentifier;
		[Export ("productIdentifier")]
		string ProductIdentifier { get; }

		// @property (readonly, nonatomic) enum StoreKitProductType productType;
		[Export ("productType")]
		StoreKitProductType ProductType { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable subscriptionGroupIdentifier;
		[NullAllowed, Export ("subscriptionGroupIdentifier")]
		string SubscriptionGroupIdentifier { get; }

		// @property (readonly, copy, nonatomic) NSDate * _Nonnull purchaseDate;
		[Export ("purchaseDate", ArgumentSemantic.Copy)]
		NSDate PurchaseDate { get; }

		// @property (readonly, copy, nonatomic) NSDate * _Nonnull originalPurchaseDate;
		[Export ("originalPurchaseDate", ArgumentSemantic.Copy)]
		NSDate OriginalPurchaseDate { get; }

		// @property (readonly, copy, nonatomic) NSDate * _Nullable expirationDate;
		[NullAllowed, Export ("expirationDate", ArgumentSemantic.Copy)]
		NSDate ExpirationDate { get; }

		// @property (readonly, copy, nonatomic) NSDate * _Nonnull signedDate;
		[Export ("signedDate", ArgumentSemantic.Copy)]
		NSDate SignedDate { get; }

		// @property (readonly, nonatomic, strong) NSDecimalNumber * _Nullable price;
		[NullAllowed, Export ("price", ArgumentSemantic.Strong)]
		NSDecimalNumber Price { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable currencyCode;
		[NullAllowed, Export ("currencyCode")]
		string CurrencyCode { get; }

		// @property (readonly, nonatomic) NSInteger purchasedQuantity;
		[Export ("purchasedQuantity")]
		nint PurchasedQuantity { get; }

		// @property (readonly, nonatomic) BOOL isUpgraded;
		[Export ("isUpgraded")]
		bool IsUpgraded { get; }

		// @property (readonly, nonatomic) enum StoreKitTransactionOwnershipType ownershipType;
		[Export ("ownershipType")]
		StoreKitTransactionOwnershipType OwnershipType { get; }

		// @property (readonly, nonatomic) enum StoreKitTransactionEnvironment environment;
		[Export ("environment")]
		StoreKitTransactionEnvironment Environment { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable storefrontIdentifier;
		[NullAllowed, Export ("storefrontIdentifier")]
		string StorefrontIdentifier { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull storefrontCountryCode;
		[Export ("storefrontCountryCode")]
		string StorefrontCountryCode { get; }

		// @property (readonly, nonatomic) enum StoreKitTransactionReason reason;
		[Export ("reason")]
		StoreKitTransactionReason Reason { get; }

		// @property (readonly, copy, nonatomic) NSDate * _Nullable revocationDate;
		[NullAllowed, Export ("revocationDate", ArgumentSemantic.Copy)]
		NSDate RevocationDate { get; }

		// @property (readonly, nonatomic) enum StoreKitTransactionRevocationReason revocationReason;
		[Export ("revocationReason")]
		StoreKitTransactionRevocationReason RevocationReason { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable appAccountToken;
		[NullAllowed, Export ("appAccountToken")]
		string AppAccountToken { get; }

		// @property (readonly, nonatomic, strong) StoreKitTransactionOffer * _Nullable offer;
		[NullAllowed, Export ("offer", ArgumentSemantic.Strong)]
		StoreKitTransactionOffer Offer { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull jsonRepresentation;
		[Export ("jsonRepresentation")]
		string JsonRepresentation { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull jwsRepresentation;
		[Export ("jwsRepresentation")]
		string JwsRepresentation { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull deviceVerification;
		[Export ("deviceVerification")]
		string DeviceVerification { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull deviceVerificationNonce;
		[Export ("deviceVerificationNonce")]
		string DeviceVerificationNonce { get; }

		// @property (readonly, nonatomic) enum StoreKitTransactionVerificationStatus verificationStatus;
		[Export ("verificationStatus")]
		StoreKitTransactionVerificationStatus VerificationStatus { get; }

		// @property (readonly, nonatomic) enum StoreKitTransactionVerificationErrorCode verificationErrorCode;
		[Export ("verificationErrorCode")]
		StoreKitTransactionVerificationErrorCode VerificationErrorCode { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable verificationErrorMessage;
		[NullAllowed, Export ("verificationErrorMessage")]
		string VerificationErrorMessage { get; }

		// -(instancetype _Nonnull)initWithIdentifier:(uint64_t)identifier originalIdentifier:(uint64_t)originalIdentifier webOrderLineItemIdentifier:(NSString * _Nullable)webOrderLineItemIdentifier appBundleIdentifier:(NSString * _Nonnull)appBundleIdentifier productIdentifier:(NSString * _Nonnull)productIdentifier productType:(enum StoreKitProductType)productType subscriptionGroupIdentifier:(NSString * _Nullable)subscriptionGroupIdentifier purchaseDate:(NSDate * _Nonnull)purchaseDate originalPurchaseDate:(NSDate * _Nonnull)originalPurchaseDate expirationDate:(NSDate * _Nullable)expirationDate signedDate:(NSDate * _Nonnull)signedDate price:(NSDecimalNumber * _Nullable)price currencyCode:(NSString * _Nullable)currencyCode purchasedQuantity:(NSInteger)purchasedQuantity isUpgraded:(BOOL)isUpgraded ownershipType:(enum StoreKitTransactionOwnershipType)ownershipType environment:(enum StoreKitTransactionEnvironment)environment storefrontIdentifier:(NSString * _Nullable)storefrontIdentifier storefrontCountryCode:(NSString * _Nonnull)storefrontCountryCode reason:(enum StoreKitTransactionReason)reason revocationDate:(NSDate * _Nullable)revocationDate revocationReason:(enum StoreKitTransactionRevocationReason)revocationReason appAccountToken:(NSString * _Nullable)appAccountToken offer:(StoreKitTransactionOffer * _Nullable)offer jsonRepresentation:(NSString * _Nonnull)jsonRepresentation jwsRepresentation:(NSString * _Nonnull)jwsRepresentation deviceVerification:(NSString * _Nonnull)deviceVerification deviceVerificationNonce:(NSString * _Nonnull)deviceVerificationNonce verificationStatus:(enum StoreKitTransactionVerificationStatus)verificationStatus verificationErrorCode:(enum StoreKitTransactionVerificationErrorCode)verificationErrorCode verificationErrorMessage:(NSString * _Nullable)verificationErrorMessage __attribute__((objc_designated_initializer));
		[Export ("initWithIdentifier:originalIdentifier:webOrderLineItemIdentifier:appBundleIdentifier:productIdentifier:productType:subscriptionGroupIdentifier:purchaseDate:originalPurchaseDate:expirationDate:signedDate:price:currencyCode:purchasedQuantity:isUpgraded:ownershipType:environment:storefrontIdentifier:storefrontCountryCode:reason:revocationDate:revocationReason:appAccountToken:offer:jsonRepresentation:jwsRepresentation:deviceVerification:deviceVerificationNonce:verificationStatus:verificationErrorCode:verificationErrorMessage:")]
		[DesignatedInitializer]
		NativeHandle Constructor (ulong identifier, ulong originalIdentifier, [NullAllowed] string webOrderLineItemIdentifier, string appBundleIdentifier, string productIdentifier, StoreKitProductType productType, [NullAllowed] string subscriptionGroupIdentifier, NSDate purchaseDate, NSDate originalPurchaseDate, [NullAllowed] NSDate expirationDate, NSDate signedDate, [NullAllowed] NSDecimalNumber price, [NullAllowed] string currencyCode, nint purchasedQuantity, bool isUpgraded, StoreKitTransactionOwnershipType ownershipType, StoreKitTransactionEnvironment environment, [NullAllowed] string storefrontIdentifier, string storefrontCountryCode, StoreKitTransactionReason reason, [NullAllowed] NSDate revocationDate, StoreKitTransactionRevocationReason revocationReason, [NullAllowed] string appAccountToken, [NullAllowed] StoreKitTransactionOffer offer, string jsonRepresentation, string jwsRepresentation, string deviceVerification, string deviceVerificationNonce, StoreKitTransactionVerificationStatus verificationStatus, StoreKitTransactionVerificationErrorCode verificationErrorCode, [NullAllowed] string verificationErrorMessage);
	}

	// @interface StoreKitTransactionOffer : NSObject
	[BaseType (typeof (NSObject), Name = "_TtC15StoreKitWrapper24StoreKitTransactionOffer")]
	[DisableDefaultCtor]
	interface StoreKitTransactionOffer {
		// @property (readonly, copy, nonatomic) NSString * _Nullable identifier;
		[NullAllowed, Export ("identifier")]
		string Identifier { get; }

		// @property (readonly, nonatomic) enum StoreKitTransactionOfferType offerType;
		[Export ("offerType")]
		StoreKitTransactionOfferType OfferType { get; }

		// @property (readonly, nonatomic) enum StoreKitTransactionOfferPaymentMode paymentMode;
		[Export ("paymentMode")]
		StoreKitTransactionOfferPaymentMode PaymentMode { get; }

		// @property (readonly, nonatomic, strong) StoreKitSubscriptionPeriod * _Nullable period;
		[NullAllowed, Export ("period", ArgumentSemantic.Strong)]
		StoreKitSubscriptionPeriod Period { get; }

		// -(instancetype _Nonnull)initWithIdentifier:(NSString * _Nullable)identifier offerType:(enum StoreKitTransactionOfferType)offerType paymentMode:(enum StoreKitTransactionOfferPaymentMode)paymentMode period:(StoreKitSubscriptionPeriod * _Nullable)period __attribute__((objc_designated_initializer));
		[Export ("initWithIdentifier:offerType:paymentMode:period:")]
		[DesignatedInitializer]
		NativeHandle Constructor ([NullAllowed] string identifier, StoreKitTransactionOfferType offerType, StoreKitTransactionOfferPaymentMode paymentMode, [NullAllowed] StoreKitSubscriptionPeriod period);
	}
}
