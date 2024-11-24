terraform {
  backend "gcs" {
    bucket = "terraform-state-bucket-009876"
    prefix = "terraform/state"
  }
}
