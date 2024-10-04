provider "aws" {
region = "us-east-1"
}

resource "aws_instance" "one" {
  ami           = "ami-00f251754ac5da7f0"
  instance_type = "t2.micro"
  key_name      = "bleach"

  tags = {
    Name = "dev-instance"
  }
}
