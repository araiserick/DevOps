# Домашнее задание к занятию «Файловые системы»

## Задание

1. Узнайте о [sparse-файлах](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных).

    Файлы с пустотами на диске. Разреженный файл эффективен, потому что он не хранит нули на диске, вместо этого он содержит достаточно метаданных, описывающих нули, которые будут сгенерированы. Разрежённые файлы используются для хранения, например, контейнеров.

2. Могут ли файлы, являющиеся жёсткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?


    Нет, не могут, т.к. это просто ссылки на один и тот же inode - в нём и хранятся права доступа и имя владельца.

3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```ruby
    path_to_disk_folder = './disks'
    host_params = {
        'disk_size' => 2560,
        'disks'=>[1, 2],
        'cpus'=>2,
        'memory'=>2048,
        'hostname'=>'sysadm-fs',
        'vm_name'=>'sysadm-fs'
    }
    Vagrant.configure("2") do |config|
        config.vm.box = "bento/ubuntu-20.04"
        config.vm.hostname=host_params['hostname']
        config.vm.provider :virtualbox do |v|
            v.name=host_params['vm_name']
            v.cpus=host_params['cpus']
            v.memory=host_params['memory']
            host_params['disks'].each do |disk|
                file_to_disk=path_to_disk_folder+'/disk'+disk.to_s+'.vdi'
                unless File.exist?(file_to_disk)
                    v.customize ['createmedium', '--filename', file_to_disk, '--size', host_params['disk_size']]
                end
                v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', disk.to_s, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
            end
        end
        config.vm.network "private_network", type: "dhcp"
    end
    ```

    Эта конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2,5 Гб.

    Справочная информация: vagrant на моем компьютере не работает, создал виртуальную машина на virtual box с двумя дополнительными дисками

4. Используя `fdisk`, разбейте первый диск на два раздела: 2 Гб и оставшееся пространство.

Ответ: 

![скрин](https://ie.wampi.ru/2023/03/27/fdisk.jpg)


5. Используя `sfdisk`, перенесите эту таблицу разделов на второй диск.

Ответ: 

![скрин](https://im.wampi.ru/2023/03/27/sfdisk.jpg)

6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

Ответ: 

![скрин](https://ic.wampi.ru/2023/03/27/RAID1.jpg)

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

Ответ: 

![скрин](https://im.wampi.ru/2023/03/27/RAID0.jpg)

8. Создайте два независимых PV на получившихся md-устройствах.

```bash
root@Ubuntu-virtualboxt:~# pvcreate /dev/md0
  Physical volume "/dev/md0" successfully created.
root@Ubuntu-virtualbox:~# pvcreate /dev/md1
  Physical volume "/dev/md1" successfully created.
```

9. Создайте общую volume-group на этих двух PV.

```bash
root@Ubuntu-virtualbox:~# vgcreate raid /dev/md0 /dev/md1
  Volume group "raid" successfully created
```

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

```bash
root@Ubuntu-virtualbox:~# lvcreate -L 100m -n raid-lv raid /dev/md1
  Logical volume "raid-lv" created.
```

11. Создайте `mkfs.ext4` ФС на получившемся LV.

Ответ: 

```bash
root@Ubuntu-virtualbox:~# mkfs.ext4 -L raid-ext4 -m 1 /dev/mapper/raid-raid--lv
```

![скрин](https://ie.wampi.ru/2023/03/27/11mkfs.jpg)

12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

Ответ: 

```bash
root@Ubuntu-virtualbox:~# mkdir /tmp/new
root@Ubuntu-virtualbox:~# mount /dev/mapper/raid-raid--lv /tmp/new/
root@Ubuntu-virtualbox:~# mount | grep raid-raid--lv
/dev/mapper/raid-raid--lv on /tmp/new type ext4 (rw,relatime,stripe=256)
```
![скрин](https://ie.wampi.ru/2023/03/27/12mount.jpg)

13. Поместите туда тестовый файл, например, `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.
    
Ответ: 

![скрин](https://im.wampi.ru/2023/03/27/13.lsblk.jpg)

14.  Прикрепите вывод `lsblk`.
    
Ответ: 

![скрин](https://im.wampi.ru/2023/03/27/14wget.jpg)

15.  Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
Ответ: 

![скрин](https://ie.wampi.ru/2023/03/27/15gzip.jpg)

16.  Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

Ответ: 

![скрин](https://ic.wampi.ru/2023/03/27/16pvmove.jpg)

17.  Сделайте `--fail` на устройство в вашем RAID1 md.

Ответ: 

![скрин](https://im.wampi.ru/2023/03/27/17mdadmfail.png)

18.  Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

Ответ: 

![скрин](https://ic.wampi.ru/2023/03/27/18dmesg.jpg)

19.  Протестируйте целостность файла — он должен быть доступен несмотря на «сбойный» диск:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
Ответ: 

![скрин](https://ie.wampi.ru/2023/03/27/19gzip.jpg)


20.  Погасите тестовый хост — `vagrant destroy`.

Ответ: 
```bash
root@Ubuntu-virtualbox:~# reboot
```
 
*В качестве решения пришлите ответы на вопросы и опишите, как они были получены.*

----
