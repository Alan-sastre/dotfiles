#!/bin/bash
if [ "$1" = "press" ]; then
    pactl set-source-mute @DEFAULT_SOURCE@ 0
elif [ "$1" = "release" ]; then
    pactl set-source-mute @DEFAULT_SOURCE@ 1
fi