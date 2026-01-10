resource "aws_instance" "instance_gokul" {
  count                  = 3
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Helloworld-${count.index + 1}"
  }
}
