resource "local_file" "hosts_cfg" {
 content = templatefile("${path.module}/hosts.tftpl",
    {
 webservers = yandex_compute_instance.platform
 databases = yandex_compute_instance.vm_for_each
 storage = [yandex_compute_instance.storage]
    }
  )
 filename = "${abspath(path.module)}/hosts.cfg"
}
 
resource "null_resource" "ansible_provisioning" {  
  depends_on = [resource.yandex_compute_instance.storage]
  provisioner "local-exec" {  
    command = "ansible-playbook -i hosts.cfg ../demonstration2/test.yml"   
    
    working_dir = path.module  
    interpreter = ["bash", "-c"]  
  }  
} 
