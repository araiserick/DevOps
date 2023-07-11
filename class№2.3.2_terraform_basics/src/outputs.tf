output "ip_address_platform" {
  value = "${yandex_compute_instance.platform.network_interface.0.nat_ip_address}"
}

output "ip_address_platform_db" {
  value = "${yandex_compute_instance.platform_db.network_interface.0.nat_ip_address}"
}
