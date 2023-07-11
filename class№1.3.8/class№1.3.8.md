## Задание

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP.

 ```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```

Ответ: 

нет возможности

2. Создайте dummy-интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
 
Ответ:
```
bash
ubuntu@ubuntu-virtual-machine:~$ sudo ip link add dummy0 type dummy
ubuntu@ubuntu-virtual-machine:~$ sudo ip addr add 192.168.50.1/24 dev dummy0
ubuntu@ubuntu-virtual-machine:~$ sudo ip link set dummy0 up
ubuntu@ubuntu-virtual-machine:~$ sudo ip route add 192.168.100.0/24 via 192.168.50.1
ubuntu@ubuntu-virtual-machine:~$ sudo ip route add 192.168.200.0/24 via 192.168.50.1
ubuntu@ubuntu-virtual-machine:~$ ip route 
default via 192.168.177.2 dev ens33 proto dhcp metric 100 
169.254.0.0/16 dev ens33 scope link metric 1000 
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown 
192.168.50.0/24 dev dummy0 proto kernel scope link src 192.168.50.1 
192.168.100.0/24 via 192.168.50.1 dev dummy0 
192.168.177.0/24 dev ens33 proto kernel scope link src 192.168.177.128 metric 100 
192.168.200.0/24 via 192.168.50.1 dev dummy0 
```

3. Проверьте открытые TCP-порты в Ubuntu. Какие протоколы и приложения используют эти порты? Приведите несколько примеров.

Ответ: 
```
bash 
ubuntu@ubuntu-virtual-machine:~$ sudo netstat -ntlp 
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      648/systemd-resolve 
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN      939/cupsd           
tcp6       0      0 ::1:631                 :::*                    LISTEN      939/cupsd          
```

53 порт TCP использует systemd
631 порт TCP использует цифровую печать

1. Проверьте используемые UDP-сокеты в Ubuntu. Какие протоколы и приложения используют эти порты?

Ответ:

```
bash
ubuntu@ubuntu-virtual-machine:~$ ss -lupn
State   Recv-Q   Send-Q     Local Address:Port      Peer Address:Port  Process  
UNCONN  0        0                0.0.0.0:5353           0.0.0.0:*              
UNCONN  0        0                0.0.0.0:56760          0.0.0.0:*              
UNCONN  0        0          127.0.0.53%lo:53             0.0.0.0:*              
UNCONN  0        0                0.0.0.0:631            0.0.0.0:*              
UNCONN  0        0                   [::]:5353              [::]:*              
UNCONN  0        0                   [::]:37500             [::]:*  
```
53 порт UDP используется для DNS
56760 порт для передачи данных
631 порт TCP использует цифровую печать


2. Используя diagrams.net, создайте L3-диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 

*В качестве решения пришлите ответы на вопросы, опишите, как они были получены, и приложите скриншоты при необходимости.*

Ответ: 

![](https://i.ibb.co/G0zPSkX/image.jpg)
 ---

Офис маленького телеканала, с коммутацией рабочих мест (сеть офиса) и подключение контроллера беспроводной сети и точки доступа(отдельная гостевая сеть)