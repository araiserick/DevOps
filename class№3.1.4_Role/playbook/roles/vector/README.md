Role Name
=========

Роль для установки vector.

- Установка vector
- Создание systemd unit Vector
- Конфигурирование vector на передачу данных в clickhouse



Role Variables

--------------
| Параметр | Описание | Локация |
| :-----:|:-----:|:------:|
|`vector_url`| url пакетов vector | ./group_vars/vector/vars.yml |
| `ansible_user_id` | Параметр создания user взятые из шаблона jinja2 | ./templates/vector.service.j2 |
| `ansible_user_gid` | Параметр создания group взятые из шаблона jinja2 | ./templates/vector.service.j2 |



Dependencies
------------

В inventory должен быть хост clickhouse-01

endpoint: ip-adress:8123

Требуется роль clickhouse-role

Example Playbook
----------------

```yaml
- name: Install vector
  hosts: vector
  roles:
    - vector
```

License
-------

MIT

Author Information
------------------

araiserick