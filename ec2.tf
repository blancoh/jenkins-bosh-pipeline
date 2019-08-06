data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jumpbox" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.PublicSubnetA.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.sec_web.id}"]
  key_name = "jumpbox"

  tags = {
    Name = "JumpBox"
  }

  connection {
    user = "ubuntu"
    host = "${aws_instance.jumpbox.public_ip}"
    private_key = "${file("jumpbox.pem")}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [ "mkdir ~/.aws" ]
  }

  provisioner "file" {
    source = "~/.aws/credentials"
    destination = "~/.aws/credentials"
  }

  provisioner "file" {
    source = "~/.aws/config"
    destination = "~/.aws/config"
  }

  provisioner "file" {
    source = "files.tar.gz"
    destination = "/tmp/files.tar.gz"
  }

  provisioner "remote-exec" {
    script = "./provision-vm.sh"
  }

}

resource "aws_security_group" "sec_web" {
  name        = "sec_web"
  description = "Used for autoscale group"
  vpc_id      = "${aws_vpc.default.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "sec_lb" {
  name = "sec_elb"
  vpc_id      = "${aws_vpc.default.id}"
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bosh-private-bosh" {
  name = "bosh-private-bosh"
  vpc_id      = "${aws_vpc.default.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

