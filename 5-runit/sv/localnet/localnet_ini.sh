#!/bin/bash -e

echo "Empieza el servicio localnet"

echo "Activacion del interfaz 'loopback'"
ip addr add 127.0.0.1/8 label lo dev lo
ip link set lo up

kill -stop $$
