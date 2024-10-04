provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

resource "aws_instance" "one" {
  ami           = "ami-0fff1b9a61dec8a5f"
  instance_type = "t2.micro"

  tags = {
    Name = "dev-instance"
  }
}
