# Описательная часть playbook

## Первый Play

```yaml
- name: Nginx  #Установка Nginx на хост lighthouse для того, чтобы можно было пользоваться web-интерфейсом lighthouse
  hosts: lighthouse
  handlers:
    - name: Start-nginx # handlers на запуск nginx после его установки
      become: true
      ansible.builtin.service:
        name: nginx
        state: started
    - name: Restart Nginx # handlers на перезагрузку nginx после установки конфигураций веб-сервера
      become: true
      ansible.builtin.service:
        name: nginx
        state: restarted
  tasks:
    - name: Install epel-release # установка epel-release - дополнительного хранилища пакетов для операционных систем, основанных на Red Hat Enterprise Linux (RHEL) или CentOS
      become: true
      ansible.builtin.yum:
        name: epel-release
        state: present
    - name: Install nginx # установка веб-сервера nginx
      become: true
      ansible.builtin.yum:
        name: nginx
        state: present
      notify: Start-nginx
    - name: Nginx | template config # установка конфигураций nginx по средством шаблона jinja2 (./template/nginx.j2)
      become: true
      ansible.builtin.template:
        src: templates/nginx.j2
        dest: /etc/nginx/nginx.conf
        mode: "0644"
      notify: Restart Nginx
```

## Второй Play

```yaml
- name: Install lighthouse # установка Lighthouse - инструмент производительности веб-страниц и аудита
  hosts: lighthouse
  become: true
  handlers:
    - name: Restart-nginx # handlers на перезагрузку nginx после установки lighthouse
      become: true
      ansible.builtin.service:
        name: nginx
        state: restarted
  pre_tasks:
    - name: Install dependencies # установка git, перед установкой lighthouse, будем качать lighthouse из репозитория git 
      become: true
      ansible.builtin.yum:
        name: git
        state: present
  tasks:
    - name: Lighthouse | Copy from git # устанавливаем lighthouse
      ansible.builtin.git:
        repo: "{{ lighthouse_url }}" # переменная указана в ./group_vars/lighthouse/vars.yml
        version: master
        dest: "{{ lighthouse_dir }}" # переменная указана в ./group_vars/lighthouse/vars.yml
    - name: Lighthouse | create config # устанавливаем конфигурации lighthouse по средством шаблона jinja2 ./templates/lighthouse.conf.j2
      become: true
      ansible.builtin.template:
        src: lighthouse.conf.j2
        dest: /etc/nginx/conf.d/default.conf
        mode: "0644"
      notify: Restart-nginx
```

## Третий Play

```yaml
- name: Install Clickhouse #установка clickhouse - СУБД для аналитических работ
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service # hendlers для перезапуска clickhouse после установки clickhouse
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - name: Install clickhouse # установка clickhouse
      block:
        - name: Get clickhouse distrib # скачивание дистрибутива из различных источников, в случае если из первого источника не получается, то можно будет это сделать из второго
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
            mode: "0755"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
            mode: "0755"
          check_mode: false
    - name: Install clickhouse packages # установка пакетов clickhouse использование переменных ./group_vars/clickhouse/vars.yml
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service
    - name: Flush handlers
      ansible.builtin.meta: flush_handlers

    - name: Create database # добавление базы данных
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc != 82
      changed_when: create_db.rc == 0
```

## Четвертый Play

```yaml
- name: Vector | Install rpm # установка vector- инструмент для сбора, обработки и анализа данных в реальном времени.
  hosts: vector
  tasks:
    - name: Install Vector # установка vector
      become: true
      ansible.builtin.yum:
        name: "{{ vector_url }}"
        state: present
    - name: Vector | Template Config # создание unit и установка прав unit vector c помощью шаблона jinja2 ./templates/vector.j2
      ansible.builtin.template:
        src: vector.j2
        dest: vector.yml
        mode: "0644"
        owner: "{{ ansible_user_id }}"
        group: "{{ ansible_user_gid }}"
        validate: vector validate --no-environment --config-yaml %s
    - name: Vector | Create systemd unit # установка конфигураций vector 
      become: true
      ansible.builtin.template:
        src: vector.service.j2
        dest: /etc/systemd/vector.service
        mode: "0755"
        owner: "{{ ansible_user_id }}"
        group: "{{ ansible_user_gid }}"
    - name: Vector | Start Service # запуск сервиса vector
      become: true
      ansible.builtin.systemd:
        name: vector
        state: started
        daemon_reload: true
```