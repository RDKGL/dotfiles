#!/usr/bin/env bash
#
# install.sh — автоустановка райсинг-конфигов для Void Linux
# i3wm + polybar + rofi + kitty + feh + JetBrainsMono Nerd Font
#
# Запуск:  ./install.sh
#

set -euo pipefail

# --- Пути ---
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="${HOME}/.config"
FONT_DIR="${HOME}/.local/share/fonts/JetBrainsMono"

# --- Проверка ОС ---
if ! command -v xbps-install >/dev/null 2>&1; then
    echo "Ошибка: это не Void Linux (xbps-install не найден)."
    echo "Скрипт предназначен только для Void Linux."
    exit 1
fi

# --- Утилиты ---
info()  { echo -e "\033[1;32m[+]\033[0m $*"; }
warn()  { echo -e "\033[1;33m[!]\033[0m $*"; }
fail()  { echo -e "\033[1;31m[×]\033[0m $*"; exit 1; }

# --- Список пакетов ---
PACKAGES=(
    i3
    polybar
    rofi
    kitty
    feh
    maim
    xclip
    papirus-icon-theme
    xset
    setxkbmap
    xrandr
    fontconfig
    dbus
    elogind
    polkit
    polkit-gnome
)

# --- Бэкап существующих конфигов ---
backup_existing() {
    local target="$1"
    if [ -e "$target" ]; then
        local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
        cp -r "$target" "$backup" 2>/dev/null || true
        warn "Бэкап: $target → $backup"
    fi
}

# === УСТАНОВКА ===

info "Проверка sudo-доступа..."
if [ "$(id -u)" -eq 0 ]; then
    fail "Не запускай от root. Запусти от обычного пользователя."
fi

# Проверка sudo
if ! sudo -v 2>/dev/null; then
    fail "Нужен sudo для установки пакетов. Настрой sudo для пользователя $(whoami)."
fi

info "Обновление репозиториев пакетов..."
sudo xbps-install -Syu || warn "Не удалось обновить репозитории, продолжаю..."

info "Установка пакетов: ${PACKAGES[*]}"
for pkg in "${PACKAGES[@]}"; do
    if xbps-query -R "$pkg" >/dev/null 2>&1 && xbps-query -l 2>/dev/null | grep -q "ii $pkg"; then
        info "  $pkg — уже установлен"
    else
        sudo xbps-install -y "$pkg" 2>/dev/null || warn "  $pkg — не удалось установить"
    fi
done

# === КОНФИГИ ===

info "Установка конфигов..."

# Создаём директории
mkdir -p "$CONFIG_DIR"/{i3,polybar,rofi,kitty}
mkdir -p "$FONT_DIR"

# i3
backup_existing "$CONFIG_DIR/i3/config"
cp "$DOTFILES_DIR/config/i3/config" "$CONFIG_DIR/i3/config"
info "  i3 config установлен"

# polybar
backup_existing "$CONFIG_DIR/polybar/config.ini"
backup_existing "$CONFIG_DIR/polybar/launch.sh"
cp "$DOTFILES_DIR/config/polybar/config.ini" "$CONFIG_DIR/polybar/config.ini"
cp "$DOTFILES_DIR/config/polybar/launch.sh" "$CONFIG_DIR/polybar/launch.sh"
chmod +x "$CONFIG_DIR/polybar/launch.sh"
info "  polybar config + launch.sh установлены"

# rofi
backup_existing "$CONFIG_DIR/rofi/config.rasi"
backup_existing "$CONFIG_DIR/rofi/void-theme.rasi"
cp "$DOTFILES_DIR/config/rofi/config.rasi" "$CONFIG_DIR/rofi/config.rasi"
cp "$DOTFILES_DIR/config/rofi/void-theme.rasi" "$CONFIG_DIR/rofi/void-theme.rasi"
info "  rofi config + тема установлены"

