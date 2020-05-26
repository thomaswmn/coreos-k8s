#!/bin/bash

iptables -F 
iptables -t nat -F

#Setup default policies to handle unmatched traffic:
#iptables -P INPUT ACCEPT
#iptables -P OUTPUT ACCEPT
#iptables -P FORWARD DROP

export LAN=eth0
export WAN=eth1
export VPN=tun0
export VM=br1

#The next step locks the services so they only work from the LAN:
#iptables -I INPUT 1 -i ${LAN} -j ACCEPT
#iptables -I INPUT 1 -i lo -j ACCEPT
#iptables -A INPUT -p UDP --dport bootps ! -i ${LAN} -j REJECT
#iptables -A INPUT -p UDP --dport domain ! -i ${LAN} -j REJECT

#Drop TCP / UDP packets to privileged ports:
#iptables -A INPUT -p TCP ! -i ${LAN} -d 0/0 --dport 0:1023 -j DROP
#iptables -A INPUT -p UDP ! -i ${LAN} -d 0/0 --dport 0:1023 -j DROP

# Finally add the rules for NAT:
#iptables -I FORWARD -i ${LAN} -d 192.168.0.0/16 -j DROP
#iptables -A FORWARD -i ${LAN} -s 192.168.0.0/16 -j ACCEPT
#iptables -A FORWARD -i ${WAN} -d 192.168.0.0/16 -j ACCEPT
#iptables -t nat -A POSTROUTING -o ${VPN} -j MASQUERADE
iptables -t nat -A POSTROUTING -o $LAN -j MASQUERADE

# Inform the kernel that IP forwarding is OK:
echo 1 > /proc/sys/net/ipv4/ip_forward
