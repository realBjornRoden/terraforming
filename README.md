# Infrastructure as Code (IaC) with AWS, Azure, GCP
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
     ...

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
     ...

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
     ...
   
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
     ...
   
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
     ...

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

* [Create a complete Linux virtual machine infrastructure in Azure with Terraform](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-create-complete-vm)

* main.tf
```
provider "azurerm" {
}
resource "azurerm_resource_group" "rg" {
    name     = "rg-default-01"
    location = "eastus"
}

variable "vmname" {
    default     = "vm-solo-01"
}
variable "ssh_key" {
    default     = "~/.ssh/id_rsa.pub"
}
variable "admin_username" {
    default     = "az-user"
}

resource "azurerm_virtual_machine" "example" {
    name                          = "${var.vmname}"
    location                      = "${azurerm_resource_group.rg.location}"
    resource_group_name           = "${azurerm_resource_group.rg.name}"
    primary_network_interface_id  = "${azurerm_network_interface.external.id}"
    network_interface_ids         = ["${azurerm_network_interface.external.id}", "${azurerm_network_interface.internal.id}"]

    vm_size                       = "Standard_B1s"
    delete_os_disk_on_termination = true

    storage_image_reference {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "7.5"
        version   = "latest"
    }

    storage_os_disk {
        name              = "${var.vmname}-bootdisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    os_profile {
        computer_name  = "${var.vmname}"
        admin_username = "${var.admin_username}"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/${var.admin_username}/.ssh/authorized_keys"
            key_data = "${file("~/.ssh/id_rsa.pub")}"
        }
    }
}

resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-172-16-0-0--16"
    address_space       = ["172.16.0.0/16"]
    resource_group_name = "${azurerm_resource_group.rg.name}"
    location            = "${azurerm_resource_group.rg.location}"
}

resource "azurerm_subnet" "external" {
    name                 = "vsubnet-172-16-1-0--24-external"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    address_prefix       = "172.16.1.0/24"
}

resource "azurerm_subnet" "internal" {
    name                 = "vsubnet-172-16-2-0--24-internal"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    address_prefix       = "172.16.2.0/24"
}

resource "azurerm_public_ip" "public" {
    name                = "${var.vmname}-publicip"
    location            = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "nsg" {
    name                = "nsg-default-01"
    location            = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    security_rule {
        name                       = "allow_SSH"
        description                = "Allow SSH access"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_range     = "22"
    }
}

resource "azurerm_network_interface" "external" {
    name                      = "${var.vmname}-external"
    location                  = "${azurerm_resource_group.rg.location}"
    resource_group_name       = "${azurerm_resource_group.rg.name}"
    network_security_group_id = "${azurerm_network_security_group.nsg.id}"
    ip_configuration {
        name                          = "primary"
        subnet_id                     = "${azurerm_subnet.external.id}"
        public_ip_address_id          = "${azurerm_public_ip.public.id}"
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_network_interface" "internal" {
    name                = "${var.vmname}-internal"
    location            = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    ip_configuration {
        name                          = "primary"
        subnet_id                     = "${azurerm_subnet.internal.id}"
        private_ip_address_allocation = "Dynamic"
    }
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

     # azurerm_network_interface.external will be created
     ...
     # azurerm_network_interface.internal will be created
     ...
     # azurerm_network_security_group.nsg will be created
     ...
     # azurerm_public_ip.public will be created
     ...
     # azurerm_resource_group.rg will be created
     ...
     # azurerm_subnet.external will be created
     ...
     # azurerm_subnet.internal will be created
     ...
     # azurerm_virtual_machine.example will be created
     ...
     # azurerm_virtual_network.vnet will be created
     ...

   Plan: 9 to add, 0 to change, 0 to destroy.

   ------------------------------------------------------------------------

   Note: You didn't specify an "-out" parameter to save this plan, so Terraform
   can't guarantee that exactly these actions will be performed if
   "terraform apply" is subsequently run.


   ```

