resource "aws_instance" "instance_gokul" {
  count         = 3
  ami           = "ami-053b0d53c279acc90"   # Ubuntu 22.04 (us-east-1)
  instance_type = "t2.micro"

  subnet_id = aws_subnet.subnet_pub.id   # ✅ MUST be public subnet

  vpc_security_group_ids = [
    aws_security_group.web_sg.id          # ✅ SG with SSH/HTTP/HTTPS
  ]

  key_name = "gokul-key"                  # ✅ Key pair you created

  tags = {
    Name = "Ubuntu-Server-${count.index + 1}"
  }
}
