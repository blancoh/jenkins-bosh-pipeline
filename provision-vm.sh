#!/bin/bash

echo "Applying latest OS updates..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get update -y

echo "Installing Bosh dependencies for Ubuntu Bionic 18.04..."
sudo apt-get install -y build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt1-dev libxml2-dev libssl-dev libreadline7 libreadline-dev libyaml-dev libsqlite3-dev sqlite3 whois -y

echo "Install AWS CLI tool via snap..."
sudo snap install aws-cli --classic

cd /home/ubuntu

echo "Create Bosh vars.yml file..."
echo -n "vm_passwd: " > vars.yml
mkpasswd -m sha-512 "b0sh2019" >> vars.yml
sudo chown ubuntu:ubuntu vars.yml

echo "Download Bosh CLI tool..."
wget https://github.com/cloudfoundry/bosh-cli/releases/download/v5.4.0/bosh-cli-5.4.0-linux-amd64
mv bosh-cli-5.4.0-linux-amd64 bosh
chmod ugo+rx bosh
sudo mv bosh /usr/local/bin/.

echo "Git clone bosh-deployment repository..."
git clone https://github.com/cloudfoundry/bosh-deployment
sudo chown -R ubuntu:ubuntu bosh-deployment

echo "Install custom Bosh deployment files..."
tar xzfv /tmp/files.tar.gz
cp files/* .
chmod +x *.sh

# Setup Bosh files
#priv_subnet_id=`/snap/bin/aws ec2 describe-subnets --filters "Name=tag:Name,Values=Private Subnet A" --query 'Subnets[*].SubnetId' --output text`
#sed -i "s/enteryoursubnetidhere/$priv_subnet_id/g" do-bosh.sh
#sed -i "s/enteryoursubnetidhere/$priv_subnet_id/g" update-cloud-config.sh
