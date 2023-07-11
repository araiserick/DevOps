## Задание

1. Какой системный вызов делает команда `cd`? 

    В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. 

    Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.
    
    Ответ:
    ```  
    `strace -o output.log /bin/bash -c 'cd /tmp' && egrep *tmp output.log`

    **chdir("/tmp")                           = 0**
    ```

1. Попробуйте использовать команду `file` на объекты разных типов в файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file`, на основании которой она делает свои догадки.

    Ответ: 

    ```
    vmvare@ns1:~$ strace -o file1.log /bin/bash -c 'file /dev/tty' && cat file1.log | grep magic
    /dev/tty: character special (5/0)
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
    newfstatat(AT_FDCWD, "/home/vmvare/.magic.mgc", 0x7fffbf0d3470, 0) = -1 ENOENT (No such file or directory)
    newfstatat(AT_FDCWD, "/home/vmvare/.magic", 0x7fffbf0d3470, 0) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
    newfstatat(AT_FDCWD, "/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}, 0) = 0
    openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
    openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
    ```
    Отсюда следует, что команда file обращается к своей базе данных /usr/share/misc/magic.mgc

1. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

    Ответ:

     сначала запускаем процесс и поток вывода этого процесса будет засорять файл логами, например
     ```
     vmvare@ns1:~$ping 8.8.8.8 -c 100000 > config.log 
     ```

     потом находим PID этого процесса
     
     ```
     vmvare@ns1:~$ps aux
     ```
     находим номер дискриптора данного процееса

     ```
     vmvare@ns1:~$ lsof -p 3924
     ```
     очищаем файл за счет отправки потока вывода команды echo

     ```
     vmvare@ns1:~$sudo echo '1'>/proc/3924/fd/1
     ```
    таким образомы мы получаем в данный момент очищенный файл от логов

1. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

    Ответ: 
    Зомби не занимают памяти (как процессы-сироты), но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом

1. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

    Ответ:
    ```
    PID    COMM               FD ERR PATH
    600    systemd-oomd        7   0 /proc/meminfo
    600    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.pressure
    600    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.current
    600    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.min
    600    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.low
    600    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.swap.current
    600    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.stat
    600    systemd-oomd        7   0 /proc/meminfo
    600    systemd-oomd        7   0 /proc/meminfo
    600    systemd-oomd        7   0 /proc/meminfo
    600    systemd-oomd        7   0 /proc/meminfo
    600    systemd-oomd        7   0 /proc/meminfo
    600    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.pressure
    600    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.current
    600    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.min
    600    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.low
    600    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.swap.current
    600    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.stat
    ```
1. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

    Ответ: 
    
    ```
    vmvare@ns1:~$man proc 
    ```
    альтернатива команды uname -a nano /proc/sys/kernel/[ostype, hostname, osrelease, version, domainname].

1. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?

    Ответ:
    ```
    С использованем ; обе команды отработают в любом случае.
    С использованием && вторая команда отработает только при успешном результате первой.
    С применением set -e скрипт/оболочка завершит работу при ненулевом коде возврата команды. В принципе, конструкция с && работать будет, но она необязательна, т.к. при другом условии оболочка просто завершится.
    ```

1. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
   
   Ответ: 
    set -e прекращает выполнение скрипта, если команда завершилась ошибкой.  
    set -u - прекращает выполнение скрипта, если встретилась несуществующая переменная.  
    set -x - выводит выполняемые команды в stdout перед выполненинем.  
    set -o pipefail - прекращает выполнение скрипта, даже если одна из частей пайпа завершилась ошибкой. В этом случае bash-скрипт завершит выполнение, если mycommand вернёт ошибку, не смотря на true в конце пайплайна: mycommand | true.


2. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
   
   Ответ:
    ```
    vmvare@ns1:~$ ps -ao stat,command
    STAT COMMAND
    Sl+  /usr/libexec/gnome-session-binary --session=ubuntu
    R+   ps -ao stat,command
    ```
    Наиболее частый статус:
    S interruptible sleep (waiting for an event to complete)
    
    `<` - высокий приоритет;
    `N` - низкий приорит;
    `L` - имеет страницы, заблокированные в памяти;
    `s` - является лидером сеанса;
    `l` - является многопоточным;
    `+` - находится в группе приоритетных процессов.  