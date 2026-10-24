# Void Linux Dotfiles

Райсинг-конфиги для Void Linux: i3wm + polybar + rofi + kitty + feh.

Цветовая схема — тёмная с изумрудно-зелёным акцентом (`#10b981`).

## Компоненты

| Компонент | Назначение |
|-----------|-----------|
| **i3wm** | Тайловый оконный менеджер |
| **polybar** | Статус-бар (рабочие столы, ЦП, ОЗУ, громкость, раскладка, трей) |
| **rofi** | Лаунчер приложений |
| **kitty** | Терминал |
| **feh** | Установка обоев рабочего стола |
| **JetBrainsMono Nerd Font** | Основной шрифт (терминал, бар, rofi) |
| **Papirus** | Иконки для rofi |

## Цветовая схема

```
Фон:         #111111 / #0e141b
Акцент:       #10b981 (изумрудный)
Текст:        #e5e7eb
Предупреждение: #ef4444
```

## Структура репозитория

```
dotfiles/
├── config/
│   ├── i3/           # Конфиг i3wm
│   ├── polybar/      # Конфиг polybar + launch.sh
│   ├── rofi/         # Конфиг rofi + тема void-theme
│   └── kitty/        # Конфиг kitty терминала
├── home/             # Файлы для ~/
│   ├── xinitrc       # .xinitrc (запуск PipeWire + i3)
│   ├── fehbg         # .fehbg (установка обоев)
│   ├── bashrc        # .bashrc
│   ├── bash_profile  # .bash_profile
│   └── start-audio.sh # Запуск PipeWire вручную
├── fonts/
│   └── JetBrainsMono/ # JetBrainsMono Nerd Font (.ttf)
├── wallpaper.png      # Обои рабочего стола
├── install.sh         # Скрипт автоустановки
└── README.md
```

## Установка

```bash
git clone https://github.com/ВАШ_НИК/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Скрипт:
1. Проверяет ОС (должен быть Void Linux с xbps)
2. Устанавливает пакеты через `xbps-install`: i3, polybar, rofi, kitty, feh, maim, xclip, papirus-icon-theme и др.
3. Делает бэкап существующих конфигов (с суффиксом `.bak.<дата>`)
4. Копирует конфиги в `~/.config/`
5. Копирует файлы в `~/` (.xinitrc, .fehbg, .bashrc, .bash_profile, start-audio.sh)
6. Устанавливает шрифты в `~/.local/share/fonts/` и обновляет кэш
7. Копирует обои в `~/wallpaper.png`

После установки — `startx` для запуска сессии.

## Горячие клавиши i3

| Комбинация | Действие |
|------------|----------|
| `Super+Enter` | Терминал (kitty) |
| `Super+D` | Rofi (запуск приложений) |
| `Super+Q` | Закрыть окно |
| `Super+Shift+S` | Скриншот выделенной области в буфер |
| `Super+H/J/K/L` | Фокус (vim-стиль) |
| `Super+Shift+H/J/K/L` | Перемещение окна |
| `Super+1-0` | Переключение рабочих столов |
| `Super+Shift+1-0` | Перемещение окна на рабочий стол |
| `Super+Shift+Space` | Плавающий режим |
| `Super+Shift+C` | Перезагрузить конфиг |
| `Super+Shift+R` | Перезапуск i3 |
| `Super+Shift+E` | Выход из i3 |

## Раскладка клавиатуры

US + RU, переключение по `Alt+Shift`.

## Зависимости (устанавливаются скриптом)

```
i3 polybar rofi kitty feh maim xclip papirus-icon-theme
xset setxkbmap xrandr fontconfig dbus elogind polkit polkit-gnome
```

## Лицензия

Свободно используй и модифицируй.
