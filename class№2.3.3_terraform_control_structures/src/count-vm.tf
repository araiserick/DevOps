data "yandex_compute_image" "ubuntu" {
  family = var.ubuntu
}

resource "yandex_compute_instance" "platform" {
  name        = "web-${count.index+1}"
  platform_id = "standard-v1"
  count = 2
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
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
    serial-port-enable = local.serial-port
    ssh-keys           = "ubuntu:${local.ssh-keys}"
  }

}

