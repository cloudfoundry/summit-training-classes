#!/bin/bash

set -eu

cf auth "${ADMIN_USER}" "${ADMIN_PASSWORD}"
cf target -o "${ORG}"

for COUNT in {1..30}; do
  USER=zerotohero${COUNT}

  cf create-space ${USER}
  cf set-space-role ${USER}@"${USER_EMAIL_DOMAIN}" "${ORG}" $USER SpaceDeveloper
done