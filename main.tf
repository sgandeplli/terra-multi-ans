provider "google" {
  project = "primal-gear-436812-t0"
  region  = "us-central1"  # Change this to your desired region
  zone    = "us-central1-a" # Change this to your desired zone
}

resource "google_compute_instance" "vm_instance" {
  count        = 2
  name         = "instance-${count.index + 1}"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-stream-9" # You can change this to a different OS image
    }
  }

  network_interface {
    network = "default"
    access_config {
      # This block allows the VM to have an external IP address
    }
  }

  tags = ["http-server"]

  metadata_startup_script = <<-EOF
    #! /bin/bash
    sudo apt update -y
    sudo apt install -y nginx
    sudo systemctl start nginx
  EOF
}

output "instance_ips" {
  value = google_compute_instance.vm_instance[*].network_interface[0].access_config[0].nat_ip
}
