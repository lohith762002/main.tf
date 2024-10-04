provider "aws" {
region = "us-east-1"
}

terraform {
required_providers {
aws = {
source = "hashicorp/aws"
version = "5.68.0"
}
tls = {
source = "hashicorp/tls"
version = "4.0.5"
}
local = {
source = "hashicorp/local"
version = "2.5.0"
}
}
}

#private key
resource "tls_private_key" "generated" {
 algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
content = tls_private_key.generated.private_key_pem
filename = "zoro"
}

resource "aws_key_pair" "deployer" {
  key_name   = "zoro"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

#vpc,subnet,igw,route-gate code
locals{
env = "dev"
}

resource "aws_vpc" "one" {
cidr_block = "10.0.0.0/16"
tags = {
Name = "${local.env}-vpc"
}
}

resource "aws_subnet" "two" {
vpc_id = aws_vpc.one.id
cidr_block = "10.0.0.0/24"
availability_zone = "us-east-1b"
tags = {
Name = "${local.env}-subnet"
}
}

resource "aws_internet_gateway" "three" {
vpc_id = aws_vpc.one.id
tags = {
Name = "${local.env}-agw"
}
}

resource "aws_route_table" "four" {
vpc_id = aws_vpc.one.id
route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.three.id
}
tags = {
Name = "${local.env}-routetable"
}
}

resource "aws_route_table_association" "five" {
  subnet_id      = aws_subnet.two.id
  route_table_id = aws_route_table.four.id
}

resource "aws_instance" "six" {
ami = "ami-0ebfd941bbafe70c6"
instance_type = "t2.micro"
subnet_id     = aws_subnet.two.id
key_name      = "zoro"
tags = {
Name = "${local.env}-server"
}
}

terraform {
backend "s3" {
bucket = "lohithbucketfoeterraformmm"
key = "dev/terraform.tfstate"
region = "us-east-1"
}
}


