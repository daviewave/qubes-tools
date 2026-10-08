#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DEFAULT_TEMPLATE="kali-core"
CONTAINER_IMAGE="qubes-builder-debian:latest"
CONTAINER_OS="debian"

die() {
  echo "$*" >&2
  exit 1
}

usage() {
  die "usage: $(basename "$0") [template] [--sign]"
}

check_args() {
  [ "$#" -le 2 ] || usage
  local arg
  for arg in "$@"; do
    [ "${arg:0:2}" != "--" ] || [ "$arg" = "--sign" ] || usage
  done
}

check_env() {
  "$SCRIPT_DIR/check_env.sh"
}

template_from_args() {
  local arg
  for arg in "$@"; do
    [ "$arg" = "--sign" ] || { echo "$arg"; return; }
  done
  echo "$DEFAULT_TEMPLATE"
}

signing_requested() {
  local arg
  for arg in "$@"; do
    [ "$arg" != "--sign" ] || return 0
  done
  return 1
}

container_image_exists() {
  docker image inspect "$CONTAINER_IMAGE" &> /dev/null
}

build_container_image_if_missing() {
  container_image_exists && return 0
  echo "building $CONTAINER_IMAGE..."
  (cd "$qbp" && tools/generate-container-image.sh docker "$CONTAINER_OS")
}

build_template() {
  echo "building template $1..."
  (cd "$qbp" && ./qb --builder-conf builder.yml -t "$1" template build)
}

sign_template_if_asked() {
  signing_requested "${@:2}" || return 0
  echo "signing template $1..."
  (cd "$qbp" && ./qb --builder-conf builder.yml -t "$1" template sign)
}

report_artifacts() {
  echo "done. rpm(s) in: $qbp/artifacts/templates/rpm/"
}

main() {
  check_args "$@"
  check_env
  build_container_image_if_missing
  build_template "$(template_from_args "$@")"
  sign_template_if_asked "$(template_from_args "$@")" "$@"
  report_artifacts
}

main "$@"
