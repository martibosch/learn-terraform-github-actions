terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  required_version = ">= 0.14"

  backend "remote" {
    organization = "exaf-epfl"

    workspaces {
      name = "gh-actions-demo"
    }
  }
}


provider "digitalocean" {
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-20-04-x64"
  name   = "web"
  region = "fra1"
  size   = "s-1vcpu-1gb"

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install nginx
      "sudo apt update",
      "sudo apt install -y nginx"
    ]
  }
}

output "web-address" {
  value = digitalocean_droplet.web.ipv4_address
}
