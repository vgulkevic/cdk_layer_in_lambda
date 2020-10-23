#!/usr/bin/env sh

while getopts "e:": option; do
  case "${option}" in
  e) ENV=${OPTARG} ;;
  *)
    echo "usage: $0 [-v] [-r]" >&2
    exit 1
    ;;
  esac
done

cd ./terraform/"$ENV" || exit
terraform init
terraform apply -auto-approve
