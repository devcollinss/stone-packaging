#!/bin/sh

TAG=$1

apk add --no-cache --virtual .build-deps alpine-sdk
mv /app/prover /app/prover-${TAG}
tar -czf prover-${TAG}.tar.gz prover-${TAG}
mv prover-${TAG}.tar.gz /app/