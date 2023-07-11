# Домашнее задание к занятию 3. «Введение. Экосистема. Архитектура. Жизненный цикл Docker-контейнера»

## Задача 1

Сценарий выполнения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберите любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```

Опубликуйте созданный fork в своём репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

    Ответ: 
    https://hub.docker.com/repository/docker/araiserick/araiserick_nginx/general

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
«Подходит ли в этом сценарии использование Docker-контейнеров или лучше подойдёт виртуальная машина, физическая машина? Может быть, возможны разные варианты?»

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- высоконагруженное монолитное Java веб-приложение - физический сервер, либо сервер развернутый в системе полной виртуализации по типу VMware, так как система высоконагруженная и Docker-контейнер здесь не подойдет.
- Nodejs веб-приложение - Docker-контейнер, nodejs отлично подходит для контейнеров, хорошо работает в микро сервисной архитектуре
- мобильное приложение c версиями для Android и iOS- мобильное приложение, которое имеет своих пользователей, я думаю стоит развернуть как минимум на виртуальной машине в полной виртуализации.
- шина данных на базе Apache Kafka; - Apache Kafka один из сервисов трансляции данных из одного приложения в другое, который можно развернуть на Docker-контейнерах
- Elasticsearch-кластер для реализации логирования продуктивного веб-приложения — три ноды elasticsearch, два logstash и две ноды kibana; -для упомянутых продуктов есть контейнеры на docker hub. Из-за простоты управления и сборки контейнеров, мне кажется необходимо распихать продукты по контейнерам и на основании контейнеров собрать кластер стека ELK. В силу прозрачности реализации, в том числе возможности реализации подходов IaaC, контейнеризация в данном случае помогает закрыть вопросы по менеджменту и что очень важно получить регулярный предсказуемый результат.
- мониторинг-стек на базе Prometheus и Grafana; - так же можно рагруппировать сервисы по контейнерам и совместить в кластер для мониторинга.
- MongoDB как основное хранилище данных для Java-приложения;- либо виртуализация, либо контейнеризация, все зависит от реализации архитектуры приложения. 
- Gitlab-сервер для реализации CI/CD-процессов и приватный (закрытый) Docker Registry.- Облачное решение, виртуализация, физический сервер, нужна отказоустойчивость и большой объем хранилища, а так же масштабируемость

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тегом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера.

    Ответ:
    
    ```
    root@erick-nitro:/home/erick# docker run -d -v /date:/date centos sleep infinity
    8404642bf21d3459097f5f0043910ef603d67926057d5853ff798b6a36e2ae72
    root@erick-nitro:/home/erick# docker ps
    CONTAINER ID   IMAGE     COMMAND            CREATED         STATUS         PORTS     NAMES
    8404642bf21d   centos    "sleep infinity"   5 seconds ago   Up 5 seconds             fervent_austin
    root@erick-nitro:/home/erick# docker exec -it 8404642bf21d  bash
    [root@8404642bf21d /]# ls -lha
    total 60K
    drwxr-xr-x   1 root root 4.0K May  2 12:52 .
    drwxr-xr-x   1 root root 4.0K May  2 12:52 ..
    -rwxr-xr-x   1 root root    0 May  2 12:52 .dockerenv
    lrwxrwxrwx   1 root root    7 Nov  3  2020 bin -> usr/bin
    drwxr-xr-x   2 root root 4.0K May  2 09:54 date
    drwxr-xr-x   5 root root  340 May  2 12:52 dev
    drwxr-xr-x   1 root root 4.0K May  2 12:52 etc
    drwxr-xr-x   2 root root 4.0K Nov  3  2020 home
    lrwxrwxrwx   1 root root    7 Nov  3  2020 lib -> usr/lib
    lrwxrwxrwx   1 root root    9 Nov  3  2020 lib64 -> usr/lib64
    drwx------   2 root root 4.0K Sep 15  2021 lost+found
    drwxr-xr-x   2 root root 4.0K Nov  3  2020 media
    drwxr-xr-x   2 root root 4.0K Nov  3  2020 mnt
    drwxr-xr-x   2 root root 4.0K Nov  3  2020 opt
    dr-xr-xr-x 472 root root    0 May  2 12:52 proc
    dr-xr-x---   2 root root 4.0K Sep 15  2021 root
    drwxr-xr-x  11 root root 4.0K Sep 15  2021 run
    lrwxrwxrwx   1 root root    8 Nov  3  2020 sbin -> usr/sbin
    drwxr-xr-x   2 root root 4.0K Nov  3  2020 srv
    dr-xr-xr-x  13 root root    0 May  2 12:52 sys
    drwxrwxrwt   7 root root 4.0K Sep 15  2021 tmp
    drwxr-xr-x  12 root root 4.0K Sep 15  2021 usr
    drwxr-xr-x  20 root root 4.0K Sep 15  2021 var
    [root@8404642bf21d /]# 
    ```

- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера.

    Ответ:
    
    ```
    root@erick-nitro:/home/erick# docker run -d -v /date:/date debian sleep infinity
    Unable to find image 'debian:latest' locally
    latest: Pulling from library/debian
    b0248cf3e63c: Pull complete 
    Digest: sha256:0a78ed641b76252739e28ebbbe8cdbd80dc367fba4502565ca839e5803cfd86e
    Status: Downloaded newer image for debian:latest
    67592dd92f3ee81314a64ccd62da24df520d8501d57b6c86fe3dbb0a23154552
    root@erick-nitro:/home/erick# docker ps
    CONTAINER ID   IMAGE     COMMAND            CREATED         STATUS         PORTS     NAMES
    67592dd92f3e   debian    "sleep infinity"   2 minutes ago   Up 2 minutes             flamboyant_babbage
    8404642bf21d   centos    "sleep infinity"   6 minutes ago   Up 6 minutes             fervent_austin
    root@erick-nitro:/home/erick# docker exec -it 67592dd92f3e bash
    root@67592dd92f3e:/# ls -lha
    total 76K
    drwxr-xr-x   1 root root 4.0K May  2 12:56 .
    drwxr-xr-x   1 root root 4.0K May  2 12:56 ..
    -rwxr-xr-x   1 root root    0 May  2 12:56 .dockerenv
    drwxr-xr-x   2 root root 4.0K Apr 11 00:00 bin
    drwxr-xr-x   2 root root 4.0K Dec  9 19:15 boot
    drwxr-xr-x   2 root root 4.0K May  2 09:54 date
    drwxr-xr-x   5 root root  340 May  2 12:56 dev
    drwxr-xr-x   1 root root 4.0K May  2 12:56 etc
    drwxr-xr-x   2 root root 4.0K Dec  9 19:15 home
    drwxr-xr-x   8 root root 4.0K Apr 11 00:00 lib
    drwxr-xr-x   2 root root 4.0K Apr 11 00:00 lib64
    drwxr-xr-x   2 root root 4.0K Apr 11 00:00 media
    drwxr-xr-x   2 root root 4.0K Apr 11 00:00 mnt
    drwxr-xr-x   2 root root 4.0K Apr 11 00:00 opt
    dr-xr-xr-x 471 root root    0 May  2 12:56 proc
    drwx------   2 root root 4.0K Apr 11 00:00 root
    drwxr-xr-x   3 root root 4.0K Apr 11 00:00 run
    drwxr-xr-x   2 root root 4.0K Apr 11 00:00 sbin
    drwxr-xr-x   2 root root 4.0K Apr 11 00:00 srv
    dr-xr-xr-x  13 root root    0 May  2 12:56 sys
    drwxrwxrwt   2 root root 4.0K Apr 11 00:00 tmp
    drwxr-xr-x  11 root root 4.0K Apr 11 00:00 usr
    drwxr-xr-x  11 root root 4.0K Apr 11 00:00 var
    root@67592dd92f3e:/# 

    ```
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```.

    ```
    bash 
    [root@8404642bf21d /]# echo '' > /date/centos-file-1
    [root@8404642bf21d /]# ls /date
    centos-file-1
    ```

- Добавьте ещё один файл в папку ```/data``` на хостовой машине.

    ```
    bash
    root@erick-nitro:/home/erick# echo '' > /date/host-file-1
    root@erick-nitro:/home/erick# ls /date/
    centos-file-1  host-file-1
    ```

- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

    ```
    bash
    root@67592dd92f3e:/# ls /date
    centos-file-1  host-file-1
    ```
## Задача 4 (*)

Воспроизведите практическую часть лекции самостоятельно.

Соберите Docker-образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.