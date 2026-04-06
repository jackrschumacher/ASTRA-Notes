#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# Builds a Hugo site hosted on a Cloudflare Worker.
#
# The Cloudflare Worker automatically installs Node.js dependencies.
#------------------------------------------------------------------------------

main() {

  DART_SASS_VERSION=1.97.3
  GO_VERSION=1.25.6
  HVM_CONTENT=$(cat astra-docs/.hvm | tr -d '\r\n')  # Strips hidden line endings
  HVM_VERSION=$(echo "$HVM_CONTENT" | cut -d'/' -f1) # e.g., v0.160.0
  HVM_EDITION=$(echo "$HVM_CONTENT" | cut -d'/' -f2) # e.g., extended
  RAW_VERSION="${HVM_VERSION#v}"                     # e.g., 0.160.0
  NODE_VERSION=24.13.0

  export TZ=Europe/Oslo

  # Install Dart Sass
  echo "Installing Dart Sass ${DART_SASS_VERSION}..."
  curl -sLJO "https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
  tar -C "${HOME}/.local" -xf "dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
  rm "dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
  export PATH="${HOME}/.local/dart-sass:${PATH}"

  # Install Go
  echo "Installing Go ${GO_VERSION}..."
  curl -sLJO "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
  tar -C "${HOME}/.local" -xf "go${GO_VERSION}.linux-amd64.tar.gz"
  rm "go${GO_VERSION}.linux-amd64.tar.gz"
  export PATH="${HOME}/.local/go/bin:${PATH}"

  # Install Hugo
  echo "Installing Hugo ${RAW_VERSION} (${HVM_EDITION})..."
  if [ "$HVM_EDITION" = "extended" ]; then
    HUGO_TARBALL="hugo_extended_${RAW_VERSION}_linux-amd64.tar.gz"
  else
    HUGO_TARBALL="hugo_${RAW_VERSION}_linux-amd64.tar.gz"
  fi
  
  curl -sLJO "https://github.com/gohugoio/hugo/releases/download/${HVM_VERSION}/${HUGO_TARBALL}"
  mkdir -p "${HOME}/.local/hugo"
  tar -C "${HOME}/.local/hugo" -xf "${HUGO_TARBALL}"
  rm "${HUGO_TARBALL}"
  export PATH="${HOME}/.local/hugo:${PATH}"

  # Install Node.js
  echo "Installing Node.js ${NODE_VERSION}..."
  curl -sLJO "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz"
  tar -C "${HOME}/.local" -xf "node-v${NODE_VERSION}-linux-x64.tar.xz"
  rm "node-v${NODE_VERSION}-linux-x64.tar.xz"
  export PATH="${HOME}/.local/node-v${NODE_VERSION}-linux-x64/bin:${PATH}"

  # Verify installations
  echo "Verifying installations..."
  echo Dart Sass: "$(sass --version)"
  echo Go: "$(go version)"
  echo Hugo: "$(hugo version)"
  echo Node.js: "$(node --version)"

  # Configure Git
  echo "Configuring Git..."
  git config core.quotepath false
  if [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
    git fetch --unshallow
  fi

  # Build the site
  echo "Building the site..."
  cd astra-docs
  hugo --gc --minify -d ../public

}

set -euo pipefail
main "$@"