resource "google_compute_instance" "vm_instance" {
  name         = "my-vm-instance"
  machine_type = "e2-medium" # choose type of instance any for you 
  zone         = "us-east1-b"

  # Используем актуальный образ Ubuntu 20.04 LTS
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20210429" # use image
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }
}

