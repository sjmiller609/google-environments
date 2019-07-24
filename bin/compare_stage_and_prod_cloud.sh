#!/bin/bash

# the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

stage=`md5sum $DIR/../stage/cloud/main.tf | awk '{print $1}'`
prod=`md5sum $DIR/../prod/cloud/main.tf | awk '{print $1}'`

if [[ "$stage" != "$prod" ]]; then
  echo "ERROR: Stage and Prod main.tf must be exactly the same to deploy Prod Cloud"
  exit 1
fi

echo "Stage and Prod main.tf are exactly the same. Good job."
exit 0
