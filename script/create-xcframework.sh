#!/bin/bash

IOS_ARM64_PRESET="ios-arm64"
MAC_ARM64_PRESET="macos-arm64"
MAC_X64_PRESET="macos-x86_64"
OUTPUT="install/OpenSSL.xcframework"
LIBS=""

set -e

for preset in $IOS_ARM64_PRESET $MAC_ARM64_PRESET $MAC_X64_PRESET; do
    INSTALL_DIR="install/$preset"

    rm -rf $INSTALL_DIR
    cmake --preset $preset -DOPENSSL_CONFIGURE_OPTIONS="--prefix=$(pwd)/$INSTALL_DIR"
    cmake --build --preset $preset -t install
    libtool -static -o $INSTALL_DIR/lib/openssl.a \
        $INSTALL_DIR/lib/libcrypto.a \
        $INSTALL_DIR/lib/libssl.a
    LIBS="$LIBS -library $INSTALL_DIR/lib/openssl.a -headers $INSTALL_DIR/include"
done

rm -rf $OUTPUT
xcodebuild -create-xcframework $LIBS -output $OUTPUT
