#!/bin/bash
#####################################################
#
# This script takes as standard input a list
# of student environments that need to be created.
#
# This script must be run on an AWS VM.
#
# Ex. ./create-student-env.sh < students-example
#
# Where students would be a file containing a
# student identifier per line. See "students-example"
# in this repo. Having a common identifier as part
# of each students entry helps when cleaning up the
# vagrant boxes in AWS. On the instances page, filter
# on the common identifier reduce the list to just those
# instances used in class.
#
# The students would be provided with BOSH_LITE_PRIVATE_KEY
# which would be used to ssh into their environment.
#
# ex. ssh -i ./operator-class-key.pem ubuntu@<vm ip>
#
# Note the user is "ubuntu" not "ec2-user".
#
#####################################################

# Exit if a command fails.
set -e

export BOSH_AWS_ACCESS_KEY_ID="REPLACE_ME"
export BOSH_AWS_SECRET_ACCESS_KEY="REPLACE_ME"
export BOSH_LITE_PRIVATE_KEY="REPLACE_ME"
export BOSH_LITE_SECURITY_GROUP="REPLACE_ME" # AWS security group id
export BOSH_LITE_SUBNET_ID="REPLACE_ME" # AWS subnet id
export BOSH_LITE_REGION="REPLACE_ME" # <-- AWS region
export BOSH_LITE_KEYPAIR="REPLACE_ME" # <-- AWS keyPair name
export STUDENT_LIST="<Some Working Directory>/student-ip-mapping.txt"

# Vagrant requires a single Vagrantfile per workspace
while IFS='' read -r line || [[ -n "$line" ]]; do
  mkdir -p ~/$line-workspace
  cd ~/$line-workspace
  cp ~/workspace/bosh-lite/Vagrantfile .
  export BOSH_LITE_NAME="$line-bosh-lite"

  # Append the meta data for this student's environment
  # to the aggregate list. This is used to provide a
  # given student the IP of their environment.
  echo $line-workspace >> $STUDENT_LIST
  vagrant up --parallel --provider=aws | grep "public IP for" >> $STUDENT_LIST
done < "$1"
