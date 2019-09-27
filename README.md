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
* [AWS]()
* Ensure login key configuration is made with  the `aws configure` for the user with sufficient Policy permissions
<br><i>NB. Below is performed with the group set to the policy <b>AmazonEC2FullAccess</b></i>

* main.tf
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
1. Run `terraform init`
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

1. Run `terraform apply` (ordinarily after `terraform plan` to validate the configuration)
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
1. Run `aws ec2 describe-instances`
   ```
   $ aws ec2 describe-instances --region us-east-2 --query 'Reservations[*].Instances[*].[Tags[?Key==\`Name\`]|[0].Value,InstanceId,PrivateIpAddress,PublicIpAddress,Placement.AvailabilityZone,State.Name]' --output text"
   None	i-0b11a0cdff48a7308	172.31.44.122	18.220.211.66	us-east-2c	running
   ```

1. Set the AWS VM name tag by adding the "tags" stanza to the terraform `main.tf` file within the "resource" stanza
   ```
   tags = {
    Name = "vm-solo-01"
   }
   ```

1. Run `terraform plan`
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

1. Run `terraform apply` to create the VM
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

1. Run `aws ec2 describe-instances`
   ```
   $ aws ec2 describe-instances --region us-east-2 --query 'Reservations[*].Instances[*].[Tags[?Key==\`Name\`]|[0].Value,InstanceId,PrivateIpAddress,PublicIpAddress,Placement.AvailabilityZone,State.Name]' --output text"
   vm-solo-01	i-0b11a0cdff48a7308	172.31.44.122	18.220.211.66	us-east-2c	running
   ```

1. Run `terraform destroy` to delete (terminate) the VM
   ```
   $ terraform destroy
   aws_instance.vm-solo-01: Refreshing state... [id=i-0b11a0cdff48a7308]
   
   An execution plan has been generated and is shown below.
   Resource actions are indicated with the following symbols:
     - destroy
   
   Terraform will perform the following actions:
   
     # aws_instance.vm-solo-01 will be destroyed
     - resource "aws_instance" "vm-solo-01" {
         - ami                          = "ami-00c03f7f7f2ec15c3" -> null
         - arn                          = "arn:aws:ec2:us-east-2:598691507898:instance/i-0b11a0cdff48a7308" -> null
         - associate_public_ip_address  = true -> null
         - availability_zone            = "us-east-2c" -> null
         - cpu_core_count               = 1 -> null
         - cpu_threads_per_core         = 1 -> null
         - disable_api_termination      = false -> null
         - ebs_optimized                = false -> null
         - get_password_data            = false -> null
         - id                           = "i-0b11a0cdff48a7308" -> null
         - instance_state               = "running" -> null
         - instance_type                = "t2.micro" -> null
         - ipv6_address_count           = 0 -> null
         - ipv6_addresses               = [] -> null
         - monitoring                   = false -> null
         - primary_network_interface_id = "eni-0f2c842e9e3d30902" -> null
         - private_dns                  = "ip-172-31-44-122.us-east-2.compute.internal" -> null
         - private_ip                   = "172.31.44.122" -> null
         - public_dns                   = "ec2-18-220-211-66.us-east-2.compute.amazonaws.com" -> null
         - public_ip                    = "18.220.211.66" -> null
         - security_groups              = [
             - "default",
           ] -> null
         - source_dest_check            = true -> null
         - subnet_id                    = "subnet-d38e339f" -> null
         - tags                         = {
             - "Name" = "vm-solo-01"
           } -> null
         - tenancy                      = "default" -> null
         - volume_tags                  = {} -> null
         - vpc_security_group_ids       = [
             - "sg-ebf9c788",
           ] -> null
   
         - credit_specification {
             - cpu_credits = "standard" -> null
           }
   
         - root_block_device {
             - delete_on_termination = true -> null
             - encrypted             = false -> null
             - iops                  = 100 -> null
             - volume_id             = "vol-0c481ce1e1eb73b56" -> null
             - volume_size           = 8 -> null
             - volume_type           = "gp2" -> null
           }
       }
   
   Plan: 0 to add, 0 to change, 1 to destroy.
   
   Do you really want to destroy all resources?
     Terraform will destroy all your managed infrastructure, as shown above.
     There is no undo. Only 'yes' will be accepted to confirm.
   
     Enter a value: yes
   
   aws_instance.vm-solo-01: Destroying... [id=i-0b11a0cdff48a7308]
   aws_instance.vm-solo-01: Still destroying... [id=i-0b11a0cdff48a7308, 10s elapsed]
   aws_instance.vm-solo-01: Still destroying... [id=i-0b11a0cdff48a7308, 20s elapsed]
   aws_instance.vm-solo-01: Destruction complete after 25s
   
   Destroy complete! Resources: 1 destroyed.
   ```
   
