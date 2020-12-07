#!/bin/bash -e

#Sourcing network and interface parameters.
. /etc/sysconfig/ifconfig.ether

echo "Deactivating network ethernet service on ${IFACE}"

ip route del default via ${GATEWAY} dev ${IFACE}
echo "Deleting GATEWAY: ip route del default via ${GATEWAY} dev ${IFACE}"

ip link set ${IFACE} down
echo "Setting LINK down: ip link set ${IFACE} down"

ip addr del $IP/$PREFIX broadcast $BROADCAST dev ${IFACE}
echo "Deleting BROADCAST: ip addr del $IP/$PREFIX broadcast $BROADCAST dev ${IFACE}"
