# Infrastructure as Code (IaC)
The purpose of infrastructure as code (IaC) is to create and execute code to define, create, modify, and delete computing, storage and networking infrastructure, with consistency.
* [terraform](https://www.terraform.io)

***
## terraform templates
1. Install terraform
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
     <br><i>"Install Terraform by unzipping it and moving it to a directory included in your system's PATH"</i>
1. Basics
   ```
   $ terraform init
   $ terraform plan
   $ terraform apply
   ```

## AWS (Amazon Web Services)
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

1. terraform apply
   ```
   $ terraform apply

   An execution plan has been generated and is shown below.
   Resource actions are indicated with the following symbols:
     + create

   Terraform will perform the following actions:

     # aws_instance.vm-solo-01 will be created
     + resource "aws_instance" "vm-solo-01" {
         + ami                          = "ami-00c03f7f7f2ec15c3"
         + arn                          = (known after apply)
         + associate_public_ip_address  = (known after apply)
         + availability_zone            = (known after apply)
         + cpu_core_count               = (known after apply)
         + cpu_threads_per_core         = (known after apply)
         + get_password_data            = false
         + host_id                      = (known after apply)
         + id                           = (known after apply)
         + instance_state               = (known after apply)
         + instance_type                = "t2.micro"
         + ipv6_address_count           = (known after apply)
         + ipv6_addresses               = (known after apply)
         + key_name                     = (known after apply)
         + network_interface_id         = (known after apply)
         + password_data                = (known after apply)
         + placement_group              = (known after apply)
         + primary_network_interface_id = (known after apply)
         + private_dns                  = (known after apply)
         + private_ip                   = (known after apply)
         + public_dns                   = (known after apply)
         + public_ip                    = (known after apply)
         + security_groups              = (known after apply)
         + source_dest_check            = true
         + subnet_id                    = (known after apply)
         + tenancy                      = (known after apply)
         + volume_tags                  = (known after apply)
         + vpc_security_group_ids       = (known after apply)

         + ebs_block_device {
             + delete_on_termination = (known after apply)
             + device_name           = (known after apply)
             + encrypted             = (known after apply)
             + iops                  = (known after apply)
             + kms_key_id            = (known after apply)
             + snapshot_id           = (known after apply)
             + volume_id             = (known after apply)
             + volume_size           = (known after apply)
             + volume_type           = (known after apply)
           }
   
         + ephemeral_block_device {
             + device_name  = (known after apply)
             + no_device    = (known after apply)
             + virtual_name = (known after apply)
           }
   
         + network_interface {
             + delete_on_termination = (known after apply)
             + device_index          = (known after apply)
             + network_interface_id  = (known after apply)
           }
   
         + root_block_device {
             + delete_on_termination = (known after apply)
             + encrypted             = (known after apply)
             + iops                  = (known after apply)
             + kms_key_id            = (known after apply)
             + volume_id             = (known after apply)
             + volume_size           = (known after apply)
             + volume_type           = (known after apply)
           }
       }

   Plan: 1 to add, 0 to change, 0 to destroy.

   Do you want to perform these actions?
     Terraform will perform the actions described above.
     Only 'yes' will be accepted to approve.
   
     Enter a value: yes
   
   aws_instance.vm-solo-01: Creating...
   aws_instance.vm-solo-01: Still creating... [10s elapsed]
   aws_instance.vm-solo-01: Still creating... [20s elapsed]
   aws_instance.vm-solo-01: Still creating... [30s elapsed]
   aws_instance.vm-solo-01: Still creating... [40s elapsed]
   aws_instance.vm-solo-01: Creation complete after 50s [id=i-0b11a0cdff48a7308]
   
   Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
   ```
1. aws ec2 describe-instances
   ```
   $ aws ec2 describe-instances --region us-east-2 --query 'Reservations[*].Instances[*].[Tags[?Key==\`Name\`]|[0].Value,InstanceId,PrivateIpAddress,PublicIpAddress,Placement.AvailabilityZone,State.Name]' --output text"
   None	i-0b11a0cdff48a7308	172.31.44.122	18.220.211.66	us-east-2c	running
   ```

1. add to terraform main.tf file within the "resource" stanza
   ```
   tags = {
    Name = "vm-solo-01"
   }
   ```

1. terraform plan
   ```
   $ terraform plan
   Refreshing Terraform state in-memory prior to plan...
   The refreshed state will be used to calculate this plan, but will not be
   persisted to local or remote state storage.

   aws_instance.vm-solo-01: Refreshing state... [id=i-0b11a0cdff48a7308]

   ------------------------------------------------------------------------

   An execution plan has been generated and is shown below.
   Resource actions are indicated with the following symbols:
     ~ update in-place

   Terraform will perform the following actions:

     # aws_instance.vm-solo-01 will be updated in-place
     ~ resource "aws_instance" "vm-solo-01" {
           ami                          = "ami-00c03f7f7f2ec15c3"
           arn                          = "arn:aws:ec2:us-east-2:598691507898:instance/i-0b11a0cdff48a7308"
           associate_public_ip_address  = true
           availability_zone            = "us-east-2c"
           cpu_core_count               = 1
           cpu_threads_per_core         = 1
           disable_api_termination      = false
           ebs_optimized                = false
           get_password_data            = false
           id                           = "i-0b11a0cdff48a7308"
           instance_state               = "running"
           instance_type                = "t2.micro"
           ipv6_address_count           = 0
           ipv6_addresses               = []
           monitoring                   = false
           primary_network_interface_id = "eni-0f2c842e9e3d30902"
           private_dns                  = "ip-172-31-44-122.us-east-2.compute.internal"
           private_ip                   = "172.31.44.122"
           public_dns                   = "ec2-18-220-211-66.us-east-2.compute.amazonaws.com"
           public_ip                    = "18.220.211.66"
           security_groups              = [
               "default",
           ]
           source_dest_check            = true
           subnet_id                    = "subnet-d38e339f"
         ~ tags                         = {
             + "Name" = "vm-solo-01"
           }
           tenancy                      = "default"
           volume_tags                  = {}
           vpc_security_group_ids       = [
               "sg-ebf9c788",
           ]
         
           credit_specification {
               cpu_credits = "standard"
           }
      
           root_block_device {
               delete_on_termination = true
               encrypted             = false
               iops                  = 100
               volume_id             = "vol-0c481ce1e1eb73b56"
               volume_size           = 8
               volume_type           = "gp2"
           }
       }

   Plan: 0 to add, 1 to change, 0 to destroy.

   ------------------------------------------------------------------------

   Note: You didn't specify an "-out" parameter to save this plan, so Terraform
   can't guarantee that exactly these actions will be performed if
   "terraform apply" is subsequently run.
   ```

1. terraform apply
   ```
   $ terraform apply
   aws_instance.vm-solo-01: Refreshing state... [id=i-0b11a0cdff48a7308]

   An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
     ~ update in-place

   Terraform will perform the following actions:

     # aws_instance.vm-solo-01 will be updated in-place
     ~ resource "aws_instance" "vm-solo-01" {
           ami                          = "ami-00c03f7f7f2ec15c3"
           arn                          = "arn:aws:ec2:us-east-2:598691507898:instance/i-0b11a0cdff48a7308"
           associate_public_ip_address  = true
           availability_zone            = "us-east-2c"
           cpu_core_count               = 1
           cpu_threads_per_core         = 1
           disable_api_termination      = false
           ebs_optimized                = false
           get_password_data            = false
           id                           = "i-0b11a0cdff48a7308"
           instance_state               = "running"
           instance_type                = "t2.micro"
           ipv6_address_count           = 0
           ipv6_addresses               = []
           monitoring                   = false
           primary_network_interface_id = "eni-0f2c842e9e3d30902"
           private_dns                  = "ip-172-31-44-122.us-east-2.compute.internal"
           private_ip                   = "172.31.44.122"
           public_dns                   = "ec2-18-220-211-66.us-east-2.compute.amazonaws.com"
           public_ip                    = "18.220.211.66"
           security_groups              = [
               "default",
           ]
           source_dest_check            = true
           subnet_id                    = "subnet-d38e339f"
         ~ tags                         = {
             + "Name" = "vm-solo-01"
           }
           tenancy                      = "default"
           volume_tags                  = {}
           vpc_security_group_ids       = [
               "sg-ebf9c788",
           ]

           credit_specification {
               cpu_credits = "standard"
           }
   
           root_block_device {
               delete_on_termination = true
               encrypted             = false
               iops                  = 100
               volume_id             = "vol-0c481ce1e1eb73b56"
               volume_size           = 8
               volume_type           = "gp2"
           }
       }
   
   Plan: 0 to add, 1 to change, 0 to destroy.
   
   Do you want to perform these actions?
     Terraform will perform the actions described above.
     Only 'yes' will be accepted to approve.
   
     Enter a value: yes
   
   aws_instance.vm-solo-01: Modifying... [id=i-0b11a0cdff48a7308]
   aws_instance.vm-solo-01: Still modifying... [id=i-0b11a0cdff48a7308, 10s elapsed]
   aws_instance.vm-solo-01: Modifications complete after 13s [id=i-0b11a0cdff48a7308]
   
   Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
   ```

1. aws ec2 describe-instances
   ```
   $ aws ec2 describe-instances --region us-east-2 --query 'Reservations[*].Instances[*].[Tags[?Key==\`Name\`]|[0].Value,InstanceId,PrivateIpAddress,PublicIpAddress,Placement.AvailabilityZone,State.Name]' --output text"
   None	i-0b11a0cdff48a7308	172.31.44.122	18.220.211.66	us-east-2c	running
   ```

## GCP (Google Cloud Platform)
```
```

## MSAC (Microsoft Azure Cloud)
```
```
