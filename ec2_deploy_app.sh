#!/bin/bash

ec2_publicip=`/usr/local/bin/aws ec2 describe-instances --filters "Name=tag:Name,Values=JumpBox" --query 'Reservations[*].Instances[*].PublicIpAddress' --output text`

ssh -i jumpbox.pem ubuntu@$ec2_publicip "deploy-zookeeper.sh"
