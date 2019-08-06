#!/bin/bash

ec2_publicip=`/usr/local/bin/aws ec2 describe-instances --filters "Name=tag:Name,Values=JumpBox" --query 'Reservations[*].Instances[*].PublicIpAddress' --output text`

chmod 600 jumpbox.pem

ssh -i jumpbox.pem ubuntu@$ec2_publicip "setup-bosh-env.sh"
