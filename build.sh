#! /bin/sh

platforms="linux/amd64,linux/arm64/v8,linux/s390x,linux/386,linux/arm/v6,linux/arm/v7,linux/ppc64le"

set -e

for plt in `echo "$platforms" | tr , ' '`; do
    docker buildx build --platform=$plt --load \
	   --target=build --secret id=ABUILD_KEY -t figlet-build .
    docker run --platform=$plt -v `pwd`/output:/output figlet-build
done

docker buildx build --platform="$platforms" --push \
       --target=figlet -t ghcr.io/gaborcsardi/figlet .
