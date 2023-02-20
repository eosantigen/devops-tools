#!/bin/bash

sudo iptables -t nat -D PREROUTING -d 172.16.30.77/32 -p tcp -m tcp --dport 2049 -j DNAT --to-destination 172.20.0.225:2049
sudo iptables -t nat -D PREROUTING -d 172.16.30.77/32 -p udp -m udp --dport 2049 -j DNAT --to-destination 172.20.0.225:2049
sudo iptables -t nat -D PREROUTING -d 172.16.30.77/32 -p tcp -m tcp --dport 111 -j DNAT --to-destination 172.20.0.225:111
sudo iptables -t nat -D PREROUTING -d 172.16.30.77/32 -p udp -m udp --dport 111 -j DNAT --to-destination 172.20.0.225:111
