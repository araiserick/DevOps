# Домашнее задание к занятию 4. «PostgreSQL»

## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL, используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД,
- подключения к БД,
- вывода списка таблиц,
- вывода описания содержимого таблиц,
- выхода из psql.


    Ответ:

    подключаемся к контейнеру и подключаемся к самой базе данных
    
    ```bash
    sudo docker exec -it  postgres_container bash
    psql -h localhost -p 5432 -U postgres -W
    password:
    ```
    1.\l[+] [PATTERN] list databases
    
    2.\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
     connect to new database (currently "postgres")
    
    3.\d[S+] list tables, views, and sequences или
    \dt[S+] [PATTERN] list tables
    
    4.\dS+ или \dtS+
   
     5.\q

## Задача 2

Используя `psql`, создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления, и полученный результат.

    Ответ:
    ```
    CREATE DATABASE test_database;

    \c test_database

    \i /tmp/backup/test_dump.sql

    test_database=# ANALYZE VERBOSE public.orders;
    INFO:  analyzing "public.orders"
    INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
    ANALYZE

    SELECT tablename, attname, avg_width FROM pg_stats WHERE tablename='orders' ORDER BY avg_width DESC LIMIT 1;
    tablename | attname | avg_width
    -----------+---------+-----------
    orders    | title   |        16
    (1 row)
    ```
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили
провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.

Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?

Ответ:

Провести разбиение:
```SQL
CREATE TABLE orders_1 (CHECK (price < 499)) INHERITS (orders);
CREATE TABLE orders_2 (CHECK (price >= 499)) INHERITS (orders);
```
При необходимости перенести данные из основной таблицы в созданные 

```SQL
INSERT INTO orders_1 SELECT * FROM orders WHERE price < 499;
DELETE FROM only orders WHERE price < 499;
INSERT INTO orders_2 SELECT * FROM orders WHERE price >= 499;
DELETE FROM only orders WHERE price >= 499;
```

## Задача 4

Используя утилиту `pg_dump`, создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

Ответ:

Добавление  UNIQUE.

```SQL
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) UNIQUE NOT NULL,
    price integer DEFAULT 0
);
```
