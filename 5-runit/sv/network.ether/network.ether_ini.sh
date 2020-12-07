#!/bin/bash -e

#Script for activation and control with runit of the network service.
echo "Activating network ethernet service"

. /etc/sysconfig/ifconfig.ether

if [ "$(ip addr show ${IFACE} 2>/dev/null | grep ${IP}/)" = "" ]; then
  echo "Adding IPv4 address $IP/$PREFIX to the ${IFACE} interface..."
  ip addr add $IP/$PREFIX broadcast $BROADCAST dev ${IFACE}
else
  echo "Cannot add IPv4 address ${IP} to ${IFACE}.  Already present."
fi

ip link set ${IFACE} up
echo "Setting ${IFACE} up"  

if ip route | grep -q default; then
  echo "Gateway already setup; skipping."
else
  echo "Setting up default gateway..."
  ip route add default via ${GATEWAY} dev ${IFACE}
fi

kill -stop $$
