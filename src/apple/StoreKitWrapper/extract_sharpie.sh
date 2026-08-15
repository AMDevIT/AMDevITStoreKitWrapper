#!/usr/bin/env bash

set -euo pipefail

FRAMEWORK_PATH="./build/StoreKitWrapper.xcframework/ios-arm64/StoreKitWrapper.framework"
HEADER_PATH="$FRAMEWORK_PATH/Headers/StoreKitWrapper.h"
OUTPUT_PATH="./sharpie-output"

if ! command -v sharpie > /dev/null 2>&1; then
    echo "Objective Sharpie is not installed or is not available in PATH." >&2
    exit 1
fi

if [[ ! -d "$FRAMEWORK_PATH" ]]; then
    echo "Framework not found at $FRAMEWORK_PATH. Run build_xcframework.sh first." >&2
    exit 1
fi

if [[ ! -f "$HEADER_PATH" ]]; then
    echo "Framework header not found at $HEADER_PATH." >&2
    exit 1
fi

echo "Extracting classes and interfaces from xcframework"

sharpie bind --header="$HEADER_PATH" --scope="$FRAMEWORK_PATH/Headers" --sdk=iphoneos --output="$OUTPUT_PATH" --namespace="AMDevIT.StoreKitWrapper" --verbose

if [[ ! -d "$OUTPUT_PATH" ]] || [[ -z "$(find "$OUTPUT_PATH" -type f -print -quit)" ]]; then
    echo "Objective Sharpie completed without generating files in $OUTPUT_PATH." >&2
    exit 1
fi
