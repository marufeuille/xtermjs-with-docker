#!/bin/bash
TF_VAR_EXTERNAL_IP=$(curl inet-ip.info)
export TF_VAR_EXTERNAL_IP

mkdir -p ./outputs
if [ ! -e ./outputs/id_rsa ]
then
  ssh-keygen -t rsa -N "" -f ./outputs/id_rsa
fi

terraform init
terraform apply -auto-approve
