#!/usr/bin/env bash

# Окружение сессии подхватится от elogind автоматически, но для страховки:
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# Гасим старые зависшие процессы
killall -9 pipewire wireplumber pipewire-pulse 2>/dev/null

# Запускаем компоненты PipeWire
pipewire &
wireplumber &
pipewire-pulse &

echo "PipeWire успешно запущен через elogind!"
