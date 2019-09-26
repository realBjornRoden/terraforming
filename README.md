# terraform templates
* [terraform](https://www.terraform.io)

***
1. Basics
```
$ terraform init
$ terraform apply
```

* AWS (Amazon Web Services)
```
provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "vm-solo-01" {
  ami = "ami-00c03f7f7f2ec15c3"
  instance_type = "t2.micro"
}

```

* GCP (Google Cloud Platform)
```
```

* MSAC (Microsoft Azure Cloud)
```
```