1. Run `terraform apply` to create the VM
   ```
   $ terraform apply -auto-approve
   azurerm_resource_group.example: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01]
   azurerm_subnet.internal: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/net-172-16-0-0--16/subnets/internal]
   azurerm_subnet.external: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/net-172-16-0-0--16/subnets/external]
   azurerm_network_interface.external: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkInterfaces/vm-solo-01-enic]
   azurerm_network_interface.internal: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkInterfaces/vm-solo-01-inic]
   azurerm_public_ip.example: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/publicIPAddresses/publicip-vm-solo-01]
   azurerm_network_security_group.example: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkSecurityGroups/nsg-default-01]
   azurerm_virtual_network.example: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/net-172-16-0-0--16]
   azurerm_virtual_machine.example: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Compute/virtualMachines/vm-solo-01]
   azurerm_resource_group.rg: Creating...
   azurerm_resource_group.rg: Creation complete after 4s [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01]
   azurerm_virtual_network.vnet: Creating...
   azurerm_public_ip.public: Creating...
   azurerm_network_security_group.nsg: Creating...
   azurerm_network_security_group.nsg: Creation complete after 6s [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkSecurityGroups/nsg-default-01]
   azurerm_public_ip.public: Creation complete after 7s [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/publicIPAddresses/vm-solo-01-publicip]
   azurerm_virtual_network.vnet: Still creating... [10s elapsed]
   azurerm_virtual_network.vnet: Creation complete after 16s [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/vnet-172-16-0-0--16]
   azurerm_subnet.internal: Creating...
   azurerm_subnet.external: Creating...
   azurerm_subnet.internal: Creation complete after 3s [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/vnet-172-16-0-0--16/subnets/vsubnet-172-16-2-0--24-internal]
   azurerm_network_interface.internal: Creating...
   azurerm_subnet.external: Creation complete after 6s [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/vnet-172-16-0-0--16/subnets/vsubnet-172-16-1-0--24-external]
   azurerm_network_interface.external: Creating...
   azurerm_network_interface.internal: Creation complete after 9s [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkInterfaces/vm-solo-01-internal]
   azurerm_network_interface.external: Creation complete after 10s [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkInterfaces/vm-solo-01-external]
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

   Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

   ```

1. Run `terraform destroy` to delete the VM
   ```
   $ terraform destroy -auto-approve
   azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01]
   azurerm_public_ip.public: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/publicIPAddresses/vm-solo-01-publicip]
   azurerm_virtual_network.vnet: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/vnet-172-16-0-0--16]
   azurerm_network_security_group.nsg: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkSecurityGroups/nsg-default-01]
   azurerm_subnet.internal: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/vnet-172-16-0-0--16/subnets/vsubnet-172-16-2-0--24-internal]
   azurerm_subnet.external: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/vnet-172-16-0-0--16/subnets/vsubnet-172-16-1-0--24-external]
   azurerm_network_interface.external: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkInterfaces/vm-solo-01-external]
   azurerm_network_interface.internal: Refreshing state... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkInterfaces/vm-solo-01-internal]
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
   azurerm_virtual_machine.example: Destruction complete after 1m37s
   azurerm_network_interface.external: Destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkInterfaces/vm-solo-01-external]
   azurerm_network_interface.internal: Destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkInterfaces/vm-solo-01-internal]
   azurerm_network_interface.external: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-.../networkInterfaces/vm-solo-01-external, 10s elapsed]
   azurerm_network_interface.internal: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-.../networkInterfaces/vm-solo-01-internal, 10s elapsed]
   azurerm_network_interface.external: Destruction complete after 13s
   azurerm_public_ip.public: Destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/publicIPAddresses/vm-solo-01-publicip]
   azurerm_subnet.external: Destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/vnet-172-16-0-0--16/subnets/vsubnet-172-16-1-0--24-external]
   azurerm_network_security_group.nsg: Destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/networkSecurityGroups/nsg-default-01]
   azurerm_public_ip.public: Destruction complete after 2s
   azurerm_network_security_group.nsg: Destruction complete after 3s
   azurerm_network_interface.internal: Destruction complete after 16s
   azurerm_subnet.internal: Destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/vnet-172-16-0-0--16/subnets/vsubnet-172-16-2-0--24-internal]
   azurerm_subnet.external: Destruction complete after 5s
   azurerm_subnet.internal: Destruction complete after 4s
   azurerm_virtual_network.vnet: Destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01/providers/Microsoft.Network/virtualNetworks/vnet-172-16-0-0--16]
   azurerm_virtual_network.vnet: Destruction complete after 2s
   azurerm_resource_group.rg: Destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01]
   azurerm_resource_group.rg: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01, 10s elapsed]
   azurerm_resource_group.rg: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01, 20s elapsed]
   azurerm_resource_group.rg: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01, 30s elapsed]
   azurerm_resource_group.rg: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01, 40s elapsed]
   azurerm_resource_group.rg: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01, 50s elapsed]
   azurerm_resource_group.rg: Still destroying... [id=/subscriptions/deadbeef-e904-4c8e-a3d8-5503f0e310e7/resourceGroups/rg-default-01, 1m0s elapsed]
   azurerm_resource_group.rg: Destruction complete after 1m10s

   Destroy complete! Resources: 9 destroyed.
   ```

1. Login to the VM
   ```
   $ ssh az-user@13.82.56.228
   The authenticity of host '13.82.56.228 (13.82.56.228)' can't be established.
   ECDSA key fingerprint is SHA256:jjybLmcmvFqB/L0k1OZTZTghf5933DtxUyguA8wloU0.
   Are you sure you want to continue connecting (yes/no)? yes
   Warning: Permanently added '13.82.56.228' (ECDSA) to the list of known hosts.
   [az-user@vm-solo-01 ~]$ ip addr|egrep "^[0-9]|inet "
   1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
       inet 127.0.0.1/8 scope host lo
   2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
       inet 172.16.1.4/24 brd 172.16.1.255 scope global eth0
   3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
       inet 172.16.2.4/24 brd 172.16.2.255 scope global noprefixroute eth1

   ```
