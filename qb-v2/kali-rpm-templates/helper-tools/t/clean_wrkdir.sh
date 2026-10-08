#!/usr/bin/env bash
set -euo pipefail

ARTIFACT_DIRS="components distfiles logs repository sources templates tmp"

clean_one_artifact_dir() {
  echo "removing contents from 'artifacts/$1/*'"
  rm -rf "${PWD:?}/artifacts/${1:?}"/*
}

clean_all_artifact_dirs() {
  echo -e "removing contents from $PWD/artifacts/ -> \n$(ls artifacts/)"
  local dir
  for dir in $ARTIFACT_DIRS; do
    rm -rf "${PWD:?}/artifacts/$dir"/*
  done
}

clean_one_artifact_dir_or_all() {
  if [ -n "$1" ]; then
    clean_one_artifact_dir "$1"
  else
    clean_all_artifact_dirs
  fi
}

prune_docker() {
  docker container prune
  docker volume prune
}

main() {
  clean_one_artifact_dir_or_all "${1:-}"
  prune_docker
}

main "$@"
