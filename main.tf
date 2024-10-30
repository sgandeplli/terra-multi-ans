provider "google" {
  project = "primal-gear-436812-t0"
  region  = "us-central1"
}

variable "instance_count" {
  type    = number
  default = 3
}

resource "google_compute_instance" "centos_vm" {
  count        = var.instance_count
  name         = "ansible-${count.index + 1}"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-stream-9"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "centos:${file("/root/.ssh/id_rsa.pub")}"
  }

  tags = ["http-server"]
}

# Output the instance IPs for the dynamic inventory
output "vm_ips" {
  value = [for instance in google_compute_instance.centos_vm : instance.network_interface[0].access_config[0].nat_ip]
}





