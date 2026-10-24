#!/usr/bin/env bash

# Завершаем работу уже запущенных процессов polybar
killall -q polybar

# Ждём, пока процессы полностью завершатся
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Запускаем панель main
polybar main 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar запущен..."
