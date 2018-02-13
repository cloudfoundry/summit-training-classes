#!/bin/bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../terraform"

set +u
num_students=$1
if [ -z "$num_students" ]
then
    num_students=1
fi
out=$2
if [ -z "$out" ]
then
    out="students.json"
fi
set -u

tmp=$(mktemp -d)
for i in $(seq 0 $((num_students - 1)))
do
    ssh-keygen -N '' -f "$tmp/id_rsa_$i"
done

terraform init
terraform apply -auto-approve -var num_students="$num_students" -var key_dir="$tmp"

for i in $(seq 1 $num_students)
do
    jq -n \
    --arg internal_cidr "$(terraform output internal_cidr)" \
    --arg internal_gw "$(terraform output internal_gw)" \
    --arg internal_ip "$(terraform output internal_ips | cut -d, -f "$i")" \
    --arg access_key_id "$(terraform output access_key_ids | cut -d, -f "$i")" \
    --arg secret_access_key "$(terraform output secret_access_keys | cut -d, -f "$i")" \
    --arg region "$(terraform output region)" \
    --arg az "$(terraform output az)" \
    --arg default_key_name "$(terraform output default_key_names | cut -d, -f "$i")" \
    --arg private_key "$(<"$tmp/id_rsa_$((num_students -1))")" \
    --arg default_security_groups "$(terraform output default_security_groups)" \
    --arg subnet_id "$(terraform output subnet_id)" \
    --arg external_ip "$(terraform output external_ips | cut -d, -f "$i")" \
    '{
        "internal_cidr": $internal_cidr,
        "internal_gw": $internal_gw,
        "internal_ip": $internal_ip,
        "access_key_id": $access_key_id,
        "secret_access_key": $secret_access_key,
        "region": $region,
        "az": $az,
        "default_key_name": $default_key_name,
        "private_key": $private_key,
        "default_security_groups": $default_security_groups,
        "subnet_id": $subnet_id,
        "external_ip": $external_ip,
    }'
done | jq -s . > students.json

rm -r "$tmp"