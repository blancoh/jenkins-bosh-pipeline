#!/bin/bash

ec2_publicip=`/usr/local/bin/aws ec2 describe-instances --filters "Name=tag:Name,Values=JumpBox" --query 'Reservations[*].Instances[*].PublicIpAddress' --output text`

chmod 600 jumpbox.pem

ssh -o StrictHostKeyChecking=no -i jumpbox.pem ubuntu@$ec2_publicip "/home/ubuntu/setup-bosh-env.sh"

