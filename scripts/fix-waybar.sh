#!/usr/bin/env bash

echo "[1/5] Backup de configuración Waybar..."

BACKUP="$HOME/.config/waybar-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"

cp -r ~/.config/waybar "$BACKUP/"

echo "[2/5] Desactivando módulos problemáticos..."

CONFIG="$HOME/.config/waybar/config.jsonc"

cp "$CONFIG" "$CONFIG.bak"

sed -i 's/"custom\/gpuinfo"/"custom_gpuinfo_disabled"/g' "$CONFIG"
sed -i 's/"custom\/swaync"/"custom_swaync_disabled"/g' "$CONFIG"

echo "[3/5] Parando Waybar..."

pkill waybar 2>/dev/null
sleep 1

echo "[4/5] Reiniciando SwayNC..."

pkill swaync 2>/dev/null
swaync >/dev/null 2>&1 & disown

echo "[5/5] Reiniciando Waybar..."

waybar >/dev/null 2>&1 & disown

echo "Listo. Revisa si vuelve el icono."
