## Задание

1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа: опишите ход своих мыслей, если считаете, что она могла бы быть другого типа.
   
   Ответ: Это встроенная команда оболочки, какой и должна быть. Назначение у неё одно и вполне конкретное, что вполне в духе linux: одна команда - одно действие.
   
   
```
vagrant@vagrant:~$ type cd
cd is a shell builtin
```

2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`?   

	<details>
	<summary>Подсказка</summary>

	`man grep` поможет в ответе на этот вопрос. 

	</details>
	
	Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.

	Ответ: 
	```
	vmvare@ns1:~ wc -l (some_string some_file)
	```


3. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
   
   Ответ: Ubuntu 22.04.1 LTS

	Ответ:
	```
	vmvare@ns1:~$ pstree -a -p  | head -n 1
	systemd,1
	```

4. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?

	Ответ:
	```
	vmvare@ns1:~$ ls 2> /dev/pts/0
	systemd,1
	```
	
5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.
   
   Ответ:

   ```
   vmvare@ns1:~$ sed pojgepj << text1.txt >> text2.txt
   ```
   
6. Получится ли, находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

	Ответ: 
	```
	 vmvare@ns1:~$ echo messege "pty->tty" 1>/dev/tty
	 ```
	 таким образом мы направляем поток вывода на консоль виртуальной мышины, сообщение отобразилось в терминале виртуальной машины.

7. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?

	Ответ: 
	команда `bash 5>&1` создаст дискриптор 5 
	`echo netology > /proc/$$/fd/5` выведет в терминал слово "netology". Это произойдёт потому что echo отправляет netology в fd 5 текущего шелла
	
8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty?  
	Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа.
Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.

	Ответ:Можно провести через промежуточный дискриптор 5
	```
	vmvare@ns1:~$ls -l 5>&2 2>&1 1>&7
	```

1. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?

	Ответ: команда `cat /proc/$$/environ` выведет набор переменных окружения, команда `printenv` аналог данной команды.

1. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.

	Ответ:

	```
	/proc/[pid]/cmdline
              This  read-only file holds the complete command line for the process, unless the process is a zombie.  In the latter case, there is nothing in this file: that is,
              a read on this file will return 0 characters.  The command-line arguments appear in this file as a set of strings separated by null bytes ('\0'), with  a  further
              null byte after the last string.
	```
	```
	 /proc/[pid]/exe
              Under  Linux 2.2 and later, this file is a symbolic link containing the actual pathname of the executed command.  This symbolic link can be dereferenced normally;
              attempting to open it will open the executable.  You can even type /proc/[pid]/exe to run another copy of the same executable that is being run by process  [pid].
              If  the pathname has been unlinked, the symbolic link will contain the string '(deleted)' appended to the original pathname.  In a multithreaded process, the con‐
              tents of this symbolic link are not available if the main thread has already terminated (typically by calling pthread_exit(3)).
	```

2. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.

	Ответ:
	```
	vmvare@ns1:/proc/1639$ cat /proc/cpuinfo | grep sse
	flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon nopl xtopology tsc_reliable nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti ssbd ibrs ibpb stibp fsgsbase tsc_adjust bmi1 avx2 smep bmi2 invpcid rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 xsaves arat flush_l1d arch_capabilities
	flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon nopl xtopology tsc_reliable nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti ssbd ibrs ibpb stibp fsgsbase tsc_adjust bmi1 avx2 smep bmi2 invpcid rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 xsaves arat flush_l1d arch_capabilities
	```
	sse4_2

3. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty.  
	Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2.  
	Однако:

    ```bash
	vagrant@netology1:~$ ssh localhost 'tty'
	not a tty
    ```

	Почитайте, почему так происходит, и как изменить поведение.

	Ответ:
	``` 
	SSH_TTY               This is set to the name of the tty (path to the device) associated with the current shell or command.  If the current session has no tty, this vari‐
                           able is not set.
	```
	Так как SSH_TTY не установлен, то и не следует прописывать ‘tty’ в команде

1. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.

	Ответ:
	Запустим длительный процесс, например, top, выведем его в фон CTRL-Z или & • Посмотрим номер джоба (running background jobs) через команду jobs [1]+ 18586 Stopped (signal) top • Возобновим процесс в фоне: bg %1 • Запустим второй терминал через tmux • Перехватим процесс на новый tty: reptyr 18586

1. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте? что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.

	Ответ:
	Команда tee делает вывод одновременно и в файл, указаный в качестве параметра, и в stdout, в данном примере команда получает вывод из stdin, перенаправленный через pipe от stdout команды echo и так как команда запущена от sudo , соотвественно имеет права на запись в файл.
	