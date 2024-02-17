resource "yandex_vpc_network" "network" {
  folder_id = var.yc_folder_id
}

resource "yandex_vpc_subnet" "subnet" {
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.network.id}"
  v4_cidr_blocks = ["10.5.0.0/24"]
  folder_id      = var.yc_folder_id
}

locals {
  instances = {
    "instance-1" = "",
    "instance-2" = ""
  }
}

resource "yandex_compute_instance" "vm" {
  for_each = local.instances

  name        = each.key
  folder_id   = var.yc_folder_id

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vq2agp2bltpk94ule" 
      size     = 30
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet.id}"
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_key}"
  }
}

output "external_ip_vm_1" {
  value = yandex_compute_instance.vm["instance-1"].network_interface.0.nat_ip_address
}

output "external_ip_vm_2" {
  value = yandex_compute_instance.vm["instance-2"].network_interface.0.nat_ip_address
}
