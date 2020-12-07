#!/bin/bash -e

echo "Starting localnet service"

echo "Activating 'loopback' interface"
ip addr add 127.0.0.1/8 label lo dev lo
ip link set lo up

kill -stop $$
