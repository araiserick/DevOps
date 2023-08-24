Role Name
=========

Роль для установки lighthouse.

- Установка Git
- Скачивание lighthouse из репозитория
-Конфигурирование lighthouse


Requirements
------------

- Должен быть установлен git. Если его нет, роль произведёт его установку
- Требуется отдельная установка и настройка Nginx

Role Variables
--------------

Переменные для скачивания lighthouse из git и конфигурационных файлов lighthouse/nginx vars/main.yml

| Параметр | Описание | Локация |
| :-----:|:-----:|:------:|
|`lighthouse_url`| Адрес репозитория для скачивания Lighthouse | ./group_vars/lighthouse/vars.yaml |
| `lighthouse_dir` | Нахождение локальной папки, куда будет помещен lighthouse | ./group_vars/lighthouse/vars.yaml |


Dependencies
------------

Требуется роль clickhouse-role

Example Playbook
----------------

```yaml
- name: Install lighthouse
  hosts: lighthouse
  roles:
    - lighthouse
```

License
-------

MIT

Author Information
------------------

araiserick