#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/dotfiles"

echo "Instalando dotfiles..."

# =====================
# .config/ symlinks
# =====================
echo "[1/5] Configuraciones en .config/..."
for dir in "$DOTFILES"/config/*/; do
    name=$(basename "$dir")
    target="$HOME/.config/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "${target}.bak"
        echo "  Backup: $target → ${target}.bak"
    fi
    ln -sfn "$dir" "$target"
    echo "  ✓ $name"
done

# =====================
# Home dotfiles
# =====================
echo "[2/5] Dotfiles del home..."
for file in "$DOTFILES"/home/.*; do
    [ -f "$file" ] || continue
    name=$(basename "$file")
    target="$HOME/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "${target}.bak"
        echo "  Backup: $target → ${target}.bak"
    fi
    ln -sf "$file" "$target"
    echo "  ✓ $name"
done

# =====================
# Themes
# =====================
echo "[3/5] Temas GTK..."
mkdir -p "$HOME/.themes"
for theme in "$DOTFILES"/themes/*/; do
    name=$(basename "$theme")
    target="$HOME/.themes/$name"
    ln -sfn "$theme" "$target"
    echo "  ✓ $name"
done

# =====================
# Scripts
# =====================
echo "[4/5] Scripts..."
mkdir -p "$HOME/.local/bin"
for script in "$DOTFILES"/local/bin/*; do
    [ -f "$script" ] || continue
    name=$(basename "$script")
    target="$HOME/.local/bin/$name"
    ln -sf "$script" "$target"
    chmod +x "$target"
    echo "  ✓ $name"
done

for script in "$DOTFILES"/scripts/*; do
    [ -f "$script" ] || continue
    name=$(basename "$script")
    target="$HOME/$name"
    ln -sf "$script" "$target"
    chmod +x "$target"
    echo "  ✓ $name (home)"
done

# =====================
# Recargar config
# =====================
echo "[5/5] Finalizando..."
if command -v hyprctl &>/dev/null; then
    hyprctl reload 2>/dev/null || true
fi

echo ""
echo "Instalación completada."
echo "Si hay backups (.bak), revísalos y bórralos manualmente cuando confirmes que todo funciona."
