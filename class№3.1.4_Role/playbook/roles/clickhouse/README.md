Role Name
=========

Роль для установки clickhouse.

Установка:
clickhouse-client
clickhouse-server
clickhouse-common-static
Создаётся БД
Создаётся таблица для логов
Создаётся пользователь для записи в БД
Конфигурируется clickhouse-server для работы внешних подключений

------------

Role Variables
--------------

Переменные для установки необходимых пакетов и конфигурационных файлов clickhouse vars/main.yml

| Параметр | Описание | Локация |
| :-----:|:-----:|:------:|
|`clickhouse_version`| параметр версии clickhouse | ./group_vars/clickhouse/vars.yml |
| `clickhouse_packages` | Параметры пакетов для установки clickhouse| ./group_vars/clickhouse/vars.yml |


Example Playbook

----------------
```yaml
- name: Install Clickhouse
  hosts: clickhouse
  roles:
    - clickhouse
```

License
-------

MIT

Author Information
------------------

araiserick