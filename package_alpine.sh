#!/bin/sh

set -e

tag=$1

# Build the prover and verifier
cd /tmp/stone-prover
make cpu_air_prover cpu_air_verifier

# Create the Alpine package
apk add --no-cache build-base
apk add --no-cache alpine-sdk
abuild-keygen -a -n
abuild-tar --compression xz

# Package the prover and verifier
cd /tmp/stone-prover
abuild -r -P cpu_air_prover-${TARGET_ARCH}.apk cpu_air_prover
abuild -r -P cpu_air_verifier-${TARGET_ARCH}.apk cpu_air_verifier