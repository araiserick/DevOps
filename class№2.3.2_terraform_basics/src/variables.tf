###cloud_image
variable "vm_db_ubuntu" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "ubuntu_name"
}


###cloud_image
variable "ubuntu" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "ubuntu_name"
}
###compute_instance
variable "vm_web_resources" {
  type            = map(number)
  default         = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
}

variable "vm_db_resources" {
  type            = map(number)
  default         = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
}

###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = map(any)
  default     = {
    serial-port-enable = 1
    ssh-keys           = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEjXq8fpRokDIo5V5Lnkg92bVob/b4knQEwvMyAdZ0OS erick@erick-nitro"
  }
}
