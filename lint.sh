#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SHELLCHECK_SEVERITY="warning"
EXCLUDED_PATHS='^qb-v2/kali-rpm-templates/transfer-pkgs/'

FAILURES=0

record() {
  local label=$1
  shift
  if "$@"; then
    echo "ok    $label"
  else
    echo "FAIL  $label"
    FAILURES=$((FAILURES + 1))
  fi
}

tracked_files() {
  git -C "$REPO_DIR" ls-files | grep -Ev "$EXCLUDED_PATHS"
}

has_shell_shebang() {
  head -n1 "$REPO_DIR/$1" 2> /dev/null | grep -Eq '^#!.*\b(ba)?sh\b'
}

is_shell_library() {
  head -n1 "$REPO_DIR/$1" | grep -q '^# shellcheck shell='
}

shell_files() {
  local f
  while read -r f; do
    if has_shell_shebang "$f" || is_shell_library "$f"; then echo "$f"; fi
  done < <(tracked_files)
}

parses_as_bash() {
  bash -n "$REPO_DIR/$1"
}

passes_shellcheck() {
  (cd "$REPO_DIR" && shellcheck -x -P SCRIPTDIR -S "$SHELLCHECK_SEVERITY" "$1")
}

check_shell_syntax() {
  local f
  while read -r f; do
    record "bash -n $f" parses_as_bash "$f"
  done < <(shell_files)
}

check_shellcheck() {
  if ! command -v shellcheck > /dev/null; then
    echo "skip  shellcheck (not installed)"
    return
  fi
  local f
  while read -r f; do
    record "shellcheck $f" passes_shellcheck "$f"
  done < <(shell_files)
}

nft_accepts() {
  unshare -rn nft -c -f "$REPO_DIR/$1"
}

check_nft_rulesets() {
  if ! command -v nft > /dev/null || ! unshare -rn true 2> /dev/null; then
    echo "skip  nft rulesets (needs nft and unprivileged user namespaces)"
    return
  fi
  local f
  while read -r f; do
    record "nft -c $f" nft_accepts "$f"
  done < <(tracked_files | grep '\.nft$')
}

python_compiles() {
  python3 -c 'import ast, sys; ast.parse(open(sys.argv[1]).read(), sys.argv[1])' "$REPO_DIR/$1"
}

check_python() {
  local f
  while read -r f; do
    head -n1 "$REPO_DIR/$f" | grep -q python || continue
    record "python $f" python_compiles "$f"
  done < <(tracked_files)
}

summarize() {
  echo
  if [ "$FAILURES" -eq 0 ]; then
    echo "lint passed"
  else
    echo "$FAILURES check(s) failed"
    return 1
  fi
}

main() {
  check_shell_syntax
  check_shellcheck
  check_nft_rulesets
  check_python
  summarize
}

main "$@"
