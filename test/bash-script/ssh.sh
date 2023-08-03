new_port=$1  
  
# Проверяем, является ли новый порт числом  
if ! echo "$new_port" | grep -qE '^[0-9]+$'; then  
    echo "Порт должен быть числом." >&2  
    exit 1  
fi  
  
# Устанавливаем новый порт в конфигурационном файле SSH  
sed -i "s/^\(Port\s*\).*$/\1$new_port/" /etc/ssh/ssh_config  
  
# Перезапускаем службу SSH для применения изменений  
service ssh restart  
  
echo "Порт SSH успешно изменен на $new_port." 