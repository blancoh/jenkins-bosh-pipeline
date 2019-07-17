# jenkins-bosh-pipeline

Project goals:

1. Create an Amazon VPC with 1 public and 1 private subnet with Nat gateway.
2. Create an EC2 instance named jumpbox for access to internal network.
3. Deploy Bosh Director from jumpbox to the 10.0.0.0/24 subnet.
4. Deploy example zookeeper application to verify installation was successful.
