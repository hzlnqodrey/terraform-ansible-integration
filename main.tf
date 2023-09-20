resource "google_service_account" "nginx" {
  account_id = "nginx-demo"
}

resource "google_compute_firewall" "allow-http-ssh" {
  name    = "allow-http-ssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [google_service_account.nginx.email]
}

resource "google_compute_instance" "nginx" {
  name         = "nginx"
  machine_type = var.machine_type
  zone         = var.zone

  metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"
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
      user        = var.user
      private_key = file(var.privatekeypath)
      host        = google_compute_instance.nginx.network_interface[0].access_config[0].nat_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${google_compute_instance.nginx.network_interface[0].access_config[0].nat_ip}, --private-key ${var.privatekeypath} nginx.yaml"
  }
}

# add output for convenience in CLI
output "nginx_ip" {
  value = google_compute_instance.nginx.network_interface[0].access_config[0].nat_ip
}
