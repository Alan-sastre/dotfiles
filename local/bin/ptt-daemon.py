#!/usr/bin/env python3
import struct
import subprocess
import sys
import os
import glob
import signal
import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(message)s",
    datefmt="%H:%M:%S",
)

EV_KEY = 1
BTN_SIDE = 274
BTN_EXTRA = 275
KEY_276 = 276

KEYS = {BTN_EXTRA, KEY_276}

INPUT_EVENT_FMT = "<qqHHi"
INPUT_EVENT_SIZE = struct.calcsize(INPUT_EVENT_FMT)

def find_mouse_device():
    pattern = "/dev/input/by-id/usb-Logitech_Gaming_Mouse_G502*-event-mouse"
    devices = glob.glob(pattern)
    if devices:
        return devices[0]
    pattern = "/dev/input/by-id/*-event-mouse"
    devices = sorted(glob.glob(pattern))
    if devices:
        logging.warning("G502 no encontrado, usando: %s", devices[0])
        return devices[0]
    logging.error("No se encontro ningun mouse")
    sys.exit(1)

def run_pactl(command):
    try:
        subprocess.run(
            ["pactl", "set-source-mute", "@DEFAULT_SOURCE@", str(command)],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True,
        )
    except subprocess.CalledProcessError:
        pass

def main():
    device_path = find_mouse_device()
    real_path = os.path.realpath(device_path)
    logging.info("Dispositivo: %s -> %s", device_path, real_path)

    try:
        fd = os.open(real_path, os.O_RDONLY)
    except PermissionError:
        logging.error("Permiso denegado a %s", real_path)
        logging.error("Agrega tu usuario al grupo 'input' o ejecuta con sudo")
        sys.exit(1)

    muted = True
    run_pactl(1)

    running = True

    def handle_signal(signum, frame):
        nonlocal running
        logging.info("Deteniendo...")
        running = False

    signal.signal(signal.SIGINT, handle_signal)
    signal.signal(signal.SIGTERM, handle_signal)

    logging.info("Escuchando botones del mouse...")
    logging.info("Presiona mouse5 (o boton configurado) para hablar")

    while running:
        try:
            data = os.read(fd, INPUT_EVENT_SIZE)
        except OSError:
            break
        if not data or len(data) < INPUT_EVENT_SIZE:
            continue

        tv_sec, tv_usec, event_type, code, value = struct.unpack(
            INPUT_EVENT_FMT, data
        )

        if event_type != EV_KEY or code not in KEYS:
            continue

        if value == 1:
            if muted:
                run_pactl(0)
                muted = False
        elif value == 0:
            if not muted:
                run_pactl(1)
                muted = True

    if not muted:
        run_pactl(1)

    os.close(fd)

if __name__ == "__main__":
    main()
