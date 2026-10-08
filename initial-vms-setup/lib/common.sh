# shellcheck shell=bash

detect_os() {
  local ids
  # shellcheck source=/dev/null
  ids=$(. /etc/os-release && echo "${ID:-} ${ID_LIKE:-}")
  case " $ids " in
    *" fedora "*|*" rhel "*) echo fedora ;;
    *" debian "*|*" ubuntu "*) echo debian ;;
    *) echo "unsupported os: $ids" >&2; return 1 ;;
  esac
}

resolve_os() {
  case "${1:-}" in
    "") detect_os ;;
    fedora|debian) echo "$1" ;;
    *) echo "usage: $(basename "$0") [fedora|debian]" >&2; return 1 ;;
  esac
}

# TemplateVMs have no direct network; only the qrexec updates proxy is reachable.
use_updates_proxy_if_template() {
  if [ -e /run/qubes-service/updates-proxy-setup ]; then
    export http_proxy=http://127.0.0.1:8082 https_proxy=http://127.0.0.1:8082
  fi
}
