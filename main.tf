provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "gokul_vpc"{
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main_vpc"
  }
}

resource "aws_subnet" "subnet_a"{
  Vpc_id            = aws_vpc.gokul_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_a"
  }
}

resource "aws_subnet" "subnet_b" {
  Vpc_id            = aws_vpc.gokul_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_b"
  }
} 

resource "aws_internet_gateway" "igw"{
  vpc_id = aws_vpc.gokul_vpc.id
}

resource "aws_route_table" "route_table"{
  vpc_id = aws_vpc.gokul_vpc.id
}

resource "aws_route" "internet_route" {
  route_table_id          = aws_route_table.route_table.id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway_igw.id
}

resource "aws_security_group" "allow_http"{
  vpc.id = aws_vpc.gokul_vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "all"
}

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
}

  tags = {
    Name = "allow_http"
  }
}

resource "aws_security_group" "allow_https"{
  vpc.id = aws_vpc.gokul_vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "all"
}

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
}








  
  
  
