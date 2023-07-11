resource "yandex_compute_instance" "vm_for_each" {
  depends_on = [resource.yandex_compute_instance.platform]
  # определим имена и ресурсы
  platform_id = "standard-v1"
  for_each   = {
    for index, vm in var.vm_resources_list:
    vm.vm_name => vm
  }

#  for_each   =  toset(var.vm_resources_list)
  name        = each.value.vm_name

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction

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
    ssh-keys           = local.ssh-keys
  }
}
