module "vpc" {
  source       = "./modules/vpc"
  vpc_name     = "develop"
  vpc_name_subnet  = var.vpc_name

}

module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = "develop"
  network_id      =  module.vpc.vpc_id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [ module.vpc.subnet_id ]
  instance_name   = "web"
  instance_count  = 1
  image_family    = "ubuntu-2004-lts"
  public_ip       = true
  
  metadata = {
      user-data          = data.template_file.cloudinit.rendered
      serial-port-enable = 1
  }
 depends_on = [ module.vpc ]
}

data "template_file" "cloudinit" {
 template = file("./cloud-init.yml")

  vars = {
    ssh_public_key     = var.public_key
  }
}