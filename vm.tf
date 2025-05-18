// Create a Google Compute Engine VM instance with Ubuntu 20.04 LTS image
resource "google_compute_instance" "vm_instance" {
  name         = "my-vm-instance"
  machine_type = "e2-medium"  // Instance machine type
  zone         = "us-east1-b" // Deployment zone

  // Boot disk initialized with Ubuntu 20.04 LTS image
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20210429"
    }
  }

  // Attach network interface connected to the VPC network and subnet
  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {} // Assign external IP
  }
}

