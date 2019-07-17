#!/bin/bash

echo starting script >> /tmp/jumpbox-startup.sh

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get update -y
#sudo apt-get install -y build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt1-dev libxml2-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3
sudo apt-get install -y build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt1-dev libxml2-dev libssl-dev libreadline7 libreadline-dev libyaml-dev libsqlite3-dev sqlite3 -y
sudo snap install aws-cli --classic
echo installed packages1 >> /tmp/jumpbox-startup.sh

cd /home/ubuntu

sudo apt-get install whois -y
echo -n "vm_passwd: " > vars.yml
mkpasswd -m sha-512 "c1oudc0w" >> vars.yml
sudo chown ubuntu:ubuntu vars.yml

wget https://github.com/cloudfoundry/bosh-cli/releases/download/v5.4.0/bosh-cli-5.4.0-linux-amd64
mv bosh-cli-5.4.0-linux-amd64 bosh
chmod ugo+rx bosh
sudo mv bosh /usr/local/bin/.

git clone https://github.com/cloudfoundry/bosh-deployment
sudo chown -R ubuntu:ubuntu bosh-deployment

tar xzfv /tmp/files.tar.gz
cp files/* .
chmod +x *.sh

# Setup Bosh files
priv_subnet_id=`/snap/bin/aws ec2 describe-subnets --filters "Name=tag:Name,Values=Private Subnet A" --query 'Subnets[*].SubnetId' --output text`
sed -i "s/enteryoursubnetidhere/$priv_subnet_id/g" do-bosh.sh
sed -i "s/enteryoursubnetidhere/$priv_subnet_id/g" update-cloud-config.sh
#sudo reboot

echo ending script >> /tmp/jumpbox-startup.sh
