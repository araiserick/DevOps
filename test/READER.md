### Тестовое задание для кандидата на замещение должности СПЕЦИАЛИСТ, ВЕДУЩИЙ СПЕЦИАЛИСТ, РУКОВОДИТЕЛЬ ГРУППЫ


Дано - сервер Ubuntu 18.0.4
Логин user пароль 123456789

# ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000

2: ens18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 2a:6c:83:da:35:3f brd ff:ff:ff:ff:ff:ff
    inet 192.168.2.2/22 brd 192.168.2.1 scope global ens18
       valid_lft forever preferred_lft forever
    inet6 fe80::286c:83ff:feda:353f/64 scope link
       valid_lft forever preferred_lft forever

3: ens19: <BROADCAST,MULTICAST> mtu 1500 qdisc noqueue state DOWN group default qlen 1000

    A. Собрать бондинг LACP из вышеуказанных интерфейсов и переместить ip на него.


1. Установите необходимые пакеты:

```bash
sudo apt-get update
sudo apt-get install ifenslave lacp-utils
```  

2. Откройте файл настроек для сетевых интерфейсов:

```bash
sudo nano /etc/network/interfaces
```

3. Добавьте конфигурацию для бондинга в файл:
   
```
   auto bond0
   iface bond0 inet manual
     bond-slaves ens18 ens19
     bond-mode 802.3ad
     bond-miimon 100
     bond-downdelay 200
     bond-updelay 200
     bond-lacp-rate 1
```   

4. Сохраните и закройте файл.

5. Отредактируйте файл модулей ядра:

```bash
sudo nano /etc/modules
```   

6. Добавьте строки для модулей ядра bonding и miimon:
   
```
   bonding
   miimon
```

7. Сохраните и закройте файл.

8. Перезагрузите систему:

```bash
sudo reboot
```

9. Открываем 

```bash
 sudo nano /etc/network/interfaces
```

10. Добавляем 

```
auto bond0
   iface bond0 inet static
     address 192.168.2.2
     netmask 255.255.252.0
     gateway 192.168.2.1
```

11. Сохраняем и закрываем

12. Перезагружаем сетевой интерфейс

```bash
sudo ifdown bond0 && sudo ifup bond0
```
13. Проверяем

```bash
ip addr show bond0
```

В. Необходимо написать скрипт или несколько скриптов, которые удаленно выполнили бы следующие действия на сервере
        
1. Смена  пароля на вышеуказанном пользователе 

- [playbook](./pass.yml) 

- [bash-скрипт](./pass.sh)

2. Создание пользователя с любым именем и паролем

- [playbook](./user.yml) 

- [bash-скрипт](./user.sh)

3. Смена стандартного порта ssh а любой

- [playbook](./ssh.yml) 

- [bash-скрипт](./ssh.sh)