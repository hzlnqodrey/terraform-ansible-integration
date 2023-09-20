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

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [google_service_account.nginx.email]
}

resource "google_compute_instance" "nginx" {
  name         = "nginx"
  machine_type = "e2-micro"
  zone         = "asia-southeast2-a"

  boot_disk {
    initialize_params {
      image = local.image
    }
  }

  network_interface {
    network = local.network
    access_config {

    }
  }

  # attach service account to instance
  service_account {
    email  = google_service_account.nginx.email
    scopes = ["cloud-platform"]
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = google_compute_instance.nginx.network_interface[0].access_config[0].nat_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${google_compute_instance.nginx.network_interface[0].access_config[0].nat_ip}, --private-key ${local.private_key_path} nginx.yaml'"
  }
}
