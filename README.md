# jenkins-bosh-pipeline

Project goals:

1. Create an Amazon VPC with 1 public (10.0.1.0/24) and 1 private subnet (10.0.0.0/24).
2. Create an EC2 instance named jumpbox in public subnet for access to internal network.
3. Deploy Bosh Director from jumpbox to the 10.0.0.0/24 subnet.
4. Deploy sample zookeeper application using Bosh Director to verify installation was successful.
