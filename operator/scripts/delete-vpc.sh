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
    touch "$tmp/id_rsa_$i"
    touch "$tmp/id_rsa_$i.pub"
done

terraform destroy -force -var num_students="$num_students" -var key_dir="$tmp"

rm -r "$tmp"
