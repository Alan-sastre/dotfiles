#!/bin/bash

kill_thumbs() {
    local pids
    pids=$(pgrep -f "kioworker.*thumbnail\.so")
    if [ -n "$pids" ]; then
        echo "Matando kioworkers de thumbnails: $pids"
        kill $pids 2>/dev/null
    else
        echo "No hay kioworkers thumbnail activos."
    fi
}

clean_restart() {
    echo "Matando Dolphin..."
    pkill dolphin 2>/dev/null
    sleep 0.5
    kill_thumbs
    sleep 0.3
    echo "Reiniciando Dolphin..."
    dolphin &
}

write_config() {
    local rc="$HOME/.config/dolphinrc"
    if grep -q "Show Inline Previews" "$rc"; then
        sed -i 's/Show Inline Previews=.*/Show Inline Previews=false/' "$rc"
    else
        echo -e "\n[KFileDialog Settings]\nShow Inline Previews=false" >> "$rc"
    fi
    echo "Config applied: Show Inline Previews=false"
}

case "${1:-}" in
    --kill)
        kill_thumbs
        ;;
    --restart)
        clean_restart
        ;;
    *)
        write_config
        clean_restart
        ;;
esac
