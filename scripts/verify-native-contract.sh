#!/usr/bin/env bash

set -euo pipefail

script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_root="$(cd "${script_directory}/.." && pwd)"
project_path="${repository_root}/src/apple/StoreKitWrapper/StoreKitWrapper.xcodeproj"
output_root="${1:-${repository_root}/.build/native-contract}"

require_command() {
    local command_name="$1"

    if ! command -v "${command_name}" >/dev/null 2>&1; then
        echo "Required command not found: ${command_name}" >&2
        exit 1
    fi
}

require_header_text() {
    local expected_text="$1"

    if ! grep -Fq -- "${expected_text}" "${generated_header}"; then
        echo "Missing Objective-C declaration: ${expected_text}" >&2
        exit 1
    fi
}

reject_header_text() {
    local forbidden_text="$1"

    if grep -Fq -- "${forbidden_text}" "${generated_header}"; then
        echo "Internal Swift type leaked into Objective-C header: ${forbidden_text}" >&2
        exit 1
    fi
}

verify_generated_header() {
    local generated_header="$1"

    require_header_text '@interface StoreKitManager : NSObject'
    require_header_text '@protocol StoreKitManagerDelegate'
    require_header_text '@protocol IStoreKitWrapperLogger'
    require_header_text '@interface StoreKitProduct : NSObject'
    require_header_text '@interface StoreKitSubscriptionInfo : NSObject'
    require_header_text '@interface StoreKitSubscriptionOffer : NSObject'
    require_header_text '@interface StoreKitSubscriptionPeriod : NSObject'
    require_header_text '@interface StoreKitTransaction : NSObject'
    require_header_text '@interface StoreKitTransactionOffer : NSObject'
    require_header_text '@interface StoreKitProductViewController : UIViewController'
    require_header_text '@interface StoreKitProductsViewController : UIViewController'
    require_header_text '@interface StoreKitSubscriptionsViewController : UIViewController'
    require_header_text 'StoreKitWrapperErrorCode'
    require_header_text 'StoreKitPurchaseResult'
    require_header_text 'initWithLogger:'
    require_header_text '- (void)initialize'
    require_header_text '- (void)shutdown'
    require_header_text 'getProductsWithProductIdentifiers:'
    require_header_text 'getCurrentEntitlements'
    require_header_text 'getUnfinishedTransactions'
    require_header_text 'purchaseWithProductIdentifier:'
    require_header_text 'appAccountToken:'
    require_header_text 'quantity:'
    require_header_text 'finishTransactionWithTransactionIdentifier:'
    require_header_text 'cancelInitialization'
    require_header_text 'cancelShutdown'
    require_header_text 'cancelProductsRequest'
    require_header_text 'cancelCurrentEntitlementsRequest'
    require_header_text 'cancelAppStoreSync'
    require_header_text 'cancelUnfinishedTransactionsRequest'
    require_header_text 'cancelPurchase'
    require_header_text 'cancelTransactionFinish'
    require_header_text 'initWithProductIdentifier:'
    require_header_text 'initWithProductIdentifiers:'
    require_header_text 'initWithSubscriptionGroupIdentifier:'

    reject_header_text 'StoreState'
    reject_header_text 'VerificationResult'
    reject_header_text 'StoreKitWrapperErrorMapper'
    reject_header_text 'Swift.Task'
    reject_header_text 'StoreKitViewHostingContainer'
    reject_header_text 'UIHostingController'
    reject_header_text 'AnyView'
}

build_and_verify_contract() {
    local destination="$1"
    local platform_name="$2"
    local products_directory="${output_root}/${platform_name}/products"
    local intermediates_directory="${output_root}/${platform_name}/intermediates"
    local generated_header

    mkdir -p "${products_directory}" "${intermediates_directory}"

    xcodebuild -project "${project_path}" \
               -scheme StoreKitWrapper \
               -configuration Release \
               -destination "${destination}" \
               CODE_SIGNING_ALLOWED=NO \
               SYMROOT="${products_directory}" \
               OBJROOT="${intermediates_directory}" \
               build

    generated_header="$(find "${products_directory}" \
                              -path '*/StoreKitWrapper.framework/Headers/StoreKitWrapper-Swift.h' \
                              -print \
                              -quit)"

    if [[ -z "${generated_header}" ]]; then
        echo "StoreKitWrapper-Swift.h was not installed for ${platform_name}." >&2
        exit 1
    fi

    verify_generated_header "${generated_header}"
    echo "${platform_name} Objective-C contract verified: ${generated_header}"
}

require_command xcodebuild
require_command find
require_command grep

build_and_verify_contract "generic/platform=iOS Simulator" "ios-simulator"
build_and_verify_contract "generic/platform=macOS,variant=Mac Catalyst" "maccatalyst"

echo "Native Objective-C contract verified successfully."
