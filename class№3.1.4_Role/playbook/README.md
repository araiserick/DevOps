```yaml
---
- name: Install lighthouse # установка lighthouse с помощью role lighthouse
  hosts: lighthouse
  roles:
    - lighthouse
  tags:
    - lighthouse

- name: Install Clickhouse # установка clickhouse с помощью role clickhouse
  hosts: clickhouse
  roles:
    - clickhouse
  tags:
    - click

- name: Install vector # установка vector с помощью role vector
  hosts: vector
  roles:
    - vector
  tags:
    - vector
```