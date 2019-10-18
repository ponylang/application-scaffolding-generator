#!/bin/bash

set -e

API_KEY=$1
if [[ ${API_KEY} == "" ]]; then
  echo "API_KEY needs to be supplied as first script argument."
  exit 1
fi

# Compiler target parameters
ARCH=x86-64

# Triple construction
VENDOR=unknown
OS=linux
TRIPLE=${ARCH}-${VENDOR}-${OS}

# Build parameters
BUILD_PREFIX=$(mktemp -d)
APPLICATION_VERSION=$(cat VERSION)
BUILD_DIR=${BUILD_PREFIX}/${APPLICATION_VERSION}

# Asset information
PACKAGE_DIR=$(mktemp -d)
PACKAGE={%%APPLICATION%%}-${TRIPLE}

# Cloudsmith configuration
CLOUDSMITH_VERSION=$(cat VERSION)
ASSET_OWNER={%%CLOUDSMITH_OWNER%%}
ASSET_REPO={%%CLOUDSMITH_RELEASE_REPO%%}
ASSET_PATH=${ASSET_OWNER}/${ASSET_REPO}
ASSET_FILE=${PACKAGE_DIR}/${PACKAGE}.tar.gz
ASSET_SUMMARY="{%%PROJECT_DESCRIPTION%%}"
ASSET_DESCRIPTION=""

# Build {%%APPLICATION%%} installation
echo "Building {%%APPLICATION%%}..."
make install prefix="${BUILD_DIR}" arch=${ARCH} version="${APPLICATION_VERSION}" \
  static=true linker=bfd

# Package it all up
echo "Creating .tar.gz of {%%APPLICATION%%}..."
pushd "${BUILD_PREFIX}" || exit 1
tar -cvzf "${ASSET_FILE}" *
popd || exit 1

# Ship it off to cloudsmith
echo "Uploading package to cloudsmith..."
cloudsmith push raw --version "${CLOUDSMITH_VERSION}" --api-key "${API_KEY}" \
  --summary "${ASSET_SUMMARY}" --description "${ASSET_DESCRIPTION}" \
  ${ASSET_PATH} "${ASSET_FILE}"
