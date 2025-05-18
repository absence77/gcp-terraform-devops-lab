// Declare input variable for GCP project ID
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

// Declare input variable for GCP region
variable "region" {
  description = "The GCP region to deploy resources"
  type        = string
}

// Declare input variable for VPC network name
variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "my-vpc-network" // default value if not provided
}

