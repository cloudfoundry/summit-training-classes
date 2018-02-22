#!/bin/bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

set +u
prefix=$1
set -u
settings=$(cat)

internal_cidr=$(jq -r '.internal_cidr' <<< "$settings")
internal_gw=$(jq -r '.internal_gw' <<< "$settings")
internal_ip=$(jq -r '.internal_ip' <<< "$settings")
access_key_id=$(jq -r '.access_key_id' <<< "$settings")
secret_access_key=$(jq -r '.secret_access_key' <<< "$settings")
region=$(jq -r '.region' <<< "$settings")
az=$(jq -r '.az' <<< "$settings")
default_key_name=$(jq -r '.default_key_name' <<< "$settings")
private_key_file=$(mktemp)
jq -r '.private_key' <<< "$settings" > "$private_key_file"
default_security_groups=$(jq -r '.default_security_groups' <<< "$settings")
subnet_id=$(jq -r '.subnet_id' <<< "$settings")
external_ip=$(jq -r '.external_ip' <<< "$settings")
state_file="${prefix}state.json"
creds_file="${prefix}creds.yml"
bosh create-env bosh-deployment/bosh.yml \
  --state="$state_file" \
  --vars-store="$creds_file" \
  -o bosh-deployment/aws/cpi.yml \
  -o bosh-deployment/bosh-lite.yml \
  -o bosh-deployment/bosh-lite-runc.yml \
  -o bosh-deployment/external-ip-with-registry-not-recommended.yml \
  -v director_name=bosh-1 \
  -v "internal_cidr=$internal_cidr" \
  -v "internal_gw=$internal_gw" \
  -v "internal_ip=$internal_ip" \
  -v "access_key_id=$access_key_id" \
  -v "secret_access_key=$secret_access_key" \
  -v "region=$region" \
  -v "az=$az" \
  -v "default_key_name=$default_key_name" \
  -v "default_security_groups=$default_security_groups" \
  --var-file "private_key=$private_key_file" \
  -v "subnet_id=$subnet_id" \
  -v "external_ip=$external_ip"

client_secret=$(bosh int "$creds_file" --path /admin_password)
ca_cert=$(bosh int "$creds_file" --path /director_ssl/ca)
cat <<EOF
export BOSH_ENVIRONMENT=$external_ip
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=$client_secret
export BOSH_GW_HOST=$external_ip
export BOSH_GW_USER=vcap
export BOSH_GW_PRIVATE_KEY=$private_key_file
export BOSH_CA_CERT='$ca_cert'
EOF
