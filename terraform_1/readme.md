игнорирование скрытой директории .terraform

**/.terraform/*

игнорировать файлы с данным расширением

*.tfstate
*.tfstate.*

игнорировать лог файлы

crash.log
crash.*.log

игнорировать файлы с данным расширением

*.tfvars
*.tfvars.json

 Игнорировать файлы переопределения, так как они обычно используются для локального переопределения ресурсов и т.д.

override.tf
override.tf.json
*_override.tf
*_override.tf.json

Include override files you do wish to add to version control using negated pattern
!example_override.tf

Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
example: *tfplan*

Игнорировать файлы конфигурации CLI


.terraformrc
terraform.rc