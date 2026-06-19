#!/bin/bash
sudo ip link set virbr0 up
sudo iptables -I FORWARD -i virbr0 -j ACCEPT
sudo iptables -I FORWARD -o virbr0 -j ACCEPT
sudo iptables -t nat -I POSTROUTING -s 192.168.122.0/24 -j MASQUERADE
