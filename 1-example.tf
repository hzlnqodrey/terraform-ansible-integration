locals {
  project_id       = "belajar-terraform-398813"
  network          = "default"
  image            = "ubuntu-pro-2004-focal-v20230918"
  ssh_user         = "ansible"
  private_key_path = "~/.ssh/ansbile_ed25519.pub"
}

provider "google" {
  project = local.project_id
  region  = "asia-southeast2"
}

resource "google_service_account" "nginx" {
  account_id = "nginx-demo"
}

resource "google_compute_firewall" "name" {
  name    = "web-access"
  network = local.network

  # open port :80 for reverse proxy nginx
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_service_accounts = [google_service_account.nginx.email]
}
