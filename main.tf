provider "aws" {
  region = "us-east-1"
}

# --------------------
# VPC
# --------------------
resource "aws_vpc" "gokul_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main_vpc"
  }
}

# --------------------
# Public Subnet
# --------------------
resource "aws_subnet" "subnet_pub" {
  vpc_id                  = aws_vpc.gokul_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}

# --------------------
# Private Subnet
# --------------------
resource "aws_subnet" "subnet_pri" {
  vpc_id            = aws_vpc.gokul_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private_subnet"
  }
}

# --------------------
# Internet Gateway
# --------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.gokul_vpc.id
}

# --------------------
# Public Route Table
# --------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.gokul_vpc.id

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# --------------------
# Route Table Association (Public Subnet)
# --------------------
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.subnet_pub.id
  route_table_id = aws_route_table.public_rt.id
}

# --------------------
# Security Group (SSH + HTTP + HTTPS)
# --------------------
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.gokul_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_sg"
  }
}
