#!/bin/bash

detect_os() {
  local id id_like
  id=$(. /etc/os-release && echo "${ID:-}")
  id_like=$(. /etc/os-release && echo "${ID_LIKE:-}")
  case " $id $id_like " in
    *" fedora "*|*" rhel "*) echo fedora ;;
    *" debian "*|*" ubuntu "*) echo debian ;;
    *) echo "unsupported os: $id" >&2; return 1 ;;
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
