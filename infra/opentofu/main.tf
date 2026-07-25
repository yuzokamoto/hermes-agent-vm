provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "operator" {
  name       = "${var.server_name}-operator"
  public_key = var.ssh_public_key
}

resource "hcloud_firewall" "hermes" {
  name = "${var.server_name}-firewall"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = [var.admin_cidr]
  }

  rule {
    direction  = "out"
    protocol   = "tcp"
    port       = "any"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "out"
    protocol   = "udp"
    port       = "53"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_server" "hermes" {
  name        = var.server_name
  server_type = var.server_type
  location    = var.location
  image       = var.image
  ssh_keys    = [hcloud_ssh_key.operator.id]
  firewall_ids = [hcloud_firewall.hermes.id]

  user_data = templatefile("${path.module}/../cloud-init/hermes.yaml.tftpl", {
    ssh_public_key = var.ssh_public_key
  })

  labels = {
    app        = "hermes-agent"
    managed_by = "opentofu"
  }
}