# kitty
backup_existing "$CONFIG_DIR/kitty/kitty.conf"
cp "$DOTFILES_DIR/config/kitty/kitty.conf" "$CONFIG_DIR/kitty/kitty.conf"
info "  kitty config установлен"

# === ФАЙЛЫ ДОМАШНЕЙ ДИРЕКТОРИИ ===

info "Установка файлов в домашнюю директорию..."

# .xinitrc
backup_existing "$HOME/.xinitrc"
cp "$DOTFILES_DIR/home/xinitrc" "$HOME/.xinitrc"
info "  .xinitrc установлен"

# .fehbg — с корректным путём к обоине
backup_existing "$HOME/.fehbg"
cat > "$HOME/.fehbg" << 'FEHBG'
#!/bin/sh
feh --no-fehbg --bg-fill "$HOME/wallpaper.png"
FEHBG
chmod +x "$HOME/.fehbg"
info "  .fehbg установлен"

# .bashrc — дополняем, не перезаписываем
if [ -f "$HOME/.bashrc" ] && grep -q "opencode" "$HOME/.bashrc" 2>/dev/null; then
    warn "  .bashrc уже содержит кастомные настройки, пропускаю"
else
    backup_existing "$HOME/.bashrc"
    cp "$DOTFILES_DIR/home/bashrc" "$HOME/.bashrc"
    info "  .bashrc установлен"
fi

# .bash_profile
backup_existing "$HOME/.bash_profile"
cp "$DOTFILES_DIR/home/bash_profile" "$HOME/.bash_profile"
info "  .bash_profile установлен"

# start-audio.sh
cp "$DOTFILES_DIR/home/start-audio.sh" "$HOME/start-audio.sh"
chmod +x "$HOME/start-audio.sh"
info "  start-audio.sh установлен"

# === ОБОИНА ===

info "Установка обоев..."
cp "$DOTFILES_DIR/wallpaper.png" "$HOME/wallpaper.png"
info "  wallpaper.png установлен"

# === ШРИФТЫ ===

info "Установка шрифтов JetBrainsMono Nerd Font..."
cp "$DOTFILES_DIR/fonts/JetBrainsMono/"*.ttf "$FONT_DIR/" 2>/dev/null || warn "  Нет .ttf файлов для копирования"

# Обновляем кэш шрифтов
if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -fv "$FONT_DIR" >/dev/null 2>&1 || true
    info "  Кэш шрифтов обновлён"
else
    warn "  fc-cache не найден, кэш шрифтов не обновлён"
fi

# Проверка установки шрифта
if fc-list 2>/dev/null | grep -q "JetBrainsMono Nerd Font"; then
    info "  Шрифт JetBrainsMono Nerd Font найден в системе"
else
    warn "  Шрифт не найден в fc-list — возможно нужен перезапуск"
fi

# === ФИКС ПУТЕЙ В КОНФИГАХ ===

# Заменяем жёсткий путь /home/rdkgl на $HOME в i3 config
sed -i "s|/home/rdkgl|$HOME|g" "$CONFIG_DIR/i3/config" 2>/dev/null || true

# === ИТОГ ===

echo ""
echo -e "\033[1;32m========================================"
echo "  Установка завершена!"
echo "========================================\033[0m"
echo ""
echo "Установлено:"
echo "  • i3wm       — тайловый оконный менеджер"
echo "  • polybar    — статус-бар"
echo "  • rofi       — лаунчер приложений"
echo "  • kitty      — терминал"
echo "  • feh        — обои"
echo "  • JetBrainsMono Nerd Font — шрифт"
echo "  • wallpaper.png — обои"
echo ""
echo "Запуск:  startx"
echo ""
echo "Горячие клавиши i3:"
echo "  Super+Enter  — терминал"
echo "  Super+D     — rofi (запуск приложений)"
echo "  Super+Q     — закрыть окно"
echo "  Super+Shift+C — перезагрузить конфиг"
echo "  Super+Shift+R — перезапуск i3"
echo "  Super+Shift+E — выход из i3"
echo ""
