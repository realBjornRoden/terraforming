# terraform templates
The idea behind infrastructure as code (IaC) is to create and execute code to define, deploy, update, and destroy the computing, storage and networking infrastructure.
* [terraform](https://www.terraform.io)

***
1. prep install terraform
   * macOS (Unix)
   ```
   $ brew install terraform
   Updating Homebrew...
   ==> Auto-updated Homebrew!
   Updated 4 taps (homebrew/core, homebrew/cask, caskroom/cask and dart-lang/dart).
   ==> New Formulae
   ==> Updated Formulae
   ==> Deleted Formulae
   ==> Downloading https://homebrew.bintray.com/bottles/terraform-0.12.9.mojave.bottle.tar.gz
   ==> Downloading from https://akamai.bintray.com/d3/d3587a128a18cf9882a07819bcadd38d0ac71699d83b4bae5afb65956be7ee45?__gda__=exp=1569490234~hmac=11e5ea85d17f38de66b97ac0232eff3ab690a
   ######################################################################## 100.0%
   ==> Pouring terraform-0.12.9.mojave.bottle.tar.gz
   /usr/local/Cellar/terraform/0.12.9: 6 files, 49.2MB
   ```
   * Other platforms [Download Terraform](https://www.terraform.io/downloads.html)
     <br>"Install Terraform by unzipping it and moving it to a directory included in your system's PATH"
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
     count = 1
   }
```
   1. terraform init
   ```
   /Users/bjro/code/cloudactions/terraforming: terraform init

   Initializing the backend...

   Initializing provider plugins...
   - Checking for available provider plugins...
   - Downloading plugin for provider "aws" (hashicorp/aws) 2.29.0...

   The following providers do not have any version constraints in configuration,
   so the latest version was installed.

   To prevent automatic upgrades to new major versions that may contain breaking
   changes, it is recommended to add version = "..." constraints to the
   corresponding provider blocks in configuration, with the constraint strings
   suggested below.

   * provider.aws: version = "~> 2.29"
   
   Terraform has been successfully initialized!
   
   You may now begin working with Terraform. Try running "terraform plan" to see
   any changes that are required for your infrastructure. All Terraform commands
   should now work.

   If you ever set or change modules or backend configuration for Terraform,
   rerun this command to reinitialize your working directory. If you forget, other
   commands will detect it and remind you to do so if necessary.
   ```

* GCP (Google Cloud Platform)
```
```

* MSAC (Microsoft Azure Cloud)
```
```
