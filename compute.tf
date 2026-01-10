resource "aws_instance" "instance_gokul" {
  count         = 3
  ami           = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.subnet_pub.id

  vpc_security_group_ids = [
    aws_security_group.allow_http.id,
    aws_security_group.allow_https.id
  ]

  tags = {
    Name = "Helloworld-${count.index + 1}"
  }
}

