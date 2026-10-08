#!/usr/bin/env bash
set -euo pipefail

TARBALL_NAME="lace.tar.gz"
CHECKSUMS_NAME="SHA256SUMS"
NODE_FLOOR=22.19
DIST_RELEASE_BASE_URL="${LACE_DIST_BASE_URL:-https://github.com/ildella/lace-dist/releases/latest/download}"
LACE_HOME="${LACE_HOME:-$HOME/.lace}"
export LACE_HOME
TMP_DIR=""

fail() {
  printf 'lace install: %s\n' "$1" >&2
  exit 1
}

detect_platform() {
  local os arch
  os=$(uname -s)
  arch=$(uname -m)
  case "$os" in
    Linux | Darwin) ;;
    *) fail "unsupported OS '$os' — supported: Linux, macOS (Darwin)" ;;
  esac
  case "$arch" in
    x86_64 | amd64) printf 'x64\n' ;;
    aarch64 | arm64) printf 'arm64\n' ;;
    *) fail "unsupported architecture '$arch' — supported: x86_64, aarch64" ;;
  esac
}

require_node() {
  command -v node >/dev/null 2>&1 || fail "node not found — install node >= $NODE_FLOOR and retry"
  NODE_FLOOR="$NODE_FLOOR" node -e '
    const floor = process.env.NODE_FLOOR.split(".").map(Number);
    const [major, minor] = process.versions.node.split(".").map(Number);
    process.exit(major > floor[0] || (major === floor[0] && minor >= (floor[1] || 0)) ? 0 : 1);
  ' || fail "$(node -v) is too old — lace needs node >= $NODE_FLOOR"
}

download() {
  local url="$1" dest="$2"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$dest"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$dest" "$url"
  else
    fail "need curl or wget to download artifacts"
  fi
}

verify_checksum() {
  local dir="$1"
  if command -v sha256sum >/dev/null 2>&1; then
    ( cd "$dir" && sha256sum -c "$CHECKSUMS_NAME" ) >/dev/null ||
      fail "checksum verification failed for $TARBALL_NAME"
  elif command -v shasum >/dev/null 2>&1; then
    ( cd "$dir" && shasum -a 256 -c "$CHECKSUMS_NAME" ) >/dev/null ||
      fail "checksum verification failed for $TARBALL_NAME"
  else
    fail "need sha256sum or shasum to verify the download"
  fi
}

extract() {
  command -v tar >/dev/null 2>&1 || fail "tar not found"
  rm -rf "$LACE_HOME"
  mkdir -p "$LACE_HOME"
  tar -xzf "$1/$TARBALL_NAME" -C "$LACE_HOME"
}

main() {
  printf 'lace install: platform %s\n' "$(detect_platform)"
  require_node
  printf 'lace install: node %s\n' "$(node -v)"

  TMP_DIR=$(mktemp -d)
  trap 'rm -rf "$TMP_DIR"' EXIT

  printf 'lace install: downloading %s\n' "$DIST_RELEASE_BASE_URL/$TARBALL_NAME"
  download "$DIST_RELEASE_BASE_URL/$TARBALL_NAME" "$TMP_DIR/$TARBALL_NAME"
  download "$DIST_RELEASE_BASE_URL/$CHECKSUMS_NAME" "$TMP_DIR/$CHECKSUMS_NAME"
  verify_checksum "$TMP_DIR"

  extract "$TMP_DIR"
  printf 'lace install: extracted into %s\n' "$LACE_HOME"

  LACE_INSTALL_MODE=installed node "$LACE_HOME/install.js" "$@"
}

main "$@"
