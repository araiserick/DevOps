data "yandex_compute_image" "ubuntu_db" {
  family = var.ubuntu
}

resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_db_name
  platform_id = "standard-v1"
  resources {
    cores         = var.vm_db_resources.cores
    memory        = var.vm_db_resources.memory
    core_fraction = var.vm_db_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_db.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.vms_ssh_root_key.serial-port-enable
    ssh-keys           = var.vms_ssh_root_key.ssh-keys
  }
}
