#!/bin/sh
set -e

# Ensure the TAG argument is provided
TAG=$1
if [ -z "$TAG" ]; then
    echo "Error: Tag argument is required"
    exit 1
fi

# Create a temporary directory for the package
BUILD_DIR="/tmp/stone-prover"
mkdir -p $BUILD_DIR/usr/bin

# Copy the binaries into the package directory
cp /work/cpu_air_prover $BUILD_DIR/usr/bin/
cp /work/cpu_air_verifier $BUILD_DIR/usr/bin/

# Create the APKBUILD file
APKBUILD_FILE="$BUILD_DIR/APKBUILD"
cat <<EOF > $APKBUILD_FILE
# Maintainer: Baking Bad <na@baking-bad.org>
pkgname=stone-prover
pkgver=$(echo $TAG | cut -c 2-)
pkgrel=0
pkgdesc="Stone Prover binaries"
url="https://github.com/yourusername/stone-prover"
arch="x86_64"
license="MIT"
depends="libdw"
options="!check"

package() {
    install -Dm755 \$srcdir/usr/bin/cpu_air_prover "\$pkgdir/usr/bin/cpu_air_prover"
    install -Dm755 \$srcdir/usr/bin/cpu_air_verifier "\$pkgdir/usr/bin/cpu_air_verifier"
}
EOF

# Change to the build directory
cd $BUILD_DIR

# Build the package
abuild -r