1. Run `aws ec2 describe-instances`
   ```
   $ aws ec2 describe-instances --region us-east-2 --query 'Reservations[*].Instances[*].[Tags[?Key==\`Name\`]|[0].Value,InstanceId,PrivateIpAddress,PublicIpAddress,Placement.AvailabilityZone,State.Name]' --output text"
   vm-solo-01	i-0b11a0cdff48a7308	None	None	us-east-2c	terminated
   ```

## GCP (Google Cloud Platform)
* [Getting started with Terraform on Google Cloud Platform](https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform)
* Create and download service account keys JSON file from Console [create](https://console.cloud.google.com/apis/credentials), [manage](https://console.cloud.google.com/iam-admin/serviceaccounts), or CLI:
   ```
   $ gcloud auth login

   $ gcloud projects list
   PROJECT_ID          NAME                PROJECT_NUMBER
   project-01-default  project-01-default  523124300007

   $ gcloud iam service-accounts create terraform-svc --display-name "Terraform Service Account"
   Created service account [terraform-svc].

   $ gcloud iam service-accounts list --filter "terraform-svc"
   NAME                       EMAIL                                                           DISABLED
   Terraform Service Account  terraform-svc@project-01-default.iam.gserviceaccount.com        False

   $ gcloud iam service-accounts keys create ./terraform-svc.json --iam-account terraform-svc@project-01-default.iam.gserviceaccount.com
   created key [deadbeeff1fa3b6c4f6ca6647f7b615ffa554391] of type [json] as [./terraform-svc.json] for [terraform-svc@project-01-default.iam.gserviceaccount.com]

   $ gcloud iam roles create terraform_svc --project project-01-default --file terraform-roles.yaml 
   Created role [terraform_svc].
   description: Terraform Service Role for GCP Compute
   etag: deadbeef
   includedPermissions:
   - compute.disks.create
   - compute.instances.create
   - compute.instances.delete
   - compute.instances.setMetadata
   - compute.subnetworks.use
   - compute.subnetworks.useExternalIp
   name: projects/project-01-default/roles/terraform_svc
   stage: ALPHA
   title: Terraform

   $ gcloud projects add-iam-policy-binding project-01-default --role projects/project-01-default/roles/terraform_svc --member serviceAccount:terraform-svc@project-01-default.iam.gserviceaccount.com
   Updated IAM policy for project [project-01-default].
   bindings:
   - members:
     - serviceAccount:terraform-svc@project-01-default.iam.gserviceaccount.com
     role: projects/project-01-default/roles/terraform_svc
   - members:
     - serviceAccount:service-523124360557@compute-system.iam.gserviceaccount.com
     role: roles/compute.serviceAgent
   - members:
  - serviceAccount:523124360557-compute@developer.gserviceaccount.com
     - serviceAccount:523124360557@cloudservices.gserviceaccount.com
     role: roles/editor
   - members:
     - serviceAccount:terraform@project-01-default.iam.gserviceaccount.com
     - user:realbjornroden@gmail.com
     role: roles/owner
   etag: deadbeef
   version: 1
   ```
   
* main.tf
   ```
   provider "google" {
	credentials = "${file("terraform-svc.json")}"
	project = "project-01-default"
	region = "us-east1"
   }

   resource "google_compute_instance" "vm-solo-01" {
	provider = "google"
	zone = "us-east1-b"
	name = "vm-solo-01"
	machine_type = "f1-micro"
	boot_disk {
		initialize_params {
			image = "debian-cloud/debian-9"
		}
	}
	network_interface {
		network = "default"
		access_config {
			// for external IP
		}
	}
   }
   ```

1. Run `terraform init`
   ```
   $ terraform init

   Initializing the backend...

   Initializing provider plugins...
   - Checking for available provider plugins...
   - Downloading plugin for provider "google" (hashicorp/google) 2.16.0...

   The following providers do not have any version constraints in configuration,
   so the latest version was installed.

   To prevent automatic upgrades to new major versions that may contain breaking
   changes, it is recommended to add version = "..." constraints to the
   corresponding provider blocks in configuration, with the constraint strings
   suggested below.

   * provider.google: version = "~> 2.16"

   Terraform has been successfully initialized!

   You may now begin working with Terraform. Try running "terraform plan" to see
   any changes that are required for your infrastructure. All Terraform commands
   should now work.

   If you ever set or change modules or backend configuration for Terraform,
   rerun this command to reinitialize your working directory. If you forget, other
   commands will detect it and remind you to do so if necessary.
   ```

1. Run `terraform plan`
   ```
   $ terraform plan
   Refreshing Terraform state in-memory prior to plan...
   The refreshed state will be used to calculate this plan, but will not be
   persisted to local or remote state storage.


   ------------------------------------------------------------------------

   An execution plan has been generated and is shown below.
   Resource actions are indicated with the following symbols:
     + create

   Terraform will perform the following actions:

     # google_compute_instance.vm-solo-01 will be created
     + resource "google_compute_instance" "vm-solo-01" {
         + can_ip_forward       = false
         + cpu_platform         = (known after apply)
         + deletion_protection  = false
         + guest_accelerator    = (known after apply)
         + id                   = (known after apply)
         + instance_id          = (known after apply)
         + label_fingerprint    = (known after apply)
         + machine_type         = "f1-micro"
         + metadata_fingerprint = (known after apply)
         + name                 = "vm-solo-01"
         + project              = (known after apply)
         + self_link            = (known after apply)
         + tags_fingerprint     = (known after apply)
         + zone                 = (known after apply)

         + boot_disk {
             + auto_delete                = true
             + device_name                = (known after apply)
             + disk_encryption_key_sha256 = (known after apply)
             + kms_key_self_link          = (known after apply)
             + mode                       = "READ_WRITE"
             + source                     = (known after apply)
   
             + initialize_params {
                 + image  = "debian-cloud/debian-9"
                 + labels = (known after apply)
                 + size   = (known after apply)
                 + type   = (known after apply)
               }
           }
   
         + network_interface {
             + address            = (known after apply)
             + name               = (known after apply)
             + network            = "default"
             + network_ip         = (known after apply)
             + subnetwork         = (known after apply)
             + subnetwork_project = (known after apply)
           }

         + scheduling {
             + automatic_restart   = (known after apply)
             + on_host_maintenance = (known after apply)
             + preemptible         = (known after apply)
   
             + node_affinities {
                 + key      = (known after apply)
                 + operator = (known after apply)
                 + values   = (known after apply)
               }
           }
       }

   Plan: 1 to add, 0 to change, 0 to destroy.

   ------------------------------------------------------------------------
   
   Note: You didn't specify an "-out" parameter to save this plan, so Terraform
   can't guarantee that exactly these actions will be performed if
   "terraform apply" is subsequently run.
   
   ```

1. Run `terraform apply` to create the VM
   ```
   $ terraform apply -auto-approve
   google_compute_instance.vm-solo-01: Creating...
   google_compute_instance.vm-solo-01: Still creating... [10s elapsed]
   google_compute_instance.vm-solo-01: Creation complete after 14s [id=vm-solo-01]

   Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
   ```

1. Run `gcloud compute instances list`
   ```
   $ gcloud compute instances list
   NAME        ZONE        MACHINE_TYPE  PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP     STATUS
   vm-solo-01  us-east1-b  f1-micro                   10.142.0.2   35.243.203.155  RUNNING
   ```

1.  Run `gcloud iam roles update` to add the permission `compute.instances.get` 
      ```
      $ gcloud iam roles update terraform_svc --project project-01-default --file terraform-roles.yaml 
      The specified role does not contain an "etag" field identifying a 
      specific version to replace. Updating a role without an "etag" can 
      overwrite concurrent role changes.

      Replace existing role (Y/n)?  Y

      description: Terraform Service Role for GCP Compute
      etag: deadbeef
      includedPermissions:
      - compute.disks.create
      - compute.instances.create
      - compute.instances.delete
      - compute.instances.get
      - compute.instances.setMetadata
      - compute.subnetworks.use
      - compute.subnetworks.useExternalIp
      name: projects/project-01-default/roles/terraform_svc
      stage: ALPHA
      title: Terraform
      ```

1. Run `terraform destroy` to delete the VM
   ```
   $ terraform destroy -auto-approve
   google_compute_instance.vm-solo-01: Refreshing state... [id=vm-solo-01]
   google_compute_instance.vm-solo-01: Destroying... [id=vm-solo-01]
   google_compute_instance.vm-solo-01: Still destroying... [id=vm-solo-01, 10s elapsed]
   google_compute_instance.vm-solo-01: Still destroying... [id=vm-solo-01, 20s elapsed]
   google_compute_instance.vm-solo-01: Still destroying... [id=vm-solo-01, 30s elapsed]
   google_compute_instance.vm-solo-01: Still destroying... [id=vm-solo-01, 40s elapsed]
   google_compute_instance.vm-solo-01: Still destroying... [id=vm-solo-01, 50s elapsed]
   google_compute_instance.vm-solo-01: Still destroying... [id=vm-solo-01, 1m0s elapsed]
   google_compute_instance.vm-solo-01: Still destroying... [id=vm-solo-01, 1m10s elapsed]
   google_compute_instance.vm-solo-01: Still destroying... [id=vm-solo-01, 1m20s elapsed]
   google_compute_instance.vm-solo-01: Destruction complete after 1m22s

   Destroy complete! Resources: 1 destroyed.
   ```

## MSAC (Microsoft Azure Cloud)
* [Install and configure Terraform to provision Azure resources](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

* [Create a complete Linux virtual machine infrastructure in Azure with Terraform](ttps://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-create-complete-vm)

* main.tf
```
provider "azurerm" {
}
```
* Login
```
$ az login
Note, we have launched a browser for you to login. For old experience with device code, use "az login --use-device-code"
You have logged in. Now let us find all the subscriptions to which you have access...

[
  {
    "cloudName": "AzureCloud",
    "id": "deadbeef-e904-4c8e-a3d8-5503f0e310e7",
    "isDefault": true,
    "name": "Free Trial",
    "state": "Enabled",
    "tenantId": "deadbeef-3411-4054-a56e-18809a214004",
    "user": {
      "name": "user@FQDN",
      "type": "user"
    }
  }
]
```

1. Run `terraform init`
   ```
   $ terraform init

   Initializing the backend...

   Initializing provider plugins...
   - Checking for available provider plugins...
   - Downloading plugin for provider "azurerm" (hashicorp/azurerm) 1.34.0...

   The following providers do not have any version constraints in configuration,
   so the latest version was installed.

   To prevent automatic upgrades to new major versions that may contain breaking
   changes, it is recommended to add version = "..." constraints to the
   corresponding provider blocks in configuration, with the constraint strings
   suggested below.

   * provider.azurerm: version = "~> 1.34"

   Terraform has been successfully initialized!

   You may now begin working with Terraform. Try running "terraform plan" to see
   any changes that are required for your infrastructure. All Terraform commands
   should now work.

   If you ever set or change modules or backend configuration for Terraform,
   rerun this command to reinitialize your working directory. If you forget, other
   commands will detect it and remind you to do so if necessary.
   ```

1. Run `terraform plan`
   ```
   $ terraform plan
   Refreshing Terraform state in-memory prior to plan...
   The refreshed state will be used to calculate this plan, but will not be
   persisted to local or remote state storage.


   ------------------------------------------------------------------------

   An execution plan has been generated and is shown below.
   Resource actions are indicated with the following symbols:
     + create

   Terraform will perform the following actions:

     # azurerm_network_interface.example will be created
     + resource "azurerm_network_interface" "example" {
         + applied_dns_servers           = (known after apply)
         + dns_servers                   = (known after apply)
         + enable_accelerated_networking = false
         + enable_ip_forwarding          = false
         + id                            = (known after apply)
         + internal_dns_name_label       = (known after apply)
         + internal_fqdn                 = (known after apply)
         + location                      = "eastus"
         + mac_address                   = (known after apply)
         + name                          = "vm-solo-01-nic"
         + private_ip_address            = (known after apply)
         + private_ip_addresses          = (known after apply)
         + resource_group_name           = "rg-default-01"
         + tags                          = (known after apply)
         + virtual_machine_id            = (known after apply)

         + ip_configuration {
             + application_gateway_backend_address_pools_ids = (known after apply)
             + application_security_group_ids                = (known after apply)
             + load_balancer_backend_address_pools_ids       = (known after apply)
             + load_balancer_inbound_nat_rules_ids           = (known after apply)
             + name                                          = "testconfiguration1"
             + primary                                       = (known after apply)
             + private_ip_address_allocation                 = "dynamic"
             + private_ip_address_version                    = "IPv4"
             + subnet_id                                     = (known after apply)
           }
       }

     # azurerm_resource_group.example will be created
     + resource "azurerm_resource_group" "example" {
         + id       = (known after apply)
         + location = "eastus"
         + name     = "rg-default-01"
         + tags     = (known after apply)
       }
   
     # azurerm_subnet.example will be created
     + resource "azurerm_subnet" "example" {
         + address_prefix       = "10.0.2.0/24"
         + id                   = (known after apply)
         + ip_configurations    = (known after apply)
         + name                 = "subnet-10-0-2-0--24"
         + resource_group_name  = "rg-default-01"
         + virtual_network_name = "net-default-01"
       }

     # azurerm_virtual_machine.example will be created
     + resource "azurerm_virtual_machine" "example" {
         + availability_set_id              = (known after apply)
         + delete_data_disks_on_termination = false
         + delete_os_disk_on_termination    = true
         + id                               = (known after apply)
         + license_type                     = (known after apply)
         + location                         = "eastus"
         + name                             = "vm-solo-01"
         + network_interface_ids            = (known after apply)
         + resource_group_name              = "rg-default-01"
         + tags                             = (known after apply)
         + vm_size                          = "Standard_B1s"
   
         + identity {
             + identity_ids = (known after apply)
             + principal_id = (known after apply)
             + type         = (known after apply)
           }
   
         + os_profile {
             + admin_password = (sensitive value)
             + admin_username = "az-user"
             + computer_name  = "vm-solo-01"
             + custom_data    = (known after apply)
           }

         + os_profile_linux_config {
             + disable_password_authentication = false
           }
   
         + storage_data_disk {
             + caching                   = (known after apply)
             + create_option             = (known after apply)
             + disk_size_gb              = (known after apply)
             + lun                       = (known after apply)
             + managed_disk_id           = (known after apply)
             + managed_disk_type         = (known after apply)
             + name                      = (known after apply)
             + vhd_uri                   = (known after apply)
             + write_accelerator_enabled = (known after apply)
           }

         + storage_image_reference {
             + offer     = "UbuntuServer"
             + publisher = "Canonical"
             + sku       = "16.04-LTS"
             + version   = "latest"
           }

         + storage_os_disk {
             + caching                   = "ReadWrite"
             + create_option             = "FromImage"
             + disk_size_gb              = (known after apply)
             + managed_disk_id           = (known after apply)
             + managed_disk_type         = "Standard_LRS"
             + name                      = "osdisk"
             + os_type                   = (known after apply)
             + write_accelerator_enabled = false
           }
       }

     # azurerm_virtual_network.example will be created
     + resource "azurerm_virtual_network" "example" {
         + address_space       = [
             + "10.0.0.0/16",
           ]
         + id                  = (known after apply)
         + location            = "eastus"
         + name                = "net-default-01"
         + resource_group_name = "rg-default-01"
         + tags                = (known after apply)
   
         + subnet {
             + address_prefix = (known after apply)
             + id             = (known after apply)
             + name           = (known after apply)
             + security_group = (known after apply)
           }
       }

   Plan: 5 to add, 0 to change, 0 to destroy.

   ------------------------------------------------------------------------

   Note: You didn't specify an "-out" parameter to save this plan, so Terraform
   can't guarantee that exactly these actions will be performed if
   "terraform apply" is subsequently run.
   ```

1. Run `terraform apply` to create the VM
   ```
   $ terraform apply -auto-approve
   azurerm_resource_group.example: Creating...
   azurerm_resource_group.example: Creation complete after 5s [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01]
   azurerm_virtual_network.example: Creating...
   azurerm_virtual_network.example: Still creating... [10s elapsed]
   azurerm_virtual_network.example: Creation complete after 17s [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/net-default-01]
   azurerm_subnet.example: Creating...
   azurerm_subnet.example: Creation complete after 4s [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/net-default-01/subnets/subnet-10-0-2-0--24]
   azurerm_network_interface.example: Creating...
   azurerm_network_interface.example: Creation complete after 5s [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkInterfaces/vm-solo-01-nic]
   azurerm_virtual_machine.example: Creating...
   azurerm_virtual_machine.example: Still creating... [10s elapsed]
   azurerm_virtual_machine.example: Still creating... [20s elapsed]
   azurerm_virtual_machine.example: Still creating... [30s elapsed]
   azurerm_virtual_machine.example: Still creating... [40s elapsed]
   azurerm_virtual_machine.example: Still creating... [50s elapsed]
   azurerm_virtual_machine.example: Still creating... [1m0s elapsed]
   azurerm_virtual_machine.example: Still creating... [1m10s elapsed]
   azurerm_virtual_machine.example: Still creating... [1m20s elapsed]
   azurerm_virtual_machine.example: Still creating... [1m30s elapsed]
   azurerm_virtual_machine.example: Creation complete after 1m38s [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Compute/virtualMachines/vm-solo-01]

   Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
   ```

1. Run `terraform destroy` to delete the VM
   ```
   $ terraform destroy -auto-approve

   azurerm_resource_group.example: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01]
   azurerm_virtual_network.example: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/net-default-01]
   azurerm_subnet.example: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/net-default-01/subnets/subnet-10-0-2-0--24]
   azurerm_network_interface.example: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkInterfaces/vm-solo-01-nic]
   azurerm_virtual_machine.example: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Compute/virtualMachines/vm-solo-01]
   azurerm_virtual_machine.example: Destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Compute/virtualMachines/vm-solo-01]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 10s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 20s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 30s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 40s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 50s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 1m0s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 1m10s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 1m20s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 1m30s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 1m40s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 1m50s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 2m0s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 2m10s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 2m20s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 2m30s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 2m40s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 2m50s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 3m0s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 3m10s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 3m20s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 3m30s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 3m40s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 3m50s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 4m0s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 4m10s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 4m20s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 4m30s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 4m40s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 4m50s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 5m0s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 5m10s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 5m20s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 5m30s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 5m40s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 5m50s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 6m0s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 6m10s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 6m20s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 6m30s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 6m40s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 6m50s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 7m0s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 7m10s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 7m20s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 7m30s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 7m40s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 7m50s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 8m0s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 8m10s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 8m20s elapsed]
   azurerm_virtual_machine.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...oft.Compute/virtualMachines/vm-solo-01, 8m30s elapsed]
   azurerm_virtual_machine.example: Destruction complete after 8m39s
   azurerm_network_interface.example: Destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkInterfaces/vm-solo-01-nic]
   azurerm_network_interface.example: Destruction complete after 3s
   azurerm_subnet.example: Destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/net-default-01/subnets/subnet-10-0-2-0--24]
   azurerm_subnet.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-...default-01/subnets/subnet-10-0-2-0--24, 10s elapsed]
   azurerm_subnet.example: Destruction complete after 12s
   azurerm_virtual_network.example: Destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/net-default-01]
   azurerm_virtual_network.example: Destruction complete after 2s
   azurerm_resource_group.example: Destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01]
   azurerm_resource_group.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01, 10s elapsed]
   azurerm_resource_group.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01, 20s elapsed]
   azurerm_resource_group.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01, 30s elapsed]
   azurerm_resource_group.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01, 40s elapsed]
   azurerm_resource_group.example: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01, 50s elapsed]
   azurerm_resource_group.example: Destruction complete after 54s
   
   Destroy complete! Resources: 5 destroyed.
   ```
