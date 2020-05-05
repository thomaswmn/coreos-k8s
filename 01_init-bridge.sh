#!/bin/bash

netdev=coreosbr

brctl addbr $netdev
brctl addif $netdev eth1 || true
ip addr add 10.0.2.1/24 dev $netdev
ip link set $netdev up


echo 0 > /proc/sys/net/bridge/bridge-nf-call-iptables
