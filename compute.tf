resource "aws_instance" "instance_gokul" {
  ami           = "ami-0022503142e0db604"
  instance_type = "t2.micro"

  tags = {
    Name = "Helloworld"
  }
}
