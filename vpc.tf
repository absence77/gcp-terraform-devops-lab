// Configure the Google Cloud provider with project and region
provider "google" {
  project = var.project_id
  region  = var.region
}

// Create a custom VPC network without automatic subnet creation
resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

// Create a subnet in the specified region inside the VPC network
resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/24"
}

// Create a firewall rule to allow incoming SSH traffic (TCP port 22) from anywhere
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

