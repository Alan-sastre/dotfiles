#!/bin/bash
case "$1" in
    play-pause) playerctl play-pause ;;
    next) playerctl next ;;
    prev) playerctl previous ;;
    stop) playerctl stop ;;
    *) echo "Uso: media-control.sh [play-pause|next|prev|stop]" ;;
esac
