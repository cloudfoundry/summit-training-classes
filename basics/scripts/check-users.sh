#!/bin/bash

set -eu

for COUNT in {1..30}; do
  USERNAME=zerotohero${COUNT}@${USER_EMAIL_DOMAIN}

  set +e
  if cf auth "${USERNAME}" Password1! > /dev/null; then
    echo "${USERNAME}" worked
  else
    echo "${USERNAME}" failed
  fi
  set -e
done