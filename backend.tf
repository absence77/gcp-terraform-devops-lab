terraform {
  backend "gcs" {
    bucket  = "terraform-state-ahmad"
    prefix  = "terraform/state"
  }
}

