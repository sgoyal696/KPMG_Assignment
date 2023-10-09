# Define the AWS provider
provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create subnets
resource "aws_subnet" "web_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "app_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "db_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"
}

# Create security groups
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group for web tier"
  vpc_id      = aws_vpc.my_vpc.id

  # Define ingress and egress rules here
  # Example:
  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
}

# Create EC2 instances (web, app, db tiers)
resource "aws_instance" "web_instance" {
  ami           = "ami-12345678" # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.web_subnet.id
  security_groups = [aws_security_group.web_sg.id]

  # Define user data or provisioner to set up the web server
}

# Define similar resources for app and db tiers

# Output IPs or DNS names for your instances
output "web_instance_ip" {
  value = aws_instance.web_instance.private_ip
}

# Define outputs for app and db instances as needed
