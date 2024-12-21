provider "aws" {
  region = "us-west-2"
}
 
resource "aws_vpc" "main"{
  cidr_block = "10.0.0.0/16"
  }

resource "aws_subnet" "public_subnet"{
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "private_subnet"
  }
}

resource "aws_internet_gateway" "igw"{
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "main"{
  domain = "vpc"
}

resource "aws_nat_gateway" "main"{
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public_subnet.id
}

resource "aws_route_table" "public"{
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "public_association"{
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_association"{
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "web_security_group"{
  name        = "web-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow HTTP and SSH traffic"

    ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
}
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp" 
  }
}

resource "aws_instance" "web_server" {
  ami                  = "ami-001f2488b35ca8aad"
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.private_subnet.id
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              service httpd start
              chkconfig httpd on
              EOF

tags = {
  Name ="web_server"
}
}

  
  
  
