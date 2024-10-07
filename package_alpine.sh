#!/bin/sh

set -e

TAG=$1

mkdir -p /tmp/stone-prover/DEBIAN
mkdir -p /tmp/stone-prover/usr/bin

cp /tmp/stone-prover/cpu_air_prover /tmp/stone-prover/usr/bin/
cp /tmp/stone-prover/cpu_air_verifier /tmp/stone-prover/usr/bin/

cat <<EOF > /tmp/stone-prover/DEBIAN/control
Package: stone-prover
Version: $(echo $TAG | cut -c 2-)
Architecture: all
Depends: libdw1
Maintainer: Baking Bad na@baking-bad.org
Description: Stone prover deb package
EOF

dpkg-deb --build /tmp/stone-prover /tmp/stone-prover/stone-prover.deb

apk add --no-cache build-base
apk add --no-cache alpine-sdk
abuild-keygen -a -n
abuild-tar --compression xz

cd /tmp/stone-prover
abuild -r -P cpu_air_prover-${TARGET_ARCH}.apk cpu_air_prover
abuild -r -P cpu_air_verifier-${TARGET_ARCH}.apk cpu_air_verifier