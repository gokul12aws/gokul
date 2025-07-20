resource "aws_instance" "instance_gokul" {
  ami           = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"

  tags = {
    Name = "Helloworld"
  }
}
