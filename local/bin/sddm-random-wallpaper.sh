#!/usr/bin/env bash
WALLPAPER_DIR="$HOME/Imágenes/wallpapers"
SDDM_BG_DIR="/usr/share/sddm/themes/Candy/backgrounds"
THEME_CONF="/usr/share/sddm/themes/Candy/theme.conf"

sudo cp "$WALLPAPER_DIR"/*.{jpg,png,jpeg} "$SDDM_BG_DIR/"

BG_LIST=$(find "$WALLPAPER_DIR" -type f \( -name '*.jpg' -o -name '*.png' -o -name '*.jpeg' \) -exec basename {} \; | sort -u | awk '{printf "./backgrounds/%s ", $0}' | sed 's/ $//')
[ -n "$BG_LIST" ] && sudo sed -i "s|^BackgroundS=\".*\"|BackgroundS=\"$BG_LIST\"|" "$THEME_CONF"
