#!/bin/bash -e

echo "Stopping localnet service"

ip link set lo down
ip addr del 127.0.0.1/8 label lo dev lo
