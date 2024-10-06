#!/bin/bash

set -e

# Define package name and version from the tag
PACKAGE_NAME="stone-prover"
VERSION=$1  # Get the version from the argument

# Create a directory for the Alpine package
mkdir -p build/${PACKAGE_NAME}
cd build/${PACKAGE_NAME}

# Create the APKBUILD file
cat <<EOF > APKBUILD
# Maintainer: Your Name <your.email@example.com>
pkgname=${PACKAGE_NAME}
pkgver=${VERSION}
pkgrel=0
pkgdesc="Stone Prover for Tezos"
url="https://github.com/baking-bad/stone-prover"
arch="x86_64"
license="MIT"
depends=""
source="https://github.com/baking-bad/stone-prover/archive/refs/tags/\$pkgver.tar.gz"

build() {
    cmake . || return 1
    make || return 1
}

package() {
    install -Dm755 your_binary -t "\$pkgdir/usr/bin"  # Adjust this line based on your output binary
}
EOF

# Build the package
abuild -r
