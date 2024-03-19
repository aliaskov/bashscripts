#!/bin/bash

# Версия операционной системы
os_version=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d '"' -f 2)

# Дата и время
current_date=$(date "+%Y-%m-%d")
current_time=$(date "+%H:%M:%S")

# Время работы системы
uptime_info=$(uptime -p)

# Загруженность системы
system_load=$(uptime | awk -F'[a-z]:' '{ print $2 }')

# Занятое дисковое пространство
disk_usage=$(df / | awk '{print $5}' | sed 's/%//')

# Топ процессы по использованию памяти
top_processes=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6)

# Количество процессов
process_count=$(ps -ef | wc -l)

# Количество пользователей
user_count=$(who | wc -l)

# Выводим отчет
echo "Отчет о системе"
echo "Версия операционной системы: $os_version"
echo "Дата: $current_date"
echo "Время: $current_time"
echo "Время работы системы: $uptime_info"
echo "Загруженность системы: $system_load"
echo "Занятое дисковое пространство: $disk_usage"
echo "Топ процессы по использованию памяти:"
echo "$top_processes"
echo "Количество процессов: $process_count"
echo "Количество пользователей: $user_count"
