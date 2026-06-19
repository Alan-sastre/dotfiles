# dotfiles — Alan

Configuración personal de mi escritorio Hyprland con HyDE.

## Contenido

| Directorio | Descripción |
|---|---|
| `config/` | Configuraciones en `.config/` (hypr, waybar, kitty, dunst, etc.) |
| `home/` | Dotfiles del home (`.zshrc`, `.bashrc`, `.Xresources`, etc.) |
| `themes/` | Temas GTK de HyDE (Catppuccin, Tokyo-Night, etc.) |
| `local/bin/` | Scripts en `~/.local/bin/` |
| `scripts/` | Scripts varios |

## Instalación

```bash
git clone https://github.com/ALAN404/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

El script crea symlinks de cada archivo/directorio a su ubicación original.
Si ya existe un archivo, lo renombra a `.bak`.

## Requisitos

- Arch Linux / Hyprland / HyDE
- oh-my-zsh
- Los paquetes de HyDE (ver https://github.com/HyDE-Project/HyDE)
