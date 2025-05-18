provider "google" {
  project = "terrafom-test-lab"  # Choose our project
  region  = "us-east1"  # choose our region
}

resource "google_compute_network" "vpc_network" {
  name = "my-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  region        = "us-east1"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/24"
}

# Правило фаервола для SSH
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.id  # set our network

  allow {
    protocol = "tcp"
    ports    = ["22"]  # aprove port 22
  }

  source_ranges = ["0.0.0.0/0"]  # income to connect from all ip adresses
}

