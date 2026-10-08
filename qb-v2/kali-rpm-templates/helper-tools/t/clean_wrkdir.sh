#!/bin/bash

# === start 1
# a) clean_one_artifact_dir_or_all
only_one="$1"
if [ -n "$only_one" ]; then
  echo "removing contents from 'artifacts/$only_one/*'"
  rm -rf "${PWD:?}/artifacts/${only_one:?}"/*
else
  dirs=("components" "distfiles" "logs" "repository" "sources" "templates" "tmp")
  echo -e "removing contents from $PWD/artifacts/ -> \n$(ls artifacts/)"
  for dir in "${dirs[@]}"
  do
    p="$PWD/artifacts/$dir"
    rm -rf "${p:?}"/*
  done
fi

# b) prune_docker
docker container prune
docker volume prune
# === end 1


