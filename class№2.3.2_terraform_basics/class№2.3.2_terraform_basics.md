# Задание основы Terraform. Yandex Cloud

### Задание 1

1. Изучите проект. В файле variables.tf объявлены переменные для yandex provider.
2. Переименуйте файл personal.auto.tfvars_example в personal.auto.tfvars. Заполните переменные (идентификаторы облака, токен доступа). Благодаря .gitignore этот файл не попадет в публичный репозиторий. **Вы можете выбрать иной способ безопасно передать секретные данные в terraform.**
3. Сгенерируйте или используйте свой текущий ssh ключ. Запишите его открытую часть в переменную **vms_ssh_root_key**.
4. Инициализируйте проект, выполните код. Исправьте намеренное допущенные ошибки. Ответьте в чем заключается их суть?
5. Ответьте, как в процессе обучения могут пригодиться параметры```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ? Ответ в документации Yandex cloud.

В качестве решения приложите:
- скриншот ЛК Yandex Cloud с созданной ВМ,

![](./Images/vm.jpg)

- скриншот успешного подключения к консоли ВМ через ssh,

![](./Images/ssh.jpg)

- ответы на вопросы.

Ответ:

Ошибка 1- core должно быть минимальное 2
Ошибка 2- в слове standart-v4 на standard-v1
preemptible = true это значит создать прерываюмую ВМ, которая работает не более 24 часов и может быть остановлена Compute Cloud в любой момент.
пригодится для экономии средств
core_fraction указывает базовую производительность ядра в процентах.
для экономии средств

### Задание 2

1. Изучите файлы проекта.
2. Замените все "хардкод" **значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan (изменений быть не должно). 

Ответ:

![](./Images/plan.jpg)
![](./Images/var.jpg)


### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ(в файле main.tf): **"netology-develop-platform-db"** ,  cores  = 2, memory = 2, core_fraction = 20. Объявите ее переменные с префиксом **vm_db_** в том же файле('vms_platform.tf').
3. Примените изменения.

![](./Images/vm-db.jpg)

### Задание 4

1. Объявите в файле outputs.tf output типа map, содержащий { instance_name = external_ip } для каждой из ВМ.
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```

![](./Images/output.jpg)

### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с несколькими переменными по примеру из лекции.
2. Замените переменные с именами ВМ из файла variables.tf на созданные вами local переменные.
3. Примените изменения.

Ответ:

```terraform
 locals {
  project = "netology-develop-platform"
  env_web = "web"
  env_db  = "db"
}
```

* Замените переменные с именами ВМ из файла variables.tf на созданные вами local переменные.

```terraform
resource "yandex_compute_instance" "platform" {
  name        = "${local.project}-${local.env_web}"
  platform_id = "standard-v1"
```

```terraform
resource "yandex_compute_instance" "platform_db" {
  name        = "${local.project}-${local.env_db}"
  platform_id = "standard-v1"
```

Так как код terraform уже написан, в доказатльство присылаю скрин о том, что названия VM как и планировалось не поменялись в Yandex Cloud


![](./Images/local.jpg)

### Задание 6

1. Вместо использования 3-х переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедените их в переменные типа **map** с именами "vm_web_resources" и "vm_db_resources". В качестве продвинутой практики попробуйте создать одну map переменную **vms_resources** и уже внутри нее конфиги обеих ВМ(вложенный map).
2. Так же поступите с блоком **metadata {serial-port-enable, ssh-keys}**, эта переменная должна быть общая для всех ваших ВМ.
3. Найдите и удалите все более не используемые переменные проекта.
4. Проверьте terraform plan (изменений быть не должно).

------

Ответ:

создаем переменные vm_web_resources и vm_db_resources

    ```
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
    ```
и используем их в main.tf, vms_platform.tf,

меняем переменную vms_ssh_root_key на type = map
и вставляем эти переменные в main.tf, vms_platform.tf, таким образом получим общую переменную для обеих виртуальных машин
variable "vms_ssh_root_key" {
  type        = map(any)
  default     = {
    serial-port-enable = 1
    ssh-keys           = "ssh-ed25519 **************************************"
  }
}


## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   
Их выполнение поможет глубже разобраться в материале. Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. 

### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list?

try(local.test_list[1])

2. Найдите длину списка test_list с помощью функции length(<имя переменной>).

length(local.test_list)

3. Напишите, какой командой можно отобразить значение ключа admin из map test_map ?

local.test_map["admin"]
local.test_map.admin

4. Напишите interpolation выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.


result = "${local.test_map.admin} is admin for production server based on ${local.servers.production.image} with ${local.servers.production.cpu} vcpu, ${local.servers.production.ram} ram and ${length(local.servers.production.disks)} virtual disks"

В качестве решения предоставьте необходимые команды и их вывод.

![](./Images/result.jpg)

---