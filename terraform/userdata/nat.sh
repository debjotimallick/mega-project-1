#!/bin/bash

apt-get update -y

sysctl -w net.ipv4.ip_forward=1

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE

apt-get install -y iptables-persistent

netfilter-persistent save