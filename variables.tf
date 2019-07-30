variable "key_name" {
  description = "Desired name of AWS key pair"
  default     = "jumpbox"
}
variable "key_path" {
  description = "SSH key path for sshing into ec2 instance"
  default = "./jumpbox.pem"
}
variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}
variable "vpc_cidr" {
    default = "10.0.0.0/16"
  description = "the vpc cdir range"
}
variable "public_subnet_a" {
  default = "10.0.1.0/24"
  description = "Public subnet AZ A"
}
variable "private_subnet_a" {
  default = "10.0.0.0/24"
  description = "Private subnet AZ A"
}
