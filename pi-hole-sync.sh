#!/bin/bash
  
# Variables
user=root
privkey=/root/.ssh/id_ed25519
second_pi=192.168.128.3

# Script
pi_online=$(timeout 0.2 ping -c1 $second_pi &> /dev/null && echo "1" || echo "0")
if [ "$pi_online" -eq 1 ]; then
  cd /etc/pihole/
  ssh -i $privkey "$user@$second_pi" "[ ! -f '~/pihole' ] || mkdir ~/pihole"
  scp -i $privkey adlists.list *list.txt setupVars.conf willjasen.com.list $user@$second_pi:~/pihole
  scp -i $privkey /etc/dnsmasq.d/01-pihole.conf $user@$second_pi:/etc/dnsmasq.d/01-pihole.conf
  scp -i $privkey /etc/dnsmasq.d/02-lan.conf $user@$second_pi:/etc/dnsmasq.d/02-lan.conf
  ssh -i $privkey "$user@$second_pi" "sudo cp ~/pihole/* /etc/pihole/."
  ssh -i $privkey "$user@$second_pi" "pihole -g"
fi
