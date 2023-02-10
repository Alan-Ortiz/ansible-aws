#!/bin/bash

install_packages () {
   sudo apt update
   sudo apt install ansible python3-pip -y

   ansible-galaxy collection install amazon.aws
   ansible-galaxy collection install community.mysql
   ansible-galaxy collection install community.aws

   pip3 install --upgrade boto3 boto botocore
}


if [[ -z "$AWS_SECRET_ACCESS_KEY" && -z "$AWS_ACCESS_KEY_ID" ]]
then
     echo 'Please set $AWS_SECRET_ACCESS_KEY & $AWS_ACCESS_KEY_ID and re-run'
     exit 1
else
      echo "Running playbook"
      install_packages
      #Remove key verification for full automation
      sudo sed -i '/host_key_checking/s/^#//g' /etc/ansible/ansible.cfg
      ansible-playbook main.yml -i inventory/aws_ec2.yaml -vvv
fi

