## Задание

1. Установите плагин Bitwarden для браузера. Зарегестрируйтесь и сохраните несколько паролей.

    Ответ: Представлен в скриншоте 
    
    ![](https://i.ibb.co/99mcq4n/bitwaden.png")

2. Установите Google Authenticator на мобильный телефон. Настройте вход в Bitwarden-акаунт через Google Authenticator OTP.

    Ответ: телефон не поддерживает сервисы Google
    
3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.

    Ответ: Представлен в скриншоте
    
    ![](https://i.ibb.co/VVsvRSK/image.jpg)

4. Проверьте на TLS-уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК и т. п.).

     Ответ: Представлен в скриншоте

    <a href="https://ibb.co/G95LhFL"><img src="https://i.ibb.co/Jqs4hC4/Test-sait.jpg" alt="Test-sait" border="0"></a>
    <a href="https://ibb.co/7jtTBNV"><img src="https://i.ibb.co/YPBKJT8/Test-sait-2.jpg" alt="Test-sait-2" border="0"></a>
    <a href="https://ibb.co/N1zgKFD"><img src="https://i.ibb.co/jVF9D80/Test-sait-3.jpg" alt="Test-sait-3" border="0"></a>

5. Установите на Ubuntu SSH-сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.

    Ответ: Представлен в скриншоте

    <a href="https://ibb.co/tLV8X07"><img src="https://i.ibb.co/J3D5QYf/ssh.jpg" alt="ssh" border="0"></a>

6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH-клиента так, чтобы вход на удалённый сервер осуществлялся по имени сервера.

    Ответ: Представлен в скриншоте

    <a href="https://ibb.co/D8wpt1G"><img src="https://i.ibb.co/nnQCbw3/ssh2.jpg" alt="ssh2" border="0"></a>
7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.

    Ответ:
    ```shell
    # tcpdump -nnei any -c 100 -w 100packets.pcap
    tcpdump: listening on any, link-type LINUX_SLL (Linux cooked v1), capture size 262144 bytes
    100 packets captured
    178 packets received by filter
    0 packets dropped by kernel
    ```

    <a href="https://ibb.co/x8ybhvj"><img src="https://i.ibb.co/prgT2Dz/Wireshark.png" alt="Wireshark" border="0"></a>
*В качестве решения приложите: скриншоты, выполняемые команды, комментарии (при необходимости).*

 ---
 
## Задание со звёздочкой* 

Это самостоятельное задание, его выполнение необязательно.

8. Просканируйте хост scanme.nmap.org. Какие сервисы запущены?

9. Установите и настройте фаервол UFW на веб-сервер из задания 3. Откройте доступ снаружи только к портам 22, 80, 443.

----