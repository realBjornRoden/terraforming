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
