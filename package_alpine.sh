#!/bin/sh

set -e

# Ensure the TAG argument is provided
TAG=$1
if [ -z "$TAG" ]; then
  echo "Error: Tag argument is required"
  exit 1
fi

# Install necessary Alpine packages for building
apk add --no-cache alpine-sdk abuild

# Create a temporary directory for the package
BUILD_DIR="/tmp/stone-prover"
mkdir -p $BUILD_DIR/usr/bin

# Copy the binaries into the package directory
cp /usr/local/bin/cpu_air_prover $BUILD_DIR/usr/bin/
cp /usr/local/bin/cpu_air_verifier $BUILD_DIR/usr/bin/

# Create the APKBUILD file
APKBUILD_FILE="$BUILD_DIR/APKBUILD"
cat <<EOF > $APKBUILD_FILE
# Maintainer: Baking Bad <na@baking-bad.org>
pkgname=stone-prover
pkgver=$(echo $TAG | cut -c 2-)
pkgrel=0
arch="${TARGET_ARCH}"
url="https://example.com" # Replace with the actual URL
license="MIT" # Update with the correct license if different
depends="libdw"

build() {
    # No build step needed since we're copying precompiled binaries
    return 0
}

package() {
    install -Dm755 usr/bin/cpu_air_prover "${pkgdir}/usr/bin/cpu_air_prover"
    install -Dm755 usr/bin/cpu_air_verifier "${pkgdir}/usr/bin/cpu_air_verifier"
}
EOF

# Change to the build directory
cd $BUILD_DIR

# Create the APK package
abuild -r
