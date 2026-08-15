#!/usr/bin/env bash

set -euo pipefail

FRAMEWORK_PATH="./build/StoreKitWrapper.xcframework/ios-arm64/StoreKitWrapper.framework"
OUTPUT_PATH="./sharpie-output"

if ! command -v sharpie > /dev/null 2>&1; then
    echo "Objective Sharpie is not installed or is not available in PATH." >&2
    exit 1
fi

if [[ ! -d "$FRAMEWORK_PATH" ]]; then
    echo "Framework not found at $FRAMEWORK_PATH. Run build_xcframework.sh first." >&2
    exit 1
fi

echo "Extracting classes and interfaces from xcframework"

sharpie bind --framework="$FRAMEWORK_PATH" --output="$OUTPUT_PATH" --namespace="AMDevIT.StoreKitWrapper"
