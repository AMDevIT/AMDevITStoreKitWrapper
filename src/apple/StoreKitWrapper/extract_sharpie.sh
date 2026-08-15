#!/bin/bash

echo "Extracting classes and interfaces from xcframework"

sharpie bind \
  ./build/StoreKitWrapper.xcframework/ios-arm64/StoreKitWrapper.framework/Headers/*.h \
  -scope="./build/StoreKitWrapper.xcframework/ios-arm64/StoreKitWrapper.framework/Headers" \
  -o "./sharpie-output" \
  -n "AMDevIT.StoreKit.Wrapper" \
  -c -F "$HOME/Library/Developer/Xcode/DerivedData" \

