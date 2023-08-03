#!/bin/bash  
  
# Проверяем, переданы ли аргументы командной строки  
if [ $# -ne 2 ]; then  
    echo "Использование: $0 <имя_пользователя> <новый_пароль>" >&2  
    exit 1  
fi  
  
username=$1  
new_password=$2  
  
# Проверяем, существует ли пользователь с таким именем  
if ! id -u "$username" >/dev/null 2>&1; then  
    echo "Пользователь с именем $username не существует." >&2  
    exit 1  
fi  
  
# Сменяем пароль для указанного пользователя  
echo "$username:$new_password" | chpasswd  
  
echo "Пароль для пользователя $username успешно изменен."  