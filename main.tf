provider "aws" {
	region = "us-east-2"
}
resource "aws_instance" "vm-solo-01" {
	ami = "ami-00c03f7f7f2ec15c3"
	instance_type = "t2.micro"
	tags = {
		Name = "vm-solo-01"
	}
}
