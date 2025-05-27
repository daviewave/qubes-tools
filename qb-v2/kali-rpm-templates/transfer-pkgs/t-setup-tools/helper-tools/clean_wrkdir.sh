#!/bin/bash

only_one="$1"
if [ ! -e $only_one ]; then
  echo "removing contents from 'artifacts/$only_one/*'"
  rm $PWD/artifacts/$only_one/*
else
  dirs=("components" "distfiles" "logs" "repository" "sources" "templates" "tmp")
  echo -e "removing contents from $PWD/artifacts/ -> \n$(ls artifacts/)"
  for dir in "${dirs[@]}"
  do
    p="$PWD/artifacts/$dir"
    rm -rf $p/*
  done
fi

docker container prune
docker volume prune